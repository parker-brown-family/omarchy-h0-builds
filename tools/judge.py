"""Blind review of the builds of each subject: taste, implementation, execution.

For each subject, every arm's build is shown to a judge model under a random letter, as its
source files plus the pictures the offscreen preview drew. The judge scores each build 1-5 on
three described dimensions and ranks them. It runs twice per subject with different letter orders;
the mapping from letter to harness is kept apart and only joined afterwards.

    python3 evals/builds/judge.py runs/builds-3 [--model claude-opus-5-5]

Writes <run>/judge/<subject>-<pass>.json and <run>/judge/summary.json.
"""

from __future__ import annotations

import argparse
import base64
import json
import random
import subprocess
import sys
import urllib.request
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO))
from h0 import config, secrets  # noqa: E402
from h0.sandbox import Sandbox  # noqa: E402

RUBRIC = """You are reviewing several independent builds of the same request for Omarchy, a Linux desktop
(Hyprland, with a Quickshell bar called the Omarchy shell). Each build was written by a coding agent.
You see each build's files and, where one could be drawn, a picture of it rendered offscreen by
Quickshell from its own code (popup panels cannot be drawn this way; that is not the build's fault).

The request was:
{prompt}

Score every build from 1 to 5 on each dimension. Use the whole scale; a 3 is ordinary, competent work.

TASTE: the choices a person living with it would notice. Does it look and behave like it belongs in
Omarchy (its colours, fonts, iconography, bar conventions), with sensible defaults and restraint? No
clutter, no gimmicks, no surprising behaviour. For a theme: is the palette coherent, readable and true
to the brief, and is the background good to look at every day?

IMPLEMENTATION: the code as code. Correct use of the Omarchy shell's plugin API and Quickshell; simple,
readable, idiomatic; handles errors and edge cases a real desktop will hit; no dead code, no needless
machinery, nothing that could harm the machine. For a theme: complete, valid files that Omarchy's
templates will use as intended.

EXECUTION: did it do what was asked, all of it? Check each part of the request against the build. A
build that does more than asked earns nothing for the extra, and loses if the extra is unwanted.

Be concrete: each reason names something in the files or the picture. Then rank the builds best to worst.

Answer with JSON only, in this shape:
{{"builds": {{"<letter>": {{"taste": n, "taste_why": "...", "implementation": n, "implementation_why": "...",
"execution": n, "execution_why": "..."}}, ...}}, "ranking": ["<best letter>", ...], "ranking_why": "..."}}
"""

TEXT_SUFFIX = {".qml", ".js", ".json", ".toml", ".lua", ".sh", ".md", ".theme", ".rgb", ".conf", ".ini", ".css", ".tpl", ""}
PER_BUILD_CHARS = 60_000


def build_files(d: Path) -> str:
    parts, total = [], 0
    for f in sorted(d.rglob("*")):
        if not f.is_file() or f.suffix.lower() not in TEXT_SUFFIX or ".h0-" in str(f):
            continue
        try:
            t = f.read_text()
        except (UnicodeDecodeError, OSError):
            continue
        piece = f"--- {f.relative_to(d)} ---\n{t}\n"
        if total + len(piece) > PER_BUILD_CHARS:
            parts.append(f"--- {f.relative_to(d)} --- (omitted: the build's text is over {PER_BUILD_CHARS} characters)\n")
            continue
        parts.append(piece)
        total += len(piece)
    return "".join(parts) or "(no files)"


def pictures(build_dir: Path, kind: str, made: Path) -> list[bytes]:
    """Draw the build offscreen (inside the sandbox: the code is agent-written) and return images."""
    out = []
    shot = build_dir / "judge-bar.png"
    if not shot.exists():
        sb = Sandbox(root=build_dir, ro_paths=[Path("/usr/share/omarchy"), REPO / "fittings/omarchy-v4/preview", REPO / "evals/builds"])
        sb.env.update({"HOME": str(build_dir)})
        sb.run(f"python3 '{REPO}/evals/builds/shot.py' {kind} '{made}' '{shot}'", timeout=120)
    if shot.exists():
        out.append(shot.read_bytes())
    if kind == "theme":
        bgs = sorted((made / "backgrounds").glob("*")) if (made / "backgrounds").is_dir() else []
        if bgs:
            small = build_dir / "judge-bg.jpg"
            if not small.exists():
                subprocess.run(["magick", str(bgs[0]), "-resize", "1280x720>", "-quality", "85", str(small)], capture_output=True, timeout=60)
            if small.exists():
                out.append(small.read_bytes())
    return out


def ask(model: str, content: list) -> tuple[dict, dict]:
    body = {"model": model, "max_tokens": 16000, "messages": [{"role": "user", "content": content}]}
    req = urllib.request.Request("https://api.anthropic.com/v1/messages", data=json.dumps(body).encode(), method="POST",
                                 headers={"x-api-key": secrets.get("anthropic"), "anthropic-version": "2023-06-01",
                                          "content-type": "application/json"})
    with urllib.request.urlopen(req, timeout=900) as r:
        d = json.loads(r.read())
    text = "".join(b.get("text", "") for b in d["content"] if b.get("type") == "text")
    start, end = text.find("{"), text.rfind("}")
    return json.loads(text[start:end + 1]), d.get("usage", {})


def judge_subject(run: Path, sid: str, arms: list[str], model: str, out: Path) -> list[dict]:
    builds = {}
    for arm in arms:
        rec_p = run / arm / sid / "build.json"
        files = run / arm / sid / "files"
        made = [p for p in files.iterdir() if p.is_dir()] if files.is_dir() else []
        if rec_p.exists() and made:
            builds[arm] = (json.loads(rec_p.read_text()), made[0])
    if not builds:
        return []
    subj = next(iter(builds.values()))[0]["subject"]
    results = []
    for pass_no in (1, 2):
        rng = random.Random(f"{sid}-{pass_no}")
        order = list(builds)
        rng.shuffle(order)
        letters = {arm: "ABCD"[i] for i, arm in enumerate(order)}
        content = [{"type": "text", "text": RUBRIC.format(prompt=subj["prompt"])}]
        for arm in order:
            rec, made = builds[arm]
            content.append({"type": "text", "text": f"\n===== BUILD {letters[arm]} =====\n{build_files(made)}"})
            for img in pictures(run / arm / sid, subj["kind"], made):
                media = "image/png" if img[:4] == b"\x89PNG" else "image/jpeg"
                content.append({"type": "text", "text": f"(picture of build {letters[arm]})"})
                content.append({"type": "image", "source": {"type": "base64", "media_type": media, "data": base64.b64encode(img).decode()}})
        verdict, usage = ask(model, content)
        res = {"subject": sid, "pass": pass_no, "letters": letters, "verdict": verdict, "usage": usage,
               "usd": config.price(model, usage)}
        (out / f"{sid}-{pass_no}.json").write_text(json.dumps(res, indent=1))
        print(f"judged {sid} pass {pass_no}: ranking {[k for l in verdict.get('ranking', []) for k, v in letters.items() if v == l]}", flush=True)
        results.append(res)
    return results


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("run")
    ap.add_argument("--model", default="claude-opus-5-5")
    ap.add_argument("--arms", default="h0-fitted,h0-plain,claude-code,opencode")
    ap.add_argument("--subjects")
    a = ap.parse_args()
    run = Path(a.run)
    out = run / "judge"
    out.mkdir(exist_ok=True)
    subjects = [s["id"] for s in json.loads((Path(__file__).parent / "prompts.json").read_text())["subjects"]]
    if a.subjects:
        subjects = [s for s in subjects if s in a.subjects.split(",")]
    allres = [r for sid in subjects for r in judge_subject(run, sid, a.arms.split(","), a.model, out)]
    summary: dict = {}
    for r in allres:
        for arm, letter in r["letters"].items():
            b = r["verdict"]["builds"].get(letter, {})
            row = summary.setdefault(r["subject"], {}).setdefault(arm, {"taste": [], "implementation": [], "execution": [], "rank": []})
            for k in ("taste", "implementation", "execution"):
                if isinstance(b.get(k), (int, float)):
                    row[k].append(b[k])
            rk = r["verdict"].get("ranking", [])
            if letter in rk:
                row["rank"].append(rk.index(letter) + 1)
    (out / "summary.json").write_text(json.dumps(summary, indent=1))
    print(json.dumps(summary, indent=1))


if __name__ == "__main__":
    main()
