# h0 + Omarchy fitting building Screen Sleep

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `omarchy-v4` · tools read, edit, write, grep, glob, bash, check

---

### › You

```text
Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.
```

**⏺ bash** `cat /usr/share/omarchy/default/agents/skills/omarchy/plugins.md; ls .config/omarchy .config/omarchy/plugins 2>/dev/null; cat .config/omarchy/shell.json`

✓ 75 ms

```text
[exit 0, 66 ms]
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

Let me look at how built-in plugins are structured and how idle is handled.

**⏺ bash** `cd /usr/share/omarchy; ls shell/plugins; cat config/omarchy/shell.json | head -50; grep -rli "idle" shell --include=*.qml --include=*.json | head -30`

✓ 119 ms

```text
[exit 0, 109 ms]
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
        },
        {
          "id": "omarchy.workspaces"
        }
      ],
      "center": [
        {
          "id": "omarchy.indicators"
        },
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/README.md; ls plugins/services plugins/services/idle; cat plugins/services/idle/manifest.json plugins/services/idle/Service.qml`

✓ 75 ms

```text
[exit 0, 66 ms]
# First-party plugins

These plugins ship with Omarchy and are discovered by the shell at startup.
They use the same `manifest.json` contract as third-party plugins; the
only difference is that the shell flags them with `__isFirstParty: true`.
First-party non-bar plugins are enabled unless listed in `disabledPlugins[]`;
`omarchy.bar` is the default bar option and becomes inactive only while another
`kind: "bar"` plugin is selected. Services and keep-loaded panels are mounted
at startup; other panels, overlays, and menus are loaded on demand.

User-installed plugins live alongside these conceptually but on disk under
`~/.config/omarchy/plugins/<plugin-id>/` rather than in this directory.

| Plugin        | id                        | kinds                   | entry point                           |
|---------------|---------------------------|-------------------------|---------------------------------------|
| Bar           | `omarchy.bar`             | `bar`                   | `bar/Bar.qml`                         |
| Image picker  | `omarchy.image-picker`    | `overlay`               | `image-picker/ImagePicker.qml`        |
| Emojis        | `omarchy.emojis`          | `overlay`               | `emojis/Emojis.qml`                   |
| Clipboard mgr | `omarchy.clipboard`       | `overlay`               | `clipboard/Clipboard.qml`             |
| Reminders     | `omarchy.reminders`       | `overlay`               | `reminders/ReminderFlow.qml`          |
| Omarchy menu  | `omarchy.menu`            | `menu`, `bar-widget`    | `menu/Menu.qml`, `menu/BarWidget.qml` |
| Notifications | `omarchy.notifications`   | `service`               | `notifications/Service.qml`           |
| Audio         | `omarchy.audio`           | `bar-widget`            | `panels/audio/Panel.qml`              |
| Bluetooth     | `omarchy.bluetooth`       | `bar-widget`            | `panels/bluetooth/Panel.qml`          |
| Clock         | `omarchy.clock`           | `bar-widget`            | `panels/clock/BarWidget.qml`          |
| Monitor       | `omarchy.monitor`         | `bar-widget`            | `panels/monitor/Panel.qml`            |
| Network       | `omarchy.network`         | `bar-widget`            | `panels/network/Panel.qml`            |
| Power         | `omarchy.power`           | `bar-widget`            | `panels/power/Panel.qml`              |
| Tailscale     | `omarchy.tailscale`       | `bar-widget`            | `panels/tailscale/Panel.qml`          |
| Agents   | `omarchy.agents`     | `bar-widget`            | `agents/Panel.qml`               |
| Weather       | `omarchy.weather`         | `bar-widget`            | `panels/weather/BarWidget.qml`        |
| Media         | `omarchy.media`           | `service`, `bar-widget` | `services/media/Service.qml`, `services/media/BarWidget.qml` |
| Battery       | `omarchy.battery`         | `service`               | `services/battery/Service.qml`        |
| Idle          | `omarchy.idle`            | `service`               | `services/idle/Service.qml`           |
| Night light   | `omarchy.nightlight`      | `service`               | `services/nightlight/Service.qml`     |
| Lock screen   | `omarchy.lock`            | `service`               | `lock/Service.qml`                    |
| OSD           | `omarchy.osd`             | `panel`                 | `osd/Osd.qml`                         |
| Polkit agent  | `omarchy.polkit`          | `service`               | `polkit/PolkitAgent.qml`              |

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 40,120p plugins/services/idle/Service.qml; grep -rn "dpms\|suspend" plugins/services/idle/ plugins/lock/Service.qml | head -20; ls /usr/share/omarchy/bin | grep -i -E "dpms|suspend|screen|monitor" `

✓ 55 ms

```text
[exit 0, 49 ms]
  function secondsFromConfig(value, fallback) {
    return IdleModel.secondsFromConfig(value, fallback)
  }

  function nowIso() {
    return new Date().toISOString()
  }

  function logEvent(event, details) {
    var suffix = details === undefined || details === null || details === "" ? "" : ": " + String(details)
    root.lastEventAt = nowIso()
    root.lastEvent = event + suffix
    console.log("omarchy idle " + root.lastEventAt + " " + root.lastEvent)
  }

  function runProcess(process, label, command) {
    if (process.running) {
      logEvent("process-skip", label + " already running")
      return false
    }
    logEvent("process-start", label + " " + command)
    process.command = ["bash", "-lc", command]
    process.running = true
    return true
  }

  function launchScreensaver() {
    root.screensaverStartedThisCycle = true
    screensaverLaunchGraceTimer.restart()
    runProcess(screensaverProcess, "screensaver", "[[ $(omarchy-shell lock isLocked 2>/dev/null) == \"true\" ]] || omarchy-launch-screensaver")
  }

  function lockSystem(reason) {
    logEvent("lock-system", reason || "requested")
    screensaverTimer.stop()
    lockTimer.stop()
    screensaverLaunchGraceTimer.stop()
    root.idledThisCycle = false
    root.screensaverStartedThisCycle = false
…
```

**⏺ bash** `cd /usr/share/omarchy/bin; for f in omarchy-system-wake omarchy-system-lock omarchy-system-sleep-monitor omarchy-toggle-suspend; do echo "== $f"; cat $f; done; ls | grep -i -E "wake|dpms|sleep|idle"; grep -rn "suspend\|IdleAction" /usr/share/omarchy/default /usr/share/omarchy/config 2>/dev/null | gr`

✓ 112 ms

```text
[exit 0, 105 ms]
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
== omarchy-system-sleep-monitor
…
```

**⏺ bash** `cd /usr/share/omarchy/bin; cat omarchy-brightness-display | head -60; grep -rn "dpms" /usr/share/omarchy/bin /usr/share/omarchy/shell -l | head; cat /usr/share/omarchy/shell/plugins/services/battery/manifest.json; ls /usr/share/omarchy/shell/plugins/services/battery`

✓ 69 ms

```text
[exit 0, 64 ms]
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

**⏺ bash** `cd /usr/share/omarchy/bin; sed -n 60,200p omarchy-brightness-display; grep -rn "dpms" /usr/share/omarchy/bin /usr/share/omarchy/shell /usr/share/omarchy/default | head`

✓ 71 ms

```text
[exit 0, 65 ms]
step="$1"

if [[ $step == "off" ]]; then
  hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' >/dev/null 2>&1
  exit 0
elif [[ $step == "on" ]]; then
  # Skip the dispatch when every active display is already lit: a redundant
  # DPMS enable right after system resume forces another modeset, which blanks
  # the panel for a beat (visible flash at the unlock screen).
  hyprctl monitors -j 2>/dev/null | jq -e '[.[] | select(.disabled == false)] | length > 0 and all(.dpmsStatus)' >/dev/null 2>&1 && exit 0
  hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' >/dev/null 2>&1
  exit 0
fi

# Drop overlapping brightness key events so concurrent invocations do not race.
# Hardware key repeat present on some devices can otherwise glitch OSD rendering.
exec {lock_fd}>"${XDG_RUNTIME_DIR:-/tmp}/omarchy-brightness-display.lock"
flock -n "$lock_fd" || exit 0

if use_apple_display; then
  if (( no_osd )); then
    omarchy-brightness-display-apple --no-osd "$step"
  else
    omarchy-brightness-display-apple "$step"
  fi
elif use_ddc_display; then
  brightness="$(omarchy-brightness-display-ddc "$monitor" "$step")" || exit 1
  (( no_osd )) || omarchy-osd -i brightness -p "$brightness"
else
  # Current device highlighted
  device="$(omarchy-hw-display)" || exit 1

  # Current brightness percentage
  current=$(backlight_brightness "$device") || exit 1

  # Apply non-uniform step size: 1% steps if at or below 5%, otherwise set an
  # absolute target percentage to avoid raw backlight rounding causing uneven OSD steps.
  if [[ $step == "+5%" ]]; then
    if (( current < 5 )); then
…
```

**⏺ bash** `cat $(which omarchy-plugin-validate) | head -150; grep -rn "\"plugins\"\|shellConfig.plugins\|enabledPlugins\|disabledPlugins" /usr/share/omarchy/shell --include=*.qml --include=*.js | head -20`

✓ 75 ms

```text
[exit 0, 65 ms]
#!/bin/bash

# omarchy:summary=Validate a plugin folder against the Omarchy plugin manifest schema
# omarchy:group=plugin
# omarchy:args=<plugin-folder>
# omarchy:examples=omarchy plugin validate ./my-plugin

# Mirrors the checks in shell/services/PluginRegistry.qml so the CLI refuses to
# install anything the running shell would silently reject (or worse, load
# unsafely). The shell never trusts manifests blindly; neither do we.

set -o pipefail

fail() {
  echo "omarchy-plugin-validate: $*" >&2
  exit 1
}

if [[ ${1:-} == -h || ${1:-} == --help ]]; then
  cat <<USAGE
Usage: omarchy plugin validate <plugin-folder>

Checks a plugin folder's manifest.json against the schema the shell enforces:
schemaVersion, required fields, safe relative entry points that exist, an entry
point for each kind that needs one, no symlinks, and an id that is not reserved.
Exits 0 if valid — handy for plugin authors before publishing.
USAGE
  exit 0
fi

PLUGIN_DIR="${1:-}"
[[ -n $PLUGIN_DIR && -d $PLUGIN_DIR ]] || fail "plugin folder not found: ${PLUGIN_DIR:-<none>}"

MANIFEST="$PLUGIN_DIR/manifest.json"
[[ -f $MANIFEST ]] || fail "missing manifest.json in $PLUGIN_DIR"
jq -e . "$MANIFEST" >/dev/null 2>&1 || fail "manifest.json is not valid JSON: $MANIFEST"

# schemaVersion must be exactly the JSON number 1 (the only version the registry
# understands). jq's == is type-aware, so the string "1" is correctly rejected
…
```

**⏺ bash** `sed -n 120,240p /usr/share/omarchy/shell/services/PluginRegistry.qml; grep -n "service\|property var shell\|pluginConfig\|settings" /usr/share/omarchy/shell/services/PluginRegistry.qml | head -60`

✓ 73 ms

```text
[exit 0, 66 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 240,275p services/PluginRegistry.qml; sed -n 390,420p services/PluginRegistry.qml; grep -rn "\"service\"" --include=*.qml . | grep -v plugins/ | head -20`

✓ 121 ms

```text
[exit 0, 113 ms]
      if (barLocation.found) return barLocation
    }
    if (Array.isArray(config.plugins)) {
      for (var j = 0; j < config.plugins.length; j++) {
        if (config.plugins[j] && Util.canonicalWidgetId(config.plugins[j].id) === key) return { found: true, kind: "plugin", index: j }
      }
    }
    return { found: false }
  }

  function barTarget(config, placement, fallbackSection) {
    var target = placement || {}
    var section = ["left", "center", "right"].indexOf(String(target.section || "")) !== -1
      ? String(target.section) : fallbackSection
    var relativeId = String(target.before || target.after || "")
    if (relativeId) {
      var relative = findRelativeBarLocation(config, relativeId, section && target.section ? section : "")
      if (!relative.found) return { error: "could not find target widget " + relativeId }
      return {
        section: relative.section,
        index: relative.index + (target.after ? 1 : 0)
      }
    }

    if (!Array.isArray(config.bar.layout[section])) config.bar.layout[section] = []
    if (target.index !== undefined && target.index !== null) {
      var requested = Math.max(0, Math.floor(Number(target.index)))
      return { section: section, index: Math.min(requested, config.bar.layout[section].length) }
    }

    var anchors = { left: "omarchy.workspaces", center: "omarchy.weather", right: "omarchy.tray" }
    var anchor = findRelativeBarLocation(config, anchors[section], section)
    return {
      section: section,
      index: anchor.found ? anchor.index + 1 : config.bar.layout[section].length
    }
    var sections = ["left", "center", "right"]
    for (var i = 0; i < sections.length; i++) {
      if (!Array.isArray(config.bar.layout[sections[i]])) config.bar.layout[sections[i]] = []
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 260,300p shell.qml; sed -n 895,1000p shell.qml`

✓ 81 ms

```text
[exit 0, 68 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function \|property " services/PluginShellApi.qml | head -60; ls ~/.config/omarchy/plugins 2>/dev/null; ls /usr/share/omarchy/default/agents/skills/omarchy/; grep -rn "IdleMonitor\|IdleInhibitor" --include=*.qml . | grep -v "services/idle" | head`

✓ 101 ms

```text
[exit 0, 92 ms]
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
SKILL.md
capture.md
contributing.md
hooks.md
hyprland.md
plugins.md
theming.md
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n -i "dpms\|brightness\|display" plugins/lock/Service.qml | head -20; grep -n -i "suspend\|systemctl" -r plugins services | head; grep -rn "IdleAction\|HandleLidSwitch" /etc/systemd/logind.conf /etc/systemd/logind.conf.d 2>/dev/null`

✓ 74 ms

```text
[exit 0, 68 ms]
411:    command: ["bash", "-c", "omarchy-brightness-keyboard off; omarchy-brightness-display off"]
427:      // Only a password check in flight should hold the display up. The
plugins/dev-gallery/GalleryPanel.qml:323:      // current target, Esc closes. The catcher suspends itself while a
plugins/lock/Service.qml:420:      // A countdown frozen by suspend fires right after resume, which would
/etc/systemd/logind.conf:36:#HandleLidSwitch=suspend
/etc/systemd/logind.conf:37:#HandleLidSwitchExternalPower=suspend
/etc/systemd/logind.conf:38:#HandleLidSwitchDocked=ignore
/etc/systemd/logind.conf:46:#IdleAction=ignore
/etc/systemd/logind.conf:47:#IdleActionSec=30min
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 395,450p plugins/lock/Service.qml`

✓ 76 ms

```text
[exit 0, 68 ms]

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
    onTriggered: {
      // A countdown frozen by suspend fires right after resume, which would
      // blank the freshly woken unlock screen under the user. Wall-clock time
      // exposes the gap: take a fresh run-up instead of blanking.
      if (Date.now() - armedAt > interval + 2000) {
        root.armBlankTimer()
        return
      }
      // Only a password check in flight should hold the display up. The
      // fingerprint PAM stays armed for the whole lock, so gating on
      // `authenticating` here would keep the panel lit until unlock.
      if (root.lockRequested && !root.authenticatingPassword) root.runBlank()
    }
  }

…
```

**⏺ bash** `cat .config/hypr/input.lua; grep -rn "dpms\|suspend" .config | head; sed -n 60,80p /usr/share/omarchy/default/hypr/input.lua; ls ~/.config/omarchy/hooks; whoami; ls /usr/share/omarchy/shell/plugins/services/battery; head -40 /usr/share/omarchy/shell/plugins/services/battery/Service.qml`

✓ 73 ms

```text
[exit 0, 66 ms]
-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- hl.config({
--   input = {
--     -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
--     kb_layout = "us,dk,eu",
--     kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",
--
--     -- Use a specific keyboard variant if needed (e.g. intl for international keyboards).
--     kb_variant = "intl",
--
--     -- Change speed of keyboard repeat.
--     repeat_rate = 40,
--     repeat_delay = 250,
--
--     -- Start with numlock on by default.
--     numlock_by_default = true,
--
--     -- Increase sensitivity for mouse/trackpad (default: 0).
--     sensitivity = 0.35,
--
--     -- Turn off mouse acceleration (default: adaptive).
--     accel_profile = "flat",
--
--     touchpad = {
--       -- Use natural (inverse) scrolling.
--       natural_scroll = true,
--
--       -- Use two-finger clicks for right-click instead of lower-right corner.
--       clickfinger_behavior = true,
--
--       -- Control the speed of your scrolling.
--       scroll_factor = 0.4,
--
--       -- Enable the touchpad while typing.
--       disable_while_typing = false,
…
```

Now I'll write the plugin.

**⏺ write** `.config/omarchy/plugins/parker.screen-sleep/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.screen-sleep",
  "name": "Screen sleep",
  "version": "1.0.0",
  "author": "parker",
  "description": "Turns displays off (DPMS) after 10 minutes without input and back on at the next input. Never suspends.",
  "kinds": [
    "service"
  ],
  "entryPoints": {
    "service": "Service.qml"
  }
}
```

✓ 156 ms

```text
wrote 335 bytes to .config/omarchy/plugins/parker.screen-sleep/manifest.json
```

**⏺ write** `.config/omarchy/plugins/parker.screen-sleep/Service.qml`

```
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Screen sleep: DPMS off after `timeoutSeconds` of no input, DPMS on at the
// next input. This plugin only ever toggles display power. It never calls
// systemctl suspend/hibernate or anything else that sleeps the machine.
Item {
  id: root

  // Injected by omarchy-shell.
  property var shell: null

  // 10 minutes.
  readonly property int timeoutSeconds: 600

  // Same file the stock "Stay awake" indicator writes; when it exists we
  // leave the screens on.
  readonly property string stayAwakeFile: Quickshell.env("HOME") + "/.local/state/omarchy/indicators/stay-awake"

  property bool screensOff: false

  function run(process, command) {
    if (process.running) return
    process.command = ["bash", "-c", command]
    process.running = true
  }

  function screensOffNow() {
    console.log("screen-sleep: idle " + root.timeoutSeconds + "s, turning displays off")
    root.screensOff = true
    run(offProcess, "[[ -f \"" + root.stayAwakeFile + "\" ]] || omarchy-brightness-display off")
  }

  function screensOnNow() {
    if (!root.screensOff) return
    console.log("screen-sleep: activity, turning displays on")
    root.screensOff = false
    // Hyprland already wakes DPMS on key press / mouse move
    // (misc.key_press_enables_dpms / mouse_move_enables_dpms); this is a
    // backstop. `on` is a no-op when every display is already lit.
    run(onProcess, "omarchy-brightness-display on")
  }

  IdleMonitor {
    id: idleMonitor
    enabled: true
    timeout: root.timeoutSeconds
    // Honour idle inhibitors (video playback, etc.) like the stock idle service.
    respectInhibitors: true
    onIsIdleChanged: {
      if (isIdle) root.screensOffNow()
      else root.screensOnNow()
    }
  }

  Process { id: offProcess }
  Process { id: onProcess }

… (12 more lines in the repository)
```

✓ 1 ms

```text
wrote 2094 bytes to .config/omarchy/plugins/parker.screen-sleep/Service.qml
```

Now enable it in `shell.json` (third-party services are enabled via `plugins[]`).

**⏺ bash** `cp .config/omarchy/shell.json .config/omarchy/shell.json.bak.$(date +%s) && python3 - <<'EOF'
import json
p='.config/omarchy/shell.json'
d=json.load(open(p))
d['plugins'].append({"id":"parker.screen-sleep"})
open(p,'w').write(json.dumps(d,indent=2)+"\n")
EOF
tail -5 .config/omarchy/shell.json`

✓ 186 ms

```text
[exit 0, 165 ms]
    {
      "id": "parker.screen-sleep"
    }
  ]
}
```

**⏺ check** `build`

✓ 7293 ms

```text
[exit 0, 7267 ms]
plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
  service: Service.qml: loaded; drew no text
PREVIEW: ok
```

I built the plugin as a background service called `parker.screen-sleep` and turned it on in your config. It passes the project's checks, which validate it and load it offscreen, but it hasn't run on your real desktop yet. Also, your current settings will lock and blank your screens at about 5 minutes, before this plugin's 10 minutes come up (details below).

**What changed**
- `.config/omarchy/plugins/parker.screen-sleep/manifest.json` and `Service.qml`: after 600 seconds (10 minutes) with no input, it runs `omarchy-brightness-display off`, which turns all monitors off. When you move the mouse or press a key, Hyprland turns them back on through its built-in settings for this. The plugin also runs `omarchy-brightness-display on` as a backup, which does nothing if the screens are already on.
- Like Omarchy's own idle service, it holds off while something is blocking idle (such as a playing video) or while the "Stay awake" toggle is on.
- **It never suspends.** It only switches the displays' power and never calls `systemctl suspend` or anything like it.
- `.config/omarchy/shell.json`: added `{"id": "parker.screen-sleep"}` to `plugins`, which is how your own services get turned on. There's a timestamped backup next to it.

**Checks:** `build` passed (JSON syntax, Omarchy's plugin validator, and the offscreen load). I couldn't test real idle detection or turning the screens off and on, because that needs your running desktop. To try it, run `omarchy-shell shell rescanPlugins`, then `omarchy-shell screen-sleep status` to see its state.

**Things you should know**
1. **Your current lock settings come first.** `shell.json` has `idle.lock: 300`, and Omarchy's lock screen blanks the displays about 5 seconds after locking. So right now your screens go dark at about 5 minutes, before this plugin does anything. If you want them lit until 10 minutes, raise `idle.lock` to `600` or more. I didn't change it because it's a security setting. Locking doesn't suspend, so your agents keep running either way.
2. **Nothing else here suspends on idle.** Omarchy doesn't, and `/etc/systemd/logind.conf` has `IdleAction` left at its default of `ignore`. However, `HandleLidSwitch` is also at its default, which is **suspend**. On a laptop, closing the lid will suspend the machine and pause your agents. Changing that is a system file that needs root, so I left it alone. If you want it, set `HandleLidSwitch=ignore` in a drop-in file under `/etc/systemd/logind.conf.d/`.
3. To change the timeout, edit `timeoutSeconds` in `Service.qml`. Saving the file reloads the plugin automatically.

*harness: verify check `build` passed*

