"""Give a sandboxed harness the Anthropic API without giving it the key.

The proxy runs on the host and listens on a Unix socket inside the session's workspace. The
harness inside the sandbox (no network) talks to 127.0.0.1:<port>, where `bridge.py` relays bytes
to that socket. The proxy checks a per-session token, swaps in the real key, forwards to the API,
streams the answer back, and writes one line per request with the model and token usage the API
reported, so every harness is metered the same way.
"""

from __future__ import annotations

import json
import os
import secrets as pysecrets
import socketserver
import threading
import time
import urllib.error
import urllib.request
from http.server import BaseHTTPRequestHandler
from pathlib import Path

API = "https://api.anthropic.com"
FORWARD = ("anthropic-version", "anthropic-beta", "content-type", "accept", "user-agent", "x-stainless-helper-method")


class _Server(socketserver.ThreadingMixIn, socketserver.UnixStreamServer):
    daemon_threads = True


class KeyProxy:
    def __init__(self, sock: Path, key: str, log: Path):
        self.sock, self._key, self.log = Path(sock), key, Path(log)
        self.token = "h0proxy-" + pysecrets.token_hex(16)
        self._lock = threading.Lock()
        proxy = self

        class Handler(BaseHTTPRequestHandler):
            protocol_version = "HTTP/1.1"

            def address_string(self):
                return "sandbox"

            def log_message(self, *a):
                pass

            def _deny(self, code, msg):
                body = json.dumps({"type": "error", "error": {"type": "proxy", "message": msg}}).encode()
                self.send_response(code)
                self.send_header("content-type", "application/json")
                self.send_header("content-length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)

            def _handle(self):
                auth = self.headers.get("x-api-key") or (self.headers.get("authorization") or "").removeprefix("Bearer ").strip()
                if auth != proxy.token:
                    return self._deny(401, "bad token")
                if not self.path.startswith("/v1/"):
                    return self._deny(404, "only /v1/ is forwarded")
                n = int(self.headers.get("content-length") or 0)
                body = self.rfile.read(n) if n else None
                headers = {k: v for k, v in self.headers.items() if k.lower() in FORWARD}
                headers["x-api-key"] = proxy._key
                headers.setdefault("anthropic-version", "2023-06-01")
                req = urllib.request.Request(API + self.path, data=body, method=self.command, headers=headers)
                t0 = time.monotonic()
                rec = {"ts": time.time(), "path": self.path.split("?")[0], "model": None, "usage": {}, "status": None, "stream": False}
                try:
                    jb = json.loads(body) if body else {}
                except ValueError:
                    jb = {}
                rec["requested_model"] = jb.get("model")
                rec["effort"] = (jb.get("output_config") or {}).get("effort")
                rec["thinking"] = (jb.get("thinking") or {}).get("type")
                rec["tools"] = len(jb.get("tools") or [])
                try:
                    resp = urllib.request.urlopen(req, timeout=900)
                    status, rh = resp.status, resp.headers
                except urllib.error.HTTPError as e:
                    resp, status, rh = e, e.code, e.headers
                rec["status"] = status
                self.send_response(status)
                for k, v in rh.items():
                    if k.lower() in ("content-type", "request-id", "anthropic-ratelimit-requests-remaining", "retry-after"):
                        self.send_header(k, v)
                self.send_header("connection", "close")
                self.end_headers()
                buf = b""
                stream = "text/event-stream" in (rh.get("content-type") or "")
                rec["stream"] = stream
                while True:
                    chunk = resp.read1(65536) if hasattr(resp, "read1") else resp.read(65536)
                    if not chunk:
                        break
                    try:
                        self.wfile.write(chunk)
                        self.wfile.flush()
                    except (BrokenPipeError, ConnectionResetError):
                        break
                    buf += chunk
                    if stream:
                        *lines, rest = buf.split(b"\n")
                        buf = rest
                        for line in lines:
                            proxy._meter_line(line, rec)
                if not stream and buf:
                    try:
                        d = json.loads(buf)
                        rec["model"] = d.get("model")
                        rec["usage"] = {k: v for k, v in (d.get("usage") or {}).items() if isinstance(v, int)}
                    except ValueError:
                        pass
                rec["ms"] = int((time.monotonic() - t0) * 1000)
                self.close_connection = True
                if rec["path"].endswith("/messages"):
                    with proxy._lock, open(proxy.log, "a") as f:
                        f.write(json.dumps(rec) + "\n")

            do_POST = _handle
            do_GET = _handle

        self.sock.parent.mkdir(parents=True, exist_ok=True)
        if self.sock.exists():
            self.sock.unlink()
        self.server = _Server(str(self.sock), Handler)
        os.chmod(self.sock, 0o600)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)

    def _meter_line(self, line: bytes, rec: dict) -> None:
        if not line.startswith(b"data:"):
            return
        try:
            ev = json.loads(line[5:].strip())
        except ValueError:
            return
        if ev.get("type") == "message_start":
            m = ev.get("message") or {}
            rec["model"] = m.get("model")
            rec["usage"].update({k: v for k, v in (m.get("usage") or {}).items() if isinstance(v, int)})
        elif ev.get("type") == "message_delta":
            rec["usage"].update({k: v for k, v in (ev.get("usage") or {}).items() if isinstance(v, int)})

    def __enter__(self):
        self.thread.start()
        return self

    def __exit__(self, *a):
        self.server.shutdown()
        self.server.server_close()
        self.sock.unlink(missing_ok=True)


BRIDGE = r'''
import socket, sys, threading
SOCK, PORT = sys.argv[1], int(sys.argv[2])
def pump(a, b):
    try:
        while True:
            d = a.recv(65536)
            if not d:
                break
            b.sendall(d)
    except OSError:
        pass
    finally:
        for s in (a, b):
            try: s.shutdown(socket.SHUT_RDWR)
            except OSError: pass
def serve(c):
    u = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    u.connect(SOCK)
    threading.Thread(target=pump, args=(c, u), daemon=True).start()
    pump(u, c)
s = socket.socket(); s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(("127.0.0.1", PORT)); s.listen(64)
while True:
    c, _ = s.accept()
    threading.Thread(target=serve, args=(c,), daemon=True).start()
'''
