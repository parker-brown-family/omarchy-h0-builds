# h0 (plain) building Disk Free

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools read, edit, write, grep, glob, bash

---

### › You

```text
Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.
```

I'll start by looking at what's in the project and how Omarchy shell plugins are structured here.

**⏺ bash** `ls -la; find . -maxdepth 4 -not -path '*/.git/*' | head -100`

✓ 48 ms

```text
[exit 0, 43 ms]
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
./.config/foot
…
```

**⏺ bash** `cat .config/omarchy/shell.json; echo ---; cat .config/omarchy/extensions/omarchy-menu.jsonc; echo ---; ls -la .config/omarchy/themes/ember .config/omarchy/hooks/*; git log --oneline | head; ls /usr/share/omarchy* /usr/lib/omarchy* ~/.local/share/omarchy 2>&1 | head`

✓ 89 ms

```text
[exit 0, 84 ms]
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

I need the plugin API. Let me look for docs and existing plugins in the Omarchy install.

**⏺ bash** `cd /usr/share/omarchy; ls default config; grep -rli "plugin" --include=* . 2>/dev/null | head -50`

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

**⏺ bash** `cd /usr/share/omarchy; cat default/agents/skills/omarchy/plugins.md; echo ======; cat shell/plugins/README.md`

✓ 48 ms

```text
[exit 0, 43 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/bar/README.md; echo =====; cat README.md | head -300`

✓ 52 ms

```text
[exit 0, 44 ms]
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
…
```

Let me see the omitted manifest schema section, and a simple first-party widget for reference.

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "manifest" README.md | head; sed -n '/## Plugin manifest/,/## IPC contract/p' README.md | head -200`

✓ 50 ms

```text
[exit 0, 44 ms]
46:## Plugin manifest
48:Every plugin ships a `manifest.json` describing what it is and how the
96:Entry points may declare `omarchyPath`, `shell`, `manifest`, `pluginRegistry`, and `barWidgetRegistry` properties for host injection. Built-in plugins receive the trusted host objects. Third-party plugins receive capability-scoped facades: ordinary plugins can look up and control only their own service and lifecycle, built-in clones retain narrow source-specific configuration and UI compatibility, menu plugins receive an application-library facade, and plugins can read detached scalar bar state. A full-bar plugin additionally receives detached bar configuration and widget-catalog snapshots, narrow proxies for the non-authentication services used by built-in bar widgets, and lifecycle control over configured non-authentication UI plugins. Authentication capabilities are stamped from trusted first-party manifests, authentication services are retained outside the host's public service map and QML object tree, and changing a third-party registry or configuration snapshot cannot mutate host state. Facades do not isolate visual widgets from the parent hierarchy of the shared QML scene, so sensitive state must remain outside that reachable graph.
104:A plugin is a **git repo** with a `manifest.json` at its root. Adding one
106:manifest id); updating is a fast-forward pull of that checkout.
127:files, validates the manifest, and toggles enabled state over shell IPC. Since
135:1. Put it in `~/.config/omarchy/plugins/<plugin-id>/` with a `manifest.json`
261:   to use the built-in bar. Set it to another plugin id whose manifest declares
277:6. **Multiple instances** are allowed when a manifest sets
## Plugin manifest

Every plugin ships a `manifest.json` describing what it is and how the
shell should load it. Minimal example:

```json
{
  "schemaVersion": 1,
  "id": "my.org.cool-clock",
  "name": "Cool clock",
  "version": "1.0.0",
  "author": "You",
  "description": "A clock that does cool things",
  "kinds": ["bar-widget"],
  "entryPoints": { "barWidget": "Widget.qml" },
  "barWidget": {
    "displayName": "Cool clock",
    "category": "Time",
    "allowMultiple": false,
    "defaultSection": "left",
    "defaults": { "format": "HH:mm" },
    "schema": [
      { "key": "format", "type": "string", "label": "Format" }
    ]
  }
}
```

Supported `kinds`:

…
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; ls bar/widgets; ls panels/weather; cat panels/weather/manifest.json`

✓ 48 ms

```text
[exit 0, 44 ms]
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
Tray.manifest.json
Tray.qml
TrayModel.js
Workspaces.manifest.json
Workspaces.qml
BarWidget.qml
Model.js
Panel.qml
manifest.json
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
…
```

Let me look at a simple text widget (KeyboardLayout / SystemUpdate) to match how built-ins render text, colors and run commands.

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/bar/widgets; cat SystemUpdate.manifest.json SystemUpdate.qml; echo ====; cat KeyboardLayout.qml | head -120`

✓ 49 ms

```text
[exit 0, 43 ms]
{
  "schemaVersion": 1,
  "id": "omarchy.system-update",
  "name": "Omarchy update",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Indicates available Omarchy updates",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "SystemUpdate.qml"
  },
  "barWidget": {
    "displayName": "Omarchy update",
    "description": "Indicates available Omarchy updates",
    "category": "System",
    "allowMultiple": false
  }
}
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.system-update"

  property bool updateAvailable: false

  function refresh() {
    if (!updateProc.running) updateProc.running = true
  }

  function clear() { updateAvailable = false }

  function runUpdate() {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 120,400p plugins/bar/widgets/KeyboardLayout.qml | grep -n -A30 "BarIconButton\|BarText\|BarLabel" | head -60; echo ===; cat Ui/qmldir; echo ===; cat Ui/BarWidget.qml`

✓ 48 ms

```text
[exit 0, 43 ms]
===
module qs.Ui

BarIndicator 1.0 BarIndicator.qml
BarIconButton 1.0 BarIconButton.qml
BarWidget 1.0 BarWidget.qml
BorderOverlay 1.0 BorderOverlay.qml
BorderSurface 1.0 BorderSurface.qml
Button 1.0 Button.qml
ButtonGroup 1.0 ButtonGroup.qml
ConfirmDialog 1.0 ConfirmDialog.qml
CursorSurface 1.0 CursorSurface.qml
Dropdown 1.0 Dropdown.qml
KeyboardPanel 1.0 KeyboardPanel.qml
MultiSelect 1.0 MultiSelect.qml
NumberField 1.0 NumberField.qml
OpticalGlyph 1.0 OpticalGlyph.qml
Panel 1.0 Panel.qml
PanelActionButton 1.0 PanelActionButton.qml
PanelController 1.0 PanelController.qml
PanelKeyCatcher 1.0 PanelKeyCatcher.qml
PanelHero 1.0 PanelHero.qml
PanelSectionHeader 1.0 PanelSectionHeader.qml
PanelSeparator 1.0 PanelSeparator.qml
PanelSlider 1.0 PanelSlider.qml
PanelToolTip 1.0 PanelToolTip.qml
PluginBarApi 1.0 PluginBarApi.qml
PointerMoveGate 1.0 PointerMoveGate.qml
ScreenMoveRemap 1.0 ScreenMoveRemap.qml
PopupCard 1.0 PopupCard.qml
SearchableDropdown 1.0 SearchableDropdown.qml
SpeedTestOverlay 1.0 SpeedTestOverlay.qml
TextField 1.0 TextField.qml
Toggle 1.0 Toggle.qml
ToggleSwitch 1.0 ToggleSwitch.qml
WidgetButton 1.0 WidgetButton.qml
===
import QtQuick
import qs.Commons
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/bar/widgets/ActiveWindow.qml; echo ====; cat Ui/WidgetButton.qml | head -80`

✓ 48 ms

```text
[exit 0, 44 ms]
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.active-window"


  readonly property var toplevel: ToplevelManager.activeToplevel
  readonly property string title: toplevel ? (toplevel.title || toplevel.appId || "") : ""
  readonly property int maxLabelWidth: Number(setting("maxWidth", 280))

  visible: title !== "" && !vertical
  implicitWidth: visible ? Math.min(maxLabelWidth, labelText.implicitWidth) + Style.spacing.controlPaddingX * 2 : 0
  implicitHeight: barSize

  Behavior on implicitWidth {
    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
  }

  Item {
    anchors.fill: parent
    anchors.leftMargin: Style.space(8)
    anchors.rightMargin: Style.space(8)
    clip: true

    Text {
      id: labelText
      textFormat: Text.PlainText
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      width: parent.width
      text: root.title
      color: root.bar ? root.bar.barForeground : Color.foreground
      font.family: root.bar ? root.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.body
…
```

**⏺ bash** `cd /usr/share/omarchy; grep -rn "qs.Ui\|qs.Commons\|third-party" shell/services/PluginRegistry.qml | head -30; grep -rln "import qs" migrations bin 2>/dev/null | head; grep -rn "bar-widget" bin | head`

✓ 47 ms

```text
[exit 0, 43 ms]
4:import qs.Commons
400:  // deviation: an added third-party plugin in plugins[], a switched-off
692:    // $0 = first-party dir, $1 = third-party dir. Some bash versions need the explicit -- separator.
```

**⏺ bash** `cd /usr/share/omarchy; sed -n 660,800p shell/services/PluginRegistry.qml; grep -n "user\|\.config/omarchy/plugins\|qmldir\|symlink\|copy" shell/services/PluginRegistry.qml | head -40`

✓ 47 ms

```text
[exit 0, 43 ms]
    }
  }

  property Process localPluginWatcher: Process {
    command: [
      "inotifywait",
      "-m",
      "-r",
      "-q",
      "-e",
      "close_write,create,delete,move",
      "--format",
      "%w%f",
      registry.pluginsDir
    ]
    stdout: SplitParser {
      onRead: function(path) {
        var pluginId = registry.localPluginIdForPath(path)
        if (pluginId) registry.localPluginChanged(pluginId)
      }
    }
    onExited: localPluginWatcherRestart.restart()
  }

  property Timer localPluginWatcherRestart: Timer {
    interval: 1000
    onTriggered: localPluginWatcher.running = true
  }

  function rescan() {
    if (scanning) return
    scanning = true
    // $0 = first-party dir, $1 = third-party dir. Some bash versions need the explicit -- separator.
    // First-party plugins may be grouped one level deeper, e.g. panels/audio
    // or services/battery.
    // First-party bar widgets can also carry sibling manifests such as
    // widgets/Clock.manifest.json so multiple widgets can live in one source
    // directory without wrapper folders.
    // Third-party plugins stay at the top level of ~/.config/omarchy/plugins.
…
```

Cloned built-ins live under `~/.config/omarchy/plugins` too. I'll check whether the clone step rewrites `qs.*` imports, which tells me whether third-party QML can use them.

**⏺ bash** `cd /usr/share/omarchy/bin; ls | grep -i plugin; grep -n "qs\.\|sed" omarchy-plugin* 2>/dev/null | head -30`

✓ 48 ms

```text
[exit 0, 44 ms]
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
omarchy-plugin-add:137:  fail "plugin id '$id' is already used by $existing_manifest"
omarchy-plugin-catalog:10:# single source of truth used by bar selection and plugin enable/clone, so
omarchy-plugin-clone:42:        sed -i "s|$source_pattern|$target|g" "$file"
omarchy-plugin-validate:96:# not listed is left alone rather than guessed at.
```

**⏺ bash** `cd /usr/share/omarchy/bin; sed -n 1,80p omarchy-plugin-clone; echo ====; cat omarchy-plugin-validate`

✓ 49 ms

```text
[exit 0, 44 ms]
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

Clones keep `import qs.*` as-is, so a user plugin can use the shell's `qs.Ui` / `qs.Commons` modules. Now I'll check which theme color counts as "red".

**⏺ bash** `cd /usr/share/omarchy/shell; ls Commons; grep -n "urgent\|red\|color1\b" Commons/Color.qml | head -20; cat ~/.config/omarchy/themes/ember/colors.toml; grep -rn "urgent" plugins/bar/Bar.qml | head -5`

✓ 48 ms

```text
[exit 0, 44 ms]
Border.qml
BorderGeometry.js
Color.qml
Style.qml
Util.qml
qmldir
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
239:  // Machine-level override, layered on top of whatever theme is active. This
mode = "dark"

accent = "#89b4fa"
selection = "#45475a"
muted = "#585b70"

background = "#1e1e2e"
dark_background = "#161622"
darker_background = "#101019"
lighter_background = "#313244"

foreground = "#cdd6f4"
dark_foreground = "#6c7086"
light_foreground = "#bac2de"
bright_foreground = "#cdd6f4"

red = "#f38ba8"
yellow = "#f9e2af"
orange = "#f6b6ab"
green = "#a6e3a1"
cyan = "#94e2d5"
blue = "#89b4fa"
…
```

Theme `red` maps to `Color.urgent`, so that's what I'll use for the warning color. Now the rest of `WidgetButton` to see how `active` coloring works:

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 80,200p Ui/WidgetButton.qml; cat Ui/PluginBarApi.qml | head -60`

✓ 47 ms

```text
[exit 0, 43 ms]
    text: root.text
    color: root.active && root.useActiveColor ? root.activeColor : root.foreground
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    renderType: Text.NativeRendering
    rotation: root.textRotation
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Behavior on color {
      enabled: !root.bar || root.bar.foregroundAnimationEnabled
      ColorAnimation { duration: 160 }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    enabled: root.interactive
    hoverEnabled: true
    cursorShape: root.pressable ? Qt.PointingHandCursor : Qt.ArrowCursor
    onEntered: {
      if (root.bar) {
        root.bar.showTooltip(root, root.tooltipText)
      }
      if (root.maintainIndicatorReveal && root.revealHost && root.revealHost.setIndicatorItemHovered)
        root.revealHost.setIndicatorItemHovered(true)
    }
    onExited: {
      if (root.bar) {
        root.bar.hideTooltip(root)
      }
      if (root.maintainIndicatorReveal && root.revealHost && root.revealHost.setIndicatorItemHovered)
        root.revealHost.setIndicatorItemHovered(false)
    }
    onClicked: function(mouse) { if (root.pressable) root.triggerPress(mouse.button) }
    onWheel: function(wheel) { root.wheelMoved(wheel.angleDelta.y) }
  }
…
```

**⏺ write** `~/.config/omarchy/plugins/parker.disk-free/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.disk-free",
  "name": "Disk free",
  "version": "1.0.0",
  "author": "parker",
  "description": "Free space left on the main drive, red when nearly full",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "BarWidget.qml"
  },
  "barWidget": {
    "displayName": "Disk free",
    "description": "Free space left on the main drive, red when nearly full",
    "category": "System",
    "allowMultiple": true,
    "defaultSection": "right",
    "defaults": {
      "path": "/",
      "interval": 60,
      "warnPercent": 10
    },
    "schema": [
      { "key": "path", "type": "string", "label": "Mount point" },
      { "key": "interval", "type": "number", "label": "Refresh interval (seconds)" },
      { "key": "warnPercent", "type": "number", "label": "Turn red below (% free)" }
    ]
  }
}
```

✓ 1 ms

```text
wrote 854 bytes to .config/omarchy/plugins/parker.disk-free/manifest.json
```

**⏺ write** `~/.config/omarchy/plugins/parker.disk-free/Model.js`

```
.pragma library

// Parse the output of `df -B1 --output=size,avail,target <path>`:
//
//   1B-blocks        Avail Mounted on
//   999653638144 195421257728 /
//
// Returns { size, avail, mount } in bytes, or null if it can't be read.
function parseDf(output) {
  var lines = String(output || "").trim().split("\n")
  if (lines.length < 2) return null
  var fields = lines[lines.length - 1].trim().split(/\s+/)
  if (fields.length < 2) return null
  var size = Number(fields[0])
  var avail = Number(fields[1])
  if (!isFinite(size) || !isFinite(avail) || size <= 0 || avail < 0) return null
  return { size: size, avail: avail, mount: fields.slice(2).join(" ") }
}

// Human-readable size in powers of 1024, matching `df -h`: one decimal
// below 10 ("9.4G"), whole numbers above ("182G").
function formatBytes(bytes) {
  var units = ["B", "K", "M", "G", "T", "P", "E"]
  var value = Math.max(0, Number(bytes) || 0)
  var i = 0
  while (value >= 1024 && i < units.length - 1) {
    value /= 1024
    i++
  }
  var shown = value < 10 && i > 0 ? (Math.round(value * 10) / 10).toFixed(1) : String(Math.round(value))
  // Rounding can carry into the next unit (1023.6M -> "1024M"); step up instead.
  if (Number(shown) >= 1024 && i < units.length - 1) return "1.0" + units[i + 1]
  return shown + units[i]
}

function percentFree(info) {
  return info ? (info.avail / info.size) * 100 : 0
}

function isLow(info, warnPercent) {
  return !!info && percentFree(info) < warnPercent
}
```

✓ 0 ms

```text
wrote 1478 bytes to .config/omarchy/plugins/parker.disk-free/Model.js
```

**⏺ write** `~/.config/omarchy/plugins/parker.disk-free/BarWidget.qml`

```
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

// Shows free space on the main drive, e.g. "182G free". Turns the theme's red
// when less than `warnPercent` (default 10%) of the drive is left.
// Left click refreshes immediately.
BarWidget {
  id: root
  moduleName: "parker.disk-free"

  readonly property string path: String(setting("path", "/"))
  readonly property int intervalSeconds: Math.max(5, Number(setting("interval", 60)) || 60)
  readonly property real warnPercent: Number(setting("warnPercent", 10))

  property var info: null
  readonly property bool low: Model.isLow(info, warnPercent)
  readonly property string freeText: info ? Model.formatBytes(info.avail) : ""

  function refresh() {
    if (!dfProc.running) dfProc.running = true
  }

  onPathChanged: refresh()

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: dfProc
    command: ["df", "-B1", "--output=size,avail,target", "--", root.path]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.info = Model.parseDf(text)
    }
    onExited: function(exitCode) {
      if (exitCode !== 0) root.info = null
    }
  }

  Timer {
    interval: root.intervalSeconds * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    // Vertical bars are only 28px wide, so drop the word there.
    text: root.info ? (root.vertical ? root.freeText : root.freeText + " free") : "?"
    fontSize: root.vertical ? Style.font.caption : Style.font.body
    active: root.low
    activeColor: Color.urgent
… (7 more lines in the repository)
```

✓ 0 ms

```text
wrote 2040 bytes to .config/omarchy/plugins/parker.disk-free/BarWidget.qml
```

Next, I'll put it on the bar in `shell.json`, first in the right section:

**⏺ edit** `~/.config/omarchy/shell.json`

```
      "right": [
        {
          "id": "parker.disk-free"
        },
        {
          "id": "omarchy.tray"
        },
```

✓ 2 ms

```text
edited .config/omarchy/shell.json at line 40
```

**⏺ bash** `P=.config/omarchy/plugins/parker.disk-free
/usr/share/omarchy/bin/omarchy-plugin-validate $P && echo VALID
jq -e . .config/omarchy/shell.json >/dev/null && echo shell.json OK
df -B1 --output=size,avail,target -- / ; echo "exit $?"
which node qmllint qml6 qmllint6 2>/dev/null; ls /usr/lib/qt6/bin 2>/`

✓ 236 ms

```text
[exit 0, 231 ms]
VALID
shell.json OK
    1B-blocks        Avail Mounted on
1022042832896 130943000576 /
exit 0
~/.local/share/mise/shims/node
~/.local/bin/qmllint
/usr/bin/qml6
qmllint
```

The manifest validates and the JSON is fine. Next I'll test the JS logic against real `df` output plus some edge cases, and lint the QML.

**⏺ bash** `P=.config/omarchy/plugins/parker.disk-free
sed '1d' $P/Model.js > /tmp/m.js; echo 'module.exports={parseDf,formatBytes,percentFree,isLow}' >> /tmp/m.js
OUT="$(df -B1 --output=size,avail,target -- /)" node -e '
const m=require("/tmp/m.js"); const a=require("assert");
const real=m.parseDf(process.env.`

✓ 6247 ms

```text
[exit 0, 6239 ms]
Invalid environment variable name evaluates to an empty string: PIPESTATUS[0]
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Remote versions cannot be fetched for anthropics/claude-code: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for claude: [~/.config/mise/config.toml] claude@latest: unable to fetch versions for claude: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for earendil-works/pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for pi: [~/.config/mise/config.toml] pi@latest: unable to fetch versions for pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for cli/cli: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for gh: [~/.config/mise/config.toml] gh@latest: unable to fetch versions for gh: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for charmbracelet/crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for crush: [~/.config/mise/config.toml] crush@latest: unable to fetch versions for crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for openai/codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for codex: [~/.config/mise/config.toml] codex@latest: unable to fetch versions for codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for astral-sh/uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for uv: [~/.config/mise/config.toml] uv@latest: unable to fetch versions for uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for gemini: [~/.config/mise/config.toml] gemini@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for npm:playwright: [~/.config/mise/config.toml] npm:playwright@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for opencode: [~/.config/mise/config.toml] opencode@latest: timed out after 3.00s
mise by @jdx – installing 1 tool
mise ✗ node@26.7.0  14ms · failed: error sending request
mise ████████████████ 1/1 · installed 0 tools · 1 failed in 15ms
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: HTTP host https://cursor.com:443 is unavailable after an earlier connection failure: error sending request
mise ERROR Failed to install core:node@26.7.0: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise ERROR Version: 2026.10.9 linux-x64 (2026-10-13)
mise ERROR Run with --verbose or MISE_VERBOSE=1 for more information
Warning: BarWidget.qml:4:1: Warnings occurred while importing module "qs.Commons": [import]
import qs.Commons
^^^^^^
---
Warning: 4:1: Failed to import qs.Commons. Are your import paths set up properly? [import]
---

Warning: BarWidget.qml:5:1: Warnings occurred while importing module "qs.Ui": [import]
import qs.Ui
^^^^^^
---
Warning: 5:1: Failed to import qs.Ui. Are your import paths set up properly? [import]
---
…
```

**⏺ bash** `P=.config/omarchy/plugins/parker.disk-free
mv $P/BarWidget.qml $P/DiskFree.qml
sed -i 's/"barWidget": "BarWidget.qml"/"barWidget": "DiskFree.qml"/' $P/manifest.json
grep -n DiskFree $P/manifest.json
/usr/share/omarchy/bin/omarchy-plugin-validate $P && echo VALID
cd $P && qmllint -I /usr/share/omarch`

✓ 209 ms

```text
[exit 0, 204 ms]
12:    "barWidget": "DiskFree.qml"
VALID
Warning: DiskFree.qml:4:1: Warnings occurred while importing module "qs.Commons": [import]
import qs.Commons
^^^^^^
Warning: 4:1: Failed to import qs.Commons. Are your import paths set up properly? [import]
Warning: DiskFree.qml:5:1: Warnings occurred while importing module "qs.Ui": [import]
import qs.Ui
^^^^^^
Warning: 5:1: Failed to import qs.Ui. Are your import paths set up properly? [import]
Warning: DiskFree.qml:52:3: WidgetButton was not found. Did you add all imports and dependencies? [import]
  WidgetButton {
  ^^^^^^^^^^^^
Warning: DiskFree.qml:11:1: BarWidget was not found. Did you add all imports and dependencies? [import]
BarWidget {
^^^^^^^^^
Warning: DiskFree.qml:54:5: unknown grouped property scope anchors. [unqualified]
    anchors.fill: parent
    ^^^^^^^
Warning: DiskFree.qml:39:5: Type QProcess::ExitStatus of parameter exitStatus in signal called exited was not found, but is required to compile onExited. Did you add all imports and dependencies? [signal-handler-parameters]
    onExited: function(exitCode) {
    ^^^^^^^^
Warning: DiskFree.qml:54:5: Type anchors is used but it is not resolved [unresolved-type]
    anchors.fill: parent
    ^^^^^^^
Info: DiskFree.qml:2:1: Unused import [unused-imports]
import Quickshell
^^^^^^
Warning: DiskFree.qml:15:41: Unqualified access [unqualified]
  readonly property string path: String(setting("path", "/"))
                                        ^^^^^^^
Warning: DiskFree.qml:16:61: Unqualified access [unqualified]
```

**⏺ bash** `P=.config/omarchy/plugins/parker.disk-free
sed -i '/^import Quickshell$/d' $P/DiskFree.qml; head -6 $P/DiskFree.qml
echo "--- built-in SystemUpdate.qml lint (for comparison):"
(cd /usr/share/omarchy/shell/plugins/bar/widgets && qmllint SystemUpdate.qml 2>&1 | grep -c "^Warning")
echo "--- DiskFree.q`

✓ 313 ms

```text
[exit 0, 305 ms]
import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

--- built-in SystemUpdate.qml lint (for comparison):
12
--- DiskFree.qml:
16
exit 0
```

`qml6` exited 0 but printed nothing. Logging is probably being routed somewhere else, so I'll force it to stderr:

**⏺ bash** `QT_FORCE_STDERR_LOGGING=1 QT_LOGGING_RULES="qml.debug=true;js.debug=true;default.debug=true" QT_QPA_PLATFORM=offscreen timeout 20 qml6 /tmp/t.qml 2>&1 | tail -5; echo "exit ${PIPESTATUS[0]}"`

✓ 88 ms

```text
[exit 0, 84 ms]
Invalid environment variable name evaluates to an empty string: PIPESTATUS[0]
QQmlApplicationEngine failed to load component
file:///tmp/t.qml: No such file or directory
qml: Did not load any objects, exiting.
exit
```

`/tmp` doesn't persist between sandbox calls, so the earlier "exit 0" didn't prove anything. I'll rerun everything in one call from a scratch directory inside the project:

**⏺ bash** `P=.config/omarchy/plugins/parker.disk-free; T=.h0-test; mkdir -p $T
OUT="$(df -B1 --output=size,avail,target -- /)"
cat > $T/t.qml <<EOF
import QtQuick
import "file://$PWD/$P/Model.js" as M
QtObject {
  Component.onCompleted: {
    function eq(a,b){ if (a!==b) { console.log("FAIL", JSON.stringify(a)`

✓ 111 ms

```text
[exit 0, 104 ms]
Invalid environment variable name evaluates to an empty string: PIPESTATUS[0]
qml: real: {"size":1022042832896,"avail":130743468032,"mount":"/"} -> 122G free 12.8% low: false
qml: all assertions pass
exit 
/dev/mapper/root  952G  828G  122G  88% /
```

The logic matches `df -h` on this machine: `122G free` (12.8% left, so not red). Final state of the changes:

**⏺ bash** `git status --short; git diff; cat .config/omarchy/plugins/parker.disk-free/DiskFree.qml | sed -n 1,30p`

✓ 76 ms

```text
[exit 0, 68 ms]
 M .config/omarchy/shell.json
?? .config/omarchy/plugins/
?? .local/
diff --git a/.config/omarchy/shell.json b/.config/omarchy/shell.json
index e6202da..d047864 100644
--- a/.config/omarchy/shell.json
+++ b/.config/omarchy/shell.json
@@ -38,6 +38,9 @@
         }
       ],
       "right": [
+        {
+          "id": "parker.disk-free"
+        },
         {
           "id": "omarchy.tray"
         },
import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

// Shows free space on the main drive, e.g. "182G free". Turns the theme's red
// when less than `warnPercent` (default 10%) of the drive is left.
// Left click refreshes immediately.
BarWidget {
  id: root
  moduleName: "parker.disk-free"

  readonly property string path: String(setting("path", "/"))
  readonly property int intervalSeconds: Math.max(5, Number(setting("interval", 60)) || 60)
  readonly property real warnPercent: Number(setting("warnPercent", 10))

  property var info: null
  readonly property bool low: Model.isLow(info, warnPercent)
  readonly property string freeText: info ? Model.formatBytes(info.avail) : ""

  function refresh() {
…
```

A `.local/` directory appeared that I didn't make on purpose. I'll check what it is:

**⏺ bash** `find .local | head; `

✓ 167 ms

```text
[exit 0, 160 ms]
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
```

That's leftover state from the failed `node` shim call, so I'll delete it:

**⏺ bash** `rm -rf .local && git status --short`

✓ 76 ms

```text
[exit 0, 71 ms]
 M .config/omarchy/shell.json
?? .config/omarchy/plugins/
```

I've built the disk-free plugin and added it to the right side of your top bar. It shows something like `122G free`, checks every 60 seconds, and turns red when less than 10% of the drive is left. I haven't seen it running in your actual bar, though: the shell can't run in my sandbox.

**What it does**
- It reads free space on `/` and counts only the space you can actually use. The number is rounded the same way `df -h` shows it: `182G`, or `9.4G` below 10.
- The red is your theme's `red` color. In the ember theme that's `#f38ba8`, a pinkish red.
- Hovering shows the details, e.g. "122G free of 952G (12.8%) on /".
- Clicking it refreshes right away.
- On a left or right side bar it shows just `122G`, because "free" doesn't fit.
- You can change the drive, the timing and the red threshold in its entry in `shell.json`, e.g. `{ "id": "parker.disk-free", "interval": 120, "warnPercent": 15 }`.

**Files**
- `~/.config/omarchy/plugins/parker.disk-free/`
  - `manifest.json`: describes the plugin to Omarchy.
  - `DiskFree.qml`: the bar widget.
  - `Model.js`: reads the disk numbers and formats the text.
- `~/.config/omarchy/shell.json`: one line added to put the widget first in the right section.

**Testing**
- Omarchy's own plugin checker (`omarchy plugin validate`) passes, and `shell.json` is still valid.
- I ran the reading, formatting and under-10% logic in Qt's QML engine against your real drive. It gave `122G free`, 12.8% left, so not red, which matches `df -h /`. Tests for rounding, the 10% boundary and bad input all passed.
- The QML checker (`qmllint`) found no real problems. Its remaining warnings come from Omarchy shell imports the checker can't find, and a built-in Omarchy widget shows the same kind. Fixing those warnings found one real bug: the widget file was named after the type it builds on, so I renamed it to `DiskFree.qml`.

**Not checked**
- How it looks and behaves in the bar.
- Whether it actually turns red there. Your drive is above 10%, so you won't see red yet.

The shell normally picks up new plugins and `shell.json` changes on its own. If the widget doesn't appear, run `omarchy-shell shell rescanPlugins`.

I deleted a stray `.local/` folder that a failed attempt to run `node` had created in the project.

