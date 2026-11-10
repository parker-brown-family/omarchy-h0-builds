# h0 + Omarchy fitting building Window Opacity

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `omarchy-v4` · tools read, edit, write, grep, glob, bash, check

---

### › You

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

I'll start by reading the plugin guide and the current config.

**⏺ bash** `cat /usr/share/omarchy/default/agents/skills/omarchy/plugins.md; echo ----; ls -la .config/omarchy .config/omarchy/plugins 2>&1; cat .config/omarchy/shell.json; ls .config/hypr`

✓ 127 ms

```text
[exit 0, 118 ms]
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

The guide is short, so I'll study the built-in plugins as the real reference, especially one with a popup panel and a slider (audio, maybe).

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; ls; for d in */; do echo "== $d"; ls $d; done | head -150`

✓ 91 ms

```text
[exit 0, 87 ms]
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
== agents/
Agent.qml
Main.qml
Panel.qml
README.md
assets
manifest.json
== background/
Background.qml
manifest.json
== bar/
Bar.qml
BarModel.js
README.md
indicators
manifest.json
widgets
== clipboard/
Clipboard.qml
ClipboardHistory.js
capture.sh
manifest.json
== dev-gallery/
…
```

**⏺ bash** `ls /usr/share/omarchy/shell/ /usr/share/omarchy/default/agents/skills/omarchy/; ls /usr/share/omarchy/shell/* | head -80`

✓ 58 ms

```text
[exit 0, 52 ms]
/usr/share/omarchy/default/agents/skills/omarchy/:
SKILL.md
capture.md
contributing.md
hooks.md
hyprland.md
plugins.md
theming.md

/usr/share/omarchy/shell/:
Commons
README.md
Ui
plugins
services
shell.qml
/usr/share/omarchy/shell/README.md
/usr/share/omarchy/shell/shell.qml

/usr/share/omarchy/shell/Commons:
Border.qml
BorderGeometry.js
Color.qml
Style.qml
Util.qml
qmldir

/usr/share/omarchy/shell/Ui:
BarIconButton.qml
BarIndicator.qml
BarWidget.qml
BorderOverlay.qml
BorderSurface.qml
Button.qml
ButtonGroup.qml
ConfirmDialog.qml
CursorSurface.qml
Dropdown.qml
KeyboardPanel.qml
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; cat README.md; ls panels/audio panels/monitor; cat panels/audio/manifest.json panels/monitor/manifest.json`

✓ 133 ms

```text
[exit 0, 115 ms]
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

The Monitor panel (brightness slider) is the closest match, so I'll read it.

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/panels/monitor; cat Panel.qml; wc -l Model.js`

✓ 81 ms

```text
[exit 0, 68 ms]
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons
import "Model.js" as Model

Panel {
  id: root
  moduleName: "omarchy.monitor"
  ipcTarget: "omarchy.monitor"
  manageIpc: false

  // manageIpc: false so this panel can own the single IpcHandler the target
  // permits — needed for the brightness + state methods below.
  property int brightnessPercent: 0
  property int pendingBrightnessPercent: 0
  property bool brightnessSetQueued: false
  property bool brightnessAvailable: false
  property string internalMonitor: ""
  property string externalMonitor: ""
  property string focusedMonitor: ""
  property bool internalEnabled: false
  property bool mirrorEnabled: false
  property string monitorScale: ""
  property var displays: []
  property int enabledDisplayCount: 0

  // Carry sub-notch touchpad deltas between wheel events.
  property real wheelAccumulator: 0

  // Cursor model shared by keyboard and mouse. Sections:
  //   "brightness" - single slider row, selectedIndex = -1 sentinel
  //                  (mirrors Audio's slider rows). Only present if a
  //                  controllable backlight was detected.
  //   "scale"      - 6 Button scale presets; treated as a single
  //                  horizontal row from j/k's perspective. h/l moves
  //                  between presets, identical to bluetooth's header.
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/panels/monitor; sed -n 260,620p Panel.qml`

✓ 75 ms

```text
[exit 0, 67 ms]
      value: percent
    }))
  }

  function normalizeScale(scale) {
    return Model.normalizeScale(scale)
  }

  function activeScaleIndex() {
    for (var i = 0; i < displays.length; i++) {
      var display = displays[i]
      if (display && display.focused)
        return Model.matchingScaleIndex(scaleValues, monitorScale, display.width, display.height)
    }
    return -1
  }

  function effectiveScale(scale) {
    for (var i = 0; i < displays.length; i++) {
      var display = displays[i]
      if (display && display.focused)
        return Model.cleanScale(scale, display.width, display.height)
    }
    return normalizeScale(scale)
  }

  // Playful mood-name for a given brightness percent. Bands intentionally
  // span ~10–20 points so casual tweaks change the label, while small
  // nudges within one band don't.
  function brightnessName(percent) {
    return Model.brightnessName(percent)
  }

  function updateDisplays(displaysJson) {
    var parsed = Model.parseDisplays(displaysJson)
    root.displays = parsed.displays
    root.enabledDisplayCount = parsed.enabledDisplayCount
  }

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 620,700p plugins/panels/monitor/Panel.qml; echo ======; cat Ui/PanelSlider.qml; echo =====; cat Ui/Panel.qml | head -150`

✓ 76 ms

```text
[exit 0, 68 ms]
              id: brightnessRow
              width: parent.width
              height: brightnessSlider.implicitHeight + Style.spacing.controlGap
              hasCursor: root.cursorActive && root.focusSection === "brightness" && root.selectedIndex === -1
              onHasCursorChanged: if (hasCursor) root.ensureCursorVisible(brightnessRow)
              foreground: root.bar.foreground
              outline: true

              PanelSlider {
                id: brightnessSlider
                bar: root.bar
                anchors.fill: parent
                anchors.leftMargin: Style.space(6)
                anchors.rightMargin: Style.space(6)
                minimum: 1
                maximum: 100
                step: 1
                value: root.brightnessPercent
                integer: true
                onMoved: function(v) { root.previewBrightness(v) }
                onReleased: function(v) {
                  brightnessDebounce.stop()
                  root.setBrightness(v)
                }
              }

              HoverHandler {
                onHoveredChanged: if (hovered && !root.reflowingText) {
                  root.cursorActive = true
                  root.focusSection = "brightness"
                  root.selectedIndex = -1
                }
              }
            }
          }

          // ---------- Text size ----------
          PanelSeparator {
            foreground: root.bar.foreground
…
```

Now let me look at how Omarchy sets opacity in Hyprland, and whether plugins get a persistence API.

**⏺ bash** `cd /usr/share/omarchy; grep -rn -i "opacity" default/hypr/ | head -30; echo ----; cat ~/.config/hypr/looknfeel.lua ~/.config/hypr/hyprland.lua`

✓ 75 ms

```text
[exit 0, 69 ms]
default/hypr/apps/browser.lua:4:o.window({ tag = "chromium-based-browser" }, { tag = "-default-opacity", tile = true, opacity = "1.0 0.985" })
default/hypr/apps/browser.lua:5:o.window({ tag = "firefox-based-browser" }, { tag = "-default-opacity", opacity = "1.0 0.985" })
default/hypr/apps/browser.lua:7:-- Video apps: remove chromium browser tag so they don't get opacity applied.
default/hypr/apps/browser.lua:9:o.window("(^.+-youtube\\.com__.*$|^.+-app\\.zoom\\.us__wc_home.*$)", { tag = "-default-opacity" })
default/hypr/apps/davinci-resolve.lua:6:  tag = "-default-opacity",
default/hypr/apps/davinci-resolve.lua:7:  opacity = "1 1",
default/hypr/apps/hermes.lua:3:  tag = "-default-opacity",
default/hypr/apps/hermes.lua:6:  opacity = "1 1",
default/hypr/apps/omarchy-shell.lua:9:-- QML opacity transition for normal open/close, and skip it for panel handoff.
default/hypr/apps/pip.lua:4:  tag = "-default-opacity",
default/hypr/apps/pip.lua:10:  opacity = "1 1",
default/hypr/apps/pip.lua:16:  tag = "-default-opacity",
default/hypr/apps/pip.lua:22:  opacity = "1 1",
default/hypr/apps/qemu.lua:1:o.window("qemu", { tag = "-default-opacity", opacity = "1 1" })
default/hypr/apps/retroarch.lua:3:  tag = "-default-opacity",
default/hypr/apps/retroarch.lua:4:  opacity = "1 1",
default/hypr/apps/steam.lua:3:o.window("steam.*", { tag = "-default-opacity", opacity = "1 1" })
default/hypr/apps/system.lua:43:    tag = "-default-opacity",
default/hypr/apps/system.lua:49:    opacity = "1 1",
default/hypr/apps/webcam-overlay.lua:19:  tag = "-default-opacity",
default/hypr/apps/webcam-overlay.lua:24:  opacity = "1 1",
default/hypr/windows.lua:5:-- Tag all windows for default opacity (apps can override with -default-opacity tag).
default/hypr/windows.lua:6:o.window(".*", { tag = "+default-opacity" })
default/hypr/windows.lua:21:-- App-specific tweaks (may remove default-opacity tag).
default/hypr/windows.lua:24:-- Apply default opacity after apps have had a chance to opt out.
default/hypr/windows.lua:25:o.window({ tag = "default-opacity" }, { opacity = "0.985 0.96" })
----
-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function\|property" services/PluginShellApi.qml | head -60; grep -rln "pluginData\|stateDir\|dataDir\|persist" --include=*.qml . | head`

✓ 90 ms

```text
[exit 0, 85 ms]
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
./Commons/Style.qml
./Ui/MultiSelect.qml
./plugins/bar/widgets/Tray.qml
./plugins/bar/Bar.qml
./plugins/notifications/Service.qml
./plugins/panels/bluetooth/Panel.qml
./plugins/panels/clock/Panel.qml
./plugins/panels/tailscale/Panel.qml
./plugins/panels/weather/Panel.qml
./plugins/services/battery/Service.qml
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 55,80p services/PluginShellApi.qml; grep -rn "updateEntryInline" --include=*.qml . | head; grep -rn "updateEntryInline\|_updateSettings" plugins/bar/Bar.qml shell.qml services/*.qml | head`

✓ 176 ms

```text
[exit 0, 170 ms]
    return _toggle ? _toggle(String(id || ""), String(payloadJson || "")) : false
  }

  function isPluginOpen(id) {
    return _isOpen ? _isOpen(String(id || "")) : false
  }

  function updateEntryInline(id, settings) {
    return _updateSettings ? _updateSettings(String(id || ""), settings) : false
  }

  function mutateShellConfig(mutator) {
    return _mutateBarConfig && typeof mutator === "function"
      ? _mutateBarConfig(mutator) : false
  }
}
./plugins/bar/widgets/Tray.qml:184:    if (!root.bar || !root.bar.shell || typeof root.bar.shell.updateEntryInline !== "function") return
./plugins/bar/widgets/Tray.qml:186:    root.bar.shell.updateEntryInline(id, { id: id, pinned: pinned, hidden: hidden })
./plugins/panels/clock/BarWidget.qml:51:    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
./plugins/panels/clock/BarWidget.qml:52:      root.bar.shell.updateEntryInline(root.moduleName, entry)
./plugins/panels/clock/Panel.qml:161:    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
./plugins/panels/clock/Panel.qml:162:      root.bar.shell.updateEntryInline(root.moduleName, entry)
./plugins/panels/power/Panel.qml:174:    if (root.bar && root.bar.shell) root.bar.shell.updateEntryInline(root.moduleName, root.settings)
./plugins/panels/tailscale/Panel.qml:155:    if (!root.bar || !root.bar.shell || typeof root.bar.shell.updateEntryInline !== "function") return
./plugins/panels/tailscale/Panel.qml:159:    root.bar.shell.updateEntryInline(root.moduleName, entry)
./services/PluginShellApi.qml:62:  function updateEntryInline(id, settings) {
shell.qml:648:      _updateSettings: function(requestedId, settings) {
shell.qml:649:        if (shell.pluginOwnsTarget(key, requestedId)) return shell.updateEntryInline(key, settings)
shell.qml:651:          return shell.updateEntryInline(requestedId, settings)
shell.qml:726:      _updateSettings: function(requestedId, settings) {
shell.qml:728:          ? shell.updateEntryInline(target, settings) : false
shell.qml:1078:  function updateEntryInline(moduleName, settings) {
services/PluginShellApi.qml:27:  property var _updateSettings: null
services/PluginShellApi.qml:62:  function updateEntryInline(id, settings) {
services/PluginShellApi.qml:63:    return _updateSettings ? _updateSettings(String(id || ""), settings) : false
```

**⏺ bash** `cd /usr/share/omarchy; cat default/hypr/toggles.lua | head -60; grep -ln "hyprctl keyword\|hyprctl eval\|hl.eval" bin/* 2>/dev/null | head; ls bin | grep -i -E "opacity|transparen|toggle" `

✓ 280 ms

```text
[exit 0, 274 ms]
local paths = require("default.hypr.paths")
local require_all = require("default.hypr.require_all")

local toggles_dir = paths.state_home .. "/omarchy/toggles/hypr"
package.path = toggles_dir .. "/?.lua;" .. package.path

-- touchpad-disabled.lua / touchscreen-disabled.lua were generated Lua in older
-- versions and could carry an injected USB device name. They must never be loaded
-- as code again: exclude them so a not-yet-migrated install cannot execute a
-- leftover payload on reload. The migration recovers the name and deletes them.
require_all.files(toggles_dir, nil, {
  reload = true,
  exclude = {
    ["touchpad-disabled"] = true,
    ["touchscreen-disabled"] = true,
  },
})

local disabled_input_device = require("default.hypr.disabled-input-device")
disabled_input_device("touchpad")
disabled_input_device("touchscreen")

require("default.hypr.workspace-layouts")
bin/omarchy-capture-region
bin/omarchy-capture-screenshot
bin/omarchy-hyprland-monitor-clamshell
bin/omarchy-hyprland-monitor-scaling
bin/omarchy-hyprland-workspace-layout-toggle
bin/omarchy-launch-about
bin/omarchy-screensaver
bin/omarchy-toggle-input-device
omarchy-hyprland-toggle
omarchy-hyprland-toggle-disabled
omarchy-hyprland-toggle-enabled
omarchy-hyprland-window-gaps-toggle
omarchy-hyprland-window-single-square-aspect-toggle
omarchy-hyprland-window-tiled-fullscreen-toggle
omarchy-hyprland-window-transparency-toggle
omarchy-hyprland-workspace-layout-toggle
…
```

**⏺ bash** `cd /usr/share/omarchy/bin; cat omarchy-hyprland-window-transparency-toggle omarchy-hyprland-toggle; grep -n "hyprctl" omarchy-hyprland-monitor-scaling omarchy-hyprland-workspace-layout-toggle | head; sed -n 1070,1110p ../shell/shell.qml`

✓ 96 ms

```text
[exit 0, 88 ms]
#!/bin/bash

# omarchy:summary=Toggles transparency for the currently focused window.

addr=$(hyprctl activewindow -j | jq -r '.address')
hyprctl dispatch "hl.dsp.window.set_prop({ window = \"address:$addr\", prop = \"opaque\", value = \"toggle\" })" >/dev/null 2>&1 || \
  hyprctl dispatch setprop "address:$addr" opaque toggle
#!/bin/bash

# omarchy:summary=Toggle permanent Hyprland flags by copying them into a directory that's sourced entirely.
# omarchy:args=<flag-name> [on|off|toggle]

usage() {
  echo "Usage: omarchy-hyprland-toggle <flag-name> [on|off|toggle]" >&2
}

if (($# < 1)); then
  usage
  exit 1
fi

FLAG_NAME="$1"
ACTION="${2:-toggle}"
FLAG_FILE="$HOME/.local/state/omarchy/toggles/hypr/$FLAG_NAME.lua"
FLAG_SOURCE="$OMARCHY_PATH/default/hypr/toggles/$FLAG_NAME.lua"

on() {
  if [[ -f $FLAG_SOURCE ]]; then
    mkdir -p "$(dirname "$FLAG_FILE")"
    cp "$FLAG_SOURCE" "$FLAG_FILE"
  else
    echo "Flag not found: $FLAG_NAME" >&2
    exit 1
  fi
}

off() {
  rm -f "$FLAG_FILE"
}
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn "Quickshell.Hyprland\|rawEvent\|configreloaded" --include=*.qml . | head; echo; cat plugins/panels/clock/BarWidget.qml | sed -n 1,80p`

✓ 72 ms

```text
[exit 0, 65 ms]
./Ui/PopupCard.qml:3:import Quickshell.Hyprland
./plugins/bar/widgets/KeyboardLayout.qml:3:import Quickshell.Hyprland
./plugins/bar/widgets/KeyboardLayout.qml:100:      if (name.indexOf("activelayout") !== -1 || name === "configreloaded") root.refresh()
./plugins/bar/widgets/Workspaces.qml:3:import Quickshell.Hyprland
./plugins/bar/Bar.qml:2:import Quickshell.Hyprland
./plugins/services/idle/Service.qml:3:import Quickshell.Hyprland

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

// Date/time label for the bar, and the host for the calendar popup.
//
// Left click reveals the calendar — asking "what is the date?" is what a
// click on a clock means — right click walks the common label formats, and
// middle click opens the timezone picker.
BarWidget {
  id: root
  moduleName: "omarchy.clock"

  property date displayDate: clock.date

  readonly property string configuredFormat: vertical
    ? setting("verticalFormat", "HH\n—\nmm")
    : setting("format", "dddd HH:mm")
  readonly property string configuredAltFormat: vertical
    ? setting("verticalFormatAlt", "dd\nMMM\n'W'ww\n''yy")
    : setting("formatAlt", "d MMMM 'W'ww yyyy")

  readonly property var formatRing: Model.clockFormatRing(configuredFormat, configuredAltFormat, Model.clockFormats(vertical))

  // What the bar shows is what shell.json stores, so a cycled format is the
  // format from then on rather than something that reverts on restart.
  readonly property string activeFormat: configuredFormat
  readonly property string displayText: formatted(displayDate)
  readonly property var verticalLines: displayText.split("\n")
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 85,110p plugins/bar/widgets/KeyboardLayout.qml; echo; sed -n 140,180p plugins/panels/power/Panel.qml; ls /usr/share/omarchy/shell/plugins/panels/*/ ; cat Ui/qmldir | head -40`

✓ 96 ms

```text
[exit 0, 89 ms]
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (!event || !event.name) return
      var name = String(event.name)
      // The event names the keyboard that switched ahead of the layout it moved
      // to, and that is the keyboard being typed on whatever holds the main flag.
      if (name === "activelayout") {
        const named = KeyboardLayoutModel.eventKeyboardName(event)
        if (named) root.typedKeyboardName = named
      }

      // A reload that adds a layout to kb_layout decides whether the widget
      // shows at all, and leaves every keyboard on the layout it was already
      // reading, so it raises no activelayout to notice it by.
      if (name.indexOf("activelayout") !== -1 || name === "configreloaded") root.refresh()
    }
  }

  Process {
    id: queryProc
    command: ["hyprctl", "-j", "devices"]
    onRunningChanged: {
      if (running) {
        stallTimer.restart()
        return

    if (!systemProc.running) systemProc.running = true
  }

  function updateKeyValue(raw, targetName) {
    var next = Model.parseKeyValue(raw)
    // Keep last known good data if a refresh briefly returns nothing — happens
    // around AC plug/unplug events. Avoids the section collapsing mid-transition.
    if (Object.keys(next).length === 0) return
    if (targetName === "battery") batteryInfo = next
    else systemInfo = next
  }

…
```

I'll look at a small panel as a template, the hero component, and the validator's id rules.

**⏺ bash** `cd /usr/share/omarchy/shell; wc -l plugins/panels/*/Panel.qml; cat Ui/PanelHero.qml | head -60; grep -n "signal\|property" Ui/PanelKeyCatcher.qml Ui/KeyboardPanel.qml Ui/BarIconButton.qml | head -60`

✓ 72 ms

```text
[exit 0, 66 ms]
  1248 plugins/panels/audio/Panel.qml
  1045 plugins/panels/bluetooth/Panel.qml
   762 plugins/panels/clock/Panel.qml
   151 plugins/panels/disk-speedtest/Panel.qml
   547 plugins/panels/dropbox/Panel.qml
   929 plugins/panels/monitor/Panel.qml
  1970 plugins/panels/network/Panel.qml
   536 plugins/panels/power/Panel.qml
   202 plugins/panels/speedtest/Panel.qml
  1273 plugins/panels/tailscale/Panel.qml
   881 plugins/panels/weather/Panel.qml
   369 plugins/panels/wifiqr/Panel.qml
  9913 total
import QtQuick
import qs.Commons

Item {
  id: root

  property Component iconComponent: null
  property string title: ""
  property string meta: ""
  property string detail: ""
  property color foreground: Color.foreground
  property string fontFamily: Style.font.family
  property real iconSize: Style.font.display
  property real iconOpacity: 1.0
  property alias metaOpacity: metaText.opacity

  // Optional control pinned to the trailing edge of the hero — a ToggleSwitch,
  // a small button. The hero centers it against the labels and reserves the
  // space itself, so callers never do the geometry.
  property Component trailingControl: null

  readonly property color dim: Qt.darker(foreground, 1.4)
  readonly property real trailingInset: trailingLoader.item && trailingLoader.item.visible ? trailingLoader.width + Style.space(12) : 0

  width: parent ? parent.width : implicitWidth
  implicitHeight: Math.max(iconLoader.implicitHeight, heroLabels.implicitHeight, trailingLoader.implicitHeight)
…
```

**⏺ bash** `cat $(which omarchy-plugin-validate) | head -150; whoami; echo $USER`

✓ 53 ms

```text
[exit 0, 46 ms]
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

Next, how a user plugin gets enabled: shell.json has `"plugins": []` and the bar layout.

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "enabled\|disabledPlugins" services/PluginRegistry.qml | head -40; grep -n "\.plugins\b\|plugins\[" shell.qml | head -30; cat $OMARCHY_PATH/config/omarchy/shell.json 2>/dev/null | head -20; ls /usr/share/omarchy/config/omarchy/`

✓ 52 ms

```text
[exit 0, 46 ms]
140:  // Special cases (implicitly always enabled, no shell.json entry needed):
147:  //     is therefore recorded the other way round, in `disabledPlugins[]`.
167:    return Util.isPlainObject(config) && Array.isArray(config.disabledPlugins)
168:      && config.disabledPlugins.indexOf(Util.canonicalWidgetId(String(id))) !== -1
173:    // Callers keep using the built-in id after cloning; the enabled local
401:  // built-in in disabledPlugins[].
403:    if (!Array.isArray(config.disabledPlugins)) return
404:    config.disabledPlugins = config.disabledPlugins.filter(function(entry) { return entry !== id })
405:    if (config.disabledPlugins.length === 0) delete config.disabledPlugins
410:    if (!Array.isArray(config.disabledPlugins)) config.disabledPlugins = []
411:    config.disabledPlugins.push(id)
196:    return plugins ? plugins[String(pluginId || "")] || null : null
791:    var manifest = id ? plugins[id] : null
802:      var manifest = descriptor ? plugins[descriptor.pluginId] : null
823:      if (plugins[widgetKey] && shell.pluginRegistry.isEnabled(widgetKey)) widgetNext[widgetKey] = widgetApi
866:      var manifest = plugins[id]
878:      var shellManifest = descriptor ? plugins[descriptor.pluginId] : null
957:      var m = plugins[id]
995:      var stillThere = plugins[existingId]
1012:      var authenticationManifest = plugins[authenticationId]
1026:    var manifest = plugins ? plugins[pluginId] : null
1083:    if (!Array.isArray(copy.plugins)) copy.plugins = []
1103:      for (var j = 0; j < copy.plugins.length; j++) {
1104:        if (copy.plugins[j] && copy.plugins[j].id === stripped) {
1107:          if (JSON.stringify(copy.plugins[j]) !== JSON.stringify(pnext)) {
1108:            copy.plugins[j] = pnext
1140:    var m = plugins[String(pluginId || "")]
1156:    if (!plugins[id]) {
1303:      var m = plugins[id]
1386:      var manifest = plugins[pluginId]
1669:        var kinds = plugins[id].kinds || []
1673:        var metadata = plugins[id].omarchy
1677:          name: plugins[id].name,
1689:          firstParty: !!plugins[id].__isFirstParty,
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 135,200p services/PluginRegistry.qml; omarchy plugin --help 2>&1 | head -30`

✓ 173 ms

```text
[exit 0, 168 ms]
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
      }
      if (isDisabled(config, key)) return false
      if (manifest.__isFirstParty) return true
    }
    return findEntryLocation(config, key).found
  }

  function isDisabled(config, id) {
    return Util.isPlainObject(config) && Array.isArray(config.disabledPlugins)
      && config.disabledPlugins.indexOf(Util.canonicalWidgetId(String(id))) !== -1
  }

  function resolveEnabledId(id) {
    var key = Util.canonicalWidgetId(String(id || ""))
    // Callers keep using the built-in id after cloning; the enabled local
…
```

A user widget is enabled just by being in `bar.layout`. Before writing anything I'll check the preview tool and pick a Nerd Font glyph that actually exists in the installed font.

**⏺ bash** `fc-list | grep -i nerd | head -3; python3 -c "import fontTools; print('ft ok')" 2>&1; ls ~/.config/omarchy/../../ 2>/dev/null | head; find / -name "preview.py" -path "*" 2>/dev/null | grep -v proc | head`

✓ 16002 ms

```text
[exit 0, 15993 ms]
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Italic.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Italic
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Bold.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Bold
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Regular
Traceback (most recent call last):
  File "<string>", line 1, in <module>
    import fontTools; print('ft ok')
    ^^^^^^^^^^^^^^^^
ModuleNotFoundError: No module named 'fontTools'
~/Work/harness-0/fittings/omarchy-v4/preview/preview.py
```

**⏺ bash** `for cp in f05cb f1853 f0335 f04c6; do printf "%s: " $cp; fc-list ":charset=$cp" family | grep -c -i jetbrainsmono; done; sed -n 1,60p ~/Work/harness-0/fittings/omarchy-v4/preview/preview.py`

✓ 190 ms

```text
[exit 0, 181 ms]
f05cb: 1
f1853: 1
f0335: 1
f04c6: 1
#!/usr/bin/env python3
"""Load Omarchy shell plugins (or a theme) in Quickshell offscreen and report what happened.

    preview.py                      every plugin under ~/.config/omarchy/plugins
    preview.py <plugin-dir> ...     these plugins
    preview.py --theme <theme-dir>  a bar strip drawn in that theme's colours

For each entry point in a plugin's manifest it prints whether it loaded, the QML errors that
point into the plugin's own files, and the text the entry point drew. Bar widgets are also
saved as a picture under ./.h0-preview/. Exit status 1 when any plugin has an error.

Nothing is shown on a display (QT_QPA_PLATFORM=offscreen). Popup windows (PanelWindow) need a
layer-shell compositor, so their code is loaded but they cannot be drawn here.
"""

import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
SHELL = Path("/usr/share/omarchy/shell")
DEFAULT_THEME = Path("/usr/share/omarchy/themes/tokyo-night")
NOISE = ("does not support setting window masks",)


def stub(src: str) -> str:
    """An invisible stand-in for a popup type that needs a layer-shell compositor. It keeps the
    real type's properties, signals and function signatures, so a plugin that uses them still has
    to use them correctly, but nothing is drawn."""
    out = ["import QtQuick", "import Quickshell", "import qs.Commons", "", "Item {", "  id: root", "  visible: false",
           "  Item { id: stubHolder }"]
    depth = 0
…
```

**⏺ bash** `mkdir -p .config/omarchy/plugins/parker.window-opacity && cat > .config/omarchy/plugins/parker.window-opacity/manifest.json <<'EOF'
{
  "schemaVersion": 1,
  "id": "parker.window-opacity",
  "name": "Window Opacity",
  "version": "1.0.0",
  "author": "parker",
  "description": "Sliders for focused a`

✓ 448 ms

```text
[exit 0, 415 ms]
'\U000f05cb'
```

**⏺ write** `.config/omarchy/plugins/parker.window-opacity/Panel.qml`

```
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.Ui
import qs.Commons

// Window opacity control. Drives Hyprland's decoration.active_opacity and
// decoration.inactive_opacity live. Those multiply with Omarchy's default
// window-rule opacity, so 100% here = the stock Omarchy look.
//
// Settings persist in this widget's own shell.json bar entry:
//   { "id": "parker.window-opacity", "active": 100, "inactive": 90 }
// and are re-applied on shell start and after every Hyprland config reload
// (a reload resets decoration.* back to the Lua config values).
Panel {
  id: root
  moduleName: "parker.window-opacity"
  ipcTarget: "parker.window-opacity"

  readonly property int minPercent: 30
  readonly property int maxPercent: 100
  readonly property string glyph: "\u{f05cb}"

  // Live values (what the sliders show and Hyprland gets).
  property int activePercent: clampPercent(setting("active", 100))
  property int inactivePercent: clampPercent(setting("inactive", 100))

  // Keyboard cursor: 0 = focused slider, 1 = unfocused slider.
  property int cursorRow: 0
  property bool cursorActive: false
  property real wheelAccumulator: 0

  // Ignore the configreloaded our own eval may cause, so we never loop.
  property double lastApplyMs: 0
  property bool applyQueued: false

  function clampPercent(v) {
    var n = Math.round(Number(v))
    if (isNaN(n)) n = 100
    return Math.max(minPercent, Math.min(maxPercent, n))
  }

  function fraction(p) {
    return (clampPercent(p) / 100).toFixed(2)
  }

  // Push current values to Hyprland, coalescing while a call is in flight.
  function apply() {
    if (applyProc.running) {
      applyQueued = true
      return
    }
    applyQueued = false
    lastApplyMs = Date.now()
    applyProc.command = ["bash", "-c",
      "hyprctl eval \"hl.config({ decoration = { active_opacity = $1, inactive_opacity = $2 } })\" >/dev/null 2>&1 || " +
      "{ hyprctl keyword decoration:active_opacity \"$1\" && hyprctl keyword decoration:inactive_opacity \"$2\"; } >/dev/null 2>&1",
      "window-opacity", fraction(activePercent), fraction(inactivePercent)]
    applyProc.running = true
… (237 more lines in the repository)
```

✓ 220 ms

```text
wrote 8795 bytes to .config/omarchy/plugins/parker.window-opacity/Panel.qml
```

To be safe I'll swap the ES6 `\u{…}` escape for the literal glyph, then add the widget to the bar.

**⏺ bash** `cd .config/omarchy/plugins/parker.window-opacity && python3 - <<'EOF'
p='Panel.qml'; s=open(p,encoding='utf-8').read()
s=s.replace('"\\u{f05cb}"','"'+chr(0xf05cb)+'"'); open(p,'w',encoding='utf-8').write(s)
EOF
grep -n "glyph:" Panel.qml; cd ~; cp .config/omarchy/shell.json .config/omarchy/shell.jso`

✓ 339 ms

```text
[exit 0, 258 ms]
23:  readonly property string glyph: "󰗋"
57:          "id": "parker.window-opacity",
58-          "active": 100,
59-          "inactive": 100
60-        },
```

**⏺ check** `build`

✓ 4380 ms

```text
[exit 0, 4352 ms]
plugin parker.window-opacity  (~/.config/omarchy/plugins/parker.window-opacity)
  barWidget: Panel.qml: loaded; drew: 󰗋
    picture: ~/.h0-preview/parker.window-opacity-barWidget.png
PREVIEW: ok
```

**⏺ bash** `cd /usr/share/omarchy/shell/Ui; for p in fontSize foreground fontFamily horizontalPadding verticalPadding bordered; do printf "Button.%s: " $p; grep -c "property .* $p\b" Button.qml; done; for p in hasCursor foreground outline; do printf "CursorSurface.%s: " $p; grep -c "property .* $p\b" CursorSurf`

✓ 152 ms

```text
[exit 0, 147 ms]
Button.fontSize: 1
Button.foreground: 1
Button.fontFamily: 1
Button.horizontalPadding: 1
Button.verticalPadding: 1
Button.bordered: 1
CursorSurface.hasCursor: 1
CursorSurface.foreground: 1
CursorSurface.outline: 1
PanelSectionHeader.qml:10:  property color foreground: Color.foreground
PanelSectionHeader.qml:11:  property string fontFamily: Style.font.family
PanelSectionHeader.qml:19:  font.family: fontFamily
PanelSeparator.qml:10:  property color foreground: Color.foreground
161:  function fittedContentWidth(width, cap) {
168:  function fittedContentHeight(implicitHeight, cap) {
20:  function wheelSteps(accumulator, delta) {
WidgetButton.qml:32:  signal pressed(int button)
WidgetButton.qml:33:  signal wheelMoved(int delta)
```

I built the plugin and put it in your top bar. It passes the build check and the bar icon draws in the offscreen preview. I couldn't test it live: the sandbox has no Hyprland, and the preview can't draw popups, so the panel and the actual opacity change are untested.

**Files**
- `.config/omarchy/plugins/parker.window-opacity/manifest.json`: declares the bar widget.
- `.config/omarchy/plugins/parker.window-opacity/Panel.qml`: an opacity icon (󰗋) for the bar. Clicking it opens a small panel with:
  - **Focused window** slider, 30–100%
  - **Unfocused windows** slider, 30–100%
  - a **Reset** button that puts both back to 100%
- `.config/omarchy/shell.json`: added `{ "id": "parker.window-opacity", "active": 100, "inactive": 100 }` to the right side of the bar, just before the display widget. A backup is saved as `shell.json.bak.<timestamp>`.

**How it works**
- **Live changes:** dragging a slider changes Hyprland's focused and unfocused window opacity settings straight away. It uses the same command pattern as Omarchy's own scripts, with an older-style command as a fallback.
- **100% means Omarchy's normal look, not fully solid.** Hyprland multiplies your setting with Omarchy's default window opacity (98.5% focused, 96% unfocused). Apps Omarchy keeps solid, like video players, Steam and VMs, stay solid.
- **Keeping your settings:** when you let go of a slider, the values are saved into your widget's entry in `shell.json`. You can also edit them there by hand.
- **After a restart or reload:** the values are applied again when the shell starts and after every Hyprland config reload, since a reload (for example a theme change) resets them.
- **Extras:**
  - Scrolling on the bar icon changes focused-window opacity in 5% steps.
  - In the panel, `j`/`k` picks a slider, `h`/`l` adjusts it, `Esc` closes it.

**What I couldn't confirm**
- Whether `hyprctl eval` with `hl.config` changes opacity on your Hyprland version. The fallback should cover it if not.
- Whether that command itself triggers a config-reload event. If it does, the plugin ignores reload events for 1.5 seconds after its own change, so it can't loop.
- There's a short delay after login before your saved values apply, because the shell has to start first.

**Please test:** the shell hot-reloads, so the icon should appear on its own. If it doesn't, run `omarchy-shell shell rescanPlugins`. Then drag the sliders, run `hyprctl reload`, and check that the opacity stays where you set it.

*harness: verify check `build` passed*

