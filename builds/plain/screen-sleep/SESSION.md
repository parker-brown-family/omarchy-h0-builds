# h0 (plain) building Screen Sleep

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools read, edit, write, grep, glob, bash

---

### › You

```text
Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.
```

**⏺ bash** `pwd; ls -la; find . -maxdepth 4 -not -path './.git*' | head -100`

✓ 48 ms

```text
[exit 0, 44 ms]
~
total 0
drwxr-xr-x 1 parker parker  22 Nov  9 15:18 .
drwx------ 3 parker parker  60 Nov  9 15:18 ..
drwxr-xr-x 1 parker parker  72 Nov  8 22:07 .config
drwxr-xr-x 1 parker parker 160 Nov  9 15:18 .git
.
./.config
./.config/hypr
./.config/hypr/.luarc.json
./.config/hypr/autostart.lua
./.config/hypr/bindings.lua
./.config/hypr/hyprland.lua
./.config/hypr/hyprsunset.conf
./.config/hypr/input.lua
./.config/hypr/looknfeel.lua
./.config/hypr/monitors.lua
./.config/hypr/xdph.conf
./.config/omarchy
./.config/omarchy/extensions
./.config/omarchy/extensions/omarchy-menu.jsonc
./.config/omarchy/hooks
./.config/omarchy/hooks/battery-low.d
./.config/omarchy/hooks/font-set.d
./.config/omarchy/hooks/post-boot.d
./.config/omarchy/hooks/post-update.d
./.config/omarchy/hooks/pre-refresh-pacman.d
./.config/omarchy/hooks/theme-set.d
./.config/omarchy/themed
./.config/omarchy/themed/alacritty.toml.tpl.sample
./.config/omarchy/shell.json
./.config/omarchy/themes
./.config/omarchy/themes/ember
./.config/alacritty
./.config/alacritty/alacritty.toml
./.config/ghostty
./.config/ghostty/config
./.config/kitty
./.config/kitty/kitty.conf
…
```

**⏺ bash** `cd .config; cat omarchy/shell.json omarchy/extensions/omarchy-menu.jsonc hypr/hyprland.lua hypr/autostart.lua hypr/.luarc.json; ls -la omarchy/hooks/*; find omarchy/themes; git -C .. log --oneline | head`

✓ 48 ms

```text
[exit 0, 43 ms]
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  },
  "bar": {
    "position": "top",
    "transparent": false,
    "centerAnchor": "omarchy.clock",
    "layout": {
      "left": [
        {
          "id": "omarchy.menu"
        },
        {
          "id": "omarchy.workspaces"
        }
      ],
      "center": [
        {
          "id": "omarchy.indicators"
        },
        {
          "id": "omarchy.clock",
          "format": "dddd HH:mm",
          "formatAlt": "d MMMM 'W'ww yyyy",
          "verticalFormat": "HH\n\u2014\nmm"
        },
        {
          "id": "omarchy.keyboard-layout"
        },
        {
          "id": "omarchy.weather"
        },
        {
          "id": "omarchy.system-update"
        }
      ],
…
```

**⏺ bash** `echo $OMARCHY_PATH; ls /usr/share/omarchy 2>&1 | head; ls ~/.local/share/omarchy 2>&1|head; which omarchy hypridle hyprctl quickshell qs 2>&1`

✗ 48 ms

```text
[exit 1, 44 ms]

applications
bin
config
default
etc-overrides
icon.png
icon.txt
install
logo.svg
logo.txt
ls: cannot access '~/.local/share/omarchy': No such file or directory
which: no hypridle in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
/usr/bin/omarchy
/usr/bin/hyprctl
/usr/bin/quickshell
/usr/bin/qs
```

**⏺ bash** `cd /usr/share/omarchy; ls default config; grep -rli "plugin" --include=* . 2>/dev/null | grep -v node_modules | head -50`

✓ 208 ms

```text
[exit 0, 204 ms]
config:
alacritty
autostart
btop
chromium
chromium-flags.conf
fcitx5
foot
ghostty
git
herdr
hypr
hyprland-preview-share-picker
imv
kitty
lazygit
obsidian
omarchy
opencode
starship.toml
tmux
wireplumber
xournalpp

default:
agents
alacritty
applications
audio
bash
bashrc
chromium
environment.d
firefox
fontconfig
fonts
foot
ghostty
gpg
…
```

**⏺ bash** `cd /usr/share/omarchy; cat default/agents/skills/omarchy/plugins.md; cat shell/plugins/README.md`

✓ 51 ms

```text
[exit 0, 46 ms]
# Omarchy Shell: Bar, Plugins, and Idle

Read this before changing the status bar, notifications, shell plugins,
widgets, or idle/lock behavior.

The bar, notification daemon, settings panel, and assorted overlays all run
inside a single long-running Quickshell process (`omarchy-shell`).

```
~/.config/omarchy/shell.json             # User overrides: bar, plugins, idle
~/.config/omarchy/plugins/<plugin-id>/   # User-owned shell plugins
$OMARCHY_PATH/config/omarchy/shell.json  # Canonical defaults
```

The shell hot-reloads `shell.json` on save — no restart needed for layout
changes. `idle.screensaver` and `idle.lock` are seconds since user idle began.

**Commands:** `omarchy restart shell`, `omarchy refresh shell`

## Bar Layout

Use the `omarchy bar` group to move and manage widgets:

```bash
omarchy bar move omarchy.clock --section right
```

For layout edits beyond what the commands cover, edit the bar configuration
in `~/.config/omarchy/shell.json`; it hot-reloads on save.

## Customizing Built-In Plugins and Widgets

To customize a built-in bar widget, never edit `$OMARCHY_PATH/shell/plugins/`.
Clone it into the user plugin directory instead:

```bash
omarchy plugin clone omarchy.workspaces
# Edit ~/.config/omarchy/plugins/<username>.workspaces/; saved changes reload automatically.
```
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; ls; ls plugins/services/idle; cat plugins/services/idle/*; cat README.md | head -300`

✓ 53 ms

```text
[exit 0, 44 ms]
Commons
README.md
Ui
plugins
services
shell.qml
IdleModel.js
Service.qml
manifest.json
function secondsFromConfig(value, fallback) {
  var n = Number(value)
  if (!isFinite(n) || n < 0) return fallback
  return Math.floor(n)
}

function eventParts(event, count) {
  try {
    if (event && event.parse) return event.parse(count)
  } catch (error) {
  }
  return String(event && event.data ? event.data : "").split(",")
}

function screensaverWindowsAfter(windows, address, visible) {
  var key = String(address || "")
  if (!key) {
    var current = windows || {}
    var existingCount = 0
    for (var currentKey in current) {
      if (current[currentKey]) existingCount++
    }
    return { windows: current, count: existingCount }
  }

  var next = {}
  var count = 0
  for (var existing in windows || {}) {
    if (existing !== key && windows[existing]) {
      next[existing] = true
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 250,520p plugins/services/idle/Service.qml; cat plugins/services/idle/manifest.json`

✓ 49 ms

```text
[exit 0, 45 ms]

  IdleMonitor {
    id: idleMonitor
    enabled: root.idleEnabled
    timeout: root.firstIdleTimeoutSeconds
    respectInhibitors: true
    onIsIdleChanged: root.handleIdleChanged()
  }

  Timer {
    id: screensaverTimer
    interval: root.screensaverDelaySeconds * 1000
    repeat: false
    onTriggered: root.launchScreensaver()
  }

  Timer {
    id: lockTimer
    interval: root.lockDelaySeconds * 1000
    repeat: false
    onTriggered: if (root.idleEnabled && root.idledThisCycle) root.lockSystem("lock-timeout")
  }

  Timer {
    id: screensaverLaunchGraceTimer
    interval: 3000
    repeat: false
    onTriggered: {
      if (root.idleEnabled && root.idledThisCycle && root.screensaverStartedThisCycle && root.screensaverWindowCount === 0 && !idleMonitor.isIdle) {
        root.cancelIdleCycle("screensaver-not-running")
      }
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) { root.handleHyprlandEvent(event) }
  }

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1,200p README.md`

✓ 48 ms

```text
[exit 0, 43 ms]
# Omarchy shell

`omarchy-shell` is a single long-running [Quickshell](https://quickshell.org/)
instance that hosts the Omarchy desktop. Hyprland autostart launches one shell
per graphical session; everything else — the bar, background switcher, panels,
and overlays — runs **inside** the shell as a plugin.

Hosting everything inside one shell means:

- shared services and singletons live once, not once per process
- summoning a panel is an IPC call into a process that is already running,
  not a fresh `quickshell -p ...` cold start
- third-party plugins can be loaded from disk without changing any source
  code in Omarchy itself

The runtime layout:

```
shell/
  shell.qml              entry point (ShellRoot)
  services/
    PluginRegistry.qml   discovers, validates plugins, looks up enabled state in shell.json
    BarWidgetRegistry.qml unified registry for bar widgets (1p + 3p)
  plugins/
    bar/                 first-party plugins (see plugins/README.md)
    image-picker/
    menu/
    notifications/
    panels/
      audio/
      bluetooth/
      monitor/
      network/
      power/
      weather/
    agents/
    services/
      battery/
      idle/
…
```

**⏺ bash** `cd /usr/share/omarchy; for f in omarchy-system-wake omarchy-system-lock omarchy-launch-screensaver; do echo "== $f"; cat bin/$f; done; grep -rn "dpms\|suspend\|sleep" config/hypr default/hypr 2>/dev/null | head -30; ls default/systemd; grep -rln "IdleTimeout\|HandleLidSwitch\|suspend" default/system`

✓ 48 ms

```text
[exit 0, 43 ms]
== omarchy-system-wake
#!/bin/bash

# omarchy:summary=Wake displays and restore brightness after idle
# omarchy:group=system
# omarchy:name=wake
# omarchy:examples=omarchy system wake

omarchy-brightness-display on
omarchy-brightness-keyboard restore
omarchy-hyprland-monitor-clamshell >/dev/null 2>&1 || true
== omarchy-system-lock
#!/bin/bash

# omarchy:summary=Lock the computer and turn off the display
# omarchy:group=system
# omarchy:name=lock
# omarchy:examples=omarchy system lock

omarchy-shell lock lock >/dev/null

# Set keyboard layout to default (first layout)
hyprctl switchxkblayout all 0 > /dev/null 2>&1

# Ensure 1password is locked. Use timeout because `1password --lock` can
# otherwise leave a full Electron helper tree running after each lock.
if pgrep -x "1password" >/dev/null && omarchy-cmd-present 1password; then
  (
    flock -n 9 || exit 0
    timeout --kill-after=1s 3s 1password --lock >/dev/null 2>&1 || true
  ) 9>"${XDG_RUNTIME_DIR:-/tmp}/omarchy-1password-lock.lock" &
fi

# Avoid running screensaver when locked
pkill -x ttfx 2>/dev/null || true
# ttfx handles SIGTERM asynchronously, so keep its terminal alive until it exits.
timeout 1s pidwait -x ttfx 2>/dev/null || true
pkill -f '[o]rg.omarchy.screensaver' 2>/dev/null || true
== omarchy-launch-screensaver
…
```

**⏺ bash** `cd /usr/share/omarchy; cat bin/omarchy-brightness-display; sed -n 60,80p default/hypr/input.lua; grep -rn "suspend\|IdleAction" bin etc-overrides default/systemd/user 2>/dev/null | head -20; grep -v '^#' /etc/systemd/logind.conf 2>/dev/null | grep . ; ls /etc/systemd/logind.conf.d 2>/dev/null && cat`

✓ 48 ms

```text
[exit 0, 44 ms]
#!/bin/bash

# omarchy:summary=Show or adjust brightness on the focused display.
# omarchy:args=[--no-osd] [--monitor name] [+N%|N%-|N%|off|on]
# omarchy:examples=omarchy brightness display | omarchy brightness display +5% | omarchy brightness display --monitor DP-1 50% | omarchy brightness display off | omarchy brightness display on

no_osd=0
monitor=""

while (( $# > 0 )); do
  case "$1" in
  --no-osd)
    no_osd=1
    shift
    ;;
  --monitor)
    (( $# >= 2 )) || exit 1
    monitor="$2"
    shift 2
    ;;
  *)
    break
    ;;
  esac
done

# Get the brightness of the passed display
backlight_brightness() {
  brightnessctl -d "$1" -m 2>/dev/null | awk -F, '{ gsub("%", "", $4); print $4; found=1 } END{ exit !found }'
}

[[ -n $monitor ]] || monitor="$(omarchy-hyprland-monitor-focused 2>/dev/null || true)"

monitor_is_internal() {
  [[ $monitor =~ ^(eDP|LVDS|DSI)- ]]
}

use_apple_display() {
  omarchy-hyprland-monitor-focused-apple "$monitor"
…
```

**⏺ bash** `cd /usr/share/omarchy; grep -rn "suspend\|hibernate" shell bin | grep -v "^bin/omarchy-menu" | head -20; ls bin | grep -i -E "suspend|hibernat|sleep"`

✓ 47 ms

```text
[exit 0, 44 ms]
shell/Ui/Dropdown.qml:42:  // dropdown owns keys (its embedded ListView is active) and suspend its
shell/Ui/SearchableDropdown.qml:47:  // suspend its own keyCatcher so typing into the filter doesn't drive
shell/plugins/dev-gallery/GalleryPanel.qml:323:      // current target, Esc closes. The catcher suspends itself while a
shell/plugins/lock/Service.qml:420:      // A countdown frozen by suspend fires right after resume, which would
omarchy-hibernation-available
omarchy-hibernation-remove
omarchy-hibernation-setup
omarchy-system-sleep-lock
omarchy-system-sleep-monitor
omarchy-toggle-suspend
```

**⏺ bash** `cd /usr/share/omarchy; cat bin/omarchy-toggle-suspend bin/omarchy-system-sleep-monitor | head -60; sed -n 1,80p services/PluginRegistry.qml 2>/dev/null || sed -n 1,60p shell/services/PluginRegistry.qml`

✓ 51 ms

```text
[exit 0, 45 ms]
#!/bin/bash

# omarchy:summary=Toggle suspend availability in the system menu

omarchy-toggle suspend-off

if omarchy-toggle-enabled suspend-off; then
  omarchy-notification-send -g 󰒲 "Suspend removed from system menu"
else
  omarchy-notification-send -g 󰒲 "Suspend now available in system menu"
fi
#!/bin/bash

# omarchy:summary=Monitor sleep preparation and lock before suspend
# omarchy:group=system
# omarchy:hidden=true

consume_sleep_events() {
  local line sleep_lock
  sleep_lock="$OMARCHY_PATH/bin/omarchy-system-sleep-lock"

  while IFS= read -r line; do
    if [[ $line == *"boolean true"* ]]; then
      "$sleep_lock"
      return 0
    fi
  done
}

monitor_sleep_events() {
  local monitor_fd monitor_pid status

  coproc SLEEP_EVENTS {
    exec dbus-monitor --system \
      "type='signal',sender='org.freedesktop.login1',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'"
  }
  monitor_fd=${SLEEP_EVENTS[0]}
  monitor_pid=$SLEEP_EVENTS_PID

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "service" services/PluginRegistry.qml | head -40; grep -n "entrySettings\|pluginEntry\|settings" shell.qml | head -40`

✓ 47 ms

```text
[exit 0, 43 ms]
138:  // overlays, services).
398:  // back to center. Panels/overlays/menus/services go into the plugins[] array.
694:    // or services/battery.
648:      _updateSettings: function(requestedId, settings) {
649:        if (shell.pluginOwnsTarget(key, requestedId)) return shell.updateEntryInline(key, settings)
651:          return shell.updateEntryInline(requestedId, settings)
726:      _updateSettings: function(requestedId, settings) {
728:          ? shell.updateEntryInline(target, settings) : false
1073:  // Writes inline settings to a bar layout entry or top-level plugin entry in
1074:  // shell.json. moduleName is the entry id; settings is the merged plugin
1078:  function updateEntryInline(moduleName, settings) {
1093:          for (var k in settings) if (k !== "id") next[k] = settings[k]
1106:          for (var pk in settings) if (pk !== "id") pnext[pk] = settings[pk]
1407:        settingsForm: meta.settingsForm || "",
1424:      // settings panel reads metadata from the registry.
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "kind === \"service\"\|\"service\"\|loadService\|mountService\|serviceEntry\|pluginSettings\|entryFor" shell.qml | head -40`

✓ 47 ms

```text
[exit 0, 43 ms]
268:  // Generic loader for any enabled plugin that declares kind "service".
907:    if (!Array.isArray(manifest.kinds) || manifest.kinds.indexOf("service") === -1) return null
909:    var url = pluginRegistry.entryPointUrl(manifest, "service")
959:      if (!Array.isArray(m.kinds) || m.kinds.indexOf("service") === -1) continue
997:        && stillThere.kinds.indexOf("service") !== -1
1015:        && authenticationManifest.kinds.indexOf("service") !== -1
1349:          if ("service" in item) item.service = shell.serviceFor(panelEntry.pluginId)
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 260,300p shell.qml; sed -n 895,1000p shell.qml; sed -n 600,700p shell.qml`

✓ 49 ms

```text
[exit 0, 44 ms]
        console.warn("bar option " + shell.activeBarId + " failed to load, falling back to " + shell.defaultBarId)
        shell.failedBarId = shell.activeBarId
      }
    }
  }

  // ------------------------------------------------------------- services
  //
  // Generic loader for any enabled plugin that declares kind "service".
  // First-party infrastructure services are implicitly enabled by the registry;
  // third-party services are enabled by adding the plugin id to shell.json.
  Item {
    id: serviceHost
    visible: false
  }

  property var _services: ({})
  property var _pluginShellApis: ({})
  property var _pluginShellApiDescriptors: ({})
  property var _pluginBarEntryShellApis: ({})
  property var _pluginRegistryApis: ({})
  property var _pluginBarWidgetRegistryApis: ({})
  property var _pluginAppLibraryApis: ({})
  property var _pluginBarStateApis: ({})
  property var _pluginFirstPartyServiceApis: ({})

  Component {
    id: pluginShellApiComponent
    PluginShellApi { }
  }

  Component {
    id: pluginRegistryApiComponent
    PluginRegistryApi { }
  }

  Component {
    id: pluginBarWidgetRegistryApiComponent
    PluginBarWidgetRegistryApi { }
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn "dpms\|brightness-display" --include=*.qml --include=*.js . | head -20; cat services/PluginShellApi.qml | head -80`

✓ 76 ms

```text
[exit 0, 70 ms]
./plugins/lock/Service.qml:411:    command: ["bash", "-c", "omarchy-brightness-keyboard off; omarchy-brightness-display off"]
./plugins/panels/monitor/Panel.qml:247:    setBrightnessProc.command = ["omarchy-brightness-display", "--no-osd", "--monitor", root.focusedMonitor, percent + "%"]
./plugins/panels/monitor/Panel.qml:419:    // `omarchy-brightness-display` races the hardware/driver and can
import QtQuick

// Capability-scoped shell surface for installed third-party plugins.
//
// The callbacks are closed over one plugin id by shell.qml. A plugin can call
// them directly, but it cannot widen their scope: ordinary plugins are limited
// to their own id, and full-bar callbacks independently enforce their explicit
// non-authentication UI scope. This object avoids directly injecting the host
// shell, but it is not a QML sandbox: visual plugins share the host object tree.
QtObject {
  id: api

  required property string pluginId

  property var appLibrary: null
  property var bar: null
  property var barConfig: ({})
  property var idleConfig: ({})

  property var _serviceLookup: null
  property var _firstPartyServiceLookup: null
  property var _barEntryShellLookup: null
  property var _summon: null
  property var _hide: null
  property var _toggle: null
  property var _isOpen: null
  property var _updateSettings: null
  property var _mutateBarConfig: null

  function serviceFor(id) {
    return _serviceLookup ? _serviceLookup(String(id || "")) : null
  }

  // Full-bar facades and configured Indicators clones under the trusted bar
  // receive narrow proxies for their specific non-authentication services.
  function firstPartyServiceFor(id) {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 380,440p plugins/lock/Service.qml`

✓ 49 ms

```text
[exit 0, 45 ms]
    command: ["bash", "-c", "if [[ -f /etc/pam.d/omarchy-lock-fingerprint ]] && command -v fprintd-list >/dev/null 2>&1 && fprintd-list \"$USER\" 2>/dev/null | grep -qi finger; then echo yes; else echo no; fi"]
    stdout: StdioCollector { id: fingerprintCheckStdout; waitForEnd: true }
    onExited: {
      root.fingerprintConfigured = String(fingerprintCheckStdout.text || "").trim() === "yes"
      if (root.lockRequested && root.fingerprintConfigured) root.startFingerprint()
      else if (!root.fingerprintConfigured && fingerprintPam.active) fingerprintPam.abort()
    }
  }

  Process {
    id: strandedLockCheckProc
    command: ["bash", "-c", "omarchy-hyprland-session-locked"]
    onExited: function(exitCode) {
      // No output to read the lock off yet.
      if (exitCode === 2) return

      root.strandedLockResolved = true

      // A lock taken while this was in flight is this shell's own.
      root.strandedLock = exitCode === 0 && !root.locked && !root.lockRequested
      root.recoverStrandedLock()
    }
  }

  Process {
    id: wakeProcess
    command: ["bash", "-c", "omarchy-system-wake"]
  }

  Process {
    id: blankProcess
    command: ["bash", "-c", "omarchy-brightness-keyboard off; omarchy-brightness-display off"]
  }

  Timer {
    id: idleBlankTimer
    interval: 5000
    repeat: false
    property double armedAt: 0
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function publicIdleConfigFor\|function publicPluginManifest\|function pluginShellFor\b" -A15 shell.qml | head -70`

✓ 47 ms

```text
[exit 0, 43 ms]
316:  function publicPluginManifest(manifest) {
317-    if (!manifest) return null
318-    if (manifest.__isFirstParty) return manifest
319-    var copy = JSON.parse(JSON.stringify(manifest))
320-    delete copy.__sourceDir
321-    delete copy.__isFirstParty
322-    delete copy.__hostCapabilities
323-    return copy
324-  }
325-
326-  function publicBarConfig() {
327-    return JSON.parse(JSON.stringify(shell.barConfig || {}))
328-  }
329-
330-  function barConfigFor(manifest) {
331-    return !manifest || manifest.__isFirstParty
--
364:  function publicIdleConfigFor(manifest) {
365-    var metadata = manifest && Util.isPlainObject(manifest.omarchy) ? manifest.omarchy : null
366-    if (!metadata || String(metadata.clonedFrom || "") !== "omarchy.idle") return ({})
367-    var idle = shell.shellConfig && Util.isPlainObject(shell.shellConfig.idle)
368-      ? shell.shellConfig.idle : ({})
369-    return JSON.parse(JSON.stringify(idle))
370-  }
371-
372-  function pluginCloneMaySummon(manifest, requestedId) {
373-    var metadata = manifest && Util.isPlainObject(manifest.omarchy) ? manifest.omarchy : null
374-    var sourceId = metadata ? String(metadata.clonedFrom || "") : ""
375-    var allowed = {
376-      "omarchy.audio": ["omarchy.osd"],
377-      "omarchy.media": ["omarchy.osd"],
378-      "omarchy.monitor": ["omarchy.osd"],
379-      "omarchy.network": ["omarchy.speedtest", "omarchy.wifiqr"]
--
739:  function pluginShellFor(manifest) {
740-    if (!manifest || manifest.__isFirstParty) return shell
741-    var key = String(manifest.id || "")
742-    if (!key) return null
743-    return shell.createScopedPluginShell(manifest, key, true, shell.pluginHasBarCapabilities(manifest))
…
```

**⏺ bash** `which qmllint qmllint6 /usr/lib/qt6/bin/qmllint 2>&1; echo $WAYLAND_DISPLAY $HYPRLAND_INSTANCE_SIGNATURE; omarchy-shell shell ping 2>&1 | head -3`

✓ 99 ms

```text
[exit 0, 92 ms]
which: no qmllint6 in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
~/.local/bin/qmllint
/usr/lib/qt6/bin/qmllint

OMARCHY_PATH is not set
```

**⏺ bash** `cd /usr/share/omarchy/shell; ls plugins/panels/tailscale; cat plugins/panels/tailscale/manifest.json; grep -rn "omarchyPath" plugins/services/battery/Service.qml | head -3`

✓ 47 ms

```text
[exit 0, 43 ms]
Model.js
Panel.qml
README.md
Service.qml
TailscaleIcon.qml
manifest.json
{
  "schemaVersion": 1,
  "id": "omarchy.tailscale",
  "name": "Tailscale",
  "version": "1.0.0",
  "author": "Omarchy",
  "license": "MIT",
  "description": "Tailscale status, connection switching, machine browsing, and quick copy actions in the Omarchy bar.",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Panel.qml"
  },
  "barWidget": {
    "displayName": "Tailscale",
    "description": "Toggle Tailscale, switch connections, browse machines, and copy machine IPs or names.",
    "category": "Network",
    "allowMultiple": false,
    "defaultSection": "right",
    "defaults": {
      "refreshIntervalSec": 30
    },
    "schema": [
      {
        "key": "refreshIntervalSec",
        "type": "integer",
        "label": "Refresh interval (seconds)",
        "min": 5,
        "max": 3600,
        "step": 5,
        "defaultValue": 30
      }
…
```

Now writing the plugin.

**⏺ write** `.config/omarchy/plugins/parker.screen-sleep/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.screen-sleep",
  "name": "Screen sleep",
  "version": "1.0.0",
  "author": "parker",
  "description": "Turns displays off (DPMS) after 10 minutes without input and back on at the next mouse or keyboard input. Never suspends the machine.",
  "kinds": [
    "service"
  ],
  "entryPoints": {
    "service": "Service.qml"
  }
}
```

✓ 1 ms

```text
wrote 365 bytes to .config/omarchy/plugins/parker.screen-sleep/manifest.json
```

**⏺ write** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

```
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Screen sleep: DPMS-off the displays after a period with no input, DPMS-on
// again at the next input.
//
// This plugin ONLY toggles display power. It never calls systemctl suspend,
// hibernate, or anything else that sleeps the machine, so long-running jobs
// (overnight agents, builds) keep running while the screens are dark.
Item {
  id: root

  // Injected by omarchy-shell.
  property string omarchyPath: Quickshell.env("OMARCHY_PATH") || "/usr/share/omarchy"
  property var shell: null
  property var manifest: null

  // Seconds without keyboard/mouse input before the screens go dark.
  readonly property int timeoutSeconds: 600

  // Honour Omarchy's "stay awake" toggle, same file the built-in idle uses.
  readonly property string stayAwakePath: Quickshell.env("HOME") + "/.local/state/omarchy/indicators/stay-awake"
  readonly property string brightnessCmd: omarchyPath + "/bin/omarchy-brightness-display"

  property bool screensOff: false
  property string lastEvent: "starting"

  function log(event) {
    root.lastEvent = new Date().toISOString() + " " + event
    console.log("screen-sleep " + root.lastEvent)
  }

  function run(proc, command) {
    // If a previous toggle is still in flight, stop it so the newest state wins.
    if (proc.running) proc.running = false
    proc.command = ["bash", "-c", command]
    proc.running = true
  }

  function screensOffNow() {
    log("idle " + root.timeoutSeconds + "s: displays off")
    if (onProcess.running) onProcess.running = false
    root.screensOff = true
    // Skip when the user has stay-awake enabled. DPMS only; no suspend.
    run(offProcess, "[[ -f \"$1\" ]] && exit 0; exec \"$2\" off"
      .replace("$1", root.stayAwakePath).replace("$2", root.brightnessCmd))
  }

  function screensOnNow() {
    log("input: displays on")
    if (offProcess.running) offProcess.running = false
    root.screensOff = false
    run(onProcess, "exec \"" + root.brightnessCmd + "\" on")
  }

  // ext-idle-notify: fires after timeoutSeconds of no keyboard/mouse/touch
  // input, and flips back the moment input arrives. respectInhibitors keeps
  // the screens on while video playback or similar holds an idle inhibitor.
… (46 more lines in the repository)
```

✓ 2 ms

```text
wrote 3312 bytes to .config/omarchy/plugins/parker.screen-sleep/Service.qml
```

**⏺ edit** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

```
  function run(proc, args) {
    // If a previous toggle is still in flight, stop it so the newest state wins.
    if (proc.running) proc.running = false
    proc.command = args
    proc.running = true
  }

  function screensOffNow(force) {
    log((force ? "manual" : "idle " + root.timeoutSeconds + "s") + ": displays off")
    if (onProcess.running) onProcess.running = false
    root.screensOff = true
    // Idle path skips when Omarchy's stay-awake is on. DPMS only; no suspend.
    run(offProcess, ["bash", "-c",
      "[[ $1 != force && -f $2 ]] && exit 0; exec \"$3\" off",
      "screen-sleep", force ? "force" : "idle", root.stayAwakePath, root.brightnessCmd])
  }

  function screensOnNow() {
    log("input: displays on")
    if (offProcess.running) offProcess.running = false
    root.screensOff = false
    run(onProcess, [root.brightnessCmd, "on"])
  }
```

✓ 0 ms

```text
edited .config/omarchy/plugins/parker.screen-sleep/Service.qml at line 35
```

**⏺ edit** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

```
      root.screensOffNow(true)
      return "ok"
```

✓ 0 ms

```text
edited .config/omarchy/plugins/parker.screen-sleep/Service.qml at line 98
```

**⏺ edit** `.config/omarchy/shell.json`

```
  "plugins": [
    {
      "id": "parker.screen-sleep"
    }
  ]
```

✓ 1 ms

```text
edited .config/omarchy/shell.json at line 65
```

**⏺ bash** `cd .config/omarchy; jq . shell.json >/dev/null && jq . plugins/parker.screen-sleep/manifest.json >/dev/null && echo json-ok; /usr/lib/qt6/bin/qmllint plugins/parker.screen-sleep/Service.qml; echo lint=$?; grep -rn "systemctl\|suspend\|hibernate\|loginctl" plugins/parker.screen-sleep | grep -v "^\S*:`

✓ 355 ms

```text
[exit 0, 350 ms]
json-ok
Warning: plugins/parker.screen-sleep/Service.qml:75:5: Type QProcess::ExitStatus of parameter exitStatus in signal called exited was not found, but is required to compile onExited. Did you add all imports and dependencies? [signal-handler-parameters]
    onExited: function(exitCode) { if (exitCode !== 0) root.log("display off failed: exit " + exitCode) }
    ^^^^^^^^
Warning: plugins/parker.screen-sleep/Service.qml:80:5: Type QProcess::ExitStatus of parameter exitStatus in signal called exited was not found, but is required to compile onExited. Did you add all imports and dependencies? [signal-handler-parameters]
    onExited: function(exitCode) { if (exitCode !== 0) root.log("display on failed: exit " + exitCode) }
    ^^^^^^^^
lint=0
plugins/parker.screen-sleep/manifest.json:7:  "description": "Turns displays off (DPMS) after 10 minutes without input and back on at the next mouse or keyboard input. Never suspends the machine.",
```

**⏺ bash** `cd /tmp; printf '#!/bin/bash\necho "called $*"\n' > stub; chmod +x stub; s='[[ $1 != force && -f $2 ]] && exit 0; exec "$3" off'
echo "-- no stay-awake, idle:"; bash -c "$s" screen-sleep idle /tmp/nonexistent /tmp/stub
touch /tmp/sa; echo "-- stay-awake, idle:"; bash -c "$s" screen-sleep idle /tmp/s`

✓ 112 ms

```text
[exit 0, 107 ms]
-- no stay-awake, idle:
called off
-- stay-awake, idle:
exit=0
-- stay-awake, force:
called off
```

**⏺ bash** `git status --short; git diff --stat`

✓ 104 ms

```text
[exit 0, 90 ms]
 M .config/omarchy/shell.json
?? .config/omarchy/plugins/
 .config/omarchy/shell.json | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
```

I built the plugin and enabled it. One thing to know first: **your current settings already turn the screens off at about 5 minutes, not 10.** `shell.json` locks the screen at 300 seconds (5 minutes), and the built-in lock screen turns the displays off 5 seconds after it locks. The new plugin doesn't change that. If you want the screens to stay on for the full 10 minutes, change `idle.lock` to `600` or more. I left it alone because it's a security setting and you didn't ask me to change it.

**What I added**
- **`.config/omarchy/plugins/parker.screen-sleep/`**: a headless shell plugin (`manifest.json` + `Service.qml`).
  - After 600 seconds with no keyboard, mouse or touch input, it turns all displays off using Omarchy's own `omarchy-brightness-display off`.
  - The next input turns them back on. Hyprland already wakes the screens on any key press or mouse movement (Omarchy's defaults); the plugin also sends its own "on" as a backup.
  - It respects things that hold the screen on, like video playback, and Omarchy's "Stay awake" toggle.
  - It only switches display power. Nothing in it calls `systemctl`, suspend or hibernate, so the machine and your agents keep running.
  - You can control it from the command line: `omarchy-shell screen-sleep status`, `... on`, and `... off`. After a manual `off`, your next input wakes the screens through Hyprland, not the plugin.
- **`.config/omarchy/shell.json`**: added `{"id": "parker.screen-sleep"}` to `plugins`, which is how a user plugin gets turned on. The shell reloads this automatically. If it doesn't pick it up, run `omarchy-shell shell rescanPlugins`.
- **Changing the timeout**: edit `timeoutSeconds` in `Service.qml`. Omarchy doesn't let user plugins of this type read settings from `shell.json`, so it's set in the code. Saving the file reloads the plugin.

**Suspend:** none of Omarchy's own idle features suspend, and your login settings (logind) don't set an idle suspend. Choosing Suspend from the menu or closing a laptop lid would still suspend; the plugin doesn't block those. I can make it block all suspends while it runs, but that would also stop a closed lid from suspending.

**How I checked it**
- Both JSON files parse with `jq`.
- `qmllint` passes. It gives two warnings about the shape of the `onExited` handlers, which shouldn't affect how it runs.
- I ran the screen-off command with a stand-in for the brightness tool. It turns the screens off normally, does nothing when "Stay awake" is on, and still turns them off for a manual `off`.

**Not tested:** I couldn't run it in your real session, because the sandbox has no Hyprland or running shell. So I haven't seen it actually turn the screens off and on. To check it yourself, run `omarchy-shell shell listPlugins` to confirm it loaded, then `omarchy-shell screen-sleep status`. For a quick test, set `timeoutSeconds` to something like 30 for a minute, then set it back.

