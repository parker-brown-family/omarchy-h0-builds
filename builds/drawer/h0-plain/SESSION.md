# h0, plain building Bar Drawer

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools read, edit, write, grep, glob, bash

---

### › You

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

I'll start by looking at what's in the project and how Omarchy shell plugins are structured here.

**⏺ bash** `ls -la; find . -maxdepth 4 -not -path '*/.git/*' | head -100`

✓ 4608 ms

```text
[exit 0, 4584 ms]
total 0
drwxr-xr-x 1 parker parker  68 Nov  9 16:53 .
drwx------ 3 parker parker  60 Nov  9 16:53 ..
drwxr-xr-x 1 parker parker  12 Nov  9 16:53 .agents
drwxr-xr-x 1 parker parker  12 Nov  9 16:53 .claude
drwxr-xr-x 1 parker parker  12 Nov  9 16:53 .codex
drwxr-xr-x 1 parker parker  72 Nov  8 22:07 .config
drwxr-xr-x 1 parker parker 160 Nov  9 16:53 .git
drwxr-xr-x 1 parker parker  10 Nov  9 16:53 .pi
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
./.config/alacritty
./.config/alacritty/alacritty.toml
./.config/ghostty
./.config/ghostty/config
…
```

**⏺ bash** `cat .config/omarchy/shell.json; find .agents .claude .codex .pi -type f | head -50; git log --oneline | head`

✓ 98 ms

```text
[exit 0, 91 ms]
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

**⏺ bash** `ls -laR .agents .claude/skills .codex .pi | head -60`

✓ 53 ms

```text
[exit 0, 46 ms]
.agents:
total 0
drwxr-xr-x 1 parker parker 12 Nov  9 16:53 .
drwxr-xr-x 1 parker parker 68 Nov  9 16:53 ..
drwxr-xr-x 1 parker parker 42 Nov  9 16:53 skills

.agents/skills:
total 8
drwxr-xr-x 1 parker parker 42 Nov  9 16:53 .
drwxr-xr-x 1 parker parker 12 Nov  9 16:53 ..
lrwxrwxrwx 1 parker parker 55 Nov  9 16:53 diagnose-crash -> /usr/share/omarchy/default/agents/skills/diagnose-crash
lrwxrwxrwx 1 parker parker 48 Nov  9 16:53 omarchy -> /usr/share/omarchy/default/agents/skills/omarchy

.claude/skills:
total 8
drwxr-xr-x 1 parker parker 42 Nov  9 16:53 .
drwxr-xr-x 1 parker parker 12 Nov  9 16:53 ..
lrwxrwxrwx 1 parker parker 55 Nov  9 16:53 diagnose-crash -> /usr/share/omarchy/default/agents/skills/diagnose-crash
lrwxrwxrwx 1 parker parker 48 Nov  9 16:53 omarchy -> /usr/share/omarchy/default/agents/skills/omarchy

.codex:
total 0
drwxr-xr-x 1 parker parker 12 Nov  9 16:53 .
drwxr-xr-x 1 parker parker 68 Nov  9 16:53 ..
drwxr-xr-x 1 parker parker 14 Nov  9 16:53 skills

.codex/skills:
total 4
drwxr-xr-x 1 parker parker 14 Nov  9 16:53 .
drwxr-xr-x 1 parker parker 12 Nov  9 16:53 ..
lrwxrwxrwx 1 parker parker 48 Nov  9 16:53 omarchy -> /usr/share/omarchy/default/agents/skills/omarchy

.pi:
total 0
drwxr-xr-x 1 parker parker 10 Nov  9 16:53 .
drwxr-xr-x 1 parker parker 68 Nov  9 16:53 ..
drwxr-xr-x 1 parker parker 12 Nov  9 16:53 agent

.pi/agent:
…
```

**⏺ bash** `ls -R /usr/share/omarchy/default/agents/skills/omarchy | head -50; cat /usr/share/omarchy/default/agents/skills/omarchy/SKILL.md`

✓ 76 ms

```text
[exit 0, 67 ms]
/usr/share/omarchy/default/agents/skills/omarchy:
SKILL.md
capture.md
contributing.md
hooks.md
hyprland.md
plugins.md
theming.md
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
…
```

**⏺ bash** `cat /usr/share/omarchy/default/agents/skills/omarchy/plugins.md`

✓ 103 ms

```text
[exit 0, 93 ms]
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

The skill guide is thin on the plugin API, so I'll read the shell source and the built-in plugins to learn it.

**⏺ bash** `cd /usr/share/omarchy/shell; ls; find . -maxdepth 3 | grep -v '\.git/' | head -150; echo; echo OMARCHY_PATH=$OMARCHY_PATH; whoami`

✓ 52 ms

```text
[exit 0, 46 ms]
Commons
README.md
Ui
plugins
services
shell.qml
.
./Commons
./Commons/Border.qml
./Commons/BorderGeometry.js
./Commons/Color.qml
./Commons/Style.qml
./Commons/Util.qml
./Commons/qmldir
./Ui
./Ui/BarIconButton.qml
./Ui/BarIndicator.qml
./Ui/BarWidget.qml
./Ui/BorderOverlay.qml
./Ui/BorderSurface.qml
./Ui/Button.qml
./Ui/ButtonGroup.qml
./Ui/ConfirmDialog.qml
./Ui/CursorSurface.qml
./Ui/Dropdown.qml
./Ui/KeyboardPanel.qml
./Ui/MultiSelect.qml
./Ui/NumberField.qml
./Ui/OpticalGlyph.qml
./Ui/Panel.qml
./Ui/PanelActionButton.qml
./Ui/PanelController.qml
./Ui/PanelHero.qml
./Ui/PanelKeyCatcher.qml
./Ui/PanelSectionHeader.qml
./Ui/PanelSeparator.qml
./Ui/PanelSlider.qml
./Ui/PanelToolTip.qml
./Ui/PluginBarApi.qml
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat README.md plugins/README.md plugins/bar/README.md`

✓ 118 ms

```text
[exit 0, 92 ms]
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

Some of that output was cut off. I'll read the omitted middle section directly.

**⏺ bash** `cd /usr/share/omarchy/shell; wc -l README.md plugins/README.md plugins/bar/README.md; sed -n 150,400p README.md`

✓ 94 ms

```text
[exit 0, 75 ms]
  301 README.md
  119 plugins/README.md
  183 plugins/bar/README.md
  603 total
`omarchy.clock` becomes `<username>.clock` (e.g. `dhh.clock`), with `My Clock`
as its display name. The username prefix keeps shared clones from colliding
with each other or with other plugin authors.

```bash
omarchy plugin clone omarchy.clock
```

Cloning switches from the built-in to the new personal plugin, preserving an
existing bar widget's position and settings. Setup > Plugins > Clone provides
the interactive picker, then opens the new `<username>.*` directory in `$EDITOR`.
Existing shortcuts and shell IPC calls made to the built-in id are routed to
the enabled clone, so cloning does not require changing its callers. Removing
an active clone switches back to its built-in source.
Saving a file anywhere under `~/.config/omarchy/plugins/` reloads plugin code
automatically; `omarchy-shell shell rescanPlugins` remains available to force a reload.

First-party plugins under `shell/plugins/` are discovered the same way and load
by default. Disabling a non-widget records it in `disabledPlugins[]`; disabling
a widget removes it from the bar layout while leaving its component available
to add again. A full bar has no off state and is replaced by enabling another.

## IPC contract

The shell exposes a single `shell` IPC target plus whatever extra targets
individual plugins register (e.g. the bar's `bar` target for refresh
hooks, the image picker's `image-selector` target). `omarchy-menu` uses the
shell target to summon the first-party `omarchy.menu` plugin instead of
running a separate Quickshell instance.

| Method                                   | Returns | Effect                                                |
|------------------------------------------|---------|-------------------------------------------------------|
| `ping`                                   | `ok`    | health check                                          |
| `summon <id> <payloadJson>`              | `ok` / `unknown` | load + open a panel/overlay plugin           |
| `hide <id>`                              | —       | close a previously-summoned plugin                    |
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/README.md; sed -n 1,80p plugins/bar/README.md`

✓ 76 ms

```text
[exit 0, 68 ms]
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

The key question is whether a third-party bar widget can host other bar widgets inside itself. I'll check how the bar loads widgets and what the registry facades expose.

**⏺ bash** `cd /usr/share/omarchy/shell; wc -l plugins/bar/Bar.qml plugins/bar/BarModel.js services/*.qml Ui/BarWidget.qml Ui/PluginBarApi.qml Ui/Panel.qml Ui/PanelController.qml Ui/PopupCard.qml; ls plugins/bar/widgets plugins/bar/indicators`

✓ 129 ms

```text
[exit 0, 123 ms]
  2076 plugins/bar/Bar.qml
   231 plugins/bar/BarModel.js
   268 services/AppLibrary.qml
    49 services/BarWidgetRegistry.qml
    46 services/PluginAppLibraryApi.qml
    12 services/PluginBarStateApi.qml
    24 services/PluginBarWidgetRegistryApi.qml
    46 services/PluginFirstPartyServiceApi.qml
   743 services/PluginRegistry.qml
    32 services/PluginRegistryApi.qml
    70 services/PluginShellApi.qml
    45 Ui/BarWidget.qml
    87 Ui/PluginBarApi.qml
    59 Ui/Panel.qml
    16 Ui/PanelController.qml
   176 Ui/PopupCard.qml
  3980 total
plugins/bar/indicators:
Dictation.qml
Dnd.qml
NightLight.qml
Reminder.qml
ScreenRecording.qml
StayAwake.qml

plugins/bar/widgets:
ActiveWindow.manifest.json
ActiveWindow.qml
Indicators.manifest.json
Indicators.qml
KeyboardLayout.manifest.json
KeyboardLayout.qml
KeyboardLayoutModel.js
Microphone.manifest.json
Microphone.qml
Spacer.manifest.json
Spacer.qml
SystemUpdate.manifest.json
SystemUpdate.qml
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat services/BarWidgetRegistry.qml services/PluginBarWidgetRegistryApi.qml services/PluginBarStateApi.qml services/PluginShellApi.qml services/PluginRegistryApi.qml Ui/BarWidget.qml Ui/PluginBarApi.qml`

✓ 75 ms

```text
[exit 0, 68 ms]
import QtQuick

// Instance, not a singleton — instantiated once by shell.qml and injected into
// plugins that need to read or extend the widget catalogue. Relative-path
// singleton imports were creating per-importer instances which prevented the
// shell host from seeing what the bar registered.
QtObject {
  id: registry

  // { widgetId: { component: Component, metadata: var } }
  property var widgets: ({})
  property int revision: 0

  signal changed()

  function register(id, component, metadata) {
    var key = String(id)
    if (!key) return
    var next = {}
    for (var k in widgets) next[k] = widgets[k]
    next[key] = { component: component, metadata: metadata || {} }
    widgets = next
    revision++
    changed()
  }

  function unregister(id) {
    var key = String(id)
    if (!widgets[key]) return
    var next = {}
    for (var k in widgets) if (k !== key) next[k] = widgets[k]
    widgets = next
    revision++
    changed()
  }

  function metadataFor(id) {
    var entry = widgets[String(id)]
    return entry ? entry.metadata : null
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n -i 'drawer\|group\|nested\|children\|items\b\|barWidgetRegistry\|registry\|firstParty\|isFirstParty\|PluginBarApi\|createObject\|Loader {' plugins/bar/Bar.qml | head -120`

✓ 94 ms

```text
[exit 0, 81 ms]
17:  property var barWidgetRegistry: fallbackBarWidgetRegistry
18:  // Read-only registry view for third-party full bars; the built-in bar does
20:  property var pluginRegistry: null
33:    id: fallbackBarWidgetRegistry
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
325:        pluginBarApis[id].destroy()
327:    pluginBarApis = ({})
573:  // The tray drawer reveals inward (away from the bar edge). Place it at the
575:  // sections. The drawer's reserved space then sits next to the bar center,
698:    var items = []
699:    if (!id) return items
703:      items.push(slot.activeItem)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1,120p plugins/bar/Bar.qml`

✓ 133 ms

```text
[exit 0, 69 ms]
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Ui
import "BarModel.js" as BarModel

Item {
  id: root

  // The omarchy-shell host injects omarchyPath from OMARCHY_PATH.
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  // Injected by the host shell so bar slots can resolve enabled widgets.
  property var barWidgetRegistry: fallbackBarWidgetRegistry
  // Read-only registry view for third-party full bars; the built-in bar does
  // not otherwise need it, but declaring it keeps clone construction atomic.
  property var pluginRegistry: null
  // Injected by the host shell every time shell.json is reloaded. Holds the
  // `bar:` subtree: position, centerAnchor, layout. The host owns file IO;
  // the bar just renders whatever it's handed. The bar font follows the
  // OS-level fontconfig monospace binding — it is not stored in shell.json.
  property var barConfig: ({})
  // Injected by the host shell. Used for shell-wide actions such as opening
  // settings and persisting inline widget state.
  property var shell: null
  // Manifest for the active bar option. Present for custom bars and useful for
  // diagnostics; the built-in bar does not otherwise need it.
  property var manifest: null
  QtObject {
    id: fallbackBarWidgetRegistry
    property var widgets: ({})
    property int revision: 0
    function metadataFor(id) { return null }
  }
  // Mirrors the on-disk `bar-off` flag so the user can hide the bar without
  // killing the entire shell. Hidden panels stay mapped but park off-screen
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1700,2076p plugins/bar/Bar.qml`

✓ 114 ms

```text
[exit 0, 103 ms]
    onClicked: function(mouse) {
      if (suppressClick) {
        suppressClick = false
        mouse.accepted = true
      }
    }

    onDoubleClicked: function(mouse) {
      if (suppressClick) {
        suppressClick = false
        return
      }
      if (mouse.button === Qt.LeftButton) {
        root.toggleTransparency()
        mouse.accepted = true
      }
    }
  }

  component ModuleList: Loader {
    id: moduleListRoot

    property var entries: []
    property string region: ""

    visible: entries.length > 0
    // A hidden list must not build its modules. The center section declares
    // both an anchored and an unanchored arrangement and shows whichever
    // fits, so leaving the other one loaded mounts every center module
    // twice — two IPC handlers registered for the same target, two clocks
    // ticking, two of every timer and fetch behind them.
    active: visible && entries.length > 0
    sourceComponent: root.vertical ? verticalModuleList : horizontalModuleList
    width: item ? item.implicitWidth : 0
    height: item ? item.implicitHeight : 0

    Component {
      id: horizontalModuleList

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; wc -l shell.qml; grep -n -i 'clone\|cloneSource\|fullBar\|kind.*bar\|"bar"\|barWidgetRegistryApi\|serviceless\|service-less\|firstPartyServiceFor\|barEntryShell' shell.qml | head -80`

✓ 75 ms

```text
[exit 0, 68 ms]
1744 shell.qml
189:  readonly property string activeBarSourceUrl: activeBarId === defaultBarId ? "" : shell.pluginRegistry.entryPointUrl(activeBarManifest, "bar")
202:      && manifest.kinds.indexOf("bar") !== -1
211:    return shell.isBarOptionManifest(manifest) && shell.pluginRegistry.entryPointUrl(manifest, "bar") !== ""
279:  property var _pluginBarEntryShellApis: ({})
281:  property var _pluginBarWidgetRegistryApis: ({})
297:    id: pluginBarWidgetRegistryApiComponent
298:    PluginBarWidgetRegistryApi { }
355:    return shell.manifestHasKind(manifest, "bar")
358:  function pluginIsIndicatorsClone(manifest) {
360:    return shell.manifestHasKind(manifest, "bar-widget")
361:      && !!metadata && String(metadata.clonedFrom || "") === "omarchy.indicators"
366:    if (!metadata || String(metadata.clonedFrom || "") !== "omarchy.idle") return ({})
372:  function pluginCloneMaySummon(manifest, requestedId) {
374:    var sourceId = metadata ? String(metadata.clonedFrom || "") : ""
398:    return location && location.kind === "bar"
407:    var uiKinds = ["bar-widget", "panel", "overlay", "menu"]
458:  function pluginFirstPartyServiceFor(cacheKey, pluginId, requestedId) {
527:      barCapabilities ? "bar" : "no-bar",
528:      allowOwnService && shell.pluginIsIndicatorsClone(manifest) ? "indicators" : "no-indicators",
564:    _pluginBarEntryShellApis = shell.cacheWithoutPrefix(_pluginBarEntryShellApis, key + ":")
588:    // firstPartyServiceFor(). Creating a QObject while evaluating that binding
594:      : (allowOwnService && shell.pluginIsIndicatorsClone(manifest)
598:      firstPartyServices[serviceId] = shell.pluginFirstPartyServiceFor(cacheKey, key, serviceId)
614:        // Indicators clones have no service of their own. Under the trusted
617:        var indicatorsAllowed = allowOwnService && shell.pluginIsIndicatorsClone(currentManifest())
623:      _barEntryShellLookup: function(ownerId, moduleName) {
630:            && !shell.pluginCloneMaySummon(currentManifest(), requestedId)) return false
694:    if (_pluginBarEntryShellApis[cacheKey]) return _pluginBarEntryShellApis[cacheKey]
711:            && !shell.pluginCloneMaySummon(currentManifest(), requestedId)) return false
733:    for (var id in _pluginBarEntryShellApis) next[id] = _pluginBarEntryShellApis[id]
735:    _pluginBarEntryShellApis = next
774:    if (_pluginBarWidgetRegistryApis[key]) return _pluginBarWidgetRegistryApis[key]
776:    var api = pluginBarWidgetRegistryApiComponent.createObject(null, {
783:    for (var id in _pluginBarWidgetRegistryApis) next[id] = _pluginBarWidgetRegistryApis[id]
785:    _pluginBarWidgetRegistryApis = next
821:    for (var widgetKey in _pluginBarWidgetRegistryApis) {
822:      var widgetApi = _pluginBarWidgetRegistryApis[widgetKey]
826:    _pluginBarWidgetRegistryApis = widgetNext
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 180,300p shell.qml; sed -n 340,460p shell.qml`

✓ 78 ms

```text
[exit 0, 71 ms]
  readonly property bool selectedBarAvailable: {
    var revision = shell.pluginRegistry.registryRevision
    return shell.barOptionAvailable(shell.selectedBarId)
  }
  readonly property string activeBarId: selectedBarId !== failedBarId && selectedBarAvailable ? selectedBarId : defaultBarId
  readonly property var activeBarManifest: {
    var revision = shell.pluginRegistry.registryRevision
    return shell.barManifestFor(shell.activeBarId)
  }
  readonly property string activeBarSourceUrl: activeBarId === defaultBarId ? "" : shell.pluginRegistry.entryPointUrl(activeBarManifest, "bar")
  property var bar: null

  onSelectedBarIdChanged: if (failedBarId !== "") failedBarId = ""

  function barManifestFor(pluginId) {
    var plugins = shell.pluginRegistry ? shell.pluginRegistry.installedPlugins : null
    return plugins ? plugins[String(pluginId || "")] || null : null
  }

  function isBarOptionManifest(manifest) {
    return manifest
      && Array.isArray(manifest.kinds)
      && manifest.kinds.indexOf("bar") !== -1
      && manifest.entryPoints
      && manifest.entryPoints.bar
  }

  function barOptionAvailable(pluginId) {
    var id = String(pluginId || "")
    if (id === "" || id === shell.defaultBarId) return true
    var manifest = shell.barManifestFor(id)
    return shell.isBarOptionManifest(manifest) && shell.pluginRegistry.entryPointUrl(manifest, "bar") !== ""
  }

  function isActiveBarOption(pluginId) {
    return String(pluginId || "") === shell.activeBarId
  }

  function configureBar(target, manifest) {
…
```

**⏺ bash** `cd /usr/share/omarchy; ls bin | grep -i plugin; sed -n 300,340p shell/shell.qml; grep -n 'firstParty' shell/shell.qml shell/services/PluginRegistry.qml | head -30`

✓ 101 ms

```text
[exit 0, 92 ms]
omarchy-menu-plugin
omarchy-plugin-add
omarchy-plugin-catalog
omarchy-plugin-clone
omarchy-plugin-disable
omarchy-plugin-enable
omarchy-plugin-list
omarchy-plugin-remove
omarchy-plugin-update
omarchy-plugin-validate

  Component {
    id: pluginAppLibraryApiComponent
    PluginAppLibraryApi { }
  }

  Component {
    id: pluginBarStateApiComponent
    PluginBarStateApi { }
  }

  Component {
    id: pluginFirstPartyServiceApiComponent
    PluginFirstPartyServiceApi { }
  }

  function publicPluginManifest(manifest) {
    if (!manifest) return null
    if (manifest.__isFirstParty) return manifest
    var copy = JSON.parse(JSON.stringify(manifest))
    delete copy.__sourceDir
    delete copy.__isFirstParty
    delete copy.__hostCapabilities
    return copy
  }

  function publicBarConfig() {
    return JSON.parse(JSON.stringify(shell.barConfig || {}))
  }
…
```

**⏺ bash** `cd /usr/share/omarchy; cat bin/omarchy-plugin-clone | head -150; sed -n 330,345p shell/shell.qml; sed -n 1371,1420p shell/shell.qml`

✓ 55 ms

```text
[exit 0, 49 ms]
#!/bin/bash

# omarchy:summary=Clone a built-in Omarchy shell plugin into your own config
# omarchy:group=plugin
# omarchy:args=<source-id> [--edit]

set -euo pipefail

PLUGINS_DIR="$HOME/.config/omarchy/plugins"

fail() {
  echo "omarchy-plugin-clone: $*" >&2
  exit 1
}

copy_plugin() {
  local source_dir="$1"
  local manifest="$2"
  local target_dir="$3"

  if [[ ${manifest##*/} == "manifest.json" ]]; then
    cp -aL "$source_dir/." "$target_dir/"
    return
  fi

  cp -aL "$manifest" "$target_dir/manifest.json"

  local source target source_pattern file
  while IFS=$'\t' read -r source target; do
    [[ $target != /* && $target != *".."* ]] || fail "invalid clone target path: $target"
    if [[ -d $source_dir/$source ]]; then
      mkdir -p "$target_dir/$target"
      cp -aL "$source_dir/$source/." "$target_dir/$target/"
    else
      mkdir -p "$(dirname "$target_dir/$target")"
      cp -aL "$source_dir/$source" "$target_dir/$target"
    fi

    if [[ $source != "$target" ]]; then
…
```

Cloning works and keeps every kind. Before choosing between a full clone and something lighter, I need to know how built-in widgets get their services when a non-built-in bar hosts them.

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn 'bar\.shell\|root\.shell\|shell\.\(serviceFor\|firstPartyServiceFor\|pluginShellForBarEntry\|summon\|toggle\)' plugins --include=*.qml | grep -v '^plugins/bar/Bar.qml' | head -40`

✓ 273 ms

```text
[exit 0, 256 ms]
plugins/bar/widgets/Tray.qml:184:    if (!root.bar || !root.bar.shell || typeof root.bar.shell.updateEntryInline !== "function") return
plugins/bar/widgets/Tray.qml:186:    root.bar.shell.updateEntryInline(id, { id: id, pinned: pinned, hidden: hidden })
plugins/dev-gallery/GalleryPanel.qml:286:      if (!visible && !root.closingFromHost && root.shell && typeof root.shell.hide === "function")
plugins/dev-gallery/GalleryPanel.qml:287:        root.shell.hide("omarchy.dev-gallery")
plugins/emojis/Emojis.qml:60:    if (root.shell && typeof root.shell.hide === "function")
plugins/emojis/Emojis.qml:61:      root.shell.hide((root.manifest && root.manifest.id) || "omarchy.emojis")
plugins/image-picker/ImagePicker.qml:303:  // Lifecycle hooks invoked by omarchy-shell summon/hide. shell.summon(id,
plugins/menu/Menu.qml:80:  readonly property var appLibrary: root.shell ? root.shell.appLibrary : null
plugins/panels/audio/Panel.qml:434:    if (!bar || !bar.shell) return
plugins/panels/audio/Panel.qml:435:    bar.shell.summon("omarchy.osd", JSON.stringify({
plugins/panels/clock/BarWidget.qml:51:    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
plugins/panels/clock/BarWidget.qml:52:      root.bar.shell.updateEntryInline(root.moduleName, entry)
plugins/panels/clock/BarWidget.qml:59:  // ---- Calendar popup. Shape contract for shell.summon/hide/toggle
plugins/panels/clock/Panel.qml:161:    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
plugins/panels/clock/Panel.qml:162:      root.bar.shell.updateEntryInline(root.moduleName, entry)
plugins/panels/monitor/Panel.qml:257:    if (!bar || !bar.shell) return
plugins/panels/monitor/Panel.qml:258:    bar.shell.summon("omarchy.osd", JSON.stringify({
plugins/panels/network/Panel.qml:468:    bar.shell.summon("omarchy.wifiqr", JSON.stringify(payload))
plugins/panels/network/Panel.qml:658:    bar.shell.summon("omarchy.speedtest", connection ? JSON.stringify({ connection: connection }) : "{}")
plugins/panels/power/Panel.qml:174:    if (root.bar && root.bar.shell) root.bar.shell.updateEntryInline(root.moduleName, root.settings)
plugins/panels/speedtest/Panel.qml:65:    if (root.shell && typeof root.shell.hide === "function")
plugins/panels/speedtest/Panel.qml:66:      root.shell.hide((root.manifest && root.manifest.id) || "omarchy.speedtest")
plugins/panels/tailscale/Panel.qml:155:    if (!root.bar || !root.bar.shell || typeof root.bar.shell.updateEntryInline !== "function") return
plugins/panels/tailscale/Panel.qml:159:    root.bar.shell.updateEntryInline(root.moduleName, entry)
plugins/panels/weather/BarWidget.qml:26:  // Shape contract for shell.summon/hide/toggle routing (Bar.findPanelWidget
plugins/panels/wifiqr/Panel.qml:91:    if (root.shell && typeof root.shell.hide === "function")
plugins/panels/wifiqr/Panel.qml:92:      root.shell.hide((root.manifest && root.manifest.id) || "omarchy.wifiqr")
plugins/reminders/ReminderFlow.qml:52:    if (root.shell && typeof root.shell.hide === "function")
plugins/reminders/ReminderFlow.qml:53:      root.shell.hide((root.manifest && root.manifest.id) || "omarchy.reminders")
plugins/services/media/Service.qml:248:    shell.summon("omarchy.osd", JSON.stringify({
```

Built-in widgets only touch `bar.shell` for `summon` and `updateEntryInline`. I'll check what the full-bar facade allows for those two calls.

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 505,770p shell.qml`

✓ 85 ms

```text
[exit 0, 73 ms]
    api.doNotDisturb = Qt.binding(function() {
      var target = service()
      return target ? target.doNotDisturb === true : false
    })
    api.activePlayer = Qt.binding(function() {
      var target = service()
      return target ? target.activePlayer : null
    })
    api.sourcePlayers = Qt.binding(function() {
      var target = service()
      return target && Array.isArray(target.sourcePlayers) ? target.sourcePlayers : []
    })
    var next = ({})
    for (var existing in _pluginFirstPartyServiceApis) next[existing] = _pluginFirstPartyServiceApis[existing]
    next[proxyKey] = api
    _pluginFirstPartyServiceApis = next
    return api
  }

  function pluginShellCapabilityProfile(manifest, allowOwnService, barCapabilities) {
    return [
      allowOwnService ? "own-service" : "no-own-service",
      barCapabilities ? "bar" : "no-bar",
      allowOwnService && shell.pluginIsIndicatorsClone(manifest) ? "indicators" : "no-indicators",
      shell.manifestHasKind(manifest, "menu") ? "menu" : "no-menu"
    ].join("|")
  }

  function cacheWithoutKey(cache, key, destroyValue) {
    var next = ({})
    for (var existing in cache) {
      if (existing === key) {
        var value = cache[existing]
        if (destroyValue && value && typeof value.destroy === "function") value.destroy()
      } else {
        next[existing] = cache[existing]
      }
    }
    return next
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n 'function ' services/PluginRegistry.qml | head -60`

✓ 72 ms

```text
[exit 0, 67 ms]
18:  // effective shell config; shellConfigMutator takes a function that receives
36:  function isSafeEntryPoint(value) {
43:  function validateManifest(manifest, sourcePath) {
92:  function trustedCapabilities(manifest) {
104:  function stampHostCapabilities(firstParty, thirdParty) {
118:  function entryPointUrl(manifest, kind) {
148:  function isEnabled(id) {
166:  function isDisabled(config, id) {
171:  function resolveEnabledId(id) {
189:  function inBar(id) {
194:  function defaultBarWidgetSection(manifest) {
200:  function barEntryId(entry) {
204:  function findBarLocation(config, id, section) {
223:  function findRelativeBarLocation(config, id, section) {
231:  function findEntryLocation(config, id) {
250:  function barTarget(config, placement, fallbackSection) {
278:  function moveBarEntry(config, id, placement) {
307:  function moveBarWidget(id, placement) {
321:  function putBarWidget(id, placement) {
342:  function setBarWidget(id, key, value, selector) {
387:  function ensureConfigShape(config) {
402:  function removeDisabled(config, id) {
408:  function addDisabled(config, id) {
414:  function cloneShouldRestoreSource(config, id) {
418:  function setCloneShouldRestoreSource(config, id, value) {
426:  function activeCloneFor(config, sourceId) {
441:  function restoreCloneSource(config, cloneId, sourceId) {
474:  function setEnabled(id, value, placement) {
576:  function parseScanOutput(text) {
584:    function flush() {
689:  function rescan() {
723:  function ensureUserDir() {
728:  function localPluginIdForPath(filePath) {
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 140,250p services/PluginRegistry.qml; sed -n 385,400p services/PluginRegistry.qml`

✓ 76 ms

```text
[exit 0, 68 ms]
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
    // manifest is the implementation that should receive the call.
    for (var candidate in installedPlugins) {
      var manifest = installedPlugins[candidate]
      var metadata = manifest && Util.isPlainObject(manifest.omarchy) ? manifest.omarchy : null
      if (metadata && String(metadata.clonedFrom || "") === key && isEnabled(candidate))
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/bar; cat manifest.json; grep -n 'root\.shell\b\|root\.shell\.' Bar.qml | head -40`

✓ 71 ms

```text
[exit 0, 67 ms]
{
  "schemaVersion": 1,
  "id": "omarchy.bar",
  "name": "Bar",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Status bar with widgets",
  "kinds": [
    "bar"
  ],
  "entryPoints": {
    "bar": "Bar.qml"
  }
}
234:    if (registered && root.shell && typeof root.shell.pluginShellForId === "function") {
237:      pluginShell = root.shell.pluginShellForId(moduleName)
238:    } else if (root.shell && typeof root.shell.pluginShellForBarEntry === "function") {
242:      pluginShell = root.shell.pluginShellForBarEntry(key, moduleName)
519:    if (root.shell && typeof root.shell.mutateShellConfig === "function") {
520:      root.shell.mutateShellConfig(function(config) {
849:    if (root.shell && typeof root.shell.mutateShellConfig === "function") {
850:      root.shell.mutateShellConfig(function(config) {
904:    if (!root.shell || typeof root.shell.mutateShellConfig !== "function") return false
907:    root.shell.mutateShellConfig(function(config) {
1909:      readonly property bool canReorder: root.shell && typeof root.shell.mutateShellConfig === "function"
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/bar; sed -n 120,330p Bar.qml`

✓ 224 ms

```text
[exit 0, 216 ms]
  function publicLayoutConfig() {
    return JSON.parse(JSON.stringify(root.layoutConfig || {}))
  }

  function bindPluginBarApi(api) {
    if (!api) return
    api.foreground = Qt.binding(function() { return root.foreground })
    api.barForeground = Qt.binding(function() { return root.barForeground })
    api.background = Qt.binding(function() { return root.background })
    api.urgent = Qt.binding(function() { return root.urgent })
    api.fontFamily = Qt.binding(function() { return root.fontFamily })
    api.position = Qt.binding(function() { return root.position })
    api.vertical = Qt.binding(function() { return root.vertical })
    api.barSize = Qt.binding(function() { return root.barSize })
    api.transparent = Qt.binding(function() { return root.transparent })
    api.foregroundAnimationEnabled = Qt.binding(function() { return root.foregroundAnimationEnabled })
    api.centerSectionRevealHeld = Qt.binding(function() { return root.centerSectionRevealHeld })
    api._centerHoverRevealSuppressed = Qt.binding(function() { return root.centerHoverRevealSuppressed })
    root.syncPluginBarApiObjects(api)
  }

  function syncPluginBarApiObjects(api) {
    if (!api) return
    api.activePopout = root.pluginOwnsBarObject(api.pluginId, root.activePopout)
      ? root.activePopout : (root.activePopout ? api.foreignPopoutMarker : null)
    api.clickTargets = root.pluginClickTargets(api.pluginId)
    api.layoutConfig = root.publicLayoutConfig()
  }

  function pluginObjectRecord(target) {
    for (var i = 0; i < pluginObjectOwners.length; i++) {
      var record = pluginObjectOwners[i]
      if (record && record.target === target) return record
    }
    return null
  }

  function markPluginObject(pluginId, target, role) {
    var key = String(pluginId || "")
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/bar; sed -n 330,700p Bar.qml`

✓ 232 ms

```text
[exit 0, 214 ms]
  function registerClickTarget(target) {
    if (!target || clickTargets.indexOf(target) !== -1) return
    var next = clickTargets.slice()
    next.push(target)
    clickTargets = next
  }

  function unregisterClickTarget(target) {
    var next = clickTargets.filter(function(item) { return item !== target })
    clickTargets = next
  }

  function registerModuleSlot(slot) {
    if (!slot || moduleSlots.indexOf(slot) !== -1) return
    var next = moduleSlots.slice()
    next.push(slot)
    moduleSlots = next
  }

  function unregisterModuleSlot(slot) {
    var next = moduleSlots.filter(function(item) { return item !== slot })
    moduleSlots = next
  }

  function debugBarGeometry() {
    var out = []
    for (var i = 0; i < moduleSlots.length; i++) {
      var slot = moduleSlots[i]
      if (!slot || !slot.activeItem) continue
      var point = { x: slot.x, y: slot.y }
      try {
        point = slot.mapToItem(null, 0, 0)
      } catch (e) {
      }
      out.push({
        id: slot.moduleName,
        section: slot.region,
        x: Math.round(point.x),
        y: Math.round(point.y),
…
```

Next I'll look at how widget popups anchor themselves. That decides whether a widget's own popup still works when the widget is inside the drawer panel.

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/PopupCard.qml Ui/Panel.qml Ui/PanelController.qml`

✓ 103 ms

```text
[exit 0, 90 ms]
import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons

PopupWindow {
  id: root

  required property Item anchorItem
  required property QtObject bar
  property var owner: null
  property int margin: Style.gapsOut
  property int padding: Style.spacing.popupPadding
  property int contentWidth: Style.space(280)
  property int contentHeight: Style.space(200)
  property color borderColor: Color.popups.border
  property var borderSpec: Border.localOrSurfaceSpec("popups", "border", borderColor, Color.popups.border, Math.max(1, Style.space(2)))
  property bool open: false
  property bool centerOnBar: false
  // "click" — uses HyprlandFocusGrab so clicking outside dismisses the popup.
  // "hover" — passive overlay; the owning widget controls open via hover.
  property string triggerMode: "click"

  readonly property var coordinatorKey: owner || root
  readonly property var anchorWindow: anchorItem ? anchorItem.QsWindow.window : null
  readonly property var popupScreen: anchorWindow ? anchorWindow.screen : null
  readonly property bool containsMouse: cardHover.hovered
  readonly property real screenW: popupScreen ? popupScreen.width : 0
  readonly property real screenH: popupScreen ? popupScreen.height : 0
  readonly property real barW: anchorWindow ? anchorWindow.width : 0
  readonly property real barH: anchorWindow ? anchorWindow.height : 0
  readonly property real availableCardWidth: screenW > 0
    ? Math.max(120, screenW - ((bar && (bar.position === "left" || bar.position === "right")) ? barW : 0) - root.margin * 2)
    : 0
  readonly property real availableCardHeight: screenH > 0
    ? Math.max(120, screenH - ((bar && (bar.position === "top" || bar.position === "bottom")) ? barH : 0) - root.margin * 2)
    : 0
  readonly property real verticalContentInset: padding * 2 + Border.top(borderSpec) + Border.bottom(borderSpec)

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/panels/weather/BarWidget.qml | head -150`

✓ 127 ms

```text
[exit 0, 92 ms]
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
  }

  function togglePanel() {
    if (panelLoader.item && panelLoader.item.toggle) panelLoader.item.toggle()
  }

  // Shape contract for shell.summon/hide/toggle routing (Bar.findPanelWidget
  // requires open/close/opened on the bar-widget root). Open maps to the
  // panel's hotkey path so summoning suppresses the center hover reveal,
  // matching what the old per-plugin IpcHandler did.
  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item && panelLoader.item.openFromHotkey) panelLoader.item.openFromHotkey()
  }

  function close() {
    if (panelLoader.item && panelLoader.item.close) panelLoader.item.close()
  }

…
```

**⏺ bash** `which quickshell qs qmllint qmllint6 qml6 qml jq 2>&1; ls /usr/lib/qt6/bin 2>/dev/null | head -30; echo WAYLAND=$WAYLAND_DISPLAY XDG=$XDG_RUNTIME_DIR; quickshell --version 2>&1 | head -2`

✓ 578 ms

```text
[exit 0, 571 ms]
which: no qmllint6 in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
which: no qml in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
/usr/bin/quickshell
/usr/bin/qs
~/.local/bin/qmllint
/usr/bin/qml6
/usr/bin/jq
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
qmlcontextpropertydump
qmldom
qmleasing
qmlformat
qmllint
qmlls
qmlplugindump
qmlpreview
qmlprofiler
qmlscene
qmltc
qmltestrunner
qmltime
qsb
qt-cmake
qt-cmake-create
qt-configure-module
qtpaths
qtpaths6
svgtoqml
WAYLAND= XDG=
Quickshell 0.3.1 (revision , distributed by Arch Linux)
```

There's no Wayland display, so I can't run the live shell. I do have `qmllint`, `qml6`, and the plugin validator. Next I'll read the manifest rules and the validator.

**⏺ bash** `cd /usr/share/omarchy; sed -n 30,135p shell/services/PluginRegistry.qml; cat bin/omarchy-plugin-validate | head -80`

✓ 112 ms

```text
[exit 0, 98 ms]
  signal scanFinished()
  signal pluginLoadFailed(string id, string error)
  signal localPluginChanged(string id)

  // ---------------------------------------------------------------- helpers

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
…
```

The manifest rules are clear. Next I'll confirm that a replacement bar's injected `barConfig` and widget-registry snapshot stay live when shell.json or plugins change.

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 770,900p shell.qml; grep -n 'shell.bar\b\|shell\.bar\.' shell.qml | head -40`

✓ 100 ms

```text
[exit 0, 93 ms]
  function pluginBarWidgetRegistryFor(manifest) {
    if (!manifest || manifest.__isFirstParty) return shell.barWidgetRegistry
    var key = String(manifest.id || "")
    if (!key) return null
    if (_pluginBarWidgetRegistryApis[key]) return _pluginBarWidgetRegistryApis[key]

    var api = pluginBarWidgetRegistryApiComponent.createObject(null, {
      widgets: shell.publicBarWidgetSnapshot(),
      revision: shell.barWidgetRegistry.revision
    })
    if (!api) return null

    var next = ({})
    for (var id in _pluginBarWidgetRegistryApis) next[id] = _pluginBarWidgetRegistryApis[id]
    next[key] = api
    _pluginBarWidgetRegistryApis = next
    return api
  }

  function pluginApiActive(api, plugins) {
    var id = api ? String(api.pluginId || api.ownerPluginId || "") : ""
    var manifest = id ? plugins[id] : null
    return !!manifest && shell.pluginRegistry.isEnabled(id)
  }

  function prunePluginApis() {
    var plugins = shell.pluginRegistry.installedPlugins
    var shellKeys = Object.keys(_pluginShellApis)
    for (var si = 0; si < shellKeys.length; si++) {
      var shellKey = shellKeys[si]
      var shellApi = _pluginShellApis[shellKey]
      var descriptor = _pluginShellApiDescriptors[shellKey]
      var manifest = descriptor ? plugins[descriptor.pluginId] : null
      var barCapabilities = descriptor && descriptor.allowOwnService
        && shell.pluginHasBarCapabilities(manifest)
      var expectedProfile = descriptor
        ? shell.pluginShellCapabilityProfile(manifest, descriptor.allowOwnService, barCapabilities) : ""
      var active = descriptor && manifest && shell.pluginRegistry.isEnabled(descriptor.pluginId)
      if (!active || descriptor.profile !== expectedProfile)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n 'barConfig\b\|syncPluginApis()' shell.qml | head -40; grep -n 'summonBarWidget\|hideBarWidget\|isBarWidgetOpen\|function findPanelWidget\|function pickPanelSlot' plugins/bar/Bar.qml`

✓ 98 ms

```text
[exit 0, 92 ms]
116:  readonly property var barConfig: shellConfig && Util.isPlainObject(shellConfig.bar) ? shellConfig.bar : builtinShellConfig.bar
118:    if (bar && "barConfig" in bar)
119:      bar.barConfig = shell.barConfigFor(shell.activeBarManifest)
172:    var config = shell.barConfig
225:    if ("barConfig" in target) target.barConfig = shell.barConfigFor(manifest)
235:      barConfig: shell.barConfig
327:    return JSON.parse(JSON.stringify(shell.barConfig || {}))
332:      ? shell.barConfig : shell.publicBarConfig()
606:      barConfig: shell.publicBarConfig(),
708:      barConfig: shell.publicBarConfig(),
861:  function syncPluginApis() {
879:      shellApi.barConfig = shell.publicBarConfig()
883:      _pluginBarEntryShellApis[entryKey].barConfig = shell.publicBarConfig()
1055:      shell.syncPluginApis()
1062:    function onChanged() { shell.syncPluginApis() }
726:  function findPanelWidget(pluginId) {
744:  function summonBarWidget(pluginId) {
751:  function hideBarWidget(pluginId) {
758:  function isBarWidgetOpen(pluginId) {
```

Hotkeys and IPC (e.g. `omarchy-shell shell toggle omarchy.audio`) find widgets through Bar.qml's slot list. I'll read that lookup to see how tucked widgets should take part.

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 696,800p plugins/bar/Bar.qml; sed -n 1160,1220p shell.qml`

✓ 90 ms

```text
[exit 0, 74 ms]
  function moduleWidgets(pluginId) {
    var id = String(pluginId || "")
    var items = []
    if (!id) return items
    for (var i = 0; i < moduleSlots.length; i++) {
      var slot = moduleSlots[i]
      if (!slot || !slot.activeItem || slot.moduleName !== id) continue
      items.push(slot.activeItem)
    }
    return items
  }

  function slotScreenName(slot) {
    var window = slotWindow(slot)
    return window && window.screen ? String(window.screen.name || "") : ""
  }

  // The output Hyprland has focused, which is where a keyboard-summoned panel
  // belongs. Empty until Hyprland reports one, which leaves panel routing on
  // its per-monitor fallback rather than guessing at an output.
  function focusedScreenName() {
    var monitor = Hyprland.focusedMonitor
    return monitor ? String(monitor.name || "") : ""
  }

  // Resolve the live bar-widget instance for a plugin id (e.g. "omarchy.bluetooth").
  // Only widgets that expose popup open/close methods count; plain indicators
  // (clock, workspaces, tray) return null. Used by shell.summon/toggle so
  // panel hotkeys route through the bar instead of a per-target IPC handler
  // that only reaches whichever per-monitor instance claimed the target.
  function findPanelWidget(pluginId) {
    var id = String(pluginId || "")
    if (!id) return null
    var candidates = []
    for (var i = 0; i < moduleSlots.length; i++) {
      var slot = moduleSlots[i]
      if (!slot || !slot.activeItem) continue
      if (slot.moduleName !== id) continue
      var item = slot.activeItem
…
```

`shell.bar` will point at my wrapper, so the wrapper has to forward everything the host reads from or calls on the bar. I'll list every use of it across the shell.

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rnoh 'shell\.bar\.[A-Za-z_]*\|shell\.bar && [^)]*' --include=*.qml . | sort | uniq -c | sort -rn | head -40; grep -rn 'shell\.bar\b' --include=*.qml plugins services Ui | grep -v 'root.shell.bar\b' | head -20`

✓ 172 ms

```text
[exit 0, 162 ms]
      1 51:shell.bar && !shell.bar.barHidden ? Math.max(0, shell.bar.barSize
      1 450:shell.bar.position
      1 449:shell.bar.fontFamily
      1 448:shell.bar.barSize
      1 447:shell.bar.barHidden
      1 1733:shell.bar.panelWidgetIdAt
      1 1732:shell.bar && typeof shell.bar.panelWidgetIdAt === "function"
      1 1712:shell.bar && shell.bar.debugBarGeometry ? shell.bar.debugBarGeometry(
      1 1614:shell.bar.toggleTransparency
      1 1613:shell.bar && typeof shell.bar.toggleTransparency === "function"
      1 1213:shell.bar.isBarWidgetOpen
      1 1212:shell.bar && typeof shell.bar.isBarWidgetOpen === "function"
      1 1197:shell.bar.hideBarWidget
      1 1196:shell.bar && typeof shell.bar.hideBarWidget === "function"
      1 1170:shell.bar.summonBarWidget
      1 1169:shell.bar && typeof shell.bar.summonBarWidget === "function"
      1 1052:shell.bar.fontFamily
plugins/notifications/Service.qml:47:  // shell.bar isn't reachable so the popup never lands on top of the bar.
plugins/notifications/Service.qml:51:  readonly property int liveBarSize: shell && shell.bar && !shell.bar.barHidden ? Math.max(0, shell.bar.barSize) : defaultBarSize
plugins/notifications/Service.qml:1052:              fontFamily: service.shell && service.shell.bar ? service.shell.bar.fontFamily : ""
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 20,40p shell.qml; grep -n 'Variants\|PanelWindow\|WlrLayershell\|component \|screen:' plugins/bar/Bar.qml | head -40`

✓ 53 ms

```text
[exit 0, 47 ms]
  property BarWidgetRegistry barWidgetRegistry: BarWidgetRegistry { }
  property AppLibrary appLibrary: AppLibrary { }

  property string home: Quickshell.env("HOME")

  // The omarchy-shell host is the long-running entry point. Plugins live in
  // sibling directories under plugins/. OMARCHY_PATH is provided by the uwsm
  // session environment and is the single source of truth for this checkout.
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  readonly property string shellPath: omarchyPath + "/shell"
  readonly property string firstPartyPluginsDir: shellPath + "/plugins"
  readonly property string defaultsPath: omarchyPath + "/config/omarchy/shell.json"
  readonly property string userConfigPath: home + "/.config/omarchy/shell.json"

  // Bundled fallback so the shell can start even when the default shell.json is
  // missing or unreadable. The bar config here mirrors the on-disk defaults
  // closely enough to render a usable bar; not authoritative.
  readonly property var builtinShellConfig: ({
    version: 1,
    idle: {
      screensaver: 150,
1196:  Variants {
1203:        screen: modelData
1208:  Variants {
1215:        screen: modelData
1221:  Variants {
1228:        screen: modelData
1234:  component BarPanel: PanelWindow {
1268:    WlrLayershell.namespace: "omarchy-bar"
1269:    WlrLayershell.layer: WlrLayer.Top
1397:  component DragGhostPanel: PanelWindow {
1412:    WlrLayershell.namespace: "omarchy-bar-drag-ghost"
1413:    WlrLayershell.layer: WlrLayer.Overlay
1414:    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
1465:  component BarMoveGhostPanel: PanelWindow {
1474:    WlrLayershell.namespace: "omarchy-bar-move-ghost"
1475:    WlrLayershell.layer: WlrLayer.Overlay
1476:    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
1524:  component LeftModules: ModuleList {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 800,960p plugins/bar/Bar.qml`

✓ 86 ms

```text
[exit 0, 77 ms]
    return BarModel.customModuleType(entry)
  }

  function customModuleSource(entry) {
    var source = BarModel.customModulePath(entry, home, omarchyConfigDir)
    return source ? Util.fileUrl(source) : ""
  }

  Component.onCompleted: applyBarConfig()

  // Revealing the indicators widens their section, which can slide a neighbour
  // under a stationary pointer. Collapsing on that un-hover would move it back
  // out and re-open the peek, so hold until the pointer leaves the bar.
  function setCenterSectionHovered(hovered) {
    centerSectionHovered = hovered
    if (hovered) {
      centerSectionRevealTimer.stop()
      centerSectionRevealHeld = true
    } else {
      centerSectionRevealTimer.restart()
    }
  }

  function setBarHovered(hovered) {
    barHoverCount = Math.max(0, barHoverCount + (hovered ? 1 : -1))
    if (barHoverCount === 0) centerSectionRevealTimer.restart()
  }

  function setCenterHoverRevealSuppressed(value) {
    centerHoverRevealSuppressed = !!value
  }

  Timer {
    id: centerSectionRevealTimer
    interval: 120
    // Collapse only. Opening the peek is the center section's own gesture, done
    // in setCenterSectionHovered, so a timer left pending by a pointer that dipped
    // off the bar and came back cannot reveal indicators it never pointed at.
    onTriggered: if (!root.centerSectionHovered && !root.barHovered) root.centerSectionRevealHeld = false
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n 'moduleSlots\[' plugins/bar/Bar.qml; grep -rn 'broadcast(' --include=*.qml plugins | head; grep -n 'function dropBarModuleAtTarget' -A25 plugins/bar/Bar.qml | head -40`

✓ 74 ms

```text
[exit 0, 69 ms]
283:      var slot = moduleSlots[i]
357:      var slot = moduleSlots[i]
608:        var slot = moduleSlots[s]
633:        var slot = moduleSlots[j]
666:      var slot = moduleSlots[i]
701:      var slot = moduleSlots[i]
731:      var slot = moduleSlots[i]
924:      var slot = moduleSlots[i]
949:      var slot = moduleSlots[i]
plugins/bar/widgets/Indicators.qml:172:      root.broadcast("refresh")
plugins/bar/widgets/SystemUpdate.qml:31:      root.broadcast("refresh")
plugins/bar/widgets/SystemUpdate.qml:35:      root.broadcast("clear")
plugins/panels/clock/BarWidget.qml:132:    function refresh(): void { root.broadcast("refresh") }
975:  function dropBarModuleAtTarget(sourceSlot, targetSlot, afterTarget) {
976-    if (!sourceSlot || !targetSlot) return false
977-
978-    var beforeName = afterTarget ? nextVisibleModuleName(targetSlot.region, targetSlot.moduleName, sourceSlot) : targetSlot.moduleName
979-    return dropBarModule(sourceSlot, targetSlot.region, beforeName)
980-  }
981-
982-  function moduleTargetClickable(target) {
983-    return target
984-      && target.visible !== false
985-      && target.opacity !== 0
986-      && target.interactive !== false
987-      && target.pressable !== false
988-      && target.concealed !== true
989-      && typeof target.triggerPress === "function"
990-  }
991-
992-  function moduleClickTargetAt(slot, localX, localY) {
993-    for (var i = clickTargets.length - 1; i >= 0; i--) {
994-      var target = clickTargets[i]
995-      if (!moduleTargetClickable(target)) continue
996-
997-      var targetPoint = { x: localX, y: localY }
998-      try {
999-        targetPoint = slot.mapToItem(target, localX, localY)
1000-      } catch (e) {
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1000,1060p plugins/bar/Bar.qml; grep -n 'registerClickTarget\|MouseArea\|TapHandler\|triggerPress\|acceptedButtons' Ui/WidgetButton.qml Ui/BarIconButton.qml | head -20`

✓ 138 ms

```text
[exit 0, 122 ms]
      } catch (e) {
        continue
      }

      if (targetPoint.x >= 0 && targetPoint.x <= target.width &&
          targetPoint.y >= 0 && targetPoint.y <= target.height) {
        return target
      }
    }

    if (moduleTargetClickable(slot.activeItem)) return slot.activeItem
    return null
  }

  function pressModuleClickTarget(slot, button, localX, localY) {
    var target = moduleClickTargetAt(slot, localX, localY)
    if (!target) return false

    target.triggerPress(button)
    return true
  }

  function colorHex(colorValue) {
    var c = colorValue
    if (typeof c === "string") c = Qt.color(c)
    function hexChannel(value) {
      var s = Math.round(Util.clamp(value, 0, 1) * 255).toString(16)
      return s.length < 2 ? "0" + s : s
    }
    return "#" + hexChannel(c.r) + hexChannel(c.g) + hexChannel(c.b)
  }

  function setRequestedTransparency(value) {
    var nextTransparent = value === true
    requestedTransparent = nextTransparent
    if (!nextTransparent) {
      foregroundAnimationEnabled = false
      useTransparentForeground = false
      transparent = false
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/WidgetButton.qml; sed -n 1,60p Ui/BarIconButton.qml`

✓ 73 ms

```text
[exit 0, 67 ms]
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

…
```

Widgets handle their own clicks, so no MouseArea forwarding is needed. Tooltips go through `bar.showTooltip(target)`, so I'll check whether the tooltip popup copes with a target in another window.

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n 'function showTooltip' -A30 plugins/bar/Bar.qml; grep -n 'tooltipTarget' plugins/bar/Bar.qml | head -30`

✓ 50 ms

```text
[exit 0, 45 ms]
1115:  function showTooltip(target, text) {
1116-    clearTooltip()
1117-
1118-    if (!targetTooltipHovered(target) || !text) {
1119-      tooltipRequest += 1
1120-      return
1121-    }
1122-
1123-    var request = tooltipRequest + 1
1124-    tooltipRequest = request
1125-    pendingTooltipTarget = target
1126-    pendingTooltipText = text
1127-
1128-    Qt.callLater(function() {
1129-      if (request !== tooltipRequest) return
1130-      if (!targetTooltipHovered(pendingTooltipTarget)) {
1131-        clearTooltip()
1132-        return
1133-      }
1134-      tooltipTarget = pendingTooltipTarget
1135-      tooltipText = pendingTooltipText
1136-      pendingTooltipTarget = null
1137-      pendingTooltipText = ""
1138-      tooltipTimer.restart()
1139-    })
1140-  }
1141-
1142-  function hideTooltip(target) {
1143-    if (tooltipTarget !== target && pendingTooltipTarget !== target) return
1144-
1145-    tooltipRequest += 1
86:  property var tooltipTarget: null
407:    tooltipTarget = null
1134:      tooltipTarget = pendingTooltipTarget
1143:    if (tooltipTarget !== target && pendingTooltipTarget !== target) return
1153:      if (root.targetTooltipHovered(root.tooltipTarget)) root.tooltipShown = true
1162:    onTriggered: if (!root.targetTooltipHovered(root.tooltipTarget)) root.hideTooltip(root.tooltipTarget)
1289:      visible: root.tooltipShown && root.tooltipTarget !== null && root.tooltipText !== "" && root.targetBelongsToWindow(root.tooltipTarget, barWindow)
1304:          var target = root.tooltipTarget
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n 'centerAnchor\|anchorIndex\|hasAnchor' plugins/bar/Bar.qml | head -20; grep -n 'function entryIndex' -A8 plugins/bar/BarModel.js; grep -n 'function entryId\|function entrySettings' -A12 plugins/bar/BarModel.js; grep -n 'function canonicalWidgetId\|function normal`

✓ 86 ms

```text
[exit 0, 79 ms]
22:  // `bar:` subtree: position, centerAnchor, layout. The host owns file IO;
48:    centerAnchor: "omarchy.clock",
52:  property string centerAnchor: ""
586:    centerAnchor = Util.canonicalWidgetId(config.centerAnchor || "")
1520:    var idx = root.entryIndex(entries, root.centerAnchor)
1538:    readonly property bool hasAnchor: root.entryIndex(entries, root.centerAnchor) !== -1
1559:          visible: !centerRoot.hasAnchor
1566:          visible: centerRoot.hasAnchor
1567:          entries: root.entriesBefore(centerRoot.entries, root.centerAnchor)
1569:          anchors.right: centerAnchorModule.left
1570:          anchors.verticalCenter: centerAnchorModule.verticalCenter
1574:          id: centerAnchorModule
1575:          visible: centerRoot.hasAnchor
1582:          visible: centerRoot.hasAnchor
1583:          entries: root.entriesAfter(centerRoot.entries, root.centerAnchor)
1585:          anchors.left: centerAnchorModule.right
1586:          anchors.verticalCenter: centerAnchorModule.verticalCenter
1604:          visible: !centerRoot.hasAnchor
1611:          visible: centerRoot.hasAnchor
1612:          entries: root.entriesBefore(centerRoot.entries, root.centerAnchor)
50:function entryIndex(entries, name) {
51-  if (!Array.isArray(entries)) return -1
52-  for (var i = 0; i < entries.length; i++) {
53-    if (entryId(entries[i]) === name) return i
54-  }
55-  return -1
56-}
57-
58-function entriesBefore(entries, name) {
10:function entrySettings(entry) {
11-  if (!isPlainObject(entry)) return {}
12-  var copy = {}
13-  for (var key in entry) {
14-    if (key === "id") continue
15-    copy[key] = entry[key]
16-  }
17-  return copy
18-}
19-
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n 'text: \|"\\u\|chevron' plugins/bar/widgets/Tray.qml | head -15; cat plugins/bar/widgets/Indicators.manifest.json; grep -n 'accent\|popups\|bar\b' Commons/Color.qml | head -20; grep -n 'cornerRadius\|gapsOut\|popupPadding\|function space\b\|iconSlot\|statusSlot\|`

✓ 175 ms

```text
[exit 0, 153 ms]
245:          // Drawer reveals leftward; chevron sits at the right end when collapsed
246:          // and slides left as it opens. The visible region starts at the chevron.
247:          var chevronX = root.drawerExtent - root.revealExtent
248:          if (point.x >= chevronX && point.x <= horizontalTrayRoot.drawerBlockWidth) return true
272:          text: "\uf053"
330:          var chevronY = root.drawerExtent - root.revealExtent
331:          if (point.y >= chevronY && point.y <= verticalTrayRoot.drawerBlockHeight) return true
354:          text: "\uf053"
413:        text: "Tray icons"
421:        text: "Pinned icons stay visible. Hidden icons never show."
431:        text: "No tray items reporting."
476:            text: rowRoot.displayName
487:            iconText: "\uf08d"
488:            text: rowRoot.isPinned ? "Unpin" : "Pin"
502:            iconText: "\uf06e"
{
  "schemaVersion": 1,
  "id": "omarchy.indicators",
  "name": "Indicators",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Manual state indicators",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Indicators.qml"
  },
  "barWidget": {
    "displayName": "Indicators",
    "description": "Manual state indicators",
    "category": "Status",
    "allowMultiple": true,
    "schema": [
      {
        "key": "items",
        "type": "multiselect",
        "label": "Indicators",
        "description": "Choose which indicators this widget instance should show. Leave empty to show all indicators.",
…
```

I've settled the design. Before writing the manifest, I'll check which `schema` field types the shell's settings UI understands, so the `items` field renders properly there.

**⏺ bash** `cd /usr/share/omarchy; grep -rn '"multiselect"\|=== "multiselect"\|type === "\|schema\[' shell --include=*.qml | grep -v 'plugins/bar/Bar.qml' | head -20; grep -rln 'schema' bin | head`

✓ 135 ms

```text
[exit 0, 128 ms]
shell/plugins/panels/network/Panel.qml:128:  readonly property bool canShareWifi: info.type === "wifi" && canShareNetwork(connectedWifiNetwork)
shell/plugins/panels/network/Panel.qml:464:    if (!forceDetect && info.type === "wifi" && info.iface) {
shell/plugins/panels/network/Panel.qml:656:    if (info.type === "wifi") connection = info.ssid || "Wi-Fi"
shell/plugins/panels/network/Panel.qml:657:    else if (info.type === "ethernet") connection = "Ethernet"
shell/plugins/panels/network/Panel.qml:904:    running: root.opened && (root.info.type === "ethernet" || (root.info.type === "wifi" && root.canDisconnect))
shell/plugins/panels/network/Panel.qml:927:      if (!(root.info.type === "ethernet" || (root.info.type === "wifi" && root.canDisconnect))) {
shell/plugins/panels/network/Panel.qml:1178:              if (root.info.type === "wifi") return root.info.ssid || "Wi-Fi"
shell/plugins/panels/network/Panel.qml:1179:              if (root.info.type === "ethernet") return "Ethernet"
shell/plugins/panels/network/Panel.qml:1197:              if (root.info.type === "wifi") {
shell/plugins/panels/network/Panel.qml:1202:              if (root.info.type === "ethernet") return root.connectionPhrase.toUpperCase()
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerModel.js`

```
.pragma library

// Pure layout helpers for the drawer. No QML types here so the logic can be
// exercised outside the shell (see test/model.test.js).

var SECTIONS = ["left", "center", "right"]

function isPlainObject(value) {
  return value !== null && typeof value === "object" && !Array.isArray(value)
}

function entryId(entry) {
  if (typeof entry === "string") return entry
  if (isPlainObject(entry) && entry.id !== undefined && entry.id !== null) return String(entry.id)
  return ""
}

function entrySettings(entry) {
  var out = {}
  if (!isPlainObject(entry)) return out
  for (var key in entry) if (key !== "id") out[key] = entry[key]
  return out
}

// `items` on a drawer entry may be a list of ids or a single id string.
function itemList(entry, drawerId) {
  var raw = isPlainObject(entry) ? entry.items : null
  if (typeof raw === "string") raw = [raw]
  if (!Array.isArray(raw)) return []
  var out = []
  for (var i = 0; i < raw.length; i++) {
    var id = entryId(raw[i]).trim()
    if (!id || id === drawerId || out.indexOf(id) !== -1) continue
    out.push(id)
  }
  return out
}

// Every widget id tucked by any drawer entry in the layout.
function tuckedIds(layout, drawerId) {
  var out = []
  if (!isPlainObject(layout)) return out
  for (var s = 0; s < SECTIONS.length; s++) {
    var entries = layout[SECTIONS[s]]
    if (!Array.isArray(entries)) continue
    for (var i = 0; i < entries.length; i++) {
      if (entryId(entries[i]) !== drawerId) continue
      var items = itemList(entries[i], drawerId)
      for (var j = 0; j < items.length; j++) if (out.indexOf(items[j]) === -1) out.push(items[j])
    }
  }
  return out
}

// Copy of the bar config with tucked widgets removed from the visible layout.
// Their entries stay in shell.json, so their settings keep persisting.
function filteredBarConfig(barConfig, drawerId) {
  var config = isPlainObject(barConfig) ? JSON.parse(JSON.stringify(barConfig)) : {}
  var layout = isPlainObject(config.layout) ? config.layout : null
  if (!layout) return config
… (44 more lines in the repository)
```

✓ 22 ms

```text
wrote 3662 bytes to .config/omarchy/plugins/parker.drawer/DrawerModel.js
```

Now the wrapper bar. It loads the stock `Bar.qml` unmodified, hands it the filtered layout plus a registry that includes the drawer button, and forwards everything the host calls on the bar.

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerBar.qml`

```
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "DrawerModel.js" as DrawerModel

// Full-bar plugin that wraps the stock Omarchy bar instead of copying it.
//
// The stock Bar.qml is loaded unmodified from $OMARCHY_PATH, so bar updates
// keep flowing in. This wrapper only:
//   - hides widgets listed in a drawer's `items` from the visible layout,
//   - registers the drawer button (DrawerButton.qml) with the bar so it is
//     handed the live bar object and the widget catalogue, which a plain
//     third-party bar widget never receives,
//   - routes shell IPC (summon/hide/toggle) for tucked widgets into the drawer.
Item {
  id: root

  // Injected by the omarchy-shell host (see shell.qml configureBar()).
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null
  property var barWidgetRegistry: null
  property var pluginRegistry: null
  property var barConfig: ({})

  readonly property string drawerId: manifest && manifest.id ? String(manifest.id) : "parker.drawer"
  readonly property string upstreamBarUrl: "file://" + (omarchyPath || "/usr/share/omarchy") + "/shell/plugins/bar/Bar.qml"
  readonly property var innerBar: barLoader.item

  // Unfiltered layout, read by drawer buttons to find tucked entries' settings.
  readonly property var fullLayout: barConfig && barConfig.layout ? barConfig.layout : ({})
  readonly property var tucked: DrawerModel.tuckedIds(fullLayout, drawerId)
  readonly property var innerBarConfig: DrawerModel.filteredBarConfig(barConfig, drawerId)

  // Scalar state the host reads straight off shell.bar.
  readonly property bool barHidden: innerBar ? innerBar.barHidden === true : false
  readonly property int barSize: innerBar ? innerBar.barSize : 0
  readonly property string fontFamily: innerBar ? String(innerBar.fontFamily || "") : ""
  readonly property string position: innerBar ? String(innerBar.position || "top") : "top"

  // Live drawer buttons (one per monitor), registered by DrawerButton.qml.
  property var drawers: []

  function registerDrawer(drawer) {
    if (!drawer || drawers.indexOf(drawer) !== -1) return
    var next = drawers.slice()
    next.push(drawer)
    drawers = next
  }

  function unregisterDrawer(drawer) {
    drawers = drawers.filter(function(d) { return d !== drawer })
  }

  // Widget catalogue handed to the stock bar: the host snapshot plus the
  // drawer button, flagged first-party so the bar injects itself as `bar`.
  QtObject {
    id: drawerRegistry

    readonly property var drawerHost: root
… (126 more lines in the repository)
```

✓ 27 ms

```text
wrote 6978 bytes to .config/omarchy/plugins/parker.drawer/DrawerBar.qml
```

Now the drawer button and its panel.

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerButton.qml`

```
import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui
import "DrawerModel.js" as DrawerModel

// The drawer button. Clicking it opens a panel holding the widgets listed in
// this entry's `items`. Only works under the parker.drawer bar, which hands
// this widget the live bar object plus the drawer host; on any other bar it
// renders nothing.
BarWidget {
  id: root

  // `bar` is the stock Bar instance (we are flagged first-party by the
  // drawer bar's registry), so its widget catalogue is the drawer registry.
  readonly property var registry: bar && bar.barWidgetRegistry ? bar.barWidgetRegistry : null
  readonly property var host: registry && registry.drawerHost ? registry.drawerHost : null
  readonly property string drawerId: host ? host.drawerId : moduleName
  readonly property var items: host
    ? DrawerModel.drawerItems(host.fullLayout, DrawerModel.entryFromSettings(drawerId, settings), drawerId)
    : []

  property bool drawerOpen: false
  property var slotItems: []

  visible: host !== null
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onHostChanged: if (host) host.registerDrawer(root)
  Component.onCompleted: if (host) host.registerDrawer(root)
  Component.onDestruction: {
    if (host) host.unregisterDrawer(root)
    if (bar) for (var i = 0; i < slotItems.length; i++) bar.unregisterModuleSlot(slotItems[i])
  }

  // ------------------------------------------------------------ lifecycle

  function open() {
    if (drawerOpen) return
    // One popup at a time: opening the drawer closes any other bar panel.
    var other = bar ? bar.activePopout : null
    if (other && !ownsObject(other) && typeof other.close === "function") other.close()
    drawerOpen = true
  }

  function close() {
    if (!drawerOpen) return
    // A tucked widget's popup is anchored to the drawer; close it first.
    var active = bar ? bar.activePopout : null
    if (active && ownsObject(active) && typeof active.close === "function") active.close()
    drawerOpen = false
  }

  function toggle() { drawerOpen ? close() : open() }

  function screenName() {
    var window = root.QsWindow ? root.QsWindow.window : null
    return window && window.screen ? String(window.screen.name || "") : ""
… (273 more lines in the repository)
```

✓ 177 ms

```text
wrote 12007 bytes to .config/omarchy/plugins/parker.drawer/DrawerButton.qml
```

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && python3 - <<'EOF'
p='DrawerButton.qml'
s=open(p).read()
def rep(a,b):
    global s
    assert s.count(a)==1, a
    s=s.replace(a,b)
rep('''    : []

  property bool drawerOpen''','''    : []
  // Repeater model keyed by a string so unrelated shell.json wri`

✓ 320 ms

```text
[exit 0, 295 ms]
170-    return innerBar ? innerBar.debugBarGeometry() : []
171-  }
172-
173:  // `omarchy-shell shell call parker.drawer toggleDrawer ""` style helper:
174-  // toggles the drawer on the focused monitor.
175:  function toggleDrawer() {
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n 'function isBarWidgetPanelPlugin' -A12 shell.qml`

✓ 75 ms

```text
[exit 0, 70 ms]
1138:  function isBarWidgetPanelPlugin(pluginId) {
1139-    var plugins = shell.pluginRegistry.installedPlugins
1140-    var m = plugins[String(pluginId || "")]
1141-    if (!m || !Array.isArray(m.kinds)) return false
1142-    if (m.kinds.indexOf("bar-widget") === -1) return false
1143-    // Plugins that are also panel/overlay/menu kinds are owned by the
1144-    // panel loader (e.g. omarchy.menu); let that path handle them.
1145-    var loaderKinds = ["panel", "overlay", "menu"]
1146-    for (var i = 0; i < loaderKinds.length; i++) {
1147-      if (m.kinds.indexOf(loaderKinds[i]) !== -1) return false
1148-    }
1149-    return true
1150-  }
```

That works: with the `bar-widget` kind declared, `omarchy-shell shell toggle parker.drawer` reaches the button through the stock routing. I'll add `opened` and drop the unverified helper.

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && python3 - <<'EOF'
p='DrawerButton.qml'
s=open(p).read()
a='''  property bool drawerOpen: false
'''
assert s.count(a)==1
s=s.replace(a,'''  property bool drawerOpen: false
  // open/close/opened make `omarchy-shell shell toggle parker.drawer` work
  // thro`

✓ 133 ms

```text
[exit 0, 128 ms]

  function debugBarGeometry() {
    return innerBar ? innerBar.debugBarGeometry() : []
  }
}
```

Now the manifest, then the shell.json change.

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.drawer",
  "name": "Bar drawer",
  "version": "1.0.0",
  "author": "parker",
  "description": "The stock Omarchy bar plus a drawer button that holds the widgets you tuck away",
  "kinds": [
    "bar",
    "bar-widget"
  ],
  "entryPoints": {
    "bar": "DrawerBar.qml",
    "barWidget": "DrawerButton.qml"
  },
  "barWidget": {
    "displayName": "Drawer",
    "description": "Click to open a panel holding the widgets listed in items",
    "category": "Layout",
    "allowMultiple": true,
    "defaultSection": "right",
    "schema": [
      {
        "key": "items",
        "type": "string-list",
        "label": "Tucked widgets",
        "description": "Widget ids to move off the bar and into this drawer, in display order. Keep each widget's own entry in bar.layout; it holds the widget's settings."
      },
      { "key": "icon", "type": "string", "label": "Icon", "defaultValue": "\uf078" },
      { "key": "iconOpen", "type": "string", "label": "Icon while open", "defaultValue": "\uf077" },
      { "key": "tooltip", "type": "string", "label": "Tooltip", "defaultValue": "More widgets" }
    ]
  }
}
```

✓ 249 ms

```text
wrote 1152 bytes to .config/omarchy/plugins/parker.drawer/manifest.json
```

**⏺ bash** `cd .config/omarchy && cp shell.json shell.json.bak.$(date +%s) && jq '
  .bar = ({id: "parker.drawer"} + .bar)
  | .bar.layout.right = ([.bar.layout.right[0]] + [{
      id: "parker.drawer",
      items: ["omarchy.weather", "omarchy.system-update", "omarchy.keyboard-layout", "omarchy.agents", "omarc`

✓ 1172 ms

```text
[exit 0, 528 ms]
{
  "id": "parker.drawer",
  "right": [
    {
      "id": "omarchy.tray"
    },
    {
      "id": "parker.drawer",
      "items": [
        "omarchy.weather",
        "omarchy.system-update",
        "omarchy.keyboard-layout",
        "omarchy.agents",
        "omarchy.bluetooth",
        "omarchy.monitor"
      ]
    },
    {
      "id": "omarchy.agents"
    },
    {
      "id": "omarchy.bluetooth"
    },
    {
      "id": "omarchy.network"
    },
    {
      "id": "omarchy.audio"
    },
    {
      "id": "omarchy.monitor"
    },
    {
      "id": "omarchy.power"
    }
  ]
}
extensions
hooks
…
```

Now verification: the plugin validator, `qmllint` on both QML files, and a node test of the layout model against the real shell.json.

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && omarchy-plugin-validate . ; echo "validate exit=$?"
mkdir -p test && cat > test/model.test.js <<'EOF'
// Run: node test/model.test.js   (from the plugin directory)
const fs = require("fs"), path = require("path"), assert = require("assert")
const src = fs.`

✗ 6447 ms

```text
[exit 1, 6412 ms]
validate exit=0
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Remote versions cannot be fetched for cli/cli: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for gh: [~/.config/mise/config.toml] gh@latest: unable to fetch versions for gh: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for openai/codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for anthropics/claude-code: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for charmbracelet/crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for claude: [~/.config/mise/config.toml] claude@latest: unable to fetch versions for claude: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for crush: [~/.config/mise/config.toml] crush@latest: unable to fetch versions for crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for codex: [~/.config/mise/config.toml] codex@latest: unable to fetch versions for codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for earendil-works/pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for pi: [~/.config/mise/config.toml] pi@latest: unable to fetch versions for pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for astral-sh/uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for uv: [~/.config/mise/config.toml] uv@latest: unable to fetch versions for uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for gemini: [~/.config/mise/config.toml] gemini@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for npm:playwright: [~/.config/mise/config.toml] npm:playwright@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for opencode: [~/.config/mise/config.toml] opencode@latest: timed out after 3.00s
mise by @jdx – installing 1 tool
mise ✗ node@26.7.0  33ms · failed: error sending request
mise ████████████████ 1/1 · installed 0 tools · 1 failed in 36ms
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: HTTP host https://cursor.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise ERROR Failed to install core:node@26.7.0: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise ERROR Version: 2026.10.9 linux-x64 (2026-10-13)
mise ERROR Run with --verbose or MISE_VERBOSE=1 for more information
```

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && rm test/model.test.js && cat > test/ModelTest.qml <<'EOF'
// Run from the plugin directory:
//   QT_QPA_PLATFORM=offscreen qml6 test/ModelTest.qml
import QtQuick
import "../DrawerModel.js" as M

QtObject {
  function check(cond, msg) { if (!cond) throw new`

✓ 20149 ms

```text
[exit 0, 20114 ms]
Invalid environment variable name evaluates to an empty string: PIPESTATUS[0]
exit=
```

That hung with no output. Reading local files via XHR needs `QML_XHR_ALLOW_FILE_READ=1`, and exiting from `onCompleted` can fire before the event loop starts. I'll fix both and capture the exit code.

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && sed -i 's|    Qt.exit(0)|    Qt.callLater(function() { Qt.exit(0) })|' test/ModelTest.qml && sed -i 's|//   QT_QPA_PLATFORM=offscreen qml6 test/ModelTest.qml|//   QML_XHR_ALLOW_FILE_READ=1 QT_QPA_PLATFORM=offscreen qml6 test/ModelTest.qml|' test/ModelTest.`

✓ 1884 ms

```text
[exit 0, 1878 ms]
exit=0
```

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && cat /tmp/mt.log; QML_XHR_ALLOW_FILE_READ=1 QT_QPA_PLATFORM=offscreen QT_LOGGING_RULES="*.debug=true;qt.*=false" timeout 20 qml6 test/ModelTest.qml; echo "exit=$?"`

✓ 201 ms

```text
[exit 0, 194 ms]
cat: /tmp/mt.log: No such file or directory
exit=0
```

The exit code is 0 but there's no output, so I can't yet tell whether the assertions ran. I'll force logging to stderr and add a deliberate-failure control run to prove the test actually executes.

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && export QML_XHR_ALLOW_FILE_READ=1 QT_QPA_PLATFORM=offscreen QT_FORCE_STDERR_LOGGING=1 QT_LOGGING_RULES="default.debug=true;js.debug=true;qml.debug=true"; timeout 20 qml6 test/ModelTest.qml 2>&1 | tail -6; echo "---control (expect FAIL)"; sed 's/"drawer butt`

✓ 20661 ms

```text
[exit 0, 20517 ms]
qml: visible left: [omarchy.menu,omarchy.workspaces] | center: [omarchy.indicators,omarchy.clock] | right: [omarchy.tray,parker.drawer,omarchy.network,omarchy.audio,omarchy.power]
qml: drawer: omarchy.weather@center, omarchy.system-update@center, omarchy.keyboard-layout@center, omarchy.agents@right, omarchy.bluetooth@right, omarchy.monitor@right
qml: MODEL TESTS PASSED
---control (expect FAIL)
file://~/.config/omarchy/plugins/parker.drawer/test/Control.qml:7: Error: FAIL: control
```

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && for f in DrawerBar.qml DrawerButton.qml; do echo "== $f"; /usr/lib/qt6/bin/qmllint -I /usr/lib/qt6/qml "$f" 2>&1 | grep -iv 'qs\.\|warning: Failed to import\|Did you mean\|unqualified\|could not be resolved\|import\b' | grep -i 'error\|syntax\|expected' | `

✓ 2684 ms

```text
[exit 0, 2674 ms]
== DrawerBar.qml
== DrawerButton.qml
Warning: DrawerButton.qml:198:11: id declarations are only allowed in objects [syntax]

qmlformat parse OK
```

The one warning is `id` inside the `anchor { }` group. The stock `PopupCard.qml` uses exactly the same pattern, so I'll lint it to confirm this is a known false positive rather than a real problem.

**⏺ bash** `/usr/lib/qt6/bin/qmllint -I /usr/lib/qt6/qml /usr/share/omarchy/shell/Ui/PopupCard.qml 2>&1 | grep 'id declarations'`

✓ 569 ms

```text
[exit 0, 562 ms]
Warning: /usr/share/omarchy/shell/Ui/PopupCard.qml:89:9: id declarations are only allowed in objects [syntax]
```

Same warning in the shipped `PopupCard.qml`, which works in the live shell, so it's a known `qmllint` false positive. Last step is a README for the plugin.

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/README.md`

```
# parker.drawer — bar drawer

A drawer button for the Omarchy top bar. Widgets you list in the drawer leave
the bar; clicking the button opens a panel holding them.

## Choosing what goes in the drawer

Everything is in `~/.config/omarchy/shell.json` (hot-reloads on save):

```json
"bar": {
  "id": "parker.drawer",
  "layout": {
    "right": [
      { "id": "omarchy.tray" },
      { "id": "parker.drawer", "items": ["omarchy.weather", "omarchy.bluetooth"] },
      { "id": "omarchy.bluetooth" },
      { "id": "omarchy.audio" }
    ]
  }
}
```

- `bar.id: "parker.drawer"` turns the drawer bar on. Set it back to
  `"omarchy.bar"` (or delete it) to return to the stock bar; tucked widgets
  then simply reappear on the bar.
- `items` lists widget ids in the order they appear in the drawer. Take one
  out of `items` and it goes back to its spot on the bar.
- **Leave each tucked widget's own entry in `bar.layout`.** It is hidden from
  the bar, but it still holds the widget's settings (clock format, etc.) and
  keeps third-party widgets enabled.
- Optional: `icon`, `iconOpen`, `tooltip` on the drawer entry. You can add
  more than one drawer entry, each with its own `items`.
- Hotkey: `omarchy-shell shell toggle parker.drawer`. Summoning a tucked
  widget (e.g. `omarchy-shell shell toggle omarchy.bluetooth`) opens the
  drawer and then that widget's panel.

## How it works

A plain bar widget never gets the widget catalogue, so it cannot host other
widgets. This plugin therefore is also a *bar option* (`kind: bar`):
`DrawerBar.qml` loads the stock `$OMARCHY_PATH/shell/plugins/bar/Bar.qml`
unmodified (so Omarchy bar updates still arrive), gives it the layout minus
tucked widgets, and registers `DrawerButton.qml` with it. The button renders the
tucked widgets in a popup, the same way the bar renders its own slots.
`DrawerModel.js` holds the pure layout logic.

## Limitations

- Couples to stock `Bar.qml` internals (`registerModuleSlot`,
  `pluginBarApiFor`, `barWidgetRegistry`). If an Omarchy update renames them,
  the drawer may break. If the stock bar fails to load at all, the plugin
  switches `bar.id` back to `omarchy.bar` and sends a notification.
- Hover tooltips don't show for widgets inside the drawer (the bar only draws
  tooltips for its own windows). Their click popups do work.
- Under any non-stock bar, third-party widgets get Omarchy's service-less
  facade. Built-in `omarchy.*` widgets are unaffected.
- Shell command modules (`"type": "command"` / `"qml"`) can't be tucked; only
  registered widgets can.
- Tucking an id tucks every instance of it.
… (6 more lines in the repository)
```

✓ 3 ms

```text
wrote 2718 bytes to .config/omarchy/plugins/parker.drawer/README.md
```

**⏺ bash** `omarchy-plugin-validate .config/omarchy/plugins/parker.drawer && echo VALID; jq -e . .config/omarchy/shell.json >/dev/null && echo "shell.json OK"; git status --short`

✓ 283 ms

```text
[exit 0, 276 ms]
VALID
shell.json OK
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
?? .config/omarchy/shell.json.bak.1794268850
?? .local/
?? .pi/
```

The plugin validates and shell.json parses. Git also shows changes I didn't make: the `themes/ember` files are deleted, and there's a new `.local/`. I'll check where those came from before finishing.

**⏺ bash** `find .local -maxdepth 4 | head; git show --stat HEAD -- .config/omarchy/themes | tail -3`

✓ 566 ms

```text
[exit 0, 558 ms]
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
 .config/omarchy/themes/ember/install.sh   |  5 +++++
 .config/omarchy/themes/ember/neovim.lua   | 11 +++++++++++
 6 files changed, 57 insertions(+)
```

**⏺ bash** `rm -rf .local && git status --short | grep -v '^ D .config/omarchy/themes/ember'`

✓ 332 ms

```text
[exit 0, 321 ms]
 M .config/omarchy/shell.json
?? .agents/
?? .claude/
?? .codex/
?? .config/omarchy/plugins/
?? .config/omarchy/shell.json.bak.1794268850
?? .pi/
```

I've built the drawer plugin and switched your bar to it. I couldn't run it in the live shell (there's no display in my sandbox), so it's untested on screen. Please check it on your desktop; the things to look at are listed at the end.

**How you choose drawer widgets.** In `~/.config/omarchy/shell.json`, the drawer button's entry has an `items` list of widget ids. Anything listed there leaves the bar and shows up in the drawer, in that order. Leave each tucked widget's own entry in `bar.layout`: it stays hidden from the bar but still holds the widget's settings (like clock format).

**What's in your config now.** The drawer button sits next to the tray, with this starting selection, which is my pick, so edit it freely:
- weather
- system update
- keyboard layout
- agents
- bluetooth
- monitor

The bar now shows: menu and workspaces · indicators and clock · tray, drawer, network, audio, power. The file reloads on save, and the original is backed up as `shell.json.bak.1794268850`.

**Why it also replaces the bar.** Omarchy doesn't let an ordinary bar widget display other widgets; only a full bar plugin can. So the plugin `parker.drawer` (in `~/.config/omarchy/plugins/parker.drawer/`) does both jobs:
- It loads Omarchy's own bar unchanged rather than copying it, so bar updates still reach you. It just hands the bar a layout without the tucked widgets, plus the drawer button.
- Clicking the button opens a panel under it holding the tucked widgets. They keep running while the drawer is closed, and their own popups open from inside it.
- `omarchy-shell shell toggle parker.drawer` works as a hotkey. Summoning a tucked widget, e.g. `omarchy-shell shell toggle omarchy.bluetooth`, should open the drawer and then that widget's popup.
- To undo everything, set `bar.id` back to `"omarchy.bar"`; tucked widgets just reappear on the bar.

**How I checked it:**
- `omarchy plugin validate` passes and shell.json is valid JSON.
- The layout logic is tested by `test/ModelTest.qml`, run against your real shell.json. All checks pass, and a deliberately broken check fails as it should.
- Both QML files parse. `qmllint`'s only warning is one that Omarchy's own popup code also triggers.

**Limitations:**
- **Depends on bar internals.** It relies on internal parts of Omarchy's bar code. An Omarchy update that renames them could break the drawer. If the bar fails to load at all, the plugin sets `bar.id` back to `omarchy.bar` and sends a notification.
- **No hover tooltips** for widgets inside the drawer (clicks still work).
- **Command or custom QML modules can't be tucked**, only registered widgets.
- **Tucking an id moves every copy** of that widget.

**On your desktop, please check:**
- The panel's position under the button.
- Opening a tucked widget's popup from inside the drawer (e.g. bluetooth), then clicking outside to close things.
- Dragging bar widgets to reorder them.

If the drawer doesn't appear, run `omarchy-shell shell rescanPlugins`.

Separately, git shows your `themes/ember` files as deleted. They were already missing when I started; I didn't touch them or restore them.

