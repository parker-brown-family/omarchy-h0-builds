# opencode building Disk Free

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools opencode

---

### › You

```text
Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.
```

**⏺ skill** `{"id": "omarchy"}`

✓ 25 ms

```text
<skill_content name="omarchy">
# Skill: omarchy

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

Deeper instructions for common areas live next to this file. Read the
matching guide before starting:

- [`hyprland.md`](hyprland.md) - keybindings, monitors, window rules, and other Hyprland config
- [`plugins.md`](plugins.md) - the Omarchy shell: bar layout, widgets, plugins, idle behavior
- [`theming.md`](theming.md) - themes, backgrounds, and fonts
- [`hooks.md`](hooks.md) - automation hooks that run on system events
- [`capture.md`](capture.md) - screenshots, screen recordings, OCR text capture, and file sharing
- [`contributing.md`](contributing.md) - reporting Omarchy bugs and submitting fixes upstream

…
```

**⏺ read** `~/.agents/skills/omarchy/plugins.md`

✓ 508 ms

```text
Read file ~/.agents/skills/omarchy/plugins.md, lines 1-52
1: # Omarchy Shell: Bar, Plugins, and Idle
2: 
3: Read this before changing the status bar, notifications, shell plugins,
4: widgets, or idle/lock behavior.
5: 
6: The bar, notification daemon, settings panel, and assorted overlays all run
7: inside a single long-running Quickshell process (`omarchy-shell`).
8: 
9: ```
10: ~/.config/omarchy/shell.json             # User overrides: bar, plugins, idle
11: ~/.config/omarchy/plugins/<plugin-id>/   # User-owned shell plugins
12: $OMARCHY_PATH/config/omarchy/shell.json  # Canonical defaults
13: ```
14: 
15: The shell hot-reloads `shell.json` on save — no restart needed for layout
16: changes. `idle.screensaver` and `idle.lock` are seconds since user idle began.
17: 
18: **Commands:** `omarchy restart shell`, `omarchy refresh shell`
19: 
20: ## Bar Layout
21: 
22: Use the `omarchy bar` group to move and manage widgets:
23: 
24: ```bash
25: omarchy bar move omarchy.clock --section right
26: ```
27: 
28: For layout edits beyond what the commands cover, edit the bar configuration
29: in `~/.config/omarchy/shell.json`; it hot-reloads on save.
30: 
31: ## Customizing Built-In Plugins and Widgets
32: 
33: To customize a built-in bar widget, never edit `$OMARCHY_PATH/shell/plugins/`.
34: Clone it into the user plugin directory instead:
35: 
36: ```bash
37: omarchy plugin clone omarchy.workspaces
38: # Edit ~/.config/omarchy/plugins/<username>.workspaces/; saved changes reload automatically.
39: ```
…
```

**⏺ shell** `{"command": "echo $OMARCHY_PATH; ls /usr/share/omarchy/shell/plugins/ 2>&1; ls ~/.config/omarchy/plugins/ 2>&1; cat ~/.config/omarchy/shell.json 2>&1; whoami; omarchy plugin --help 2>&1"}`

✓ 1026 ms

```text
/usr/share/omarchy
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
ls: cannot access '~/.config/omarchy/plugins/': No such file or directory
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
…
```

**⏺ shell** `{"command": "cat /usr/share/omarchy/shell/plugins/README.md; ls -R /usr/share/omarchy/shell/plugins/bar | head -80"}`

✓ 436 ms

```text
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

First-party bar-only widgets also carry manifests next to their QML files,
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins/bar; cat README.md; cat widgets/SystemUpdate.manifest.json widgets/SystemUpdate.qml; ls /usr/share/omarchy/shell; ls /usr/share/omarchy/shell/plugins/p`

✓ 1079 ms

```text
# Omarchy bar

This is the Quickshell implementation of the Omarchy status bar. It is
shipped as a first-party plugin of [`omarchy-shell`](../../README.md), the
long-running shell host. The bar is mounted at startup and lives inside
the shell for its whole session.

- `manifest.json` declares the plugin (`id: omarchy.bar`, `kind: bar`) and points at `Bar.qml` as the entry point.
- `Bar.qml` is Omarchy-owned bar engine code, loaded by the omarchy-shell host. Users should not edit it directly.
- `widgets/` holds simple first-party bar widgets with sibling manifests.
- Feature plugins such as `../panels/audio/`, `../panels/network/`, `../panels/power/`, and `../agents/` provide richer popup bar plugins.
- The bar receives its config from the host shell as a `barConfig` property; the host loads it from `~/.config/omarchy/shell.json` (or `config/omarchy/shell.json` when the user has no file).
- `omarchy bar position` updates only the user shell.json file.

## Customizing

The bar config lives under the `bar:` key of [`~/.config/omarchy/shell.json`](../../README.md#shelljson-shape). Out of the box the shell uses [`config/omarchy/shell.json`](../../../config/omarchy/shell.json). Once you customize anything via the bar gestures, `omarchy bar ...`, or by editing shell.json directly, your file is canonical — there is no deep-merge.

The bar is configured directly on the bar itself: drag empty bar space (or click-and-hold) to move the bar to another screen edge, double-left-click empty center-bar space to toggle transparency, and drag widgets to reorder them. The `omarchy bar position`, `omarchy bar transparent`, `omarchy bar move`, and `omarchy bar set` commands do the same from scripts. Enable or disable widgets with `omarchy plugin enable` and `omarchy plugin disable` (widget ids come from `omarchy plugin list`).

Example `shell.json` (bar subtree only shown):

```json
{
  "version": 1,
  "bar": {
    "position": "top",
    "transparent": false,
    "centerAnchor": "omarchy.clock",
    "layout": {
      "left": [
        { "id": "omarchy.menu" },
        { "id": "omarchy.spacer", "size": 12 },
        { "id": "omarchy.workspaces" }
      ],
      "center": [
        { "id": "omarchy.media" },
        { "id": "omarchy.clock", "format": "HH:mm" }
      ],
      "right": [
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins/panels/weather; cat manifest.json BarWidget.qml; find /usr/share/omarchy/shell -name \"*.schema.json\" -o -name \"*schema*\" | head"}`

✓ 811 ms

```text
{
  "schemaVersion": 1,
  "id": "omarchy.weather",
  "name": "Weather",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Weather pill with detail popup",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "BarWidget.qml"
  },
  "barWidget": {
    "displayName": "Weather",
    "description": "Weather pill with detail popup",
    "category": "Info",
    "allowMultiple": false,
    "settingsForm": "weatherSettings"
  }
}
import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.weather"

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("settings" in target) target.settings = root.settings
    if ("anchorItem" in target) target.anchorItem = button
    if ("hostWidget" in target) target.hostWidget = root
  }

  function refresh() {
    if (panelLoader.item && panelLoader.item.refresh) panelLoader.item.refresh()
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; ls Ui Commons; cat Ui/BarWidget.qml Ui/BarIconButton.qml; cat plugins/bar/widgets/KeyboardLayout.qml"}`

✓ 542 ms

```text
Commons:
Border.qml
BorderGeometry.js
Color.qml
Style.qml
Util.qml
qmldir

Ui:
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
MultiSelect.qml
NumberField.qml
OpticalGlyph.qml
Panel.qml
PanelActionButton.qml
PanelController.qml
PanelHero.qml
PanelKeyCatcher.qml
PanelSectionHeader.qml
PanelSeparator.qml
PanelSlider.qml
PanelToolTip.qml
PluginBarApi.qml
PointerMoveGate.qml
PopupCard.qml
ScreenMoveRemap.qml
SearchableDropdown.qml
SpeedTestOverlay.qml
TextField.qml
Toggle.qml
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; cat Ui/WidgetButton.qml; grep -n \"manifest\\|kinds\\|barWidget\\|settingsForm\\|bar-widget\" README.md | head -60"}`

✓ 799 ms

```text
import QtQuick
import qs.Commons

Item {
  id: root

  property var bar: null
  property string text: ""
  property string fontFamily: bar ? bar.fontFamily : Style.font.family
  property real fontSize: Style.font.body
  property color foreground: bar ? bar.barForeground : Color.foreground
  property color activeColor: bar ? bar.urgent : Color.urgent
  property bool active: false
  property real horizontalMargin: 8.5
  property real verticalPadding: 6
  property real fixedWidth: -1
  property real fixedHeight: -1
  property real textRotation: 0
  property bool keepSpace: false
  property bool dimmed: false
  property bool concealed: false
  property bool interactive: true
  property bool pressable: true
  property bool useActiveColor: true
  property bool maintainIndicatorReveal: false
  property bool labelVisible: true
  property bool hasVisualContent: text !== ""
  property var revealHost: bar
  property string tooltipText: ""
  property var registeredBar: null

  signal pressed(int button)
  signal wheelMoved(int delta)

  function triggerPress(button) {
    if (root.bar) root.bar.hideTooltip(root)
    root.pressed(button)
  }

  function hideOwnTooltip() {
…
```

**⏺ read** `/usr/share/omarchy/shell/README.md`

✓ 614 ms

```text
Read file /usr/share/omarchy/shell/README.md, lines 40-289
40:     osd/
41:     polkit/
42: ```
43: 
44: The plugin discovery path is documented in [plugins/README.md](plugins/README.md).
45: 
46: ## Plugin manifest
47: 
48: Every plugin ships a `manifest.json` describing what it is and how the
49: shell should load it. Minimal example:
50: 
51: ```json
52: {
53:   "schemaVersion": 1,
54:   "id": "my.org.cool-clock",
55:   "name": "Cool clock",
56:   "version": "1.0.0",
57:   "author": "You",
58:   "description": "A clock that does cool things",
59:   "kinds": ["bar-widget"],
60:   "entryPoints": { "barWidget": "Widget.qml" },
61:   "barWidget": {
62:     "displayName": "Cool clock",
63:     "category": "Time",
64:     "allowMultiple": false,
65:     "defaultSection": "left",
66:     "defaults": { "format": "HH:mm" },
67:     "schema": [
68:       { "key": "format", "type": "string", "label": "Format" }
69:     ]
70:   }
71: }
72: ```
73: 
74: Supported `kinds`:
75: 
76: | Kind         | What it is                                                   |
77: |--------------|--------------------------------------------------------------|
78: | `bar-widget` | A component that the active bar can drop into a section      |
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n '\"number\"\\|type ===\\|\"int\"\\|\"bool' services/PluginRegistry.qml | head -30; grep -rn \"import qs\" plugins/*/manifest.json 2>/dev/null | head; `

✓ 1817 ms

```text
4:import qs.Commons
400:  // deviation: an added third-party plugin in plugins[], a switched-off
692:    // $0 = first-party dir, $1 = third-party dir. Some bash versions need the explicit -- separator.
module qs.Commons
singleton Border 1.0 Border.qml
singleton Color 1.0 Color.qml
singleton Style 1.0 Style.qml
singleton Util 1.0 Util.qml
327:    readonly property int caption:      root.fontToken("caption",       root.fontPx(0.833))   // 10
347:    readonly property int statusSlot:     root.barToken("status-slot",     21)
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -rn \"schema\" services/PluginRegistry.qml | head -20; grep -rln '\"schema\"' plugins | head; grep -n \"urgent\\|red\" Commons/Color.qml | head; omarchy `

✓ 1210 ms

```text
48:    if (manifest.schemaVersion !== 1) {
49:      console.warn("PluginRegistry: unsupported schemaVersion at " + sourcePath)
plugins/agents/manifest.json
plugins/bar/widgets/Indicators.manifest.json
plugins/panels/dropbox/manifest.json
plugins/panels/tailscale/manifest.json
8:// accent, urgent) comes from theme/colors.toml. Per-surface roles come from
22:  property color urgent: "#a55555"
57:    if (role === "urgent") return root.urgent
76:    property color active: root.pick("bar.active", root.urgent)
109:    property color textError: root.pick("polkit.text-error", root.urgent)
111:    property color borderError: root.composed("polkit.border-error", "polkit.border-alpha", root.urgent, 1.0)
119:    property color textError: root.pick("lock.text-error", root.urgent)
122:    property color borderError: root.composed("lock.border-error", "lock.border-alpha", root.urgent, 1.0)
152:      // file so the old single-property approach clobbered accent with it.
159:      else if (match[1] === "red" || match[1] === "color1") urgent = match[2]
Usage:
  omarchy plugin validate <plugin-folder>

Validate a plugin folder against the Omarchy plugin manifest schema

Arguments:
  <plugin-folder>

Examples:
  omarchy plugin validate ./my-plugin
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins; cat panels/tailscale/manifest.json; df -B1 --output=size,avail,target / ; command -v df"}`

✓ 654 ms

```text
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
    ]
  }
}
    1B-blocks        Avail Mounted on
1022042832896 121084608512 /
/usr/bin/df
```

**⏺ write** `~/.config/omarchy/plugins/parker.disk-free/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.disk-free",
  "name": "Disk free",
  "version": "1.0.0",
  "author": "parker",
  "description": "Shows free space left on the main drive",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "BarWidget.qml"
  },
  "barWidget": {
    "displayName": "Disk free",
    "description": "Free space left on the main drive, red when running low",
    "category": "System",
    "allowMultiple": true,
    "defaultSection": "right",
    "defaults": {
      "path": "/",
      "intervalSec": 60,
      "warnPercent": 10
    },
    "schema": [
      {
        "key": "path",
        "type": "string",
        "label": "Mount point",
        "defaultValue": "/"
      },
      {
        "key": "intervalSec",
        "type": "integer",
        "label": "Refresh interval (seconds)",
        "min": 5,
        "max": 3600,
        "step": 5,
        "defaultValue": 60
      },
      {
        "key": "warnPercent",
        "type": "integer",
        "label": "Turn red below (% free)",
        "min": 1,
        "max": 99,
        "step": 1,
        "defaultValue": 10
      }
    ]
  }
}
```

✓ 3454 ms

```text
Created file successfully: .config/omarchy/plugins/parker.disk-free/manifest.json
```

**⏺ write** `~/.config/omarchy/plugins/parker.disk-free/BarWidget.qml`

```
import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "parker.disk-free"

  readonly property string mountPath: String(setting("path", "/"))
  readonly property int intervalSec: Math.max(5, Number(setting("intervalSec", 60)))
  readonly property real warnPercent: Number(setting("warnPercent", 10))

  property real totalBytes: 0
  property real freeBytes: 0
  readonly property real freePercent: totalBytes > 0 ? freeBytes / totalBytes * 100 : 100
  readonly property bool low: totalBytes > 0 && freePercent < warnPercent

  function formatSize(bytes) {
    var gib = bytes / 1073741824
    if (gib >= 1024) return (gib / 1024).toFixed(1) + "T"
    return Math.floor(gib) + "G"
  }

  function refresh() {
    if (!dfProc.running) dfProc.running = true
  }

  onMountPathChanged: refresh()

  Process {
    id: dfProc
    command: ["df", "-B1", "--output=size,avail", root.mountPath]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var lines = String(text || "").trim().split("\n")
        if (lines.length < 2) return
        var fields = lines[lines.length - 1].trim().split(/\s+/)
        var size = Number(fields[0])
        var avail = Number(fields[1])
        if (!isFinite(size) || !isFinite(avail) || size <= 0) return
        root.totalBytes = size
        root.freeBytes = avail
      }
    }
  }

  Timer {
    interval: root.intervalSec * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  visible: totalBytes > 0
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

… (16 more lines in the repository)
```

✓ 4845 ms

```text
Created file successfully: .config/omarchy/plugins/parker.disk-free/BarWidget.qml
```

**⏺ shell** `{"command": "echo $HOME; ls -la ~/.config/omarchy/plugins/parker.disk-free; omarchy plugin validate ~/.config/omarchy/plugins/parker.disk-free; command -v omarchy-launch-or-focus-tui"}`

✓ 980 ms

```text
~
total 8
drwxr-xr-x 1 parker parker   52 Nov  9 17:29 .
drwxr-xr-x 1 parker parker   32 Nov  9 17:29 ..
-rw-r--r-- 1 parker parker 2242 Nov  9 17:29 BarWidget.qml
-rw-r--r-- 1 parker parker 1135 Nov  9 17:29 manifest.json
/usr/bin/omarchy-launch-or-focus-tui
```

**⏺ shell** `{"command": "omarchy plugin validate ~/.config/omarchy/plugins/parker.disk-free; echo \"exit=$?\"; omarchy-shell shell rescanPlugins; omarchy plugin enable parker.disk-free 2>&1; omarchy plugin list 2`

✓ 1661 ms

```text
exit=0
omarchy-shell is not running
omarchy-shell is not running
```

The shell isn't running here, so I'll add the widget to the bar layout in `shell.json` directly.

**⏺ edit** `~/.config/omarchy/shell.json`

```
      "right": [
        {
          "id": "omarchy.tray"
        },
        {
          "id": "parker.disk-free",
          "path": "/",
          "intervalSec": 60,
          "warnPercent": 10
        },
```

✓ 1174 ms

```text
Edited .config/omarchy/shell.json (1 replacement)
```

**⏺ shell** `{"command": "python3 -m json.tool ~/.config/omarchy/shell.json >/dev/null && echo ok; df -B1 --output=size,avail / | tail -1 | awk '{printf \"%dG free (%.0f%%)\\n\", $2/1073741824, $2/$1*100}'; comman`

✓ 1304 ms

```text
ok
112G free (12%)
~/.local/bin/qmllint
/usr/lib/qt6/bin/qmllint
```

**⏺ shell** `{"command": "qmllint ~/.config/omarchy/plugins/parker.disk-free/BarWidget.qml 2>&1 | grep -iv \"import\\|unqualified\\|not found\\|unknown\\|could not\\|warning: .*type\" | head -20"}`

✓ 915 ms

```text
^^^^^^
---
---

^^^^^^
---
---

  WidgetButton {
  ^^^^^^^^^^^^
Warning: ~/.config/omarchy/plugins/parker.disk-free/BarWidget.qml:6:1: BarWidget is part of an inheritance cycle: BarWidget -> BarWidget [inheritance-cycle]
BarWidget {
^^^^^^^^^
    anchors.fill: parent
    ^^^^^^^
BarWidget {
^^^^^^^^^
    anchors.fill: parent
    ^^^^^^^
  readonly property string mountPath: String(setting("path", "/"))
```

qmllint flags a possible name clash because the file is named `BarWidget.qml` and also extends `BarWidget`. I'll rename the file to rule out an inheritance loop.

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.disk-free && mv BarWidget.qml DiskFree.qml && sed -i 's/\"barWidget\": \"BarWidget.qml\"/\"barWidget\": \"DiskFree.qml\"/' manifest.json && grep barWid`

✓ 1850 ms

```text
    "barWidget": "DiskFree.qml"
  "barWidget": {
exit=0
```

I built the plugin and added it to the right side of your top bar, but I couldn't see it running. The Omarchy shell (the process that draws the bar) isn't running in this session. The plugin passes `omarchy plugin validate`, but it will only show up once the shell starts. Run `omarchy restart shell` or log back in. If it doesn't appear, run `omarchy-shell shell rescanPlugins`.

**Files**
- `~/.config/omarchy/plugins/parker.disk-free/manifest.json`: describes the plugin and its settings.
- `~/.config/omarchy/plugins/parker.disk-free/DiskFree.qml`: the bar widget.
- `~/.config/omarchy/shell.json`: I added the widget to the right side of the bar, just after the tray.

**What it does**
- Shows free space on `/`, like `112G free`. Drives of 1 TB or more show something like `1.2T free`.
- Checks again every 60 seconds. Middle-click checks right away.
- Turns red when less than 10% is left, using your theme's red so it matches the current theme.
- Hovering shows details, like `/: 112G of 951G free (12%)`.
- Left-click opens `btop`.

Your drive currently has about 112G free (12%), so the text will be normal-coloured for now but is close to turning red.

You can change the settings on the widget's entry in `shell.json`. The bar picks up changes as soon as you save.

```json
{ "id": "parker.disk-free", "path": "/", "intervalSec": 60, "warnPercent": 10 }
```

To move it, run something like `omarchy bar move parker.disk-free --section center`.

