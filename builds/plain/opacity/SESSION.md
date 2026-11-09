# h0 (plain) building Window Opacity

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools read, edit, write, grep, glob, bash

---

### › You

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

I'll start by looking at what's in the project and how Omarchy shell plugins are structured here.

**⏺ bash** `ls -la; find . -maxdepth 4 -not -path './.git*' | head -100`

✓ 110 ms

```text
[exit 0, 106 ms]
total 0
drwxr-xr-x 1 parker parker  22 Nov  9 15:20 .
drwx------ 3 parker parker  60 Nov  9 15:21 ..
drwxr-xr-x 1 parker parker  72 Nov  8 22:07 .config
drwxr-xr-x 1 parker parker 160 Nov  9 15:20 .git
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
./.config/foot
…
```

**⏺ bash** `cd .config; cat omarchy/shell.json; echo ----; cat hypr/hyprland.lua; echo ----; cat hypr/looknfeel.lua; echo ----; cat hypr/.luarc.json; cat hypr/autostart.lua; ls -la omarchy/hooks/*; ls omarchy/themes/ember; cat omarchy/extensions/omarchy-menu.jsonc; git -C .. log --oneline | head`

✓ 97 ms

```text
[exit 0, 90 ms]
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

Now I need the plugin API. Let me look at the installed Omarchy for shell plugin docs and examples.

**⏺ bash** `echo $OMARCHY_PATH; ls /usr/share/omarchy 2>&1 | head; ls ~/.local/share/omarchy 2>&1|head; find / -path /proc -prune -o \( -iname '*plugin*' -path '*omarchy*' \) -print 2>/dev/null | head -50`

✓ 5868 ms

```text
[exit 0, 5862 ms]

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
/var/tmp/builder-showcase-omarchy-mobile-repo/packages/omamobile-shell/plugins
/var/tmp/omarchy-mobile-native-proof/launcher-harness/Ui/PluginBarApi.qml
/var/tmp/omarchy-mobile-native-proof/launcher-harness/services/PluginAppLibraryApi.qml
/var/tmp/omarchy-mobile-native-proof/launcher-harness/services/PluginBarStateApi.qml
/var/tmp/omarchy-mobile-native-proof/launcher-harness/services/PluginBarWidgetRegistryApi.qml
/var/tmp/omarchy-mobile-native-proof/launcher-harness/services/PluginFirstPartyServiceApi.qml
/var/tmp/omarchy-mobile-native-proof/launcher-harness/services/PluginRegistry.qml
/var/tmp/omarchy-mobile-native-proof/launcher-harness/services/PluginRegistryApi.qml
/var/tmp/omarchy-mobile-native-proof/launcher-harness/services/PluginShellApi.qml
/var/tmp/omarchy-mobile-native-proof/home-harness/Ui/PluginBarApi.qml
/var/tmp/omarchy-mobile-native-proof/home-harness/services/PluginAppLibraryApi.qml
/var/tmp/omarchy-mobile-native-proof/home-harness/services/PluginBarStateApi.qml
/var/tmp/omarchy-mobile-native-proof/home-harness/services/PluginBarWidgetRegistryApi.qml
/var/tmp/omarchy-mobile-native-proof/home-harness/services/PluginFirstPartyServiceApi.qml
/var/tmp/omarchy-mobile-native-proof/home-harness/services/PluginRegistry.qml
/var/tmp/omarchy-mobile-native-proof/home-harness/services/PluginRegistryApi.qml
/var/tmp/omarchy-mobile-native-proof/home-harness/services/PluginShellApi.qml
/usr/share/omarchy/default/agents/skills/omarchy/plugins.md
/usr/share/omarchy/bin/omarchy-menu-plugin
/usr/share/omarchy/bin/omarchy-plugin-add
/usr/share/omarchy/bin/omarchy-plugin-catalog
/usr/share/omarchy/bin/omarchy-plugin-clone
/usr/share/omarchy/bin/omarchy-plugin-disable
/usr/share/omarchy/bin/omarchy-plugin-enable
/usr/share/omarchy/bin/omarchy-plugin-list
/usr/share/omarchy/bin/omarchy-plugin-remove
/usr/share/omarchy/bin/omarchy-plugin-update
…
```

**⏺ bash** `cat /usr/share/omarchy/default/agents/skills/omarchy/plugins.md; ls /usr/share/omarchy/default/agents/skills/omarchy/`

✓ 75 ms

```text
[exit 0, 68 ms]
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

**⏺ bash** `cd /usr/share/omarchy; cat default/agents/skills/omarchy/SKILL.md | head -80; ls shell shell/plugins; find shell -iname '*.md' | head`

✓ 73 ms

```text
[exit 0, 67 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/README.md; echo =====; cat plugins/bar/README.md`

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

**⏺ bash** `cd /usr/share/omarchy/shell; cat README.md`

✓ 73 ms

```text
[exit 0, 65 ms]
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

The monitor panel (brightness sliders in a popup) is the closest analogue. Let me study it.

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/panels/monitor; ls -la; cat manifest.json; wc -l *.qml`

✓ 74 ms

```text
[exit 0, 66 ms]
total 40
drwxr-xr-x 1 nobody nobody    60 Oct 13 11:12 .
drwxr-xr-x 1 nobody nobody   180 Aug 30 11:54 ..
-rw-r--r-- 1 nobody nobody  3464 Sep 15 14:04 Model.js
-rw-r--r-- 1 nobody nobody 32299 Sep 15 14:04 Panel.qml
-rw-r--r-- 1 nobody nobody   445 Sep 15 14:04 manifest.json
{
  "schemaVersion": 1,
  "id": "omarchy.monitor",
  "name": "Display",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Brightness slider and laptop display controls",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Panel.qml"
  },
  "barWidget": {
    "displayName": "Display",
    "description": "Brightness slider and laptop display controls",
    "category": "System",
    "allowMultiple": false
  }
}
929 Panel.qml
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/panels/monitor; cat Panel.qml`

✓ 80 ms

```text
[exit 0, 65 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/panels/monitor; sed -n 250,620p Panel.qml`

✓ 73 ms

```text
[exit 0, 66 ms]

  function previewBrightness(value) {
    root.brightnessPercent = Model.clampBrightness(value)
    brightnessDebounce.restart()
  }

  function showBrightnessOsd(percent) {
    if (!bar || !bar.shell) return
    bar.shell.summon("omarchy.osd", JSON.stringify({
      icon: "brightness",
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
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/panels/monitor; sed -n 620,700p Panel.qml; ls ../../../Ui; `

✓ 71 ms

```text
[exit 0, 65 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell/Ui; cat Panel.qml PanelSlider.qml; cat qmldir`

✓ 95 ms

```text
[exit 0, 87 ms]
import QtQuick
import Quickshell.Io
import qs.Commons

// Base item for plugin popup widgets. Many first-party plugins expose a bar
// button plus a popup from one QML entry point; this base owns the shared
// IPC-backed open/close lifecycle while implementations own button behavior,
// keyboard navigation, and content.
Item {
  id: root

  property QtObject bar: null
  property string moduleName: ""
  property var settings: ({})
  property string ipcTarget: ""
  property bool manageIpc: true
  property alias controller: panelController
  property bool popoutSwitching: false
  property bool popoutSwitchClosing: false

  readonly property bool opened: panelController.open
  readonly property color barForeground: bar ? bar.barForeground : Color.foreground

  function open() { panelController.show() }
  function close() { panelController.hide() }
  function closeForPopoutSwitch() {
    popoutSwitchClosing = true
    close()
    Qt.callLater(function() { popoutSwitchClosing = false })
  }
  function toggle() { opened ? close() : open() }
  function switchPanel(direction) {
    if (bar && typeof bar.switchPanelFrom === "function") return bar.switchPanelFrom(root, direction)
    return false
  }

  // Read a single value from this panel's inline shell.json entry, with a
  // fallback for missing/null values. Matches BarWidget.setting().
  function setting(name, fallback) {
…
```

Next: how third-party plugins load (can they use `qs.Ui`?), and how a widget can persist its own settings.

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/PluginBarApi.qml | head -120; grep -rn "updateSetting\|setSetting\|saveSetting\|updateWidgetSettings\|updateEntry" --include=*.qml . | head -30`

✓ 73 ms

```text
[exit 0, 66 ms]
import QtQuick

// Bar surface exposed to an installed third-party widget. Scalar presentation
// state is mirrored by Bar.qml and operations are delegated through scoped
// callbacks. The facade avoids direct host-Bar injection; it cannot isolate a
// visual child from the parent hierarchy of the QML scene that renders it.
QtObject {
  id: api

  required property string pluginId
  required property string moduleName
  property var shell: null

  property color foreground: "transparent"
  property color barForeground: "transparent"
  property color background: "transparent"
  property color urgent: "transparent"
  property string fontFamily: ""
  property string position: "top"
  property bool vertical: false
  property int barSize: 0
  property bool transparent: false
  property bool foregroundAnimationEnabled: true
  property bool centerSectionRevealHeld: false
  property bool _centerHoverRevealSuppressed: false
  readonly property bool centerHoverRevealSuppressed: _centerHoverRevealSuppressed
  property var activePopout: null
  property var clickTargets: []
  property var layoutConfig: ({})
  readonly property var foreignPopoutMarker: ({ foreign: true })

  property var _showTooltip: null
  property var _hideTooltip: null
  property var _registerClickTarget: null
  property var _unregisterClickTarget: null
  property var _requestPopout: null
  property var _releasePopout: null
  property var _switchPanelFrom: null
  property var _targetBelongsToWindow: null
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat services/PluginShellApi.qml; sed -n 600,760p shell.qml; sed -n 1070,1130p shell.qml; sed -n 40,60p plugins/panels/clock/BarWidget.qml`

✓ 97 ms

```text
[exit 0, 89 ms]
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
    return _firstPartyServiceLookup
      ? _firstPartyServiceLookup(String(id || "")) : null
  }
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "pluginBarApi\|PluginBarApi\|shell: \|qs\.\|import" plugins/bar/Bar.qml | head -60; grep -rn "qs\.Ui\|qs\.Commons\|import" services/PluginRegistry.qml | head -20`

✓ 73 ms

```text
[exit 0, 65 ms]
1:import Quickshell
2:import Quickshell.Hyprland
3:import Quickshell.Io
4:import Quickshell.Wayland
5:import QtQuick
6:import QtQuick.Layouts
7:import qs.Commons
8:import qs.Ui
9:import "BarModel.js" as BarModel
28:  property var shell: null
112:  property var pluginBarApis: ({})
116:    id: pluginBarApiComponent
117:    PluginBarApi { }
124:  function bindPluginBarApi(api) {
138:    root.syncPluginBarApiObjects(api)
141:  function syncPluginBarApiObjects(api) {
203:  function syncAllPluginBarApiObjects() {
204:    for (var id in pluginBarApis) root.syncPluginBarApiObjects(pluginBarApis[id])
229:  function pluginBarApiFor(pluginId, moduleName, registered) {
245:    if (pluginBarApis[key]) {
246:      pluginBarApis[key].shell = pluginShell
247:      return pluginBarApis[key]
250:    var api = pluginBarApiComponent.createObject(null, {
253:      shell: pluginShell,
272:    root.bindPluginBarApi(api)
275:    for (var id in pluginBarApis) next[id] = pluginBarApis[id]
277:    pluginBarApis = next
281:  function pluginBarApiUsed(pluginId) {
302:  function prunePluginBarApis() {
304:    for (var id in pluginBarApis) {
305:      var api = pluginBarApis[id]
306:      if (root.pluginBarApiUsed(id)) {
313:    pluginBarApis = next
316:  onActivePopoutChanged: syncAllPluginBarApiObjects()
317:  onClickTargetsChanged: syncAllPluginBarApiObjects()
318:  onLayoutConfigChanged: syncAllPluginBarApiObjects()
319:  onModuleSlotsChanged: Qt.callLater(prunePluginBarApis)
322:    for (var id in pluginBarApis) {
324:      if (pluginBarApis[id] && typeof pluginBarApis[id].destroy === "function")
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 225,275p plugins/bar/Bar.qml; sed -n 1980,2040p plugins/bar/Bar.qml; ls /var/tmp/builder-showcase-omarchy-mobile-repo/packages/omamobile-shell/plugins 2>/dev/null`

✓ 72 ms

```text
[exit 0, 66 ms]
    root.releasePopout(owner)
    root.unmarkPluginObject(pluginId, owner, "popout")
  }

  function pluginBarApiFor(pluginId, moduleName, registered) {
    var key = String(pluginId || "")
    if (!key) return null

    var pluginShell = null
    if (registered && root.shell && typeof root.shell.pluginShellForId === "function") {
      // Only the trusted built-in bar receives ShellRoot and can request a
      // service-capable facade for the widget it is instantiating.
      pluginShell = root.shell.pluginShellForId(moduleName)
    } else if (root.shell && typeof root.shell.pluginShellForBarEntry === "function") {
      // Replacement bars receive a service-less entry facade. Giving an
      // untrusted bar a generic facade factory would let it retrieve another
      // third-party plugin's live service object.
      pluginShell = root.shell.pluginShellForBarEntry(key, moduleName)
    }

    if (pluginBarApis[key]) {
      pluginBarApis[key].shell = pluginShell
      return pluginBarApis[key]
    }

    var api = pluginBarApiComponent.createObject(null, {
      pluginId: key,
      moduleName: String(moduleName || ""),
      shell: pluginShell,
      _showTooltip: function(target, text) { root.showTooltip(target, text) },
      _hideTooltip: function(target) { root.hideTooltip(target) },
      _registerClickTarget: function(target) { root.registerPluginClickTarget(key, target) },
      _unregisterClickTarget: function(target) { root.unregisterPluginClickTarget(key, target) },
      _requestPopout: function(owner) { root.requestPluginPopout(key, owner) },
      _releasePopout: function(owner) { root.releasePluginPopout(key, owner) },
      _switchPanelFrom: function(owner, direction) { return root.switchPanelFrom(owner, direction) },
      _targetBelongsToWindow: function(target, window) { return root.targetBelongsToWindow(target, window) },
      _moduleWidgets: function(requestedId) {
        return String(requestedId || "") === String(moduleName || "")
…
```

**⏺ bash** `cd /usr/share/omarchy; cat default/agents/skills/omarchy/hyprland.md; ls default/hypr; grep -rn "opacity" default/hypr | head -30`

✓ 97 ms

```text
[exit 0, 87 ms]
# Hyprland Configuration

Read this before changing keybindings, monitors, window rules, or any other
Hyprland (window manager) configuration.

Omarchy configures Hyprland in Lua. User files are loaded after Omarchy's
defaults, so overrides go here:

```
~/.config/hypr/
├── hyprland.lua       # Main config (loads Omarchy defaults, then user files)
├── bindings.lua       # Keybindings
├── monitors.lua       # Display configuration
├── input.lua          # Keyboard/mouse settings
├── looknfeel.lua      # Appearance (gaps, borders, animations)
├── autostart.lua      # Startup applications
├── hyprsunset.conf    # Night light / blue light filter
└── xdph.conf          # Screen sharing / desktop portal
```

**Key behaviors (the `.lua` files):**
- Hyprland auto-reloads on config save (no restart needed for most changes)
- Use `hyprctl reload` to force reload
- After ANY Hyprland Lua config change, validate with `hyprctl reload` followed by `hyprctl configerrors`
- If `hyprctl configerrors` reports errors, address them and rerun validation until clean or until a real blocker is identified
- Use `omarchy refresh hyprland` to reset the Lua config files to defaults

The two `.conf` files are read by separate processes, so `hyprctl` neither
applies nor validates them:
- `hyprsunset.conf` (night light): apply changes with `omarchy restart hyprsunset`; reset with `omarchy refresh hyprsunset`
- `xdph.conf` (screen-sharing portal): applies when the portal restarts, e.g. on next login

## Keybindings

Edit `~/.config/hypr/bindings.lua`. Format:
```lua
o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")
o.bind("SUPER + B", "Browser", { launch = "chromium" })  -- launch wraps with uwsm-app
```
…
```

**⏺ bash** `cd /usr/share/omarchy/default/hypr; cat toggles.lua; ls toggles; head -50 toggles/*.lua | head -120; cat looknfeel.lua | head -60`

✓ 74 ms

```text
[exit 0, 68 ms]
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
flags.lua
single-window-aspect-ratio.lua
window-no-gaps.lua
==> toggles/flags.lua <==
-- This directory is intended for permanent config toggle flags.
-- Do not remove this file; the directory always needs at least one file.

==> toggles/single-window-aspect-ratio.lua <==
-- Avoid overly wide single-window layouts on wide screens.
hl.config({
  layout = {
    single_window_aspect_ratio = { 1, 1 },
  },
})

==> toggles/window-no-gaps.lua <==
…
```

**⏺ bash** `cd /usr/share/omarchy/bin; grep -ln "toggles/hypr\|toggles_dir" * | head; echo; grep -rln "hyprctl eval\|hyprctl keyword\|hl.config" . | head -20`

✓ 135 ms

```text
[exit 0, 128 ms]
omarchy-hw-recover-internal-monitor
omarchy-hyprland-monitor-clamshell
omarchy-hyprland-monitor-internal
omarchy-hyprland-monitor-internal-mirror
omarchy-hyprland-toggle
omarchy-hyprland-toggle-disabled
omarchy-hyprland-toggle-enabled
omarchy-refresh-hyprland
omarchy-toggle-input-device
omarchy-upgrade-to-quattro
```

**⏺ bash** `cd /usr/share/omarchy/bin; cat omarchy-hyprland-toggle omarchy-hyprland-toggle-enabled; grep -rn "hyprctl" omarchy-hyprland-monitor-internal | head; grep -rhn "hyprctl [a-z]*" . -o | sort | uniq -c | sort -rn | head -20`

✓ 95 ms

```text
[exit 0, 87 ms]
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

toggle() {
  if [[ -f $FLAG_FILE ]]; then
    off
    echo "off"
  else
    on
…
```

**⏺ bash** `which hyprctl quickshell qmllint qmlformat qml 2>&1; hyprctl --help 2>&1 | head -60; ls /usr/share/hypr/stubs`

✓ 80 ms

```text
[exit 0, 68 ms]
which: no qmlformat in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
which: no qml in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
/usr/bin/hyprctl
/usr/bin/quickshell
~/.local/bin/qmllint
usage: hyprctl [flags] <command> [args...|--help]

commands:
    activewindow        → Gets the active window name and its properties
    activeworkspace     → Gets the active workspace and its properties
    animations          → Gets the current config'd info about animations
                          and beziers
    binds               → Lists all registered binds
    clients             → Lists all windows with their properties
    configerrors        → Lists all current config parsing errors
    cursorpos           → Gets the current cursor position in global layout
                          coordinates
    decorations <window_regex> → Lists all decorations and their info
    devices             → Lists all connected keyboards and mice
    dismissnotify [amount] → Dismisses all or up to AMOUNT notifications
    dispatch <dispatcher> [args] → Issue a dispatch to call a keybind
                          dispatcher with arguments
    eval <code>         → Issue a Lua string to execute
    getoption <option>  → Gets the config option status (values)
    globalshortcuts     → Lists all global shortcuts
    hyprpaper ...       → Issue a hyprpaper request
    hyprsunset ...      → Issue a hyprsunset request
    instances           → Lists all running instances of Hyprland with
                          their info
    keyword <name> <value> → Issue a keyword to call a config keyword
                          dynamically
    kill                → Issue a kill to get into a kill mode, where you can
                          kill an app by clicking on it. You can exit it
                          with ESCAPE
    layers              → Lists all the surface layers
    layouts             → Lists all layouts available (including plugin'd ones)
    monitors            → Lists active outputs with their properties,
                          'monitors all' lists active and inactive outputs
    notify ...          → Sends a notification using the built-in Hyprland
…
```

**⏺ bash** `grep -rhn "hyprctl[\"', ]*[a-z]*" /usr/share/omarchy/shell -o | sort | uniq -c | sort -rn | head -20; grep -rn "\"keyword\"\|'keyword'\|hyprctl\", \"eval\|\"eval\"" /usr/share/omarchy/shell /usr/share/omarchy/bin | head`

✓ 71 ms

```text
[exit 0, 66 ms]
      1 76:hyprctl switchxkblayout
      1 65:hyprctl command
      1 5:hyprctl reports
      1 57:hyprctl", "hyprsunset
      1 51:hyprctl hyprsunset
      1 500:hyprctl reflects
      1 490:hyprctl gives
      1 453:hyprctl", "
      1 444:hyprctl", "
      1 443:hyprctl
      1 442:hyprctl
      1 377:hyprctl missing
      1 365:hyprctl missing
      1 35:hyprctl dispatch
      1 351:hyprctl
      1 303:hyprctl", "keyword
      1 196:hyprctl forever
      1 16:hyprctl getoption
      1 129:hyprctl gets
      1 106:hyprctl", "
/usr/share/omarchy/shell/plugins/panels/monitor/Panel.qml:303:    actionProc.command = ["hyprctl", "keyword", "monitor", name + (enabled ? ",disable" : ",preferred,auto,auto")]
```

**⏺ bash** `grep -n "opacity" /usr/share/hypr/stubs/hl.meta.lua | head -20; hyprctl getoption decoration:active_opacity 2>&1 | head; echo "HYPR=$HYPRLAND_INSTANCE_SIGNATURE XDG=$XDG_RUNTIME_DIR WL=$WAYLAND_DISPLAY"`

✓ 90 ms

```text
[exit 0, 85 ms]
99:---| "decoration.active_opacity"
103:---| "decoration.blur.ignore_opacity"
122:---| "decoration.fullscreen_opacity"
128:---| "decoration.inactive_opacity"
1018:---@field ['decoration.active_opacity'] number|boolean
1022:---@field ['decoration.blur.ignore_opacity'] boolean
1041:---@field ['decoration.fullscreen_opacity'] number|boolean
1047:---@field ['decoration.inactive_opacity'] number|boolean
1371:---@field active_opacity? number|boolean
1372:---@field inactive_opacity? number|boolean
1373:---@field fullscreen_opacity? number|boolean
1407:---@field ignore_opacity? boolean
HYPRLAND_INSTANCE_SIGNATURE not set! (is hyprland running?)

HYPR= XDG= WL=
```

**⏺ bash** `cd /usr/share/omarchy/default/hypr; cat require_optional.lua bootstrap.lua paths.lua; grep -rn "require_optional" . | head`

✓ 74 ms

```text
[exit 0, 69 ms]
-- Require a module only when it can be found on package.path.
-- Errors inside existing modules still surface normally.

local M = {}

function M.module(module)
  if package.searchpath(module, package.path) then
    return require(module)
  end
end

return M
-- Hyprland bootstrap for Omarchy's Lua module path.

local home = os.getenv("HOME")
local reload_prefixes = {
  "default.hypr",
  "hypr",
  "omarchy.current.theme",
}

local function should_reload_module(module)
  for _, prefix in ipairs(reload_prefixes) do
    if module == prefix or module:sub(1, #prefix + 1) == prefix .. "." then
      return true
    end
  end

  return false
end

local modules_to_reload = {}
for module in pairs(package.loaded) do
  if should_reload_module(module) then
    table.insert(modules_to_reload, module)
  end
end

for _, module in ipairs(modules_to_reload) do
…
```

**⏺ bash** `grep -n "function hl.config\|^function hl\.\(eval\|exec\)" /usr/share/hypr/stubs/hl.meta.lua; sed -n 1360,1380p /usr/share/hypr/stubs/hl.meta.lua; grep -rn "setText\|atomicWrites\|blockWrites" /usr/share/omarchy/shell --include=*.qml | head -8`

✓ 91 ms

```text
[exit 0, 86 ms]

---@class HL.ConfigOpt.General.Snap
---@field enabled? boolean
---@field window_gap? integer|boolean
---@field monitor_gap? integer|boolean
---@field border_overlap? boolean
---@field respect_gaps? boolean

---@class HL.ConfigOpt.Decoration
---@field rounding? integer|boolean
---@field rounding_power? number|boolean
---@field active_opacity? number|boolean
---@field inactive_opacity? number|boolean
---@field fullscreen_opacity? number|boolean
---@field shadow? HL.ConfigOpt.Decoration.Shadow
---@field glow? HL.ConfigOpt.Decoration.Glow
---@field dim_modal? boolean
---@field dim_inactive? boolean
---@field dim_strength? number|boolean
---@field dim_special? number|boolean
---@field dim_around? number|boolean
/usr/share/omarchy/shell/plugins/agents/Main.qml:352:    atomicWrites: true
/usr/share/omarchy/shell/plugins/agents/Main.qml:413:    syncSnapshotFile.setText(JSON.stringify(localSnapshot(), null, 2) + "\n")
/usr/share/omarchy/shell/plugins/agents/Panel.qml:753:      id: resetText
/usr/share/omarchy/shell/plugins/clipboard/Clipboard.qml:76:    historyFile.setText(JSON.stringify(root.history.slice(0, root.historyLimit), null, 2) + "\n")
/usr/share/omarchy/shell/plugins/clipboard/Clipboard.qml:254:    atomicWrites: true
/usr/share/omarchy/shell/plugins/notifications/Service.qml:785:    atomicWrites: true
/usr/share/omarchy/shell/plugins/notifications/Service.qml:832:    settingsFile.setText(JSON.stringify({ version: 3, dnd: persisted.doNotDisturb }, null, 2) + "\n")
/usr/share/omarchy/shell/plugins/panels/monitor/Panel.qml:335:  function setTextSize(px) {
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 240,275p plugins/clipboard/Clipboard.qml; grep -n "^function hl\.\|^hl\.[a-z_]* = function\|hl.config" /usr/share/hypr/stubs/hl.meta.lua | head -20; grep -rn "Quickshell.env\|homeDir\|HOME" --include=*.qml plugins/clipboard plugins/notifications/Service.qml | head`

✓ 91 ms

```text
[exit 0, 86 ms]

  Component.onCompleted: initProc.running = true

  ListModel { id: displayModel }

  PointerMoveGate {
    id: pointerGate
    referenceItem: card
  }

  FileView {
    id: historyFile
    path: root.historyPath
    watchChanges: true
    atomicWrites: true
    printErrors: false
    onLoaded: root.loadHistory(text())
    onLoadFailed: root.loadHistory("[]")
    onFileChanged: reload()
  }

  // Reap watchers left behind by a previous shell instance, then start our
  // own. The pdeathsig on the watchers makes the kernel kill them whenever
  // the shell exits, however it exits, so no further lifecycle management.
  Process {
    id: initProc
    command: ["pkill", "-f", "wl-paste .*--watch .*/shell/plugins/clipboard/capture\\.sh"]
    onExited: {
      currentProc.running = true
      textWatchProc.running = true
      imageWatchProc.running = true
    }
  }

  Process {
    id: currentProc
plugins/clipboard/Clipboard.qml:12:  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
plugins/clipboard/Clipboard.qml:20:  property string historyPath: Quickshell.env("HOME") + "/.local/state/omarchy/clipboard-history.json"
plugins/notifications/Service.qml:20:  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
…
```

**⏺ bash** `grep -n "config" /usr/share/hypr/stubs/hl.meta.lua | grep -i "function\|@param" | head; grep -n "^function" /usr/share/hypr/stubs/hl.meta.lua | head -40`

✓ 92 ms

```text
[exit 0, 86 ms]
```

**⏺ bash** `grep -n "hl\.config\|fun(\|---@param\|@class HL\b\|^hl" /usr/share/hypr/stubs/hl.meta.lua | head -30; wc -l /usr/share/hypr/stubs/hl.meta.lua`

✓ 73 ms

```text
[exit 0, 67 ms]
400:---@class HL.Dispatcher
403:---@class HL.Vec2
408:---@class HL.Box
415:---@class HL.LayoutTarget
419:---@field place fun(self: HL.LayoutTarget, box: HL.Box): nil
420:---@field set_box fun(self: HL.LayoutTarget, box: HL.Box): nil
423:---@class HL.LayoutContext
426:---@field grid_cell fun(self: HL.LayoutContext, i: integer, cols: integer, rows?: integer): HL.Box
427:---@field column fun(self: HL.LayoutContext, i: integer, n: integer): HL.Box
428:---@field row fun(self: HL.LayoutContext, i: integer, n: integer): HL.Box
429:---@field split fun(self: HL.LayoutContext, box: HL.Box, side: 'left'|'right'|'top'|'bottom'|'up'|'down', ratio: number): HL.Box
432:---@class HL.LayoutProvider
433:---@field recalculate fun(ctx: HL.LayoutContext): nil
434:---@field layout_msg? fun(ctx: HL.LayoutContext, msg: string): boolean|string|nil
437:---@class HL.BindOptions
455:---@class HL.TimerOptions
460:---@class HL.GestureSpec
472:---@class HL.PermissionSpec
478:---@class HL.NotificationOptions
486:---@class HL.Plugin
493:---@class HL.LayerQueryFilter
498:---@class HL.WindowQueryFilter
508:---@class HL.DeviceSpec
555:---@class HL.LayerRuleSpec
571:---@class HL.MonitorSpec
597:---@class HL.WindowRuleSpec
603:---@class HL.WorkspaceRuleSpec
624:---@class HL.EventSubscription
625:---@field is_active fun(self: HL.EventSubscription, ...): any
626:---@field remove fun(self: HL.EventSubscription, ...): any
1777 /usr/share/hypr/stubs/hl.meta.lua
```

**⏺ bash** `cd /usr/share/omarchy/shell/Ui; grep -n "bar\.\|property" KeyboardPanel.qml | head -50; grep -n "bar\.\|property" PopupCard.qml | head -40`

✓ 100 ms

```text
[exit 0, 90 ms]
40:  required property Item anchorItem
41:  required property QtObject bar
42:  property var owner: null
43:  property int margin: Style.gapsOut
44:  property int padding: Style.spacing.popupPadding
45:  property int contentWidth: Style.space(280)
46:  property int contentHeight: Style.space(200)
47:  property var borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, Math.max(1, Style.space(2)))
48:  property bool centerOnBar: false
49:  property bool open: false
50:  property int gap: Style.gapsOut  // distance between bar edge and panel
51:  property bool popoutSwitching: false
52:  property bool popoutSwitchClosing: false
53:  property bool focusPrimed: false
61:  property Item focusTarget: null
63:  default property alias contentItem: contentHolder.children
65:  readonly property var coordinatorKey: owner || root
66:  readonly property var anchorWindow: anchorItem ? anchorItem.QsWindow.window : null
67:  readonly property string barPos: bar ? bar.position : "top"
118:  // works in one click even when the overlay surface is above the bar.
119:  readonly property real _barStripSize: {
122:    return Math.max(bar.barSize, actual) + root.gap
144:  readonly property point anchorScreenPos: {
149:  readonly property real anchorW: anchorItem ? anchorItem.width : 0
150:  readonly property real anchorH: anchorItem ? anchorItem.height : 0
151:  readonly property real screenW: screen ? screen.width : 0
152:  readonly property real screenH: screen ? screen.height : 0
153:  readonly property real availableCardWidth: screenW > 0
156:  readonly property real availableCardHeight: screenH > 0
159:  readonly property real verticalContentInset: padding * 2 + Border.top(borderSpec) + Border.bottom(borderSpec)
192:  readonly property real barW: anchorWindow ? anchorWindow.width : screenW
193:  readonly property real barH: anchorWindow ? anchorWindow.height : 0
194:  readonly property point cardOrigin: {
240:      popoutSwitching = bar.activePopout && bar.activePopout !== coordinatorKey
241:      bar.requestPopout(coordinatorKey)
246:      if (bar.activePopout === coordinatorKey) bar.releasePopout(coordinatorKey)
286:    property bool hoveringBar: false
303:      if (!root.anchorWindow || !root.anchorWindow.contentItem || !root.bar || !root.bar.clickTargets) return null
305:      var targets = root.bar.clickTargets
…
```

All the properties `KeyboardPanel` uses exist on the plugin facade. Let me check the remaining building blocks I'll use, plus the validator.

**⏺ bash** `cd /usr/share/omarchy/shell/Ui; grep -n "property\|signal" BarIconButton.qml PanelHero.qml PanelKeyCatcher.qml PanelSectionHeader.qml CursorSurface.qml | head -60; cat /usr/share/omarchy/bin/omarchy-plugin-validate | head -60`

✓ 117 ms

```text
[exit 0, 108 ms]
BarIconButton.qml:8:  property Component iconComponent: null
BarIconButton.qml:9:  property real slotSize: Style.bar.iconSlot
BarIconButton.qml:10:  property real opticalSize: Style.bar.iconCanvas
BarIconButton.qml:11:  property bool debugOpticalBounds: Quickshell.env("OMARCHY_DEBUG_BAR_ICONS") === "1"
BarIconButton.qml:12:  readonly property real opticalCenterErrorX: glyph.visible ? glyph.paintedCenterX - opticalCanvas.width / 2 : 0
BarIconButton.qml:13:  readonly property real glyphPaintedWidth: glyph.visible ? glyph.tightWidth : 0
BarIconButton.qml:14:  readonly property real glyphBaselineY: glyph.visible ? glyph.baselineY : 0
BarIconButton.qml:15:  readonly property int glyphFontSize: glyph.visible ? glyph.renderedFontSize : 0
PanelHero.qml:7:  property Component iconComponent: null
PanelHero.qml:8:  property string title: ""
PanelHero.qml:9:  property string meta: ""
PanelHero.qml:10:  property string detail: ""
PanelHero.qml:11:  property color foreground: Color.foreground
PanelHero.qml:12:  property string fontFamily: Style.font.family
PanelHero.qml:13:  property real iconSize: Style.font.display
PanelHero.qml:14:  property real iconOpacity: 1.0
PanelHero.qml:15:  property alias metaOpacity: metaText.opacity
PanelHero.qml:20:  property Component trailingControl: null
PanelHero.qml:22:  readonly property color dim: Qt.darker(foreground, 1.4)
PanelHero.qml:23:  readonly property real trailingInset: trailingLoader.item && trailingLoader.item.visible ? trailingLoader.width + Style.space(12) : 0
PanelKeyCatcher.qml:4:// and emits semantic signals so each panel keeps its own state machine
PanelKeyCatcher.qml:32:// triggering signals.
PanelKeyCatcher.qml:36:  property bool blocked: false
PanelKeyCatcher.qml:38:  signal moveRequested(int dx, int dy)
PanelKeyCatcher.qml:39:  signal activateRequested()
PanelKeyCatcher.qml:40:  signal returnRequested()
PanelKeyCatcher.qml:41:  signal closeRequested()
PanelKeyCatcher.qml:42:  signal deleteRequested()
PanelKeyCatcher.qml:43:  signal tabRequested(int direction)
PanelKeyCatcher.qml:44:  signal textKey(string text)
PanelSectionHeader.qml:10:  property color foreground: Color.foreground
PanelSectionHeader.qml:11:  property string fontFamily: Style.font.family
PanelSectionHeader.qml:12:  property real fontSize: Style.font.caption
CursorSurface.qml:17:  property bool hasCursor: false
CursorSurface.qml:18:  property bool current: false
CursorSurface.qml:19:  property bool outline: false
CursorSurface.qml:20:  property bool bordered: false
CursorSurface.qml:22:  property color foreground: Color.foreground
CursorSurface.qml:23:  property color accent: Color.accent
…
```

**⏺ bash** `fc-list | grep -i "nerd" | head -3; python3 -c "import fontTools; print('ft ok')" 2>&1`

✗ 174 ms

```text
[exit 1, 168 ms]
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Italic.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Italic
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Bold.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Bold
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Regular
Traceback (most recent call last):
  File "<string>", line 1, in <module>
    import fontTools; print('ft ok')
    ^^^^^^^^^^^^^^^^
ModuleNotFoundError: No module named 'fontTools'
```

**⏺ bash** `cd /tmp; uv run --offline --with fonttools python -c "
from fontTools.ttLib import TTFont
f=TTFont('/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf')
cmap=f.getBestCmap()
for cp,n in cmap.items():
    if 'opacity' in n.lower() or 'transparen' in n.lower() or 'circle_half' in n.lower() or 'con`

✓ 293 ms

```text
[exit 0, 287 ms]
error: No solution found when resolving `--with` dependencies
  cause: Because fonttools was not found in the cache and you require fonttools, we can conclude that your requirements are unsatisfiable.

hint: Packages were unavailable because the network was disabled. When the network is disabled, registry packages may only be read from the cache.
```

No fontTools offline. Material Design Icons' `mdi-opacity` is U+F05CB, and Nerd Fonts keep MDI codepoints, so I'll check that it's in the installed font's charset with `fc-query`.

**⏺ bash** `fc-query --format='%{charset}\n' /usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf | tr ' ' '\n' | awk -F- '{s=strtonum("0x"$1); e=($2?strtonum("0x"$2):s); if (0xF05CB>=s && 0xF05CB<=e) print "F05CB present in", $0}'; grep -rn $'\U000F05CB' /usr/share/omarchy 2>/dev/null | head -3`

✓ 466 ms

```text
[exit 0, 460 ms]
F05CB present in f0001-f1af0
```

The glyph is in the installed font. One more check on `BarIconButton`'s base type (for the tooltip and click API), then I'll write the plugin.

**⏺ bash** `cd /usr/share/omarchy/shell/Ui; head -7 BarIconButton.qml; grep -n "property\|signal" WidgetButton.qml | head -30; cat PanelSectionHeader.qml | head -30`

✓ 93 ms

```text
[exit 0, 87 ms]
import QtQuick
import Quickshell
import qs.Commons

WidgetButton {
  id: root

7:  property var bar: null
8:  property string text: ""
9:  property string fontFamily: bar ? bar.fontFamily : Style.font.family
10:  property real fontSize: Style.font.body
11:  property color foreground: bar ? bar.barForeground : Color.foreground
12:  property color activeColor: bar ? bar.urgent : Color.urgent
13:  property bool active: false
14:  property real horizontalMargin: 8.5
15:  property real verticalPadding: 6
16:  property real fixedWidth: -1
17:  property real fixedHeight: -1
18:  property real textRotation: 0
19:  property bool keepSpace: false
20:  property bool dimmed: false
21:  property bool concealed: false
22:  property bool interactive: true
23:  property bool pressable: true
24:  property bool useActiveColor: true
25:  property bool maintainIndicatorReveal: false
26:  property bool labelVisible: true
27:  property bool hasVisualContent: text !== ""
28:  property var revealHost: bar
29:  property string tooltipText: ""
30:  property var registeredBar: null
32:  signal pressed(int button)
33:  signal wheelMoved(int delta)
57:  readonly property bool vertical: bar ? bar.vertical : false
58:  readonly property int barSize: bar ? bar.barSize : Style.bar.sizeHorizontal
59:  readonly property real scaledHorizontalMargin: Style.spaceReal(horizontalMargin)
60:  readonly property real scaledVerticalPadding: Style.spaceReal(verticalPadding)
import QtQuick
import qs.Commons
…
```

I have what I need. I'll put the pure logic (clamping, the Lua snippet, parsing the saved file) in a small `Model.js` so I can test it with node, and keep the QML as the UI.

**⏺ write** `.config/omarchy/plugins/parker.window-opacity/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.window-opacity",
  "name": "Window opacity",
  "version": "1.0.0",
  "author": "parker",
  "description": "Live sliders for Hyprland's focused and unfocused window opacity",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Widget.qml"
  },
  "barWidget": {
    "displayName": "Window opacity",
    "description": "Live sliders for Hyprland's focused and unfocused window opacity",
    "category": "System",
    "allowMultiple": false,
    "defaultSection": "right"
  }
}
```

✓ 1 ms

```text
wrote 534 bytes to .config/omarchy/plugins/parker.window-opacity/manifest.json
```

**⏺ write** `.config/omarchy/plugins/parker.window-opacity/Model.js`

```
// Pure helpers for the window-opacity widget. No QML dependencies so they can
// be exercised with plain node (see test.js).
.pragma library

var MIN_PERCENT = 10
var MAX_PERCENT = 100

function clampPercent(value) {
  var n = Math.round(Number(value))
  if (!isFinite(n)) return MAX_PERCENT
  return Math.max(MIN_PERCENT, Math.min(MAX_PERCENT, n))
}

// 90 -> "0.90". Fixed precision keeps the Lua file and hyprctl input stable.
function toFraction(percent) {
  return (clampPercent(percent) / 100).toFixed(2)
}

// The Lua table both `hyprctl eval` and the persisted file apply.
function configCall(active, inactive) {
  return "hl.config({ decoration = { active_opacity = " + toFraction(active)
    + ", inactive_opacity = " + toFraction(inactive) + " } })"
}

function luaFile(active, inactive) {
  return "-- Managed by the parker.window-opacity bar widget\n"
    + "-- (~/.config/omarchy/plugins/parker.window-opacity). Moving its sliders\n"
    + "-- rewrites this file; delete it to fall back to your other settings.\n"
    + "hl.config({\n"
    + "  decoration = {\n"
    + "    active_opacity = " + toFraction(active) + ",\n"
    + "    inactive_opacity = " + toFraction(inactive) + ",\n"
    + "  },\n"
    + "})\n"
}

function readOption(text, name) {
  // Anchor on a non-identifier char so "active_opacity" never matches inside
  // "inactive_opacity".
  var re = new RegExp("(^|[^A-Za-z0-9_])" + name + "\\s*=\\s*([0-9]*\\.?[0-9]+)")
  var m = re.exec(String(text || ""))
  if (!m) return MAX_PERCENT
  return clampPercent(parseFloat(m[2]) * 100)
}

// Parse a previously written file. Missing file/values mean Hyprland's
// default of fully opaque.
function parseLuaFile(text) {
  return {
    active: readOption(text, "active_opacity"),
    inactive: readOption(text, "inactive_opacity")
  }
}
```

✓ 0 ms

```text
wrote 1812 bytes to .config/omarchy/plugins/parker.window-opacity/Model.js
```

**⏺ write** `.config/omarchy/plugins/parker.window-opacity/Widget.qml`

```
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons
import "Model.js" as Model

// Bar icon + popup with two sliders that drive Hyprland's
// decoration.active_opacity / decoration.inactive_opacity live.
//
// Persistence: the values are written to ~/.config/hypr/window-opacity.lua,
// which hyprland.lua loads. That keeps them across shell restarts, Hyprland
// reloads, and logins (Hyprland applies them itself, before the shell starts).
// The same file is read back to seed the sliders.
Panel {
  id: root
  moduleName: "parker.window-opacity"

  property int activePercent: 100
  property int inactivePercent: 100
  property bool fileReady: false      // never write before the first read
  property bool applyQueued: false

  // Keyboard cursor: "active" | "inactive"; painted after hover/first key.
  property string focusRow: "active"
  property bool cursorActive: false

  readonly property string luaPath: Quickshell.env("HOME") + "/.config/hypr/window-opacity.lua"

  function setOpacity(row, value) {
    var percent = Model.clampPercent(value)
    if (row === "active") {
      if (percent === activePercent) return
      activePercent = percent
    } else {
      if (percent === inactivePercent) return
      inactivePercent = percent
    }
    apply()
    persistDebounce.restart()
  }

  // Live update. Coalesce while hyprctl is still running so a fast drag
  // never stacks processes; the last value always lands.
  function apply() {
    if (applyProc.running) {
      applyQueued = true
      return
    }
    applyQueued = false
    applyProc.command = ["hyprctl", "eval", Model.configCall(activePercent, inactivePercent)]
    applyProc.running = true
  }

  function persist() {
    if (!fileReady) return
    luaFile.setText(Model.luaFile(activePercent, inactivePercent))
  }

  function loadFrom(text) {
… (184 more lines in the repository)
```

✓ 1 ms

```text
wrote 7157 bytes to .config/omarchy/plugins/parker.window-opacity/Widget.qml
```

Before testing, a few things to tighten: confirm the glyph bytes I wrote, check `PanelHero`'s icon API, and drop the alias indirection, since `loadFrom` can read `activeRow.slider` directly.

**⏺ bash** `cd .config/omarchy/plugins/parker.window-opacity; python3 -c "
import re;s=open('Widget.qml',encoding='utf-8').read()
print({hex(ord(c)) for c in s if ord(c)>0xffff or 0xe000<=ord(c)<=0xf8ff})"; cat /usr/share/omarchy/shell/Ui/PanelHero.qml | sed -n 1,80p`

✓ 94 ms

```text
[exit 0, 88 ms]
{'0xf05cb'}
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

  Loader {
    id: iconLoader
    sourceComponent: root.iconComponent
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    opacity: root.iconOpacity
  }

  Column {
    id: heroLabels
    anchors.left: iconLoader.right
…
```

**⏺ bash** `cd .config/omarchy/plugins/parker.window-opacity; python3 - <<'EOF'
p='Widget.qml'; s=open(p,encoding='utf-8').read()
s=s.replace("""    if (persistDebounce.running || activeSlider.dragging || inactiveSlider.dragging) return""","""    if (persistDebounce.running || activeRow.slider.dragging || inact`

✓ 93 ms

```text
[exit 0, 87 ms]
141:          meta: "FOCUSED " + root.activePercent + "% · UNFOCUSED " + root.inactivePercent + "%"
178:    property alias slider: rowSlider
199:        text: Math.round(rowSlider.dragging ? rowSlider.liveValue : rowRoot.percent) + "%"
212:      height: rowSlider.implicitHeight + Style.spacing.controlGap
217:      PanelSlider {
218:        id: rowSlider
```

The hero meta repeats the row values, so I'll make it a plain caption.

**⏺ edit** `.config/omarchy/plugins/parker.window-opacity/Widget.qml`

```
          meta: "APPLIES LIVE"
```

✓ 1 ms

```text
edited .config/omarchy/plugins/parker.window-opacity/Widget.qml at line 141
```

**⏺ edit** `.config/hypr/hyprland.lua`

```
-- Window opacity saved by the window-opacity bar widget (only if the file exists).
require("default.hypr.require_optional").module("hypr.window-opacity")

-- Add any other personal Hyprland configuration below.
```

✓ 1 ms

```text
edited .config/hypr/hyprland.lua at line 28
```

**⏺ edit** `.config/omarchy/shell.json`

```
        {
          "id": "parker.window-opacity"
        },
        {
          "id": "omarchy.monitor"
        },
```

✓ 1 ms

```text
edited .config/omarchy/shell.json at line 56
```

Now verification. First the static checks: the plugin validator, `shell.json` syntax, and the Model helpers under node.

**⏺ bash** `omarchy-plugin-validate .config/omarchy/plugins/parker.window-opacity && echo VALID; jq -e '.bar.layout.right[] | select(.id=="parker.window-opacity")' .config/omarchy/shell.json; 
cd .config/omarchy/plugins/parker.window-opacity && sed 's/^\.pragma library//' Model.js > /tmp/model.cjs && echo 'modu`

✗ 6363 ms

```text
[exit 1, 6356 ms]
VALID
{
  "id": "parker.window-opacity"
}
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Remote versions cannot be fetched for cli/cli: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for openai/codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for gh: [~/.config/mise/config.toml] gh@latest: unable to fetch versions for gh: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for charmbracelet/crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for codex: [~/.config/mise/config.toml] codex@latest: unable to fetch versions for codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for anthropics/claude-code: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for claude: [~/.config/mise/config.toml] claude@latest: unable to fetch versions for claude: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for crush: [~/.config/mise/config.toml] crush@latest: unable to fetch versions for crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for astral-sh/uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for uv: [~/.config/mise/config.toml] uv@latest: unable to fetch versions for uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for earendil-works/pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for pi: [~/.config/mise/config.toml] pi@latest: unable to fetch versions for pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for npm:playwright: [~/.config/mise/config.toml] npm:playwright@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for gemini: [~/.config/mise/config.toml] gemini@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for opencode: [~/.config/mise/config.toml] opencode@latest: timed out after 3.00s
mise by @jdx – installing 1 tool
mise ✗ node@26.7.0  4ms · failed: error sending request
mise ████████████████ 1/1 · installed 0 tools · 1 failed in 6ms
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: HTTP host https://cursor.com:443 is unavailable after an earlier connection failure: error sending request
mise ERROR Failed to install core:node@26.7.0: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise ERROR Version: 2026.10.9 linux-x64 (2026-10-13)
mise ERROR Run with --verbose or MISE_VERBOSE=1 for more information
```

The validator passes and `shell.json` is valid. `node` here is a mise shim that wants network, so I'll look for another JS runtime.

**⏺ bash** `ls /usr/bin/node /usr/bin/qjs /usr/bin/deno /usr/bin/bun 2>/dev/null; ls ~/.local/share/mise/installs/node/ 2>/dev/null; which lua luajit lua5.4 2>/dev/null`

✓ 91 ms

```text
[exit 0, 85 ms]
/usr/bin/bun
/usr/bin/deno
/usr/bin/qjs
/usr/bin/lua
/usr/bin/luajit
/usr/bin/lua5.4
```

**⏺ bash** `cd /tmp && /usr/bin/bun -e '
const M=require("/tmp/model.cjs"), a=require("assert");
a.equal(M.clampPercent(0),10); a.equal(M.clampPercent(150),100); a.equal(M.clampPercent("abc"),100); a.equal(M.clampPercent(87.6),88);
a.equal(M.toFraction(90),"0.90"); a.equal(M.toFraction(100),"1.00");
console.log`

✓ 253 ms

```text
[exit 0, 247 ms]
error: Cannot find module '/tmp/model.cjs' from '/tmp/[eval]'

Bun v1.4.0 (Linux x64)
retry
```

`/tmp` isn't shared between calls, so I'll do the model test and the Lua load test in one command inside a scratch directory and clean it up afterwards.

**⏺ bash** `set -e; P=.config/omarchy/plugins/parker.window-opacity; S=$(mktemp -d); mkdir -p $S/home/.config/hypr
sed 's/^\.pragma library//' $P/Model.js > $S/model.cjs; echo 'module.exports={clampPercent,toFraction,configCall,luaFile,parseLuaFile}' >> $S/model.cjs
/usr/bin/bun -e '
const M=require(process.arg`

✓ 200 ms

```text
[exit 0, 188 ms]
model tests ok
file  -> active	0.85	inactive	0.6
eval  -> active	0.9	inactive	0.75
absent ->
```

**⏺ bash** `cd .config/omarchy/plugins/parker.window-opacity; qmllint Widget.qml 2>&1 | grep -v "^$" | grep -iv "warning: Unused import\|qs\.\|unknown\|Did you mean\|import\b" | head -30; echo "exit-ish done"; qmllint Widget.qml 2>&1 | grep -ci "error\|syntax"`

✗ 458 ms

```text
[exit 1, 454 ms]
^^^^^^
---
---
^^^^^^
---
---
  BarIconButton {
  ^^^^^^^^^^^^^
        PanelHero {
        ^^^^^^^^^
        PanelSeparator { foreground: root.bar.foreground }
        ^^^^^^^^^^^^^^
      PanelSectionHeader {
      ^^^^^^^^^^^^^^^^^^
      PanelSlider {
      ^^^^^^^^^^^
    CursorSurface {
    ^^^^^^^^^^^^^
  KeyboardPanel {
  ^^^^^^^^^^^^^
Panel {
^^^^^
    PanelKeyCatcher {
    ^^^^^^^^^^^^^^^
    anchors.fill: parent
    ^^^^^^^
      anchors.fill: parent
      ^^^^^^^
        anchors.left: parent.left
        ^^^^^^^
exit-ish done
0
```

**⏺ bash** `P=$PWD/.config/omarchy/plugins/parker.window-opacity; S=$PWD/.wo-harness; rm -rf $S; mkdir -p $S/cfg $S/home/.config/hypr $S/bin
ln -s /usr/share/omarchy/shell/Ui $S/cfg/Ui; ln -s /usr/share/omarchy/shell/Commons $S/cfg/Commons; cp $P/Widget.qml $P/Model.js $S/cfg/
printf '#!/bin/sh\necho "$@" >> %s`

✓ 307 ms

```text
[exit 0, 288 ms]
  INFO: Launching config: "~/.wo-harness/cfg/shell.qml"
  INFO: Shell ID: "bb3e09ec54afce1be3dc82865d22182a" Path ID "bb3e09ec54afce1be3dc82865d22182a"
  INFO: Saving logs to "/run/user/1000/quickshell/by-id/ez9a9ot/log.qslog"
 ERROR: Failed to load configuration
 ERROR:   caused by @shell.qml[12:5]: Type Widget unavailable
 ERROR:   caused by @Widget.qml[109:3]: Type KeyboardPanel unavailable
 ERROR:   caused by @Ui/KeyboardPanel.qml[37:1]: No PanelWindow backend loaded.
--- hyprctl calls:
--- saved file:
hl.config({ decoration = { active_opacity = 0.70, inactive_opacity = 0.55 } })
```

**⏺ bash** `S=$PWD/.wo-harness; rm $S/cfg/Ui; mkdir $S/cfg/Ui; cp /usr/share/omarchy/shell/Ui/* $S/cfg/Ui/
cat > $S/cfg/Ui/KeyboardPanel.qml <<'EOF'
import QtQuick
Item {
  id: root
  required property Item anchorItem
  required property QtObject bar
  property var owner: null; property bool open: false; proper`

✓ 2343 ms

```text
[exit 0, 2329 ms]
  WARN scene: @Ui/WidgetButton.qml[90:7]: Unable to assign [undefined] to bool
  INFO: Configuration Loaded
 DEBUG qml: LOADED active=70 inactive=55 ready=true
 DEBUG qml: SET active=90 inactive=10
--- hyprctl calls:
-j getoption decoration:rounding
-j getoption general:gaps_out
-j getoption decoration:rounding
-j getoption general:gaps_out
eval hl.config({ decoration = { active_opacity = 0.90, inactive_opacity = 0.55 } })
eval hl.config({ decoration = { active_opacity = 0.90, inactive_opacity = 0.10 } })
--- saved file:
-- Managed by the parker.window-opacity bar widget
-- (~/.config/omarchy/plugins/parker.window-opacity). Moving its sliders
-- rewrites this file; delete it to fall back to your other settings.
hl.config({
  decoration = {
    active_opacity = 0.90,
    inactive_opacity = 0.10,
  },
})
```

**⏺ bash** `sed -n 86,92p /usr/share/omarchy/shell/Ui/WidgetButton.qml; grep -n "centerSectionRevealHeld" /usr/share/omarchy/shell/Ui/PluginBarApi.qml
S=$PWD/.wo-harness; : > $S/hyprctl.log; sed -i 's/w.open(); w.setOpacity("active", 90); w.setOpacity("inactive", 3)//' $S/cfg/shell.qml
cd $S; HOME=$S/home PATH=`

✓ 2357 ms

```text
[exit 0, 2350 ms]
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Behavior on color {
      enabled: !root.bar || root.bar.foregroundAnimationEnabled
      ColorAnimation { duration: 160 }
    }
24:  property bool centerSectionRevealHeld: false
 DEBUG qml: LOADED active=90 inactive=10 ready=true
eval calls after restart: 0
 M .config/hypr/hyprland.lua
 M .config/omarchy/shell.json
?? .config/omarchy/plugins/
?? .local/
```

**⏺ bash** `find .local -maxdepth 4 | head; `

✓ 71 ms

```text
[exit 0, 65 ms]
.local
.local/state
.local/state/mise
.local/state/mise/tracked-configs
.local/state/mise/tracked-configs/3a8292bc9105163d
.local/state/mise/tracked-configs/8689d62d58dd82ae
.local/state/mise/incomplete-installs
.local/state/mise/incomplete-installs/node
.local/share
.local/share/mise
```

That's left over from my failed `node` shim call (mise state), not from the plugin, so I'll remove it and show the final diff.

**⏺ bash** `rm -rf .local; git status --short; git diff; ls .config/omarchy/plugins/parker.window-opacity`

✓ 92 ms

```text
[exit 0, 88 ms]
 M .config/hypr/hyprland.lua
 M .config/omarchy/shell.json
?? .config/omarchy/plugins/
diff --git a/.config/hypr/hyprland.lua b/.config/hypr/hyprland.lua
index 45c9b66..497a0a8 100644
--- a/.config/hypr/hyprland.lua
+++ b/.config/hypr/hyprland.lua
@@ -25,5 +25,8 @@ require("hypr.autostart")
 -- Toggle config flags dynamically.
 require("default.hypr.toggles")
 
+-- Window opacity saved by the window-opacity bar widget (only if the file exists).
+require("default.hypr.require_optional").module("hypr.window-opacity")
+
 -- Add any other personal Hyprland configuration below.
 -- o.window("qemu", { workspace = "5" })
diff --git a/.config/omarchy/shell.json b/.config/omarchy/shell.json
index e6202da..5ddb226 100644
--- a/.config/omarchy/shell.json
+++ b/.config/omarchy/shell.json
@@ -53,6 +53,9 @@
         {
           "id": "omarchy.audio"
         },
+        {
+          "id": "parker.window-opacity"
+        },
         {
           "id": "omarchy.monitor"
         },
Model.js
Widget.qml
manifest.json
```

I've built the opacity plugin and added it to the right side of your top bar, next to the Display icon. I tested it in Quickshell with a fake `hyprctl`, but there's no running Hyprland in my sandbox, so I haven't seen it change real windows yet.

**How it works**
- **The bar icon:** a droplet icon whose tooltip shows both values. Clicking it opens a small panel with two sliders: "Focused window" and "Unfocused windows", from 10% to 100%.
- **Live changes:** moving a slider changes Hyprland's opacity settings for focused and unfocused windows right away. You can also use the keyboard: j/k to switch sliders, h/l to change by 5%, Esc to close.
- **Keeping your settings:** after you stop moving a slider, the values are saved to `~/.config/hypr/window-opacity.lua`. I added one line to `hyprland.lua` that loads this file, so Hyprland applies your values itself at login and on every config reload, even before the bar starts. If the file is missing, nothing happens. Delete it to go back to normal.

**Files**
- `~/.config/omarchy/plugins/parker.window-opacity/`: `manifest.json`, `Widget.qml` and `Model.js` (the value and file logic)
- `~/.config/omarchy/shell.json`: added the widget to the bar
- `~/.config/hypr/hyprland.lua`: the one loading line

**How I checked it**
- Omarchy's plugin validator passes and `shell.json` is valid.
- I tested the value logic: it limits values to 10–100 and reads the saved file back correctly.
- I ran your Hyprland config's loading code on the saved file: the values are found and applied, and a missing file causes no error.
- In Quickshell, with only the popup window swapped for a placeholder, the widget read the saved values and sent the right commands to `hyprctl`. When I moved both sliders quickly, the last values were the ones applied. A slider set to 3% was raised to 10%, and the save happened. On a simulated restart it read the values back and didn't reapply or rewrite anything.

**Please check on your machine**
- The bar should pick up the new widget by itself; if it doesn't, run `omarchy-shell shell rescanPlugins`. Then move a slider and run `hyprctl configerrors` to confirm there are no errors.
- **How the numbers combine:** Omarchy already gives most windows 98.5% opacity when focused and 96% when unfocused. Hyprland multiplies that by your slider, so 90% shows as about 89%.
- **What it affects:** these sliders change all windows, including ones Omarchy normally keeps fully opaque (video, games, picture-in-picture). Fullscreen windows aren't affected.
- **Brief reload:** saving the file may make Hyprland reload its config automatically when you let go of a slider. Your values stay the same; it's just a reload.

