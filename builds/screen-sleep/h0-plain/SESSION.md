# h0, plain building Screen Sleep

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools read, edit, write, grep, glob, bash

---

### › You

```text
Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.
```

**⏺ bash** `pwd; ls -la; find . -path ./.git -prune -o -type f -print | head -100`

✓ 76 ms

```text
[exit 0, 71 ms]
~
total 0
drwxr-xr-x 1 parker parker  68 Nov  9 16:39 .
drwx------ 3 parker parker  60 Nov  9 16:39 ..
drwxr-xr-x 1 parker parker  12 Nov  9 16:39 .agents
drwxr-xr-x 1 parker parker  12 Nov  9 16:39 .claude
drwxr-xr-x 1 parker parker  12 Nov  9 16:39 .codex
drwxr-xr-x 1 parker parker  72 Nov  8 22:07 .config
drwxr-xr-x 1 parker parker 160 Nov  9 16:39 .git
drwxr-xr-x 1 parker parker  10 Nov  9 16:39 .pi
./.config/hypr/.luarc.json
./.config/hypr/autostart.lua
./.config/hypr/bindings.lua
./.config/hypr/hyprland.lua
./.config/hypr/hyprsunset.conf
./.config/hypr/input.lua
./.config/hypr/looknfeel.lua
./.config/hypr/monitors.lua
./.config/hypr/xdph.conf
./.config/omarchy/extensions/omarchy-menu.jsonc
./.config/omarchy/hooks/battery-low.d/play-warning-sound.sample
./.config/omarchy/hooks/font-set.d/show-font-notification.sample
./.config/omarchy/hooks/post-boot.d/weather.sample
./.config/omarchy/hooks/post-update.d/show-update-notification.sample
./.config/omarchy/hooks/pre-refresh-pacman.d/add-custom-repo.sample
./.config/omarchy/hooks/theme-set.d/show-theme-notification.sample
./.config/omarchy/themed/alacritty.toml.tpl.sample
./.config/omarchy/shell.json
./.config/alacritty/alacritty.toml
./.config/ghostty/config
./.config/kitty/kitty.conf
./.config/foot/foot.ini
```

**⏺ bash** `ls -la .agents .claude .codex .pi; find .agents .claude .codex .pi -type f | head; cat .config/omarchy/shell.json; cat .config/omarchy/extensions/omarchy-menu.jsonc; cat .config/hypr/autostart.lua .config/hypr/hyprland.lua; git log --oneline | head`

✓ 340 ms

```text
[exit 0, 331 ms]
.agents:
total 0
drwxr-xr-x 1 parker parker 12 Nov  9 16:39 .
drwxr-xr-x 1 parker parker 68 Nov  9 16:39 ..
drwxr-xr-x 1 parker parker 42 Nov  9 16:39 skills

.claude:
total 0
drwxr-xr-x 1 parker parker 12 Nov  9 16:39 .
drwxr-xr-x 1 parker parker 68 Nov  9 16:39 ..
drwxr-xr-x 1 parker parker 42 Nov  9 16:39 skills

.codex:
total 0
drwxr-xr-x 1 parker parker 12 Nov  9 16:39 .
drwxr-xr-x 1 parker parker 68 Nov  9 16:39 ..
drwxr-xr-x 1 parker parker 14 Nov  9 16:39 skills

.pi:
total 0
drwxr-xr-x 1 parker parker 10 Nov  9 16:39 .
drwxr-xr-x 1 parker parker 68 Nov  9 16:39 ..
drwxr-xr-x 1 parker parker 12 Nov  9 16:39 agent
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
…
```

**⏺ bash** `find .agents .claude .codex .pi -type f -o -type l | head -50; echo; echo OMARCHY_PATH=$OMARCHY_PATH; ls /usr/share/omarchy 2>&1 | head`

✓ 49 ms

```text
[exit 0, 45 ms]
.agents/skills/omarchy
.agents/skills/diagnose-crash
.claude/skills/omarchy
.claude/skills/diagnose-crash
.codex/skills/omarchy
.pi/agent/skills/omarchy

OMARCHY_PATH=
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
```

**⏺ bash** `ls -la .agents/skills/; readlink -f .agents/skills/omarchy; ls -R $(readlink -f .agents/skills/omarchy) | head -50`

✓ 80 ms

```text
[exit 0, 69 ms]
total 8
drwxr-xr-x 1 parker parker 42 Nov  9 16:39 .
drwxr-xr-x 1 parker parker 12 Nov  9 16:39 ..
lrwxrwxrwx 1 parker parker 55 Nov  9 16:39 diagnose-crash -> /usr/share/omarchy/default/agents/skills/diagnose-crash
lrwxrwxrwx 1 parker parker 48 Nov  9 16:39 omarchy -> /usr/share/omarchy/default/agents/skills/omarchy
/usr/share/omarchy/default/agents/skills/omarchy
/usr/share/omarchy/default/agents/skills/omarchy:
SKILL.md
capture.md
contributing.md
hooks.md
hyprland.md
plugins.md
theming.md
```

**⏺ bash** `cd /usr/share/omarchy/default/agents/skills/omarchy; cat SKILL.md; cat plugins.md`

✓ 53 ms

```text
[exit 0, 46 ms]
---
name: omarchy
description: >
  REQUIRED for end-user customization of Linux desktop, window manager, or system config.
  Use when editing ~/.config/hypr/, ~/.config/omarchy/,
  ~/.config/alacritty/, ~/.config/foot/, ~/.config/kitty/, or ~/.config/ghostty/.
  Triggers: Hyprland, window rules, animations, keybindings, monitors, gaps, borders,
  blur, opacity, omarchy-shell, bar, terminal config, themes, background,
  night light, idle, lock screen, screenshots, reminders, layer rules, workspace
  settings, display config, and user-facing omarchy commands. Excludes Omarchy
  source development through `omarchy dev link` workflows.
---

# Omarchy Skill

Manage [Omarchy](https://omarchy.org/) Linux systems - a beautiful, modern, opinionated Arch Linux distribution with Hyprland.

This skill is for end-user customization on installed systems.
It is not for contributing to Omarchy source code.

## When This Skill MUST Be Used

**ALWAYS invoke this skill for end-user requests involving ANY of these:**

- Editing ANY file in `~/.config/hypr/` (window rules, animations, keybindings, monitors, etc.)
- Editing `~/.config/omarchy/shell.json` (status bar layout, widgets)
- Editing terminal configs (alacritty, foot, kitty, ghostty)
- Editing ANY file in `~/.config/omarchy/`
- Window behavior, animations, opacity, blur, gaps, borders
- Layer rules, workspace settings, display/monitor configuration
- Themes, backgrounds, fonts, appearance changes
- User-facing `omarchy` commands (`omarchy theme ...`, `omarchy refresh ...`, `omarchy restart ...`, etc.)
- Screenshots, screen recording, reminders, night light, idle behavior, lock screen

**If you're about to edit a config file in ~/.config/ on this system, STOP and use this skill first.**

**Do NOT use this skill for Omarchy development tasks** (editing the Omarchy source tree, creating migrations, or running `omarchy dev ...` workflows).

## Topic Guides
…
```

**⏺ bash** `cd /usr/share/omarchy; ls shell shell/plugins; cat config/omarchy/shell.json | head -30; grep -rn "idle" --include=*.qml --include=*.js --include=*.json -il shell | head -30`

✓ 111 ms

```text
[exit 0, 106 ms]
shell:
Commons
README.md
Ui
plugins
services
shell.qml

shell/plugins:
README.md
agents
background
bar
clipboard
dev-gallery
emojis
image-picker
lock
menu
notifications
osd
panels
polkit
reminders
services
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
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat README.md plugins/README.md; ls plugins/services; cat plugins/services/idle/manifest.json plugins/services/idle/Service.qml`

✓ 58 ms

```text
[exit 0, 46 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 150,400p plugins/README.md`

✓ 66 ms

```text
[exit 0, 45 ms]
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/services/idle/manifest.json; sed -n 1,200p plugins/services/idle/Service.qml`

✓ 62 ms

```text
[exit 0, 51 ms]
{
  "schemaVersion": 1,
  "id": "omarchy.idle",
  "name": "Idle",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Quickshell-based idle detection for screensaver, lock, and display wake.",
  "kinds": [
    "service"
  ],
  "keepLoaded": true,
  "entryPoints": {
    "service": "Service.qml"
  }
}
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import "IdleModel.js" as IdleModel

Item {
  id: root

  // Injected by omarchy-shell (the first-party service loader).
  property var shell: null

  readonly property string home: Quickshell.env("HOME")
  readonly property string stayAwakeStateDir: home + "/.local/state/omarchy/indicators"
  readonly property string stayAwakeStatePath: stayAwakeStateDir + "/stay-awake"
  readonly property int defaultScreensaverSeconds: 150
  readonly property int defaultLockSeconds: 300
  readonly property var idleConfig: shell && shell.shellConfig && shell.shellConfig.idle
    ? shell.shellConfig.idle : (shell && shell.idleConfig ? shell.idleConfig : ({}))
  readonly property int screensaverTimeoutSeconds: secondsFromConfig(idleConfig.screensaver, defaultScreensaverSeconds)
  readonly property int lockTimeoutSeconds: secondsFromConfig(idleConfig.lock, defaultLockSeconds)
  readonly property int firstIdleTimeoutSeconds: Math.min(screensaverTimeoutSeconds, lockTimeoutSeconds)
  readonly property int screensaverDelaySeconds: Math.max(0, screensaverTimeoutSeconds - firstIdleTimeoutSeconds)
…
```

**⏺ bash** `cd /usr/share/omarchy; cat bin/omarchy-system-wake bin/omarchy-system-lock 2>&1 | head -60; ls bin | grep -iE "dpms|monitor|screen|suspend|sleep|wake|display"; grep -rln "suspend" bin default config shell 2>/dev/null | head -30`

✓ 91 ms

```text
[exit 0, 86 ms]
#!/bin/bash

# omarchy:summary=Wake displays and restore brightness after idle
# omarchy:group=system
# omarchy:name=wake
# omarchy:examples=omarchy system wake

omarchy-brightness-display on
omarchy-brightness-keyboard restore
omarchy-hyprland-monitor-clamshell >/dev/null 2>&1 || true
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
omarchy-branding-screensaver
omarchy-brightness-display
omarchy-brightness-display-apple
…
```

**⏺ bash** `cd /usr/share/omarchy; cat bin/omarchy-brightness-display; echo ----; grep -n -i "suspend\|dpms\|off" shell/plugins/lock/Service.qml | head -30; echo ---; cat bin/omarchy-toggle-suspend bin/omarchy-system-sleep-monitor | head -60`

✓ 50 ms

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

**⏺ bash** `cd /usr/share/omarchy; sed -n 380,440p shell/plugins/lock/Service.qml; grep -rn "IdleAction\|HandleLidSwitch\|systemctl suspend" etc-overrides default install bin 2>/dev/null | head; grep -rhn "IdleAction" /etc/systemd/logind.conf /etc/systemd/logind.conf.d/ 2>/dev/null`

✓ 71 ms

```text
[exit 0, 66 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; ls plugins/services/*; cat plugins/services/battery/manifest.json; grep -n "service\|keepLoaded\|settings" services/PluginRegistry.qml | head -80`

✓ 70 ms

```text
[exit 0, 66 ms]
plugins/services/battery:
BatteryModel.js
Service.qml
manifest.json

plugins/services/idle:
IdleModel.js
Service.qml
manifest.json

plugins/services/media:
BarWidget.qml
MediaModel.js
Service.qml
manifest.json

plugins/services/nightlight:
NightlightModel.js
Service.qml
manifest.json
{
  "schemaVersion": 1,
  "id": "omarchy.battery",
  "name": "Battery",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Low battery warning service",
  "kinds": [
    "service"
  ],
  "entryPoints": {
    "service": "Service.qml"
  }
}
138:  // overlays, services).
143:  //   - first-party non-bar plugins are shell infrastructure (settings,
146:  //     silently make `omarchy launch bar-settings` a no-op. Turning one off
398:  // back to center. Panels/overlays/menus/services go into the plugins[] array.
694:    // or services/battery.
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 120,200p services/PluginRegistry.qml; sed -n 380,460p services/PluginRegistry.qml; grep -n "function\b" services/PluginRegistry.qml | head -80`

✓ 74 ms

```text
[exit 0, 67 ms]
    var ep = manifest.entryPoints ? manifest.entryPoints[kind] : null
    if (!ep) return ""
    var dir = manifest.__sourceDir || ""
    if (!dir) return ""
    // Defense in depth: even after validateManifest, confirm the resolved
    // path stays inside the plugin's sourceDir.
    var resolved = dir.replace(/\/$/, "") + "/" + String(ep)
    var expectedPrefix = dir.replace(/\/$/, "") + "/"
    if (resolved.indexOf(expectedPrefix) !== 0) {
      console.warn("PluginRegistry: entry point escapes sourceDir: " + resolved)
      return ""
    }
    return Util.fileUrl(resolved)
  }

  // Enabled = the plugin id is referenced somewhere in shell.json. That can
  // be either the active bar option in `bar.id`, a layout entry inside
  // `bar.layout.*` (bar widgets), or a top-level entry in `plugins[]` (panels,
  // overlays, services).
  //
  // Special cases (implicitly always enabled, no shell.json entry needed):
  //   - the built-in bar option (`omarchy.bar`) is active when `bar.id` is
  //     missing or set to `omarchy.bar`.
  //   - first-party non-bar plugins are shell infrastructure (settings,
  //     image-picker, ...). Requiring users to add them to plugins[] just to
  //     summon them was a footgun: a stock shell.json with `plugins: []` would
  //     silently make `omarchy launch bar-settings` a no-op. Turning one off
  //     is therefore recorded the other way round, in `disabledPlugins[]`.
  function isEnabled(id) {
    var key = String(id)
    var manifest = installedPlugins[key]
    var config = shellConfigProvider ? shellConfigProvider() : null
    if (manifest) {
      if (Array.isArray(manifest.kinds) && manifest.kinds.indexOf("bar") !== -1) {
        var selectedBar = ""
        if (Util.isPlainObject(config) && Util.isPlainObject(config.bar))
          selectedBar = Util.canonicalWidgetId(String(config.bar.id || ""))
        if (!selectedBar) selectedBar = "omarchy.bar"
        return selectedBar === key
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 36,118p services/PluginRegistry.qml; grep -n "service" shell.qml | head -60`

✓ 53 ms

```text
[exit 0, 47 ms]
  function isSafeEntryPoint(value) {
    if (typeof value !== "string" || value.length === 0) return false
    if (value.charAt(0) === "/") return false
    if (value.indexOf("..") !== -1) return false
    return true
  }

  function validateManifest(manifest, sourcePath) {
    if (!Util.isPlainObject(manifest)) {
      console.warn("PluginRegistry: manifest is not an object at " + sourcePath)
      return null
    }
    if (manifest.schemaVersion !== 1) {
      console.warn("PluginRegistry: unsupported schemaVersion at " + sourcePath)
      return null
    }
    var required = ["id", "name", "version", "kinds", "entryPoints"]
    for (var i = 0; i < required.length; i++) {
      if (manifest[required[i]] === undefined) {
        console.warn("PluginRegistry: missing required field '" + required[i] + "' at " + sourcePath)
        return null
      }
    }
    var id = String(manifest.id)
    if (!id || id.indexOf("/") !== -1 || id.indexOf("..") !== -1 || id.charAt(0) === "/") {
      console.warn("PluginRegistry: invalid plugin id '" + id + "' at " + sourcePath)
      return null
    }
    if (!Array.isArray(manifest.kinds) || manifest.kinds.length === 0) {
      console.warn("PluginRegistry: kinds must be a non-empty array at " + sourcePath)
      return null
    }
    if (!Util.isPlainObject(manifest.entryPoints)) {
      console.warn("PluginRegistry: entryPoints must be an object at " + sourcePath)
      return null
    }
    if (manifest.barWidget !== undefined && Util.isPlainObject(manifest.barWidget)
        && manifest.barWidget.defaultSection !== undefined) {
      var defaultSection = String(manifest.barWidget.defaultSection)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 440,560p shell.qml; sed -n 895,1000p shell.qml`

✓ 72 ms

```text
[exit 0, 65 ms]
    return api
  }

  function pluginBarStateFor(cacheKey, pluginId) {
    if (_pluginBarStateApis[cacheKey]) return _pluginBarStateApis[cacheKey]
    var api = pluginBarStateApiComponent.createObject(null, { ownerPluginId: pluginId })
    if (!api) return null
    api.barHidden = Qt.binding(function() { return shell.bar ? shell.bar.barHidden === true : false })
    api.barSize = Qt.binding(function() { return shell.bar ? Math.max(0, shell.bar.barSize || 0) : 0 })
    api.fontFamily = Qt.binding(function() { return shell.bar ? String(shell.bar.fontFamily || "") : "" })
    api.position = Qt.binding(function() { return shell.bar ? String(shell.bar.position || "top") : "top" })
    var next = ({})
    for (var id in _pluginBarStateApis) next[id] = _pluginBarStateApis[id]
    next[cacheKey] = api
    _pluginBarStateApis = next
    return api
  }

  function pluginFirstPartyServiceFor(cacheKey, pluginId, requestedId) {
    var id = String(requestedId || "")
    var allowed = ["omarchy.idle", "omarchy.media", "omarchy.nightlight", "omarchy.notifications"]
    if (allowed.indexOf(id) === -1) return null
    var proxyKey = cacheKey + "::" + id
    if (_pluginFirstPartyServiceApis[proxyKey]) return _pluginFirstPartyServiceApis[proxyKey]

    function service() {
      return shell.serviceFor(shell.pluginRegistry.resolveEnabledId(id))
    }
    var api = pluginFirstPartyServiceApiComponent.createObject(null, {
      ownerPluginId: pluginId,
      serviceId: id,
      _setIdleEnabled: function(value) {
        var target = service()
        if (target && typeof target.setIdleEnabled === "function") target.setIdleEnabled(value)
      },
      _setNightlight: function(value) {
        var target = service()
        if (target && typeof target.setNightlight === "function") target.setNightlight(value)
      },
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "property\|function" services/PluginShellApi.qml | head -60; cat services/PluginFirstPartyServiceApi.qml | head -40`

✓ 76 ms

```text
[exit 0, 69 ms]
13:  required property string pluginId
15:  property var appLibrary: null
16:  property var bar: null
17:  property var barConfig: ({})
18:  property var idleConfig: ({})
20:  property var _serviceLookup: null
21:  property var _firstPartyServiceLookup: null
22:  property var _barEntryShellLookup: null
23:  property var _summon: null
24:  property var _hide: null
25:  property var _toggle: null
26:  property var _isOpen: null
27:  property var _updateSettings: null
28:  property var _mutateBarConfig: null
30:  function serviceFor(id) {
36:  function firstPartyServiceFor(id) {
41:  function pluginShellForBarEntry(ownerId, moduleName) {
46:  function summon(id, payloadJson) {
50:  function hide(id) {
54:  function toggle(id, payloadJson) {
58:  function isPluginOpen(id) {
62:  function updateEntryInline(id, settings) {
66:  function mutateShellConfig(mutator) {
67:    return _mutateBarConfig && typeof mutator === "function"
import QtQuick

// Narrow proxy for the non-authentication first-party services used by the
// built-in bar. It intentionally has no generic property or method forwarding.
QtObject {
  required property string ownerPluginId
  required property string serviceId

  property bool stayAwake: false
  property bool enabled: false
  property bool doNotDisturb: false
  property var activePlayer: null
  property var sourcePlayers: []

  property var _setIdleEnabled: null
…
```

**⏺ bash** `which quickshell qs qmllint qmllint6 omarchy-shell hyprctl 2>&1; ls /usr/lib/qt6/bin 2>/dev/null | head; echo $WAYLAND_DISPLAY $HYPRLAND_INSTANCE_SIGNATURE; cat /usr/share/omarchy/shell/plugins/services/idle/IdleModel.js | head -30; whoami`

✓ 78 ms

```text
[exit 0, 70 ms]
which: no qmllint6 in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
/usr/bin/quickshell
/usr/bin/qs
~/.local/bin/qmllint
/usr/bin/omarchy-shell
/usr/bin/hyprctl
androiddeployqt
androiddeployqt6
androidtestrunner
mozcerts-qt6
qcatool-qt6
qdbuscpp2xml
qdbusxml2cpp
qmake
qmake6
qml

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
…
```

**⏺ bash** `cd /usr/share/omarchy; grep -rn "enables_dpms\|dpms" default/hypr | head; ls config/omarchy; ls ~/.config/omarchy; grep -rn "IdleMonitor" shell | grep -v "^shell/plugins/services/idle" | head`

✓ 70 ms

```text
[exit 0, 66 ms]
default/hypr/input.lua:72:    key_press_enables_dpms = true,
default/hypr/input.lua:73:    mouse_move_enables_dpms = true,
extensions
hooks
shell.json
themed
extensions
hooks
shell.json
themed
themes
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 474,575p services/PluginRegistry.qml; sed -n 231,250p services/PluginRegistry.qml`

✓ 71 ms

```text
[exit 0, 66 ms]
  function setEnabled(id, value, placement) {
    var key = Util.canonicalWidgetId(String(id))
    lastEnableError = ""
    if (!shellConfigMutator) {
      console.warn("PluginRegistry.setEnabled called before shellConfigMutator wired")
      return false
    }
    var manifest = installedPlugins[key]
    if (value && !manifest) {
      console.warn("PluginRegistry.setEnabled: unknown plugin " + key)
      return false
    }
    var isBarOption = manifest && Array.isArray(manifest.kinds) && manifest.kinds.indexOf("bar") !== -1
    var isBarWidget = manifest && Array.isArray(manifest.kinds) && manifest.kinds.indexOf("bar-widget") !== -1
    var hasNonWidgetKind = manifest && Array.isArray(manifest.kinds)
      && manifest.kinds.some(function(kind) { return kind !== "bar-widget" })
    var metadata = manifest && Util.isPlainObject(manifest.omarchy) ? manifest.omarchy : null
    var clonedFrom = metadata ? Util.canonicalWidgetId(String(metadata.clonedFrom || "")) : ""
    shellConfigMutator(function(config) {
      ensureConfigShape(config)

      if (value && placement && (placement.before || placement.after)) {
        var relativeId = String(placement.before || placement.after)
        if (!findRelativeBarLocation(config, relativeId, String(placement.section || "")).found) {
          lastEnableError = "could not find target widget " + relativeId
          return
        }
      }

      if (value && manifest && manifest.__isFirstParty) {
        var activeClone = activeCloneFor(config, key)
        if (activeClone) {
          restoreCloneSource(config, activeClone, key)
          removeDisabled(config, key)
        }
      }

      if (isBarOption) {
        if (value) {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/services/nightlight/manifest.json; head -40 plugins/services/nightlight/Service.qml; cat ~/.local/bin/qmllint 2>/dev/null | head -5; file ~/.local/bin/qmllint`

✓ 70 ms

```text
[exit 0, 65 ms]
{
  "schemaVersion": 1,
  "id": "omarchy.nightlight",
  "name": "Night Light",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Owns the hyprsunset night light temperature for the bar indicator and CLI.",
  "kinds": [
    "service"
  ],
  "entryPoints": {
    "service": "Service.qml"
  }
}
import QtQuick
import Quickshell.Io
import "NightlightModel.js" as NightlightModel

Item {
  id: root

  // Injected by omarchy-shell (the first-party service loader).
  property var shell: null

  // Keep in sync with bin/omarchy-toggle-nightlight, which sets the same
  // temperatures for callers outside the shell (keybindings, menu, ssh).
  readonly property int nightTemperature: 4000
  readonly property int dayTemperature: 6500

  property bool stateLoaded: false
  property var temperature: null
  readonly property bool enabled: stateLoaded && NightlightModel.isNightlight(temperature)

  property bool hasPendingTemperature: false
  property int pendingTemperature: 0

  function refresh() {
    if (!statusProbe.running) statusProbe.running = true
  }
…
```

**⏺ write** `.config/omarchy/plugins/parker.screen-sleep/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.screen-sleep",
  "name": "Screen Sleep",
  "version": "1.0.0",
  "author": "parker",
  "description": "Turns displays off after 10 minutes without input and back on at the next mouse or keyboard input. Never suspends the machine.",
  "kinds": [
    "service"
  ],
  "entryPoints": {
    "service": "Service.qml"
  }
}
```

✓ 2558 ms

```text
wrote 358 bytes to .config/omarchy/plugins/parker.screen-sleep/manifest.json
```

**⏺ write** `.config/omarchy/plugins/parker.screen-sleep/ScreenSleepModel.js`

```
.pragma library

// Pure decision logic for the screen-sleep service, kept free of QML so it
// can be unit tested with plain node (see test.mjs).

// Ten minutes without keyboard/mouse input.
var DEFAULT_IDLE_SECONDS = 600

// The only commands this plugin ever runs. Neither touches systemd sleep,
// logind, or anything that can suspend/hibernate the machine: they only toggle
// Hyprland DPMS and the keyboard backlight.
var SCREENS_OFF_COMMAND = "omarchy-brightness-keyboard off; omarchy-brightness-display off"
var SCREENS_ON_COMMAND = "omarchy-system-wake"

// Decide what to do after the idle monitor or stay-awake state changes.
// Returns "off", "on", or "" (nothing to do).
//   idle       - the compositor reports no input for the idle timeout
//   stayAwake  - Omarchy's "stay awake" toggle is on
//   screensOff - this plugin currently has the screens turned off
function nextAction(idle, stayAwake, screensOff) {
  var wantOff = !!idle && !stayAwake
  if (wantOff && !screensOff) return "off"
  if (!wantOff && screensOff) return "on"
  return ""
}

function commandFor(action) {
  if (action === "off") return SCREENS_OFF_COMMAND
  if (action === "on") return SCREENS_ON_COMMAND
  return ""
}
```

✓ 23 ms

```text
wrote 1209 bytes to .config/omarchy/plugins/parker.screen-sleep/ScreenSleepModel.js
```

**⏺ write** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

```
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "ScreenSleepModel.js" as Model

// Headless service: turn every display off after 10 minutes without keyboard
// or mouse input, and back on at the next input.
//
// It never suspends the machine. The only commands it runs are listed in
// ScreenSleepModel.js and just toggle DPMS / keyboard backlight, so anything
// left running (agents, builds, downloads) keeps going while the screens are
// dark.
//
// Respects Omarchy's "stay awake" toggle and Wayland idle inhibitors (e.g. a
// fullscreen video), the same way the built-in omarchy.idle service does.
Item {
  id: root

  // Injected by omarchy-shell; unused but declared so injection is harmless.
  property var shell: null
  property var manifest: null

  readonly property int idleSeconds: Model.DEFAULT_IDLE_SECONDS

  readonly property string home: Quickshell.env("HOME")
  readonly property string stayAwakeStateDir: home + "/.local/state/omarchy/indicators"

  property bool stayAwake: false
  property bool screensOff: false
  property string pendingAction: ""

  function log(message) {
    console.log("parker.screen-sleep " + new Date().toISOString() + " " + message)
  }

  function evaluate(reason) {
    var action = Model.nextAction(idleMonitor.isIdle, root.stayAwake, root.screensOff)
    if (!action) return
    log(reason + " -> screens " + action)
    root.screensOff = action === "off"
    run(action)
  }

  function run(action) {
    // Never overlap DPMS commands; replay only the latest wanted state.
    if (displayProcess.running) {
      root.pendingAction = action
      return
    }
    displayProcess.command = ["bash", "-lc", Model.commandFor(action)]
    displayProcess.running = true
  }

  IdleMonitor {
    id: idleMonitor
    enabled: true
    timeout: root.idleSeconds
    respectInhibitors: true
    onIsIdleChanged: root.evaluate(isIdle ? "idle" : "input")
… (62 more lines in the repository)
```

✓ 2 ms

```text
wrote 3779 bytes to .config/omarchy/plugins/parker.screen-sleep/Service.qml
```

**⏺ write** `.config/omarchy/plugins/parker.screen-sleep/test.mjs`

```
// Run: node ~/.config/omarchy/plugins/parker.screen-sleep/test.mjs
import { readFileSync } from "node:fs"
import vm from "node:vm"
import assert from "node:assert/strict"

const dir = new URL(".", import.meta.url)
const read = (name) => readFileSync(new URL(name, dir), "utf8")

const Model = {}
vm.runInNewContext(read("ScreenSleepModel.js").replace(".pragma library", ""), Model)

// Timeout is ten minutes.
assert.equal(Model.DEFAULT_IDLE_SECONDS, 600)

// idle, stayAwake, screensOff -> action
const cases = [
  [true, false, false, "off"], // 10 min of no input: turn screens off
  [true, false, true, ""],     // already off
  [false, false, true, "on"],  // mouse/keyboard input: turn back on
  [false, false, false, ""],   // already on
  [true, true, false, ""],     // stay-awake keeps screens on
  [true, true, true, "on"],    // stay-awake toggled while dark wakes them
  [false, true, true, "on"],
  [false, true, false, ""],
]
for (const [idle, stay, off, want] of cases)
  assert.equal(Model.nextAction(idle, stay, off), want, JSON.stringify({ idle, stay, off }))

assert.equal(Model.commandFor("off"), "omarchy-brightness-keyboard off; omarchy-brightness-display off")
assert.equal(Model.commandFor("on"), "omarchy-system-wake")
assert.equal(Model.commandFor(""), "")

// Never suspend: no sleep/suspend/hibernate/poweroff primitives anywhere in
// the plugin's executable code (comments stripped).
const forbidden = /systemctl|loginctl|suspend|hibernate|hybrid-sleep|poweroff|rtcwake|\/sys\/power|omarchy-system-(sleep|shutdown|reboot|lock)|zzz/i
for (const file of ["Service.qml", "ScreenSleepModel.js"]) {
  const code = read(file).replace(/\/\/.*$/gm, "")
  assert.ok(!forbidden.test(code), `${file} contains a sleep/suspend primitive: ${code.match(forbidden)}`)
}

// The commands it does run must not themselves reach suspend.
for (const bin of ["omarchy-brightness-display", "omarchy-brightness-keyboard", "omarchy-system-wake"]) {
  const src = readFileSync(`/usr/share/omarchy/bin/${bin}`, "utf8")
  assert.ok(!/systemctl\s+(suspend|hibernate|hybrid-sleep|suspend-then-hibernate)|loginctl\s+suspend/.test(src), `${bin} can suspend`)
}

console.log("parker.screen-sleep: all tests passed")
```

✓ 1 ms

```text
wrote 2215 bytes to .config/omarchy/plugins/parker.screen-sleep/test.mjs
```

**⏺ bash** `node .config/omarchy/plugins/parker.screen-sleep/test.mjs; cat /usr/share/omarchy/bin/omarchy-brightness-keyboard | head -40; cat /usr/share/omarchy/bin/omarchy-hyprland-monitor-clamshell | head -40`

✓ 6455 ms

```text
[exit 0, 6442 ms]
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Remote versions cannot be fetched for anthropics/claude-code: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for cli/cli: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for gh: [~/.config/mise/config.toml] gh@latest: unable to fetch versions for gh: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for openai/codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for codex: [~/.config/mise/config.toml] codex@latest: unable to fetch versions for codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for charmbracelet/crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for crush: [~/.config/mise/config.toml] crush@latest: unable to fetch versions for crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for claude: [~/.config/mise/config.toml] claude@latest: unable to fetch versions for claude: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for earendil-works/pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for pi: [~/.config/mise/config.toml] pi@latest: unable to fetch versions for pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for astral-sh/uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for uv: [~/.config/mise/config.toml] uv@latest: unable to fetch versions for uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Failed to resolve tool version list for npm:playwright: [~/.config/mise/config.toml] npm:playwright@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for gemini: [~/.config/mise/config.toml] gemini@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for opencode: [~/.config/mise/config.toml] opencode@latest: timed out after 3.00s
mise by @jdx – installing 1 tool
mise ✗ node@26.7.0  20ms · failed: error sending request
mise ████████████████ 1/1 · installed 0 tools · 1 failed in 24ms
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: HTTP host https://cursor.com:443 is unavailable after an earlier connection failure: error sending request
mise ERROR Failed to install core:node@26.7.0: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise ERROR Version: 2026.10.9 linux-x64 (2026-10-13)
mise ERROR Run with --verbose or MISE_VERBOSE=1 for more information
#!/bin/bash

# omarchy:summary=Adjust keyboard backlight brightness using available steps.
# omarchy:args=[--no-osd] <up|down|cycle|off|restore>

no_osd=0
if [[ ${1:-} == "--no-osd" ]]; then
  no_osd=1
  shift
fi

direction="${1:-up}"

# Find keyboard backlight device (look for *kbd_backlight* pattern in leds class).
…
```

**⏺ bash** `ls /usr/bin/node /usr/bin/bun /usr/bin/deno /usr/bin/qjs 2>&1; ls ~/.local/share/mise/installs/node/ 2>&1; ls ~/.local/share/mise/installs/node/*/bin/node 2>&1`

✓ 108 ms

```text
[exit 0, 93 ms]
ls: cannot access '/usr/bin/node': No such file or directory
/usr/bin/bun
/usr/bin/deno
/usr/bin/qjs
ls: cannot access '~/.local/share/mise/installs/node/': No such file or directory
~/.local/share/mise/installs/node/22.23.2/bin/node
~/.local/share/mise/installs/node/22.23/bin/node
~/.local/share/mise/installs/node/22/bin/node
~/.local/share/mise/installs/node/26.7.0/bin/node
~/.local/share/mise/installs/node/26.7/bin/node
~/.local/share/mise/installs/node/26/bin/node
~/.local/share/mise/installs/node/global/bin/node
~/.local/share/mise/installs/node/latest/bin/node
~/.local/share/mise/installs/node/lts-jod/bin/node
```

**⏺ bash** `/usr/bin/bun .config/omarchy/plugins/parker.screen-sleep/test.mjs; echo exit=$?; ~/.local/share/mise/installs/node/26.7.0/bin/node .config/omarchy/plugins/parker.screen-sleep/test.mjs; echo exit=$?`

✓ 616 ms

```text
[exit 0, 609 ms]
33 | // Never suspend: no sleep/suspend/hibernate/poweroff primitives anywhere in
34 | // the plugin's executable code (comments stripped).
35 | const forbidden = /systemctl|loginctl|suspend|hibernate|hybrid-sleep|poweroff|rtcwake|\/sys\/power|omarchy-system-(sleep|shutdown|reboot|lock)|zzz/i
36 | for (const file of ["Service.qml", "ScreenSleepModel.js"]) {
37 |   const code = read(file).replace(/\/\/.*$/gm, "")
38 |   assert.ok(!forbidden.test(code), `${file} contains a sleep/suspend primitive: ${code.match(forbidden)}`)
              ^
AssertionError: Service.qml contains a sleep/suspend primitive: suspend,
 generatedMessage: false,
     actual: false,
   expected: true,
   operator: "==",
       diff: "simple",
       code: "ERR_ASSERTION"

      at ~/.config/omarchy/plugins/parker.screen-sleep/test.mjs:38:10

Bun v1.4.0 (Linux x64)
exit=1
node:internal/modules/run_main:107
    triggerUncaughtException(
    ^

AssertionError [ERR_ASSERTION]: Service.qml contains a sleep/suspend primitive: suspend,
    at file://~/.config/omarchy/plugins/parker.screen-sleep/test.mjs:38:10
    at ModuleJob.run (node:internal/modules/esm/module_job:569:25)
    at async node:internal/modules/esm/loader:650:26
    at async asyncRunEntryPointWithESMLoader (node:internal/modules/run_main:101:5) {
  generatedMessage: false,
  code: 'ERR_ASSERTION',
  actual: false,
  expected: true,
  operator: '==',
  diff: 'simple'
}

Node.js v26.7.0
exit=1
```

**⏺ edit** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

```
idle (display power only)")
```

✓ 3 ms

```text
edited .config/omarchy/plugins/parker.screen-sleep/Service.qml at line 100
```

**⏺ bash** `N=~/.local/share/mise/installs/node/26.7.0/bin/node; $N .config/omarchy/plugins/parker.screen-sleep/test.mjs; echo exit=$?; qmllint --help >/dev/null 2>&1 && echo hasqmllint; cd .config/omarchy/plugins/parker.screen-sleep && qmllint Service.qml 2>&1 | head -30`

✓ 541 ms

```text
[exit 0, 530 ms]
parker.screen-sleep: all tests passed
exit=0
hasqmllint
Warning: Service.qml:65:5: Type QProcess::ExitStatus of parameter exitStatus in signal called exited was not found, but is required to compile onExited. Did you add all imports and dependencies? [signal-handler-parameters]
    onExited: function(exitCode) {
    ^^^^^^^^
Warning: Service.qml:88:5: Type QProcess::ExitStatus of parameter exitStatus in signal called exited was not found, but is required to compile onExited. Did you add all imports and dependencies? [signal-handler-parameters]
    onExited: stayAwakeWatcher.reload()
    ^^^^^^^^
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/services/idle && qmllint Service.qml 2>&1 | grep -c ExitStatus; T=$(mktemp -d); cp ~/.config/omarchy/plugins/parker.screen-sleep/{Service.qml,ScreenSleepModel.js} $T/; cat > $T/shell.qml <<'EOF'
import QtQuick
import Quickshell
ShellRoot {
  Service { id: s }
  Ti`

✓ 1919 ms

```text
[exit 0, 1912 ms]
5
  INFO: Launching config: "/tmp/tmp.6GhxgPADcl/shell.qml"
  INFO: Shell ID: "07209d3b6ec567412723008c7dab4cbe" Path ID "07209d3b6ec567412723008c7dab4cbe"
  INFO: Saving logs to "/run/user/1000/quickshell/by-id/apud9ot/log.qslog"
 DEBUG qml: parker.screen-sleep 2026-11-09T23:42:25.850Z ready, screens off after 600s idle (display power only)
error: XDG_RUNTIME_DIR is invalid or not set in the environment.
  WARN : Failed to create wl_display (No such file or directory)
  WARN: Cannot create idle monitor as ext-idle-notify-v1 is not supported by the current compositor.
  INFO: Configuration Loaded
 DEBUG qml: STATUS idle=600 off=false stay=false
```

**⏺ bash** `T=$(ls -dt /tmp/tmp.* | head -1); mkdir -p $T/.local/state/omarchy/indicators; touch $T/.local/state/omarchy/indicators/stay-awake; HOME=$T QT_QPA_PLATFORM=offscreen timeout 10 quickshell -p $T/shell.qml 2>&1 | grep -E "qml|WARN|rror"; rm -rf $T`

✓ 163 ms

```text
[exit 0, 151 ms]
ls: cannot access '/tmp/tmp.*': No such file or directory
mkdir: cannot create directory ‘/.local’: Read-only file system
touch: cannot touch '/.local/state/omarchy/indicators/stay-awake': No such file or directory
Could not open config file at "/shell.qml"
```

Temp dirs don't persist between calls; redo in one shot.

**⏺ bash** `T=$(mktemp -d); cp ~/.config/omarchy/plugins/parker.screen-sleep/{Service.qml,ScreenSleepModel.js} $T/; cat > $T/shell.qml <<'EOF'
import QtQuick
import Quickshell
ShellRoot {
  Service { id: s }
  Timer { interval: 1500; running: true; onTriggered: { console.log("STATUS stay=" + s.stayAwake + " off`

✓ 1737 ms

```text
[exit 0, 1708 ms]
 DEBUG qml: parker.screen-sleep 2026-11-09T23:42:36.765Z ready, screens off after 600s idle (display power only)
 DEBUG qml: STATUS stay=true off=false
```

**⏺ edit** `.config/omarchy/shell.json`

```
  "plugins": [
    {
      "id": "parker.screen-sleep"
    }
  ]
```

✓ 203 ms

```text
edited .config/omarchy/shell.json at line 65
```

**⏺ bash** `jq -e '.plugins' .config/omarchy/shell.json && jq . .config/omarchy/plugins/parker.screen-sleep/manifest.json >/dev/null && echo ok; omarchy-shell shell ping 2>&1 | head -3; git status --short`

✓ 455 ms

```text
[exit 0, 375 ms]
[
  {
    "id": "parker.screen-sleep"
  }
]
ok
OMARCHY_PATH is not set
 M .config/omarchy/shell.json
 D .config/omarchy/themes/ember/README.md
 D .config/omarchy/themes/ember/colors.toml
 D .config/omarchy/themes/ember/hyprland.lua
 D .config/omarchy/themes/ember/icons.theme
 D .config/omarchy/themes/ember/install.sh
 D .config/omarchy/themes/ember/neovim.lua
?? .agents/
?? .claude/
?? .codex/
?? .config/omarchy/plugins/
?? .local/
?? .pi/
```

**⏺ bash** `find .local | head; ls -la .config/omarchy/themes; git show --stat HEAD | grep -i ember`

✓ 320 ms

```text
[exit 0, 296 ms]
.local
.local/state
.local/state/mise
.local/state/mise/tracked-configs
.local/state/mise/tracked-configs/8689d62d58dd82ae
.local/state/mise/tracked-configs/3a8292bc9105163d
.local/state/mise/incomplete-installs
.local/state/mise/incomplete-installs/node
.local/share
.local/share/mise
total 0
drwxr-xr-x 1 parker parker  0 Nov  9 16:39 .
drwxr-xr-x 1 parker parker 88 Nov  9 16:42 ..
 .config/omarchy/themes/ember/README.md             |  7 ++
 .config/omarchy/themes/ember/colors.toml           | 31 ++++++++
 .config/omarchy/themes/ember/hyprland.lua          |  2 +
 .config/omarchy/themes/ember/icons.theme           |  1 +
 .config/omarchy/themes/ember/install.sh            |  5 ++
 .config/omarchy/themes/ember/neovim.lua            | 11 +++
```

**⏺ bash** `rm -rf .local; git status --short; ls .config/omarchy/plugins/parker.screen-sleep`

✓ 639 ms

```text
[exit 0, 634 ms]
 M .config/omarchy/shell.json
 D .config/omarchy/themes/ember/README.md
 D .config/omarchy/themes/ember/colors.toml
 D .config/omarchy/themes/ember/hyprland.lua
 D .config/omarchy/themes/ember/icons.theme
 D .config/omarchy/themes/ember/install.sh
 D .config/omarchy/themes/ember/neovim.lua
?? .agents/
?? .claude/
?? .codex/
?? .config/omarchy/plugins/
?? .pi/
ScreenSleepModel.js
Service.qml
manifest.json
test.mjs
```

I built the plugin and turned it on. Its logic passes its tests and it loads cleanly in Quickshell, but I couldn't watch it turn real screens off and on, because there's no Hyprland session in my sandbox.

**One thing to fix first:** your stock idle settings will turn the screens off before 10 minutes. `shell.json` still has the screensaver at 150s (2.5 min) and the lock at 300s (5 min). The stock lock screen turns the displays off about 5 seconds after it locks, so right now they'd go dark at about 5 minutes. To make 10 minutes the real behavior, raise or remove `idle.lock` (and `idle.screensaver` if you want). I didn't change these without asking. Tell me and I'll do it.

**What it does** (`~/.config/omarchy/plugins/parker.screen-sleep/`)
- After 600 seconds with no keyboard or mouse input, it turns off every display and the keyboard backlight. It uses the same Omarchy commands the stock idle and lock use.
- At the next input it runs `omarchy-system-wake` to turn the displays back on. Hyprland is also set to wake displays on any key press or mouse move, so there are two paths back.
- It leaves the screens on while Omarchy's "stay awake" toggle is on, or while an app is blocking idle (for example, a fullscreen video). Turning stay-awake on while the screens are off wakes them.
- If the plugin is reloaded or turned off while the screens are dark, it turns them back on first.
- `omarchy-shell screen-sleep status` shows its current state.
- I added `{"id": "parker.screen-sleep"}` to `plugins` in `~/.config/omarchy/shell.json`, which turns it on. The shell reloads that file when it changes.

**Never suspending**
- The plugin only ever runs two commands, one to turn displays off and one to turn them on. Nothing in it can suspend or hibernate the machine.
- Nothing else in Omarchy suspends after idle time either.
- **Still possible:** suspending on purpose from the system menu, or closing a laptop lid, can still suspend the machine. That's outside this plugin. If you want those blocked too, I can run `omarchy toggle suspend` to take Suspend out of the menu, or block sleep entirely while the plugin runs.

**How I checked it**
- `test.mjs` checks the 10-minute timeout and every combination of idle and stay-awake. It also scans the plugin and the commands it calls for anything that could suspend. All tests pass.
- I loaded it in Quickshell without a display. It starts without errors and picks up the stay-awake setting.
- `qmllint` only gave the same type warning the stock idle service gets.
- To run the tests yourself: `node ~/.config/omarchy/plugins/parker.screen-sleep/test.mjs`. That's the full path to `node` on your machine; plain `node` tried to download a version and failed offline.

**Also found:** git shows the `ember` theme files in `~/.config/omarchy/themes/ember/` as deleted. They were already gone when I started, and I didn't touch them. I also removed some leftover `.local/state/mise` files that my `node` attempt created.

---

### › You

```text
It's not working yet: I can't see where it turns the screens off through Hyprland's DPMS, or it can suspend the machine.

read from the code
```

**⏺ bash** `cd .config/omarchy/plugins/parker.screen-sleep; grep -n "" ScreenSleepModel.js | sed -n 8,31p; grep -n "Model\.\|IdleMonitor\|execDetached\|command" Service.qml; echo ---; grep -n "dpms\|off\|on\"" /usr/share/omarchy/bin/omarchy-brightness-display | head; echo ---; cat -n /usr/share/omarchy/bin/omar`

✓ 74 ms

```text
[exit 0, 68 ms]
8:
9:// The only commands this plugin ever runs. Neither touches systemd sleep,
10:// logind, or anything that can suspend/hibernate the machine: they only toggle
11:// Hyprland DPMS and the keyboard backlight.
12:var SCREENS_OFF_COMMAND = "omarchy-brightness-keyboard off; omarchy-brightness-display off"
13:var SCREENS_ON_COMMAND = "omarchy-system-wake"
14:
15:// Decide what to do after the idle monitor or stay-awake state changes.
16:// Returns "off", "on", or "" (nothing to do).
17://   idle       - the compositor reports no input for the idle timeout
18://   stayAwake  - Omarchy's "stay awake" toggle is on
19://   screensOff - this plugin currently has the screens turned off
20:function nextAction(idle, stayAwake, screensOff) {
21:  var wantOff = !!idle && !stayAwake
22:  if (wantOff && !screensOff) return "off"
23:  if (!wantOff && screensOff) return "on"
24:  return ""
25:}
26:
27:function commandFor(action) {
28:  if (action === "off") return SCREENS_OFF_COMMAND
29:  if (action === "on") return SCREENS_ON_COMMAND
30:  return ""
31:}
5:import "ScreenSleepModel.js" as Model
10:// It never suspends the machine. The only commands it runs are listed in
11:// ScreenSleepModel.js and just toggle DPMS / keyboard backlight, so anything
24:  readonly property int idleSeconds: Model.DEFAULT_IDLE_SECONDS
38:    var action = Model.nextAction(idleMonitor.isIdle, root.stayAwake, root.screensOff)
46:    // Never overlap DPMS commands; replay only the latest wanted state.
51:    displayProcess.command = ["bash", "-lc", Model.commandFor(action)]
55:  IdleMonitor {
66:      if (exitCode !== 0) root.log("display command exited " + exitCode)
79:    command: ["bash", "-c", "mkdir -p \"$HOME/.local/state/omarchy/indicators\"; [[ -f $HOME/.local/state/omarchy/indicators/stay-awake ]] && echo yes || echo no"]
107:    if (root.screensOff) Quickshell.execDetached(["bash", "-lc", Model.SCREENS_ON_COMMAND])
---
4:# omarchy:args=[--no-osd] [--monitor name] [+N%|N%-|N%|off|on]
5:# omarchy:examples=omarchy brightness display | omarchy brightness display +5% | omarchy brightness display --monitor DP-1 50% | omarchy brightness display off | omarchy brightness display on
62:if [[ $step == "off" ]]; then
…
```

**⏺ read** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

✓ 1 ms

```text
1	import QtQuick
2	import Quickshell
3	import Quickshell.Io
4	import Quickshell.Wayland
5	import "ScreenSleepModel.js" as Model
6	
7	// Headless service: turn every display off after 10 minutes without keyboard
8	// or mouse input, and back on at the next input.
9	//
10	// It never suspends the machine. The only commands it runs are listed in
11	// ScreenSleepModel.js and just toggle DPMS / keyboard backlight, so anything
12	// left running (agents, builds, downloads) keeps going while the screens are
13	// dark.
14	//
15	// Respects Omarchy's "stay awake" toggle and Wayland idle inhibitors (e.g. a
16	// fullscreen video), the same way the built-in omarchy.idle service does.
17	Item {
18	  id: root
19	
20	  // Injected by omarchy-shell; unused but declared so injection is harmless.
21	  property var shell: null
22	  property var manifest: null
23	
24	  readonly property int idleSeconds: Model.DEFAULT_IDLE_SECONDS
25	
26	  readonly property string home: Quickshell.env("HOME")
27	  readonly property string stayAwakeStateDir: home + "/.local/state/omarchy/indicators"
28	
29	  property bool stayAwake: false
30	  property bool screensOff: false
31	  property string pendingAction: ""
32	
33	  function log(message) {
34	    console.log("parker.screen-sleep " + new Date().toISOString() + " " + message)
35	  }
36	
37	  function evaluate(reason) {
38	    var action = Model.nextAction(idleMonitor.isIdle, root.stayAwake, root.screensOff)
39	    if (!action) return
40	    log(reason + " -> screens " + action)
…
```

**⏺ bash** `cd .config/omarchy/plugins/parker.screen-sleep && python3 - <<'EOF'
import re
p='ScreenSleepModel.js'; s=open(p).read()
s=s.replace('''// The only commands this plugin ever runs. Neither touches systemd sleep,
// logind, or anything that can suspend/hibernate the machine: they only toggle
// Hyprlan`

✓ 621 ms

```text
[exit 0, 613 ms]
Service.qml:52:    displayProcess.command = Model.argvFor(action)
Service.qml:80:    command: ["bash", "-c", "mkdir -p \"$HOME/.local/state/omarchy/indicators\"; [[ -f $HOME/.local/state/omarchy/indicators/stay-awake ]] && echo yes || echo no"]
Service.qml:108:    if (root.screensOff) Quickshell.execDetached(Model.argvFor("on"))
ScreenSleepModel.js:28:function argvFor(action) {
```

Now I'll remove the last `bash` call, the stay-awake check, so the plugin runs no shell anywhere:

**⏺ read** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

✓ 1 ms

```text
74	  }
75	
76	  // Omarchy's stay-awake toggle is a marker file; watch its directory so
77	  // toggling it on while the screens are off wakes them immediately.
78	  Process {
79	    id: stayAwakeProbe
80	    command: ["bash", "-c", "mkdir -p \"$HOME/.local/state/omarchy/indicators\"; [[ -f $HOME/.local/state/omarchy/indicators/stay-awake ]] && echo yes || echo no"]
81	    stdout: SplitParser {
82	      onRead: function(line) {
83	        var value = String(line).trim() === "yes"
84	        if (value === root.stayAwake) return
85	        root.stayAwake = value
86	        root.evaluate(value ? "stay-awake on" : "stay-awake off")
87	      }
88	    }
89	    onExited: stayAwakeWatcher.reload()
90	  }
91	
92	  FileView {
93	    id: stayAwakeWatcher
94	    path: root.stayAwakeStateDir
95	    watchChanges: true
96	    printErrors: false
97	    onFileChanged: if (!stayAwakeProbe.running) stayAwakeProbe.running = true
98	  }
99	
100	  Component.onCompleted: {
101	    log("ready, screens off after " + root.idleSeconds + "s idle (display power only)")
102	    stayAwakeProbe.running = true
103	  }
104	
105	  // If the plugin is disabled or reloaded while the screens are dark, light
106	  // them back up rather than leaving them off with nothing to wake them.
107	  Component.onDestruction: {
108	    if (root.screensOff) Quickshell.execDetached(Model.argvFor("on"))
109	  }
110	
111	  IpcHandler {
112	    target: "screen-sleep"
113	
…
```

**⏺ edit** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

```
  // The directory must exist for the watcher below, so create it first.
  Process {
    id: stayAwakeDirMaker
    command: ["mkdir", "-p", root.stayAwakeStateDir]
    onExited: stayAwakeProbe.running = true
  }

  Process {
    id: stayAwakeProbe
    command: ["test", "-f", root.stayAwakeStateDir + "/stay-awake"]
    onExited: function(exitCode) {
      stayAwakeWatcher.reload()
      var value = exitCode === 0
      if (value === root.stayAwake) return
      root.stayAwake = value
      root.evaluate(value ? "stay-awake on" : "stay-awake off")
    }
  }
```

✓ 449 ms

```text
edited .config/omarchy/plugins/parker.screen-sleep/Service.qml at line 78
```

**⏺ edit** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

```
    stayAwakeDirMaker.running = true
  }
```

✓ 86 ms

```text
edited .config/omarchy/plugins/parker.screen-sleep/Service.qml at line 107
```

Now I'll update the tests so they check the exact Hyprland DPMS calls and the full list of programs the plugin can run:

**⏺ bash** `cd .config/omarchy/plugins/parker.screen-sleep && python3 - <<'EOF'
p='test.mjs'; s=open(p).read()
start=s.index('assert.equal(Model.commandFor("off")')
end=s.index('console.log(')
s=s[:start]+r'''// Screens off/on is exactly Hyprland's DPMS dispatcher, run without a shell.
assert.deepEqual([...Mode`

✓ 1457 ms

```text
[exit 0, 549 ms]
Referenced but unset environment variable evaluates to an empty string: file
Invalid environment variable name evaluates to an empty string: code.match(forbidden)
parker.screen-sleep: all tests passed
exit=0
```

**⏺ bash** `cd .config/omarchy/plugins/parker.screen-sleep && grep -n 'contains\|slice' test.mjs; ls -a ~ | grep .local`

✗ 95 ms

```text
[exit 1, 89 ms]
42:  '["test", "-f", root.stayAwakeStateDir + "/stay-awake"])'.slice(0, -1),
50:  assert.ok(!forbidden.test(code), ` contains `)
```

The sandbox removed the template placeholders on line 50, and line 42 has a messy hack. I'll fix both:

**⏺ edit** `.config/omarchy/plugins/parker.screen-sleep/test.mjs`

```
  assert.ok(!forbidden.test(code), file + " contains " + code.match(forbidden))
```

✓ 2 ms

```text
edited .config/omarchy/plugins/parker.screen-sleep/test.mjs at line 50
```

**⏺ edit** `.config/omarchy/plugins/parker.screen-sleep/test.mjs`

```
const commands = [...service.matchAll(/(?:\.command\s*=|command:|execDetached\()\s*([^\n]+)/g)].map((m) => m[1].trim())
assert.deepEqual(commands, [
  "Model.argvFor(action)",
  '["mkdir", "-p", root.stayAwakeStateDir]',
  '["test", "-f", root.stayAwakeStateDir + "/stay-awake"]',
  'Model.argvFor("on"))',
])
// Any other way to start a process would bypass the list above.
assert.equal((service.match(/\bProcess\s*\{/g) || []).length, 3)
assert.equal((service.match(/exec\w*\(/g) || []).length, 1)
```

✓ 3 ms

```text
edited .config/omarchy/plugins/parker.screen-sleep/test.mjs at line 38
```

**⏺ bash** `cd .config/omarchy/plugins/parker.screen-sleep && N=~/.local/share/mise/installs/node/26.7.0/bin/node; $N test.mjs; echo exit=$?
# negative check: inject a suspend call and confirm the test catches it
cp Service.qml /tmp/s.bak 2>/dev/null; T=$(mktemp -d); cp * $T/; sed -i 's|Model.argvFor(action)|["`

✓ 1485 ms

```text
[exit 0, 1478 ms]
parker.screen-sleep: all tests passed
exit=0
AssertionError [ERR_ASSERTION]: Expected values to be strictly deep-equal:
lint-done
```

The tests pass, and a planted `systemctl suspend` makes them fail, so the check works. Next I'll run the real service under Quickshell with a fake `hyprctl` that logs the exact arguments it receives:

**⏺ bash** `T=$(mktemp -d); cp ~/.config/omarchy/plugins/parker.screen-sleep/{Service.qml,ScreenSleepModel.js} $T/; mkdir $T/bin
cat > $T/bin/hyprctl <<EOF
#!/bin/sh
printf 'hyprctl' >> $T/calls; for a in "\$@"; do printf ' [%s]' "\$a" >> $T/calls; done; echo >> $T/calls
EOF
chmod +x $T/bin/hyprctl
cat > $T/she`

✓ 3537 ms

```text
[exit 0, 3527 ms]
 DEBUG qml: parker.screen-sleep 2026-11-09T23:44:43.721Z ready, screens off after 600s idle (display power only)
 DEBUG qml: parker.screen-sleep 2026-11-09T23:44:45.327Z test stay-awake -> screens on
--- hyprctl calls:
hyprctl [dispatch] [hl.dsp.dpms({ action = "disable" })]
hyprctl [dispatch] [hl.dsp.dpms({ action = "enable" })]
hyprctl [dispatch] [hl.dsp.dpms({ action = "enable" })]
/tmp/tmp.ApLWvIx2n1/.local/state/omarchy/indicators
```

**⏺ bash** `git status --short; cat -n .config/omarchy/plugins/parker.screen-sleep/ScreenSleepModel.js | sed -n 9,14p`

✓ 76 ms

```text
[exit 0, 68 ms]
 M .config/omarchy/shell.json
 D .config/omarchy/themes/ember/README.md
 D .config/omarchy/themes/ember/colors.toml
 D .config/omarchy/themes/ember/hyprland.lua
 D .config/omarchy/themes/ember/icons.theme
 D .config/omarchy/themes/ember/install.sh
 D .config/omarchy/themes/ember/neovim.lua
?? .agents/
?? .claude/
?? .codex/
?? .config/omarchy/plugins/
?? .pi/
     9	// The only commands this plugin ever runs, as argv arrays executed directly
    10	// (no shell, no wrapper scripts). Both are Hyprland's own DPMS dispatcher:
    11	// they power the displays down/up and nothing else. Nothing here talks to
    12	// systemd/logind, so the machine itself never sleeps.
    13	var SCREENS_OFF_ARGV = ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "disable" })']
    14	var SCREENS_ON_ARGV = ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "enable" })']
```

The plugin now calls Hyprland's DPMS directly, so you can see it in the code. It runs no shell and no Omarchy scripts.

**What the old code did:** it didn't call DPMS itself. It ran `omarchy-brightness-display off` through `bash`, and the actual DPMS call was two scripts down (`omarchy-brightness-display:63`). The wake command, `omarchy-system-wake`, also ran a monitor script that can reload Hyprland and change monitor settings. That's more than turning a screen back on. Nothing in that chain could suspend the machine, but you couldn't confirm that from the plugin's own code.

**Where to look now:**
- **The DPMS calls** (`ScreenSleepModel.js:13-14`), run directly by `Service.qml:52`:
  ```
  ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "disable" })']   // after 10 min idle
  ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "enable" })']    // on mouse/keyboard input
  ```
  These match the calls Omarchy's own scripts use.
- **Everything else it runs:** `mkdir -p` and `test -f` on the stay-awake file. I replaced the old `bash` command for that, so `bash` no longer appears anywhere in the plugin.
- I also dropped the keyboard backlight changes, since you didn't ask for them.

**Proof that it can't suspend:**
- `test.mjs` checks the exact DPMS arguments above. It also lists every process the service can start and fails if anything else is added. It fails on any shell, `systemctl`, `loginctl`, `suspend`, `hibernate`, `poweroff`, `/sys/power` or `omarchy-*` call.
- All tests pass. When I planted a `systemctl suspend` in a copy, the test caught it.
- I ran the service in Quickshell with a fake `hyprctl` that logged its arguments. It received only these three calls: the disable call, then the enable call when stay-awake turned on, then the enable call when the plugin was unloaded with screens off.

**What I couldn't check:** the idle trigger itself. There's no Hyprland in my sandbox, so the 10-minute timer never fired; I started the off and on paths by hand.

**Still true from before:**
- Your stock lock (`idle.lock: 300`) still turns the screens off at about 5 minutes. If you want me to change it, say so.
- Choosing Suspend in the system menu or closing a laptop lid can still suspend the machine, because that's handled outside this plugin.

