# h0 + Omarchy fitting building Bar Drawer

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `omarchy-v4` · tools read, edit, write, grep, glob, bash, check

---

### › You

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

**⏺ bash** `cat /usr/share/omarchy/default/agents/skills/omarchy/plugins.md; echo ----; cat .config/omarchy/shell.json; ls -R .config/omarchy/plugins 2>/dev/null; ls /usr/share/omarchy/shell/plugins/`

✓ 101 ms

```text
[exit 0, 91 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; cat README.md; ls -R bar | head -80`

✓ 108 ms

```text
[exit 0, 98 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/bar; cat README.md; cat manifest.json; wc -l Bar.qml BarModel.js`

✓ 112 ms

```text
[exit 0, 106 ms]
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

**⏺ bash** `ls /usr/share/omarchy/shell/ ; ls /usr/share/omarchy/shell/* | head -60; ls /usr/share/omarchy/default/agents/skills/omarchy/`

✓ 112 ms

```text
[exit 0, 107 ms]
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
…
```

**⏺ bash** `cat /usr/share/omarchy/shell/README.md`

✓ 52 ms

```text
[exit 0, 45 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/PluginBarApi.qml | head -150; ls services; grep -n "function \|property " services/BarWidgetRegistry.qml | head -60`

✓ 74 ms

```text
[exit 0, 68 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; cat services/PluginBarWidgetRegistryApi.qml | head -80; grep -n "drawer\|Drawer\|moduleWidgets\|hidden" plugins/bar/Bar.qml | head -50`

✓ 51 ms

```text
[exit 0, 45 ms]
import QtQuick

// Detached widget-catalogue snapshot for third-party full-bar implementations.
// Plugins can render the referenced components, but mutating this local view
// cannot replace a registration in the host registry.
QtObject {
  id: api

  property var widgets: ({})
  property int revision: 0

  function metadataFor(id) {
    var entry = widgets[String(id || "")]
    return entry ? entry.metadata : null
  }

  function availableIds() {
    return Object.keys(widgets)
  }

  function has(id) {
    return widgets[String(id || "")] !== undefined
  }
}
262:      _moduleWidgets: function(requestedId) {
264:          ? root.moduleWidgets(moduleName) : []
573:  // The tray drawer reveals inward (away from the bar edge). Place it at the
575:  // sections. The drawer's reserved space then sits next to the bar center,
696:  function moduleWidgets(pluginId) {
1165:  // Presence of the `bar-off` flag = bar hidden. Watching the parent toggles
1726:    // A hidden list must not build its modules. The center section declares
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 200,330p plugins/bar/Bar.qml; sed -n 680,720p plugins/bar/Bar.qml`

✓ 188 ms

```text
[exit 0, 181 ms]
    return out
  }

  function syncAllPluginBarApiObjects() {
    for (var id in pluginBarApis) root.syncPluginBarApiObjects(pluginBarApis[id])
  }

  function registerPluginClickTarget(pluginId, target) {
    if (!root.markPluginObject(pluginId, target, "clickTarget")) return
    root.registerClickTarget(target)
  }

  function unregisterPluginClickTarget(pluginId, target) {
    if (!root.pluginOwnsBarObject(pluginId, target)) return
    root.unregisterClickTarget(target)
    root.unmarkPluginObject(pluginId, target, "clickTarget")
  }

  function requestPluginPopout(pluginId, owner) {
    if (!root.markPluginObject(pluginId, owner, "popout")) return
    root.requestPopout(owner)
  }

  function releasePluginPopout(pluginId, owner) {
    if (!root.pluginOwnsBarObject(pluginId, owner)) return
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
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "component \|Component {\|Loader\|sourceComponent\|createObject\|settings:" plugins/bar/Bar.qml | head -60`

✓ 50 ms

```text
[exit 0, 46 ms]
115:  Component {
250:    var api = pluginBarApiComponent.createObject(null, {
1199:    delegate: Component {
1211:    delegate: Component {
1224:    delegate: Component {
1234:  component BarPanel: PanelWindow {
1271:    Loader {
1273:      sourceComponent: root.vertical ? verticalBar : horizontalBar
1350:    Component {
1372:    Component {
1395:  Component { id: emptyModuleComponent; Item { implicitWidth: 0; implicitHeight: 0; visible: false } }
1397:  component DragGhostPanel: PanelWindow {
1465:  component BarMoveGhostPanel: PanelWindow {
1524:  component LeftModules: ModuleList {
1529:  component RightModules: ModuleList {
1534:  component CenterModules: Item {
1541:    Loader {
1543:      sourceComponent: root.vertical ? verticalCenterModules : horizontalCenterModules
1546:    Component {
1591:    Component {
1637:  component CenterGestureArea: MouseArea {
1719:  component ModuleList: Loader {
1732:    sourceComponent: root.vertical ? verticalModuleList : horizontalModuleList
1736:    Component {
1754:    Component {
1773:  component ModuleSlot: Item {
1791:      return w[registryName] ? w[registryName].component : null
1797:      if (registered) return registryLoader.item
1798:      if (qmlCustom) return qmlLoader.item
1799:      return componentLoader.item
1838:    Loader {
1839:      id: componentLoader
1841:      sourceComponent: slot.commandCustom ? customCommandModuleComponent : emptyModuleComponent
1850:    Loader {
1851:      id: registryLoader
1853:      sourceComponent: slot.registered ? slot.registryComponent : null
1862:    Loader {
1863:      id: qmlLoader
2008:    Component {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1719,2010p plugins/bar/Bar.qml`

✓ 75 ms

```text
[exit 0, 66 ms]
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

      Row {
        spacing: 0

        Repeater {
          model: moduleListRoot.entries

          ModuleSlot {
            required property var modelData
            entry: modelData
            region: moduleListRoot.region
          }
        }
      }
    }

    Component {
      id: verticalModuleList

      Column {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; ls panels panels/audio; cat panels/audio/manifest.json; grep -n "property\|bar\.\|shell\." panels/audio/Panel.qml | head -60; wc -l panels/audio/Panel.qml`

✓ 143 ms

```text
[exit 0, 134 ms]
panels:
audio
bluetooth
clock
disk-speedtest
dropbox
monitor
network
power
speedtest
tailscale
weather
wifiqr

panels/audio:
Model.js
Panel.qml
manifest.json
{
  "schemaVersion": 1,
  "id": "omarchy.audio",
  "name": "Audio",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Volume slider, output picker, per-app mixer",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Panel.qml"
  },
  "barWidget": {
    "displayName": "Audio",
    "description": "Volume slider, output picker, per-app mixer",
    "category": "Audio",
    "allowMultiple": false
  }
}
4:import Quickshell.Io
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function markPluginObject\|function pluginOwnsBarObject\|function pressModuleClickTarget\|function moduleClickTargetAt\|function requestPopout\|function registerClickTarget" -A22 plugins/bar/Bar.qml | head -170`

✓ 72 ms

```text
[exit 0, 66 ms]
157:  function markPluginObject(pluginId, target, role) {
158-    var key = String(pluginId || "")
159-    if (!key || !target) return false
160-    var record = root.pluginObjectRecord(target)
161-    if (record && record.pluginId !== key) return false
162-    var next = []
163-    for (var i = 0; i < pluginObjectOwners.length; i++) {
164-      var existing = pluginObjectOwners[i]
165-      if (!existing || existing.target !== target) next.push(existing)
166-    }
167-    var updated = record || { target: target, pluginId: key, clickTarget: false, popout: false }
168-    updated[role] = true
169-    next.push(updated)
170-    pluginObjectOwners = next
171-    return true
172-  }
173-
174-  function unmarkPluginObject(pluginId, target, role) {
175-    var key = String(pluginId || "")
176-    var next = []
177-    for (var i = 0; i < pluginObjectOwners.length; i++) {
178-      var record = pluginObjectOwners[i]
179-      if (!record || record.target !== target || record.pluginId !== key) {
--
189:  function pluginOwnsBarObject(pluginId, target) {
190-    var record = target ? root.pluginObjectRecord(target) : null
191-    return !!record && record.pluginId === String(pluginId || "")
192-  }
193-
194-  function pluginClickTargets(pluginId) {
195-    var out = []
196-    for (var i = 0; i < root.clickTargets.length; i++) {
197-      var target = root.clickTargets[i]
198-      if (root.pluginOwnsBarObject(pluginId, target)) out.push(target)
199-    }
200-    return out
201-  }
202-
203-  function syncAllPluginBarApiObjects() {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/Ui; cat WidgetButton.qml | head -150; cat qmldir`

✓ 80 ms

```text
[exit 0, 71 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1,140p Ui/Panel.qml`

✓ 52 ms

```text
[exit 0, 48 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/PanelController.qml | head -80; cat Ui/PopupCard.qml | head -120`

✓ 52 ms

```text
[exit 0, 46 ms]
import QtQuick
// Stores the open state for a shell panel. Panel owns the public lifecycle
// methods and IPC wiring; this object only keeps state separate from the
// panel implementation's own properties.
//
// Usage:
//   PanelController { id: panelController }
QtObject {
  id: root

  property bool open: false

  function toggle() { open = !open }
  function show() { if (!open) open = true }
  function hide() { open = false }
}
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

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function syncPluginBarApiObjects\|function bindPluginBarApi" -A30 plugins/bar/Bar.qml | head -80`

✓ 132 ms

```text
[exit 0, 115 ms]
124:  function bindPluginBarApi(api) {
125-    if (!api) return
126-    api.foreground = Qt.binding(function() { return root.foreground })
127-    api.barForeground = Qt.binding(function() { return root.barForeground })
128-    api.background = Qt.binding(function() { return root.background })
129-    api.urgent = Qt.binding(function() { return root.urgent })
130-    api.fontFamily = Qt.binding(function() { return root.fontFamily })
131-    api.position = Qt.binding(function() { return root.position })
132-    api.vertical = Qt.binding(function() { return root.vertical })
133-    api.barSize = Qt.binding(function() { return root.barSize })
134-    api.transparent = Qt.binding(function() { return root.transparent })
135-    api.foregroundAnimationEnabled = Qt.binding(function() { return root.foregroundAnimationEnabled })
136-    api.centerSectionRevealHeld = Qt.binding(function() { return root.centerSectionRevealHeld })
137-    api._centerHoverRevealSuppressed = Qt.binding(function() { return root.centerHoverRevealSuppressed })
138-    root.syncPluginBarApiObjects(api)
139-  }
140-
141:  function syncPluginBarApiObjects(api) {
142-    if (!api) return
143-    api.activePopout = root.pluginOwnsBarObject(api.pluginId, root.activePopout)
144-      ? root.activePopout : (root.activePopout ? api.foreignPopoutMarker : null)
145-    api.clickTargets = root.pluginClickTargets(api.pluginId)
146-    api.layoutConfig = root.publicLayoutConfig()
147-  }
148-
149-  function pluginObjectRecord(target) {
150-    for (var i = 0; i < pluginObjectOwners.length; i++) {
151-      var record = pluginObjectOwners[i]
152-      if (record && record.target === target) return record
153-    }
154-    return null
155-  }
156-
157-  function markPluginObject(pluginId, target, role) {
158-    var key = String(pluginId || "")
159-    if (!key || !target) return false
160-    var record = root.pluginObjectRecord(target)
161-    if (record && record.pluginId !== key) return false
162-    var next = []
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn "bar\.shell\|bar?\.shell\|barWidgetRegistry\|bar\.layoutConfig\|bar\.[a-zA-Z]*(" plugins/panels plugins/bar/widgets plugins/agents plugins/menu/BarWidget.qml plugins/services/media/BarWidget.qml 2>/dev/null | grep -o "bar[?]*\.[a-zA-Z]*\(\.[a-zA-Z]*\)\?" | sort `

✓ 113 ms

```text
[exit 0, 109 ms]
     10 bar.run
      9 bar.shell.updateEntryInline
      7 bar.shell
      4 bar.shell.summon
      3 bar.showTooltip
      3 bar.moduleWidgets
      3 bar.hideTooltip
      2 bar?.shell
      2 bar.switchPanelFrom
      2 bar.setCenterHoverRevealSuppressed
      2 bar.layoutConfig
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rhoE "\bbar\??\.[a-zA-Z_]+" plugins/panels plugins/bar/widgets plugins/bar/indicators plugins/agents plugins/menu/BarWidget.qml plugins/services/media/BarWidget.qml Ui | sort | uniq -c | sort -rn; grep -n "^  property\|^  readonly property\|^  function" plugins/bar`

✓ 78 ms

```text
[exit 0, 72 ms]
    168 bar.foreground
    110 bar.fontFamily
     20 bar.shell
     14 bar.urgent
     14 bar.position
     12 bar.run
      6 bar.switchPanelFrom
      6 bar.moduleWidgets
      6 bar.iconSlot
      6 bar.hideTooltip
      6 bar.barForeground
      5 bar?.shell
      4 bar.vertical
      4 bar.statusSlot
      4 bar.showTooltip
      4 bar.setCenterHoverRevealSuppressed
      4 bar.activePopout
      3 bar.centerHoverRevealSuppressed
      3 bar.barSize
      2 bar.targetBelongsToWindow
      2 bar.sizeHorizontal
      2 bar.requestPopout
      2 bar.releasePopout
      2 bar.layoutConfig
      2 bar.foregroundAnimationEnabled
      2 bar.clickTargets
      2 bar.background
      1 bar.x
      1 bar.iconFont
      1 bar.iconCanvas
      1 bar.centerSectionRevealHeld
155
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "listPlugins\|function pluginList\|dir:\|path:\|entryUrl\|barWidget\b" shell.qml services/PluginRegistry.qml | head -40; grep -n "omarchy.indicators\|omarchy.tray\|omarchy.workspaces" services/*.qml shell.qml | head`

✓ 53 ms

```text
[exit 0, 46 ms]
shell.qml:123:    path: shell.defaultsPath
shell.qml:136:    path: shell.userConfigPath
shell.qml:1395:      var url = shell.pluginRegistry.entryPointUrl(manifest, "barWidget")
shell.qml:1397:        console.warn("Plugin " + manifest.id + " has no barWidget entry point")
shell.qml:1400:      var meta = manifest.barWidget || {}
shell.qml:1665:    function listPlugins(): string {
services/PluginRegistry.qml:72:    if (manifest.barWidget !== undefined && Util.isPlainObject(manifest.barWidget)
services/PluginRegistry.qml:73:        && manifest.barWidget.defaultSection !== undefined) {
services/PluginRegistry.qml:74:      var defaultSection = String(manifest.barWidget.defaultSection)
services/PluginRegistry.qml:76:        console.warn("PluginRegistry: invalid barWidget.defaultSection at " + sourcePath)
services/PluginRegistry.qml:195:    var metadata = manifest && Util.isPlainObject(manifest.barWidget) ? manifest.barWidget : null
services/PluginRegistry.qml:270:    var anchors = { left: "omarchy.workspaces", center: "omarchy.weather", right: "omarchy.tray" }
shell.qml:48:        left: [{ id: "omarchy.menu" }, { id: "omarchy.workspaces" }],
shell.qml:361:      && !!metadata && String(metadata.clonedFrom || "") === "omarchy.indicators"
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1380,1440p shell.qml; sed -n 1660,1690p shell.qml; grep -n "function entryPointUrl" -A15 services/PluginRegistry.qml; grep -n "function scan\|find \|FolderListModel\|Process" services/PluginRegistry.qml | head`

✓ 76 ms

```text
[exit 0, 68 ms]

  function syncPluginWidgets() {
    var plugins = shell.pluginRegistry.installedPlugins
    var seen = ({})

    for (var pluginId in plugins) {
      var manifest = plugins[pluginId]
      if (!manifest || !manifest.kinds || manifest.kinds.indexOf("bar-widget") === -1) continue
      if (!shell.pluginRegistry.isEnabled(pluginId)) continue

      var registryKey = String(manifest.id)
      seen[registryKey] = true

      // Already loaded with matching source — leave it alone.
      var existing = pluginWidgetComponents[registryKey]
      var url = shell.pluginRegistry.entryPointUrl(manifest, "barWidget")
      if (!url) {
        console.warn("Plugin " + manifest.id + " has no barWidget entry point")
        continue
      }
      var meta = manifest.barWidget || {}
      meta = {
        displayName: meta.displayName || manifest.name,
        description: meta.description || manifest.description,
        category: meta.category || "Plugin",
        allowMultiple: meta.allowMultiple === true,
        defaults: meta.defaults || {},
        settingsForm: meta.settingsForm || "",
        schema: meta.schema || [],
        pluginId: manifest.id,
        sourceDir: manifest.__sourceDir || "",
        source: "plugin",
        firstParty: !!manifest.__isFirstParty
      }

      // A load already in flight for this URL registers itself when it
      // finishes. Starting a second one produces a second Component for the
      // same widget, and swapping a slot's component rebuilds its item —
      // briefly running two of the widget, each registering its IPC handler.
…
```

**⏺ bash** `ls /usr/bin/omarchy-plugin* /usr/share/omarchy/bin/omarchy-plugin* 2>/dev/null; omarchy plugin --help 2>&1 | head -30; ls /usr/share/omarchy/shell/plugins/dev-gallery`

✓ 436 ms

```text
[exit 0, 427 ms]
/usr/bin/omarchy-plugin-add
/usr/bin/omarchy-plugin-catalog
/usr/bin/omarchy-plugin-clone
/usr/bin/omarchy-plugin-disable
/usr/bin/omarchy-plugin-enable
/usr/bin/omarchy-plugin-list
/usr/bin/omarchy-plugin-remove
/usr/bin/omarchy-plugin-update
/usr/bin/omarchy-plugin-validate
/usr/share/omarchy/bin/omarchy-plugin-add
/usr/share/omarchy/bin/omarchy-plugin-catalog
/usr/share/omarchy/bin/omarchy-plugin-clone
/usr/share/omarchy/bin/omarchy-plugin-disable
/usr/share/omarchy/bin/omarchy-plugin-enable
/usr/share/omarchy/bin/omarchy-plugin-list
/usr/share/omarchy/bin/omarchy-plugin-remove
/usr/share/omarchy/bin/omarchy-plugin-update
/usr/share/omarchy/bin/omarchy-plugin-validate
Plugin commands — Omarchy shell plugin and bar widget management:
  omarchy plugin add [git-url] [--enable] [--yes]  Add a shell plugin from git
  omarchy plugin clone <source-id> [--edit]        Clone a built-in Omarchy shell plugin into your own config
  omarchy plugin disable <id>                      Disable a shell plugin
  omarchy plugin enable <id> [placement]           Enable a shell plugin
  omarchy plugin list [--json]                     List discovered shell plugins
  omarchy plugin remove [id] [--yes]               Remove an installed shell plugin
  omarchy plugin update [id] [--yes]               Update installed git-managed plugins
  omarchy plugin validate <plugin-folder>          Validate a plugin folder against the Omarchy plugin manifest schema
GalleryPanel.qml
manifest.json
```

**⏺ bash** `cat /usr/bin/omarchy-plugin-validate | head -150; cat /usr/share/omarchy/shell/plugins/panels/weather/manifest.json`

✓ 54 ms

```text
[exit 0, 48 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/BarWidget.qml | head -80; sed -n 1,80p plugins/panels/weather/BarWidget.qml`

✓ 72 ms

```text
[exit 0, 66 ms]
import QtQuick
import qs.Commons

// Base item every bar widget extends. Codifies the three properties the
// bar host injects into each widget slot:
//   bar         - the host Bar instance (foreground/background/run/etc).
//   moduleName  - widget's canonical id, used by the host registry to look
//                 up settings and to disambiguate inline IPC routes.
//   settings    - per-widget overrides read from shell.json's layout entry.
//
// Widgets are free to add their own properties, signals, and child items.
Item {
  id: root

  property QtObject bar: null
  property string moduleName: ""
  property var settings: ({})

  // Bar geometry, lifted off the host. Widgets read these constantly to pick
  // between horizontal/vertical layouts; defining them on the base keeps the
  // `bar ? bar.x : fallback` ternary out of every widget body.
  readonly property bool vertical: bar ? bar.vertical : false
  readonly property int barSize: bar ? bar.barSize : Style.bar.sizeHorizontal

  // Run `method` on every live instance of this widget. An IPC target only
  // ever routes to one handler, but a bar surface exists per monitor, so the
  // instance that owns the target relays the call to its peers — otherwise a
  // refresh would land on a single screen and leave the others stale.
  function broadcast(method) {
    var items = bar && typeof bar.moduleWidgets === "function"
      ? bar.moduleWidgets(moduleName) : [root]
    for (var i = 0; i < items.length; i++) {
      if (items[i] && typeof items[i][method] === "function") items[i][method]()
    }
  }

  // Read a single value from this widget's inline shell.json entry, with a
  // fallback for missing/null values. Every widget that takes user-tunable
  // settings needs this; defining it once on the base keeps the wiring
…
```

Now let me find the preview harness to see how plugins are loaded offline.

**⏺ bash** `ls -a; ls -a .config .config/omarchy; find / -name "preview.py" -not -path "*/proc/*" 2>/dev/null | head`

✓ 34223 ms

```text
[exit 0, 34215 ms]
.
..
.agents
.claude
.codex
.config
.git
.pi
.config:
.
..
alacritty
foot
ghostty
hypr
kitty
omarchy

.config/omarchy:
.
..
extensions
hooks
shell.json
themed
themes
~/Work/harness-0/fittings/omarchy-v4/preview/preview.py
```

**⏺ bash** `sed -n 1,200p ~/Work/harness-0/fittings/omarchy-v4/preview/preview.py`

✓ 54 ms

```text
[exit 0, 48 ms]
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
    for line in src.splitlines():
        s = line.strip()
        if depth == 1 and not s.startswith("//"):
            if s.startswith("default property alias"):
…
```

**⏺ bash** `cd ~/Work/harness-0/fittings/omarchy-v4/preview/; cat shell.qml FakeBar.qml | head -200`

✓ 142 ms

```text
[exit 0, 111 ms]
import QtQuick
import Quickshell
import qs.Commons

// Loads one plugin entry point (or, with no WIDGET, a stock bar strip) in an ordinary window,
// offscreen. Prints every string it drew as PREVIEW_TEXT lines and, for visual entries, saves
// a picture. Nothing is drawn on a display: QT_QPA_PLATFORM=offscreen.
ShellRoot {
  FakeBar { id: fakeBar }
  FloatingWindow {
    id: win
    implicitWidth: Number(Quickshell.env("PREVIEW_W") || 420); implicitHeight: 34
    Rectangle {
      id: frame; anchors.fill: parent; color: Color.bar.background
      Row {
        anchors.centerIn: parent; spacing: 14
        Loader { active: Quickshell.env("STRIP") === "1"; source: "file:///usr/share/omarchy/shell/plugins/panels/clock/BarWidget.qml"
                 onLoaded: { item.bar = fakeBar; item.settings = { "format": "ddd HH:mm" } } }
        Loader {
          id: loader
          active: (Quickshell.env("WIDGET") || "") !== ""
          source: Quickshell.env("WIDGET") || ""
          onStatusChanged: if (status === Loader.Error) console.warn("PREVIEW_LOAD_ERROR " + source)
          onLoaded: {
            if (item && ("bar" in item)) item.bar = fakeBar
            if (item && ("settings" in item)) item.settings = JSON.parse(Quickshell.env("SETTINGS") || "{}")
            if (item && ("moduleName" in item)) item.moduleName = Quickshell.env("MODULE") || ""
          }
        }
        Row { visible: Quickshell.env("STRIP") === "1"; spacing: 4; anchors.verticalCenter: parent.verticalCenter
          Repeater { model: [Color.accent, Color.foreground, Color.muted, Color.urgent]
            Rectangle { width: 14; height: 14; radius: 3; color: modelData } } }
      }
    }
    function texts(it, out) {
      if (!it) return out
      if (it.text !== undefined && it.visible !== false && String(it.text).trim() !== "") out.push(String(it.text))
      var kids = it.children || []
      for (var i = 0; i < kids.length; i++) texts(kids[i], out)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function entrySettings\|function entryId\|function canonicalWidgetId" -A14 plugins/bar/Bar.qml; cat plugins/bar/widgets/KeyboardLayout.manifest.json; grep -n "pluginShellForId" -A25 shell.qml | head -60`

✓ 111 ms

```text
[exit 0, 92 ms]
763:  function entrySettings(entry) {
764-    return BarModel.entrySettings(entry)
765-  }
766-
767:  function entryId(entry) {
768-    return BarModel.entryId(entry)
769-  }
770-
771-  function moduleString(entry, key, fallback) {
772-    return BarModel.moduleString(entry, key, fallback)
773-  }
774-
775-  function entryIndex(entries, name) {
776-    return BarModel.entryIndex(entries, name)
777-  }
778-
779-  function entriesBefore(entries, name) {
780-    return BarModel.entriesBefore(entries, name)
781-  }
--
787:  function canonicalWidgetId(name) {
788-    return Util.canonicalWidgetId(name)
789-  }
790-
791-  function expandPath(path) {
792-    return BarModel.expandPath(path, home)
793-  }
794-
795-  function customModuleSafeName(name) {
796-    return BarModel.customModuleSafeName(name)
797-  }
798-
799-  function customModuleType(entry) {
800-    return BarModel.customModuleType(entry)
801-  }
{
  "schemaVersion": 1,
  "id": "omarchy.keyboard-layout",
  "name": "Keyboard layout",
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function entrySettings\|function entryId" -A14 plugins/bar/BarModel.js; cat services/PluginShellApi.qml | head -120`

✓ 51 ms

```text
[exit 0, 45 ms]
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
20:function entryId(entry) {
21-  if (typeof entry === "string") return entry
22-  if (isPlainObject(entry)) {
23-    var id = entry["id"]
24-    if (id !== undefined && id !== null && String(id) !== "") return String(id)
25-  }
26-  return ""
27-}
28-
29-function pinTrayToInner(entries, section) {
30-  var trayEntry = null
31-  var result = []
32-  var values = Array.isArray(entries) ? entries : []
33-  for (var i = 0; i < values.length; i++) {
34-    if (entryId(values[i]) === "omarchy.tray") trayEntry = values[i]
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

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function scopedPluginShellForId" -A60 shell.qml`

✓ 105 ms

```text
[exit 0, 93 ms]
676:  function scopedPluginShellForId(pluginId) {
677-    var key = String(pluginId || "")
678-    var manifest = shell.pluginRegistry.installedPlugins[key]
679-    if (!manifest) return null
680-    if (!manifest.__isFirstParty) return shell.pluginShellFor(manifest)
681-    return shell.createScopedPluginShell(manifest, "hosted:" + key, false, false)
682-  }
683-
684-  function pluginShellForId(pluginId) {
685-    return shell.scopedPluginShellForId(pluginId)
686-  }
687-
688-  function pluginShellForBarEntry(ownerId, moduleName) {
689-    var owner = String(ownerId || "")
690-    var target = String(moduleName || "")
691-    if (!owner || !target) return null
692-    if (!shell.barEntryConfigured(target)) return null
693-    var cacheKey = owner + "::" + target
694-    if (_pluginBarEntryShellApis[cacheKey]) return _pluginBarEntryShellApis[cacheKey]
695-
696-    function owns(requestedId) {
697-      return shell.pluginRegistry.resolveEnabledId(String(requestedId || ""))
698-        === shell.pluginRegistry.resolveEnabledId(target)
699-    }
700-
701-    function currentManifest() {
702-      var id = shell.pluginRegistry.resolveEnabledId(target)
703-      return shell.pluginRegistry.installedPlugins[id] || null
704-    }
705-
706-    var api = pluginShellApiComponent.createObject(null, {
707-      pluginId: target,
708-      barConfig: shell.publicBarConfig(),
709-      _summon: function(requestedId, payloadJson) {
710-        if (!owns(requestedId)
711-            && !shell.pluginCloneMaySummon(currentManifest(), requestedId)) return false
712-        return shell.summon(shell.pluginRegistry.resolveEnabledId(requestedId), payloadJson)
713-      },
714-      _hide: function(requestedId) {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function barEntryConfigured\|function pluginShellFor(\|_barEntryShellLookup\|function pluginCloneMaySummon" -A12 shell.qml | head -120`

✓ 105 ms

```text
[exit 0, 96 ms]
372:  function pluginCloneMaySummon(manifest, requestedId) {
373-    var metadata = manifest && Util.isPlainObject(manifest.omarchy) ? manifest.omarchy : null
374-    var sourceId = metadata ? String(metadata.clonedFrom || "") : ""
375-    var allowed = {
376-      "omarchy.audio": ["omarchy.osd"],
377-      "omarchy.media": ["omarchy.osd"],
378-      "omarchy.monitor": ["omarchy.osd"],
379-      "omarchy.network": ["omarchy.speedtest", "omarchy.wifiqr"]
380-    }
381-    var targets = allowed[sourceId] || []
382-    return targets.indexOf(String(requestedId || "")) !== -1
383-  }
384-
--
396:  function barEntryConfigured(pluginId) {
397-    var location = shell.pluginRegistry.findEntryLocation(shell.shellConfig, pluginId)
398-    return location && location.kind === "bar"
399-  }
400-
401-  function barPluginMayControl(manifest, requestedId) {
402-    if (!shell.pluginHasBarCapabilities(manifest)) return false
403-    var id = shell.pluginRegistry.resolveEnabledId(String(requestedId || ""))
404-    var target = shell.pluginRegistry.installedPlugins[id]
405-    if (!target || shell.isAuthenticationService(target, id)) return false
406-    if (shell.barEntryConfigured(id)) return true
407-    var uiKinds = ["bar-widget", "panel", "overlay", "menu"]
408-    for (var i = 0; i < uiKinds.length; i++)
--
623:      _barEntryShellLookup: function(ownerId, moduleName) {
624-        return hasCurrentBarCapabilities()
625-          ? shell.pluginShellForBarEntry(cacheKey + ":" + ownerId, moduleName) : null
626-      },
627-      _summon: function(requestedId, payloadJson) {
628-        if (!shell.pluginOwnsTarget(key, requestedId)
629-            && !shell.barPluginMayControl(currentManifest(), requestedId)
630-            && !shell.pluginCloneMaySummon(currentManifest(), requestedId)) return false
631-        return shell.summon(shell.pluginRegistry.resolveEnabledId(requestedId), payloadJson)
632-      },
633-      _hide: function(requestedId) {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 120,300p Ui/PopupCard.qml`

✓ 121 ms

```text
[exit 0, 113 ms]
        var cx = 0;
        var cy = 0;
        if (root.bar.position === "top" || root.bar.position === "bottom") {
          cx = window.width / 2 - popupWidth / 2
          cy = root.bar.position === "bottom" ? -popupHeight - root.margin : window.height + root.margin
          cx = Math.max(root.margin, Math.min(cx, window.width - popupWidth - root.margin))
        } else {
          cx = root.bar.position === "left" ? window.width + root.margin : -popupWidth - root.margin
          cy = window.height / 2 - popupHeight / 2
          cy = Math.max(root.margin, Math.min(cy, window.height - popupHeight - root.margin))
        }

        popupAnchor.rect.x = Math.round(cx)
        popupAnchor.rect.y = Math.round(cy)
        return
      }

      var point = window.contentItem.mapFromItem(target, localX, localY)

      if (root.bar.position === "top" || root.bar.position === "bottom") {
        point.x = Math.max(root.margin, Math.min(point.x, window.width - popupWidth - root.margin))
      } else {
        point.y = Math.max(root.margin, Math.min(point.y, window.height - popupHeight - root.margin))
      }

      popupAnchor.rect.x = Math.round(point.x)
      popupAnchor.rect.y = Math.round(point.y)
    }
  }

  BorderSurface {
    id: card
    anchors.fill: parent
    color: Color.popups.background
    borderSpec: root.borderSpec
    padding: root.padding
    radius: Style.cornerRadius
    opacity: root.open ? 1.0 : 0

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn "HyprlandFocusGrab" -A4 --include=*.qml . | grep -v "^--$" | head -60`

✓ 524 ms

```text
[exit 0, 510 ms]
./Ui/PopupCard.qml:20:  // "click" — uses HyprlandFocusGrab so clicking outside dismisses the popup.
./Ui/PopupCard.qml-21-  // "hover" — passive overlay; the owning widget controls open via hover.
./Ui/PopupCard.qml-22-  property string triggerMode: "click"
./Ui/PopupCard.qml-23-
./Ui/PopupCard.qml-24-  readonly property var coordinatorKey: owner || root
./Ui/PopupCard.qml:82:  HyprlandFocusGrab {
./Ui/PopupCard.qml-83-    active: root.open && root.triggerMode === "click"
./Ui/PopupCard.qml-84-    windows: root.anchorWindow ? [root, root.anchorWindow] : [root]
./Ui/PopupCard.qml-85-    onCleared: root.close()
./Ui/PopupCard.qml-86-  }
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rln "PopupCard\|KeyboardPanel" plugins | head -30; sed -n 1,60p Ui/KeyboardPanel.qml`

✓ 127 ms

```text
[exit 0, 113 ms]
plugins/agents/Panel.qml
plugins/bar/widgets/Tray.qml
plugins/panels/audio/Panel.qml
plugins/panels/bluetooth/Panel.qml
plugins/panels/clock/BarWidget.qml
plugins/panels/clock/Panel.qml
plugins/panels/dropbox/Panel.qml
plugins/panels/monitor/Panel.qml
plugins/panels/network/Panel.qml
plugins/panels/power/Panel.qml
plugins/panels/tailscale/Panel.qml
plugins/panels/weather/BarWidget.qml
plugins/panels/weather/Panel.qml
plugins/services/media/BarWidget.qml
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons

// Layer-shell popup attached to a bar widget icon, designed for
// click-driven AND keyboard-driven panels (e.g. SUPER+CTRL+W summon).
//
// Built on PanelWindow with a brief WlrKeyboardFocus.Exclusive prime followed
// by OnDemand rather than PopupWindow (xdg-popup). The prime acquires focus
// both when the surface maps and when it reopens while still mapped for its
// fade-out. xdg-popups don't get that — they only receive keys after a
// click/hover routes focus through their parent surface — so keyboard-summoned
// popups fell flat without it.
//
// Exclusive would also grant map-time focus, but it makes Hyprland route
// *every* pointer event to the exclusive surface no matter which output
// the cursor is over, which leaves clicks on any other monitor unable to
// reach the dismissal surfaces below.
//
// API is a subset of Common.PopupCard: anchorItem, owner, bar, open,
// padding, margin, contentWidth/Height, centerOnBar, default contentItem.
// Missing on purpose (for now): triggerMode ("hover"), containsMouse.
//
// Positioning: full-screen layer-shell with the card placed inside at
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 60,260p Ui/KeyboardPanel.qml`

✓ 82 ms

```text
[exit 0, 75 ms]
  // mapped and child items have completed layout.
  property Item focusTarget: null

  default property alias contentItem: contentHolder.children

  readonly property var coordinatorKey: owner || root
  readonly property var anchorWindow: anchorItem ? anchorItem.QsWindow.window : null
  readonly property string barPos: bar ? bar.position : "top"

  function close() {
    if (owner && "close" in owner) owner.close()
    else root.open = false
  }

  function beginFocusPrime() {
    if (open && backingWindowVisible) focusPrimeTimer.restart()
  }

  // --- screen + lifetime ---------------------------------------------------

  screen: anchorWindow ? anchorWindow.screen : null
  visible: open || card.opacity > 0 || popoutSwitching
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  WlrLayershell.namespace: "omarchy-keyboard-panel"
  WlrLayershell.layer: WlrLayer.Overlay
  // Keyboard focus follows `open` (NOT `visible`). The window remains
  // mapped during the fade-out so the opacity animation has something to
  // animate, but keyboard/click ownership must release the moment the
  // logical close fires — otherwise the user is locked out for 140ms.
  //
  // Prime with Exclusive on every open, then settle on OnDemand. Hyprland
  // focuses OnDemand when a surface first maps, but not when an already-mapped
  // fade-out surface changes from None back to OnDemand. Exclusive also takes
  // focus when the previously focused application has constrained the pointer.
  // The brief prime covers both cases; OnDemand then releases compositor-wide
  // pointer hit-testing so clicks can reach the dismissal windows below.
  WlrLayershell.keyboardFocus: open
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 260,420p Ui/KeyboardPanel.qml`

✓ 204 ms

```text
[exit 0, 176 ms]

  Timer {
    id: popoutSwitchTimer
    interval: 150
    onTriggered: root.popoutSwitching = false
  }

  Timer {
    id: closeSwitchTimer
    interval: 1
    onTriggered: root.popoutSwitchClosing = false
  }

  // --- outside-click dismissal --------------------------------------------

  // Catches clicks anywhere in the clickable region (i.e. everywhere on
  // screen except the bar strip, which is masked out). The card has its
  // own MouseArea below so clicks on it don't bubble up here. Disabled
  // during the fade-out so the dying overlay doesn't swallow clicks that
  // were meant for the apps behind it.
  MouseArea {
    id: dismissArea
    anchors.fill: parent
    enabled: root.open
    acceptedButtons: Qt.AllButtons
    hoverEnabled: true
    property bool hoveringBar: false
    cursorShape: hoveringBar ? Qt.PointingHandCursor : Qt.ArrowCursor

    function inBarRegion(px, py) {
      if (root.barPos === "bottom") return py >= root.screenH - root._barStripSize
      if (root.barPos === "left") return px <= root._barStripSize
      if (root.barPos === "right") return px >= root.screenW - root._barStripSize
      return py <= root._barStripSize
    }

    function barPoint(px, py) {
      if (root.barPos === "bottom") return Qt.point(px, py - (root.screenH - root.barH))
      if (root.barPos === "right") return Qt.point(px - (root.screenW - root.barW), py)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn "broadcast(\|moduleWidgets(" plugins --include=*.qml | grep -v "function " | head; grep -n "function targetBelongsToWindow\|function targetWindow" -A10 plugins/bar/Bar.qml; grep -n "WlrLayershell.layer\|namespace" plugins/bar/Bar.qml`

✓ 190 ms

```text
[exit 0, 182 ms]
plugins/bar/widgets/Indicators.qml:172:      root.broadcast("refresh")
plugins/bar/widgets/SystemUpdate.qml:31:      root.broadcast("refresh")
plugins/bar/widgets/SystemUpdate.qml:35:      root.broadcast("clear")
plugins/bar/Bar.qml:264:          ? root.moduleWidgets(moduleName) : []
plugins/panels/bluetooth/Panel.qml:429:    var items = bar.moduleWidgets(moduleName)
plugins/panels/bluetooth/Panel.qml:573:    var items = bar && typeof bar.moduleWidgets === "function" ? bar.moduleWidgets(moduleName) : []
380:  function targetWindow(target) {
381-    return target && target.QsWindow ? target.QsWindow.window : null
382-  }
383-
384:  function targetBelongsToWindow(target, window) {
385-    return !!target && !!window && targetWindow(target) === window
386-  }
387-
388-  function slotWindow(slot) {
389-    if (!slot) return null
390-    return targetWindow(slot.activeItem) || targetWindow(slot)
391-  }
392-
393-  function sameWindow(left, right) {
394-    if (!left || !right) return false
1268:    WlrLayershell.namespace: "omarchy-bar"
1269:    WlrLayershell.layer: WlrLayer.Top
1412:    WlrLayershell.namespace: "omarchy-bar-drag-ghost"
1413:    WlrLayershell.layer: WlrLayer.Overlay
1474:    WlrLayershell.namespace: "omarchy-bar-move-ghost"
1475:    WlrLayershell.layer: WlrLayer.Overlay
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 420,440p plugins/panels/bluetooth/Panel.qml; sed -n 565,580p plugins/panels/bluetooth/Panel.qml; sed -n 20,40p plugins/bar/widgets/SystemUpdate.qml; sed -n 1234,1300p plugins/bar/Bar.qml`

✓ 218 ms

```text
[exit 0, 202 ms]
    }
  }

  // Another per-monitor instance of this widget whose panel is open, if any.
  // All instances share the default adapter, and switching the popout to a
  // different monitor closes one instance as it opens the next, so the
  // closing side has to leave the scan alone for the side still on screen.
  function openSibling() {
    if (!bar || typeof bar.moduleWidgets !== "function") return null
    var items = bar.moduleWidgets(moduleName)
    for (var i = 0; i < items.length; i++) {
      if (items[i] && items[i] !== root && items[i].opened === true) return items[i]
    }
    return null
  }

  function updateFocusedAddress() {
    var d = deviceAt(focusSection, selectedIndex)
    focusedDeviceAddress = d ? (d.address || "") : ""
  }

  }

  // A destroyed instance cannot wait for BlueZ confirmations, so it hands any
  // debt to a surviving sibling — whose declarative stop catches even a start
  // confirmed after this object is gone — and only writes the stop directly
  // when it is the last one standing.
  Component.onDestruction: {
    if (!owesDiscoveryStop) return
    var items = bar && typeof bar.moduleWidgets === "function" ? bar.moduleWidgets(moduleName) : []
    for (var i = 0; i < items.length; i++) {
      if (items[i] && items[i] !== root) { items[i].owesDiscoveryStop = true; return }
    }
    if (adapter !== null && adapter.discovering) adapter.discovering = false
  }

  Timer {
    if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation omarchy-update")
  }
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function canonicalWidgetId\|function fileUrl\|function isPlainObject" -A8 Commons/Util.qml | head -40; cat Commons/qmldir; grep -n "bar:\|statusSlot\|iconSlot\|sizeHorizontal\|popupPadding\|gapsOut\|function space\b\|function space(" Commons/Style.qml | head -20`

✓ 81 ms

```text
[exit 0, 75 ms]
42:  function fileUrl(path) {
43-    if (!path) return ""
44-    return "file://" + String(path).split("/").map(encodeURIComponent).join("/")
45-  }
46-
47-  // Single-quote a string for bash. The replace handles embedded single
48-  // quotes by closing, escaping, and re-opening the literal.
49-  function shellQuote(value) {
50-    return "'" + String(value || "").replace(/'/g, "'\\''") + "'"
--
66:  function isPlainObject(value) {
67-    return value !== null && typeof value === "object" && !Array.isArray(value)
68-  }
69-
70:  function canonicalWidgetId(id) {
71-    return String(id || "")
72-  }
73-
74-  // Best-effort base64 decode. Returns "" on parse failure rather than
75-  // surfacing garbage downstream.
76-  function decodeBase64(value) {
77-    var s = String(value || "")
78-    if (!s) return ""
module qs.Commons
singleton Border 1.0 Border.qml
singleton Color 1.0 Color.qml
singleton Style 1.0 Style.qml
singleton Util 1.0 Util.qml
11:// `cornerRadius` mirrors Hyprland's `decoration:rounding`. `gapsOut` is
32:  property int gapsOut: 5
219:  function space(px) {
260:    readonly property int popupPadding: root.spacingToken("popup-padding", 14)
341:  readonly property QtObject bar: QtObject {
342:    readonly property int sizeHorizontal: root.barToken("size-horizontal", 26)
344:    readonly property int iconSlot:       root.barToken("icon-slot",       27)
347:    readonly property int statusSlot:     root.barToken("status-slot",     21)
352:    gapsOutProc.running = true
375:      if (isFinite(n) && n >= 0) gapsOut = Math.max(0, Math.round(n / 2))
451:  property Process gapsOutProc: Process {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/BarIconButton.qml | head -40; grep -n "muted\|accent\|popups" Commons/Color.qml | head -12`

✓ 75 ms

```text
[exit 0, 68 ms]
import QtQuick
import Quickshell
import qs.Commons

WidgetButton {
  id: root

  property Component iconComponent: null
  property real slotSize: Style.bar.iconSlot
  property real opticalSize: Style.bar.iconCanvas
  property bool debugOpticalBounds: Quickshell.env("OMARCHY_DEBUG_BAR_ICONS") === "1"
  readonly property real opticalCenterErrorX: glyph.visible ? glyph.paintedCenterX - opticalCanvas.width / 2 : 0
  readonly property real glyphPaintedWidth: glyph.visible ? glyph.tightWidth : 0
  readonly property real glyphBaselineY: glyph.visible ? glyph.baselineY : 0
  readonly property int glyphFontSize: glyph.visible ? glyph.renderedFontSize : 0

  labelVisible: false
  hasVisualContent: text !== "" || iconComponent !== null
  fontSize: Style.bar.iconFont
  fixedWidth: vertical ? -1 : slotSize
  fixedHeight: vertical ? slotSize : -1

  Item {
    id: opticalCanvas
    anchors.centerIn: parent
    width: root.opticalSize
    height: root.opticalSize

    OpticalGlyph {
      id: glyph
      anchors.fill: parent
      visible: root.iconComponent === null
      text: root.text
      fontFamily: root.fontFamily
      fontSize: root.fontSize
      color: root.active && root.useActiveColor ? root.activeColor : root.foreground
      rotation: root.textRotation
      debugBounds: root.debugOpticalBounds
    }
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "chevron\|\\\\u[fe]\|text:" plugins/bar/widgets/Tray.qml | head -20; grep -rn "IpcHandler" -A2 plugins/panels/*/Panel.qml | grep target | head`

✓ 120 ms

```text
[exit 0, 111 ms]
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
503:            text: rowRoot.isHidden ? "Show" : "Hide"
574:            text: "\u2039"
587:            text: root.currentTitle
692:                text: menuRow.modelData.checkState === Qt.Checked ? "\uf00c" : ""
722:                text: menuRow.rowText
plugins/panels/bluetooth/Panel.qml:15:  // manageIpc: false so this panel can own the single IpcHandler the target
plugins/panels/bluetooth/Panel.qml-641-    target: "omarchy.bluetooth"
plugins/panels/dropbox/Panel.qml-159-    target: root.ipcTarget
plugins/panels/monitor/Panel.qml:15:  // manageIpc: false so this panel can own the single IpcHandler the target
plugins/panels/monitor/Panel.qml-221-    target: "omarchy.monitor"
plugins/panels/network/Panel.qml:15:  // manageIpc: false so this panel can own the single IpcHandler the target
plugins/panels/network/Panel.qml-211-    target: "omarchy.network"
plugins/panels/power/Panel.qml:13:  // manageIpc: false so this panel can own the single IpcHandler the target
plugins/panels/power/Panel.qml-178-    target: "omarchy.power"
plugins/panels/tailscale/Panel.qml-367-    target: root.ipcTarget
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rln '"schema"' plugins | head; grep -rh -A3 '"type":' plugins/*/manifest.json plugins/*/*/manifest.json plugins/bar/widgets/*.json | grep '"type"' | sort | uniq -c`

✓ 258 ms

```text
[exit 0, 248 ms]
plugins/agents/manifest.json
plugins/bar/widgets/Indicators.manifest.json
plugins/panels/dropbox/manifest.json
plugins/panels/tailscale/manifest.json
      1         "type": "boolean",
      2         "type": "integer",
      1         "type": "multiselect",
      1       { "key": "refreshIntervalSec", "type": "integer", "label": "Refresh interval (seconds)", "min": 30, "max": 3600, "step": 30, "defaultValue": 900 },
      1       { "key": "syncDeviceId", "type": "string", "label": "Device id", "defaultValue": "", "description": "Optional stable device name used inside synced aggregate snapshots." }
      1       { "key": "syncDir", "type": "path", "label": "Sync folder", "defaultValue": "", "description": "A folder synced by Syncthing, Dropbox, rsync, etc." },
      1       { "key": "syncFileName", "type": "string", "label": "Snapshot file name", "defaultValue": "", "description": "Optional. Defaults to <hostname>.json. Use a different file name on each machine, such as laptop.json or desktop.json." },
      1       { "key": "syncMode", "type": "enum", "label": "Synced aggregation", "options": ["Off", "On"], "defaultValue": "Off", "description": "When On, write this machine's local usage snapshot and merge snapshots from other machines." },
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "property\|function" Ui/BorderSurface.qml | head -30; grep -n "function surfaceSpec\|function localOrSurfaceSpec\|function flat" Commons/Border.qml`

✓ 93 ms

```text
[exit 0, 86 ms]
10:  property var borderSpec: Border.none()
11:  property real padding: 0
12:  property real topPadding: padding
13:  property real rightPadding: padding
14:  property real bottomPadding: padding
15:  property real leftPadding: padding
17:  readonly property real borderTop: Border.top(borderSpec)
18:  readonly property real borderRight: Border.right(borderSpec)
19:  readonly property real borderBottom: Border.bottom(borderSpec)
20:  readonly property real borderLeft: Border.left(borderSpec)
21:  readonly property real contentTopInset: borderTop + topPadding
22:  readonly property real contentRightInset: borderRight + rightPadding
23:  readonly property real contentBottomInset: borderBottom + bottomPadding
24:  readonly property real contentLeftInset: borderLeft + leftPadding
25:  readonly property bool usesOverlayBorder: Border.needsOverlay(borderSpec)
16:  function flat(color, width) {
105:  function localOrSurfaceSpec(section, token, localColor, defaultColor, fallbackWidth, alphaKey) {
140:  function surfaceSpec(section, token, fallbackColor, fallbackWidth, alphaKey) {
```

Writing the plugin files now.

**⏺ write** `.config/omarchy/plugins/parker.bar-drawer/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.bar-drawer",
  "name": "Bar drawer",
  "version": "1.0.0",
  "author": "parker",
  "description": "A drawer button that opens a panel holding the bar widgets you tucked away",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Drawer.qml"
  },
  "barWidget": {
    "displayName": "Bar drawer",
    "description": "Click to open a panel holding the widgets listed in this entry's \"items\"",
    "category": "Layout",
    "allowMultiple": true,
    "defaultSection": "right",
    "defaults": {
      "items": [],
      "autoClose": true,
      "autoCloseDelay": 900
    },
    "schema": [
      { "key": "icon", "type": "string", "label": "Button icon", "defaultValue": "", "description": "Optional glyph. Empty uses a chevron that points toward the drawer." },
      { "key": "autoClose", "type": "boolean", "label": "Close when the pointer leaves", "defaultValue": true },
      { "key": "autoCloseDelay", "type": "integer", "label": "Auto-close delay (ms)", "min": 200, "max": 10000, "step": 100, "defaultValue": 900 }
    ]
  }
}
```

✓ 6 ms

```text
wrote 1094 bytes to .config/omarchy/plugins/parker.bar-drawer/manifest.json
```

**⏺ write** `.config/omarchy/plugins/parker.bar-drawer/NestedBar.qml`

```
import QtQuick
import qs.Commons

// The `bar` object handed to a widget that lives inside the drawer. It mirrors
// the bar facade the drawer itself received and forwards every call to it, with
// two changes:
//   - requestPopout() tells the drawer that the request comes from one of its
//     own widgets, so the drawer stays open while that widget's panel is up;
//   - moduleWidgets() returns the drawer's live instances of the widget (the
//     host only knows widgets that sit directly in the bar).
QtObject {
  id: proxy

  property var host: null
  property var drawer: null
  property var drawerWindow: null
  property string moduleId: ""

  property color foreground: host ? host.foreground : Color.bar.text
  property color barForeground: host ? host.barForeground : Color.bar.text
  property color background: host ? host.background : Color.bar.background
  property color urgent: host ? host.urgent : Color.urgent
  property string fontFamily: host ? host.fontFamily : Style.font.family
  property string position: host ? host.position : "top"
  property bool vertical: host ? host.vertical : false
  property int barSize: host ? host.barSize : Style.bar.sizeHorizontal
  property bool transparent: false
  property bool foregroundAnimationEnabled: host ? host.foregroundAnimationEnabled !== false : true
  property bool centerSectionRevealHeld: false
  property bool centerHoverRevealSuppressed: host ? host.centerHoverRevealSuppressed === true : false
  property var shell: host ? host.shell : null
  property var activePopout: host ? host.activePopout : null
  property var clickTargets: host && host.clickTargets ? host.clickTargets : []
  property var layoutConfig: host && host.layoutConfig ? host.layoutConfig : ({})
  property var foreignPopoutMarker: host ? host.foreignPopoutMarker : null

  function run(command) { if (host) host.run(command) }
  function shellQuote(value) { return Util.shellQuote(value) }
  function showTooltip(target, text) { if (host) host.showTooltip(target, text) }
  function hideTooltip(target) { if (host) host.hideTooltip(target) }
  function registerClickTarget(target) { if (host && host.registerClickTarget) host.registerClickTarget(target) }
  function unregisterClickTarget(target) { if (host && host.unregisterClickTarget) host.unregisterClickTarget(target) }

  function requestPopout(owner) {
    if (!host) return
    if (drawer) drawer.beginNestedPopout(owner)
    host.requestPopout(owner)
    if (drawer) drawer.endNestedPopout()
  }

  function releasePopout(owner) { if (host) host.releasePopout(owner) }
  function switchPanelFrom(owner, direction) { return false }

  function targetBelongsToWindow(target, window) {
    return host && host.targetBelongsToWindow ? host.targetBelongsToWindow(target, window) : false
  }

  function moduleWidgets(id) {
    if (String(id || "") !== moduleId || !drawerWindow) return []
    return drawerWindow.widgetsFor(moduleId)
… (6 more lines in the repository)
```

✓ 1 ms

```text
wrote 3092 bytes to .config/omarchy/plugins/parker.bar-drawer/NestedBar.qml
```

**⏺ write** `.config/omarchy/plugins/parker.bar-drawer/DrawerWindow.qml`

```
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

// The drawer panel. A transparent layer-shell strip anchored to the same screen
// edge as the bar, spanning the bar plus the card below it. Only the card takes
// input (see `mask`), so the bar underneath stays clickable. Covering the bar's
// strip matters for the tucked widgets' own panels: they place themselves just
// past the edge of the window their button lives in, so with this geometry they
// open beyond the drawer instead of on top of it.
PanelWindow {
  id: win

  property var drawer: null
  property Item anchorItem: null
  property var entries: []

  readonly property var hostBar: drawer ? drawer.bar : null
  readonly property bool open: drawer ? drawer.opened === true : false
  readonly property string barPos: hostBar ? String(hostBar.position || "top") : "top"
  readonly property bool vertical: barPos === "left" || barPos === "right"
  readonly property int slotSize: hostBar && hostBar.barSize ? hostBar.barSize : Style.bar.sizeHorizontal
  readonly property var anchorWindow: anchorItem ? anchorItem.QsWindow.window : null
  readonly property real barThickness: anchorWindow
    ? (vertical ? anchorWindow.width : anchorWindow.height) : slotSize
  readonly property int gap: Style.gapsOut
  readonly property int edgeMargin: Style.gapsOut
  readonly property bool hovered: cardHover.hovered
  readonly property Item contentRoot: card
  readonly property bool empty: vertical ? widgetGrid.implicitHeight <= 0 : widgetGrid.implicitWidth <= 0

  function widgetsFor(id) {
    var out = []
    for (var i = 0; i < repeater.count; i++) {
      var slot = repeater.itemAt(i)
      if (slot && slot.widget && slot.entryId === id) out.push(slot.widget)
    }
    return out
  }

  function allWidgets() {
    var out = []
    for (var i = 0; i < repeater.count; i++) {
      var slot = repeater.itemAt(i)
      if (slot && slot.widget) out.push(slot.widget)
    }
    return out
  }

  screen: anchorWindow ? anchorWindow.screen : null
  visible: open || card.opacity > 0
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "parker-bar-drawer"
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  anchors {
… (125 more lines in the repository)
```

✓ 7 ms

```text
wrote 6538 bytes to .config/omarchy/plugins/parker.bar-drawer/DrawerWindow.qml
```

**⏺ write** `.config/omarchy/plugins/parker.bar-drawer/Drawer.qml`

```
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Bar drawer: a button that opens a panel holding the widgets listed in this
// entry's `items` in ~/.config/omarchy/shell.json, e.g.
//
//   { "id": "parker.bar-drawer",
//     "items": [ "omarchy.weather", { "id": "omarchy.clock", "format": "HH:mm" } ] }
//
// Each item is a widget id, or an object with an id plus that widget's usual
// settings. Move a widget's entry out of bar.layout when you tuck it away, so
// it is not shown twice.
BarWidget {
  id: root

  readonly property string pluginId: "parker.bar-drawer"

  property bool opened: false
  property bool everOpened: false
  property bool engaged: false
  property bool nestedRequestPending: false
  property var nestedOwner: null

  // id -> entry-point URL for every bar widget installed (built-in and user).
  property var catalog: ({})
  property bool catalogReady: false
  property var warned: ({})

  readonly property string barPos: bar ? String(bar.position || "top") : "top"
  readonly property bool autoClose: setting("autoClose", true) !== false
  readonly property int autoCloseDelay: Math.max(200, Number(setting("autoCloseDelay", 900)) || 900)

  // `items` normalised to [{ id, settings }], first occurrence of an id wins.
  readonly property var itemEntries: {
    var raw = setting("items", [])
    var list = Array.isArray(raw) ? raw : []
    var seen = ({})
    var out = []
    for (var i = 0; i < list.length; i++) {
      var item = list[i]
      var id = typeof item === "string" ? item : (Util.isPlainObject(item) ? String(item.id || "") : "")
      if (!id || seen[id]) continue
      if (id === root.pluginId || id === root.moduleName) continue  // no drawer inside a drawer
      seen[id] = true
      var settings = ({})
      if (Util.isPlainObject(item)) {
        for (var key in item) if (key !== "id") settings[key] = item[key]
      }
      out.push({ id: id, settings: settings })
    }
    return out
  }

  readonly property var resolvedEntries: {
    var out = []
    if (!catalogReady) return out
    for (var i = 0; i < itemEntries.length; i++) {
… (224 more lines in the repository)
```

✓ 1 ms

```text
wrote 9731 bytes to .config/omarchy/plugins/parker.bar-drawer/Drawer.qml
```

**⏺ bash** `cd .config/omarchy && cp shell.json shell.json.bak.$(date +%s) && python3 - <<'EOF'
import json
p='shell.json'; c=json.load(open(p))
L=c['bar']['layout']
tuck=["omarchy.weather","omarchy.keyboard-layout","omarchy.agents","omarchy.bluetooth","omarchy.monitor"]
moved=[]
for s in ('left','center','righ`

✓ 2319 ms

```text
[exit 0, 2302 ms]
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
          "id": "omarchy.system-update"
        }
      ],
      "right": [
        {
          "id": "omarchy.tray"
        },
        {
          "id": "parker.bar-drawer",
          "items": [
            {
              "id": "omarchy.weather"
            },
            {
              "id": "omarchy.keyboard-layout"
            },
…
```

**⏺ check** `build`

✗ 4524 ms

```text
[exit 1, 4469 ms]
plugin parker.bar-drawer  (~/.config/omarchy/plugins/parker.bar-drawer)
  barWidget: Drawer.qml: errors; drew no text
    picture: ~/.h0-preview/parker.bar-drawer-barWidget.png
    WARN scene: file://~/.config/omarchy/plugins/parker.bar-drawer/Drawer.qml[277:7]: Type DrawerWindow unavailable
    WARN scene: file://~/.config/omarchy/plugins/parker.bar-drawer/DrawerWindow.qml[13:1]: No PanelWindow backend loaded.
    WARN qml: PREVIEW_LOAD_ERROR file://~/.config/omarchy/plugins/parker.bar-drawer/Drawer.qml
PREVIEW: FAILED
```

**⏺ edit** `.config/omarchy/plugins/parker.bar-drawer/Drawer.qml`

```
    // Loaded by URL on first open, so the layer-shell window is only compiled
    // and created once it is needed.
    active: root.everOpened
    source: root.everOpened ? Qt.resolvedUrl("DrawerWindow.qml") : ""
    onLoaded: {
      item.drawer = root
      item.anchorItem = button
      item.entries = Qt.binding(function() { return root.resolvedEntries })
    }
    onStatusChanged: if (status === Loader.Error) console.warn("parker.bar-drawer: could not load DrawerWindow.qml")
  }
```

✓ 14 ms

```text
edited .config/omarchy/plugins/parker.bar-drawer/Drawer.qml at line 275

[harness note] Read /usr/share/omarchy/default/agents/skills/omarchy/plugins.md first. Bar is omarchy-shell, not Waybar; idle values are seconds. A new plugin goes in .config/omarchy/plugins/<id>/ with a manifest.json; read a built-in plugin's source under /usr/share/omarchy/shell/plugins/ for the patterns, and switch a plugin on by adding its id to shell.json (bar.layout for widgets, plugins for others). Run the validate and preview checks before finishing. Never edit packaged plugins.
```

**⏺ check** `build`

✓ 4654 ms

```text
[exit 0, 4639 ms]
plugin parker.bar-drawer  (~/.config/omarchy/plugins/parker.bar-drawer)
  barWidget: Drawer.qml: loaded; drew: 
    picture: ~/.h0-preview/parker.bar-drawer-barWidget.png
PREVIEW: ok
```

Preview only exercises the bar button. Let me drive the drawer itself offscreen (catalog scan, open, nested widgets) with a temporary harness that swaps the layer-shell window for a plain window.

**⏺ bash** `set -e; P=~/Work/harness-0/fittings/omarchy-v4/preview; T=$(mktemp -d); cp -r .config/omarchy/plugins/parker.bar-drawer $T/pl
sed -i -e 's/^PanelWindow {/FloatingWindow {/' -e '/WlrLayershell/d' -e '/exclusionMode/d' -e '/^  anchors {/,/^  }/d' -e '/mask: Region/d' -e 's/^  screen:.*//' $T/pl/Drawer`

✓ 4496 ms

```text
[exit 0, 4478 ms]
  WARN: This plugin does not support setting window masks
  WARN qml: parker.bar-drawer: nope.bogus: unknown widget id
  INFO qml: T catalog=20 resolved=omarchy.weather,omarchy.keyboard-layout,omarchy.bluetooth,omarchy.monitor,omarchy.agents
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
  WARN quickshell.bluetooth: Could not connect to DBus. Bluetooth integration is not available.
 ERROR quickshell.service.pipewire.loop: Failed to connect pipewire context. Errno: 112
  WARN: This plugin does not support setting window masks
  INFO qml: T opened=true win=true widgets=omarchy.weather:false:21,omarchy.keyboard-layout:false:12,omarchy.bluetooth:false:27,omarchy.monitor:true:27,omarchy.agents:false:27 card=39x38
  INFO qml: T mw=1
  INFO qml: T after foreign opened=false
```

The drawer logic works offscreen: it finds 20 installed widgets, resolves my 5 items, loads them into the panel, and closes when another popup takes over. Last checks:

**⏺ check** `validate`

✓ 172 ms

```text
[exit 0, 167 ms]
valid: .config/omarchy/plugins/parker.bar-drawer/
```

**⏺ check** `json`

✓ 259 ms

```text
[exit 0, 250 ms]
```

I built the drawer plugin and turned it on in your bar. It passes the project's checks and an offscreen test, but I couldn't run it on your real desktop, so nobody has clicked it yet.

**How it works:** a chevron button sits in the bar, next to the tray. Click it and a panel slides out under it showing your tucked-away widgets. Click any of those and its normal popup opens, with the drawer staying open behind it. The drawer closes when you:
- click the button again,
- open any other bar popup, or
- move the pointer away for about 0.9s, but only once it has been over the drawer.

It works with the bar on any edge.

**Choosing what goes in the drawer** — this is the drawer's entry in `.config/omarchy/shell.json`:
```json
{ "id": "parker.bar-drawer",
  "items": [ {"id":"omarchy.weather"}, {"id":"omarchy.keyboard-layout"},
             {"id":"omarchy.agents"}, {"id":"omarchy.bluetooth"}, {"id":"omarchy.monitor"} ],
  "autoClose": true, "autoCloseDelay": 900 }
```
I picked those five as a starting point and moved them out of `bar.layout`; change the list however you like. Each item can be just a widget id (`"omarchy.weather"`) or an object with the widget's usual settings (`{"id":"omarchy.clock","format":"HH:mm"}`). When you tuck a widget away, delete its entry from `bar.layout` so it doesn't show twice; the plugin logs a warning if you forget. It also warns about ids it doesn't recognise. Your bar now shows menu and workspaces on the left, indicators, clock and system-update in the middle, and tray, drawer, network, audio and power on the right. The file reloads on save, and your original is backed up as `shell.json.bak.<timestamp>`.

**Files** (in `.config/omarchy/plugins/parker.bar-drawer/`):
- `manifest.json`
- `Drawer.qml`: the button, open/close behaviour, and the lookup of installed widgets (built-in and your own plugins)
- `DrawerWindow.qml`: the panel
- `NestedBar.qml`: passes the bar connection through to the tucked widgets, and keeps the drawer open while one of them has its popup up

**Checks:**
- The `build`, `validate` and `json` checks all pass.
- I also ran a temporary offscreen test that opens the drawer. It found the tucked widgets and loaded them into the panel. Tucked widgets could find their own copies, and opening another popup closed the drawer. An unknown id produced a warning.
- What I couldn't check: the panel's actual position on screen, clicks reaching the bar underneath it, and tucked widgets' popups opening just beyond the drawer. That needs Hyprland, so please try it and tell me if anything is misplaced. If it doesn't appear, run `omarchy-shell shell rescanPlugins`.

**Limitations, because widgets in the drawer run through your plugin rather than the bar itself:**
- **No hover tooltips** for tucked widgets.
- **No volume/brightness pop-up display** (the on-screen display) when you scroll on tucked audio or monitor widgets. The shell's permissions block plugins from showing it.
- **Shortcuts that open a tucked widget's panel** (e.g. bluetooth or monitor) won't work until you've opened the drawer once per session. The tucked widgets only load on first open.
- **Your tucked widgets' popups:** the drawer stays open while one is up, but I haven't checked where they appear.
- **`"type": "command"` / `"type": "qml"` custom modules** aren't supported in the drawer yet.
- **Keyboard shortcut:** none yet, but I can add one, since the drawer responds to `omarchy-shell shell toggle parker.bar-drawer '{}'`.

*harness: verify check `build` passed*

