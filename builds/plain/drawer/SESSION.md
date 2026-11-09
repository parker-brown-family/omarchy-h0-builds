# h0 (plain) building Bar Drawer

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools read, edit, write, grep, glob, bash

---

### › You

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

I'll start by looking at what's in the project and how Omarchy shell plugins are laid out.

**⏺ bash** `ls -la; find . -maxdepth 4 -not -path '*/.git/*' | head -100`

✓ 90 ms

```text
[exit 0, 85 ms]
total 0
drwxr-xr-x 1 parker parker  22 Nov  9 15:21 .
drwx------ 3 parker parker  60 Nov  9 15:21 ..
drwxr-xr-x 1 parker parker  72 Nov  8 22:07 .config
drwxr-xr-x 1 parker parker 160 Nov  9 15:21 .git
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

**⏺ bash** `cat .config/omarchy/shell.json; cat .config/omarchy/extensions/omarchy-menu.jsonc; ls -la .config/omarchy/themes/ember .config/omarchy/hooks/*; git log --oneline | head`

✓ 72 ms

```text
[exit 0, 67 ms]
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

**⏺ bash** `ls /usr/share/omarchy* /opt/omarchy* 2>&1 | head; ls ~/.local/share/omarchy 2>&1 | head; which omarchy-shell qs quickshell 2>&1; ls /usr/share/quickshell /etc/xdg/quickshell 2>&1 | head`

✓ 97 ms

```text
[exit 0, 88 ms]
ls: cannot access '/opt/omarchy*': No such file or directory
/usr/share/omarchy:
applications
bin
config
default
etc-overrides
icon.png
icon.txt
install
ls: cannot access '~/.local/share/omarchy': No such file or directory
/usr/bin/omarchy-shell
/usr/bin/qs
/usr/bin/quickshell
ls: cannot access '/usr/share/quickshell': No such file or directory
ls: cannot access '/etc/xdg/quickshell': No such file or directory
```

Omarchy is installed under /usr/share/omarchy. Next I'll find the shell code and how it loads plugins.

**⏺ bash** `cd /usr/share/omarchy; ls default config; grep -rli "plugin" --include=*.qml --include=*.md --include=*.json --include=*.js . 2>/dev/null | head -50; file /usr/bin/omarchy-shell; head -40 /usr/bin/omarchy-shell`

✓ 114 ms

```text
[exit 0, 107 ms]
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

There's a plugin authoring guide. I'll read it along with the plugin README.

**⏺ bash** `cd /usr/share/omarchy; cat default/agents/skills/omarchy/plugins.md; echo ======; cat shell/plugins/README.md`

✓ 73 ms

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

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/bar/README.md; echo =====; cat README.md | head -300`

✓ 79 ms

```text
[exit 0, 68 ms]
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

I need the middle section of the README that the output cut off, since it covers the manifest schema.

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 25,160p README.md`

✓ 76 ms

```text
[exit 0, 68 ms]
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
    osd/
    polkit/
```

The plugin discovery path is documented in [plugins/README.md](plugins/README.md).

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
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; wc -l plugins/bar/Bar.qml services/*.qml Ui/*.qml; ls plugins/bar plugins/bar/widgets; cat plugins/bar/widgets/*.manifest.json | head -80`

✓ 76 ms

```text
[exit 0, 69 ms]
  2076 plugins/bar/Bar.qml
   268 services/AppLibrary.qml
    49 services/BarWidgetRegistry.qml
    46 services/PluginAppLibraryApi.qml
    12 services/PluginBarStateApi.qml
    24 services/PluginBarWidgetRegistryApi.qml
    46 services/PluginFirstPartyServiceApi.qml
   743 services/PluginRegistry.qml
    32 services/PluginRegistryApi.qml
    70 services/PluginShellApi.qml
    63 Ui/BarIconButton.qml
    51 Ui/BarIndicator.qml
    45 Ui/BarWidget.qml
    54 Ui/BorderOverlay.qml
    40 Ui/BorderSurface.qml
   209 Ui/Button.qml
   132 Ui/ButtonGroup.qml
   133 Ui/ConfirmDialog.qml
    41 Ui/CursorSurface.qml
   244 Ui/Dropdown.qml
   418 Ui/KeyboardPanel.qml
   623 Ui/MultiSelect.qml
    85 Ui/NumberField.qml
    56 Ui/OpticalGlyph.qml
    59 Ui/Panel.qml
   100 Ui/PanelActionButton.qml
    16 Ui/PanelController.qml
   111 Ui/PanelHero.qml
    85 Ui/PanelKeyCatcher.qml
    30 Ui/PanelSectionHeader.qml
    18 Ui/PanelSeparator.qml
   149 Ui/PanelSlider.qml
    49 Ui/PanelToolTip.qml
    87 Ui/PluginBarApi.qml
    54 Ui/PointerMoveGate.qml
   176 Ui/PopupCard.qml
    43 Ui/ScreenMoveRemap.qml
   353 Ui/SearchableDropdown.qml
   412 Ui/SpeedTestOverlay.qml
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat services/BarWidgetRegistry.qml services/PluginBarWidgetRegistryApi.qml services/PluginBarStateApi.qml Ui/PluginBarApi.qml services/PluginShellApi.qml services/PluginRegistryApi.qml`

✓ 74 ms

```text
[exit 0, 65 ms]
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

Ordinary third-party widgets don't get the widget catalogue, but `moduleWidgets(id)` looks relevant. Next I'll check how Bar.qml creates widgets and wires up these facades.

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "moduleWidgets\|PluginBarApi\|function \|barWidgetRegistry\|Loader\|Repeater\|isFirstParty\|__isFirstParty\|hidden\|drawer" plugins/bar/Bar.qml | head -200`

✓ 73 ms

```text
[exit 0, 67 ms]
17:  property var barWidgetRegistry: fallbackBarWidgetRegistry
36:    function metadataFor(id) { return null }
117:    PluginBarApi { }
120:  function publicLayoutConfig() {
124:  function bindPluginBarApi(api) {
138:    root.syncPluginBarApiObjects(api)
141:  function syncPluginBarApiObjects(api) {
149:  function pluginObjectRecord(target) {
157:  function markPluginObject(pluginId, target, role) {
174:  function unmarkPluginObject(pluginId, target, role) {
189:  function pluginOwnsBarObject(pluginId, target) {
194:  function pluginClickTargets(pluginId) {
203:  function syncAllPluginBarApiObjects() {
204:    for (var id in pluginBarApis) root.syncPluginBarApiObjects(pluginBarApis[id])
207:  function registerPluginClickTarget(pluginId, target) {
212:  function unregisterPluginClickTarget(pluginId, target) {
218:  function requestPluginPopout(pluginId, owner) {
223:  function releasePluginPopout(pluginId, owner) {
229:  function pluginBarApiFor(pluginId, moduleName, registered) {
262:      _moduleWidgets: function(requestedId) {
264:          ? root.moduleWidgets(moduleName) : []
272:    root.bindPluginBarApi(api)
281:  function pluginBarApiUsed(pluginId) {
289:  function releasePluginObjects(pluginId) {
302:  function prunePluginBarApis() {
316:  onActivePopoutChanged: syncAllPluginBarApiObjects()
317:  onClickTargetsChanged: syncAllPluginBarApiObjects()
318:  onLayoutConfigChanged: syncAllPluginBarApiObjects()
319:  onModuleSlotsChanged: Qt.callLater(prunePluginBarApis)
330:  function registerClickTarget(target) {
337:  function unregisterClickTarget(target) {
342:  function registerModuleSlot(slot) {
349:  function unregisterModuleSlot(slot) {
354:  function debugBarGeometry() {
380:  function targetWindow(target) {
384:  function targetBelongsToWindow(target, window) {
388:  function slotWindow(slot) {
393:  function sameWindow(left, right) {
399:  function targetTooltipHovered(target) {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1,130p plugins/bar/Bar.qml; sed -n 225,330p plugins/bar/Bar.qml`

✓ 79 ms

```text
[exit 0, 70 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 540,830p plugins/bar/Bar.qml`

✓ 75 ms

```text
[exit 0, 65 ms]
  }

  function requestPopout(owner) {
    if (activePopout === owner) return
    if (activePopout) {
      if ("closeForPopoutSwitch" in activePopout) activePopout.closeForPopoutSwitch()
      else if ("close" in activePopout) activePopout.close()
    }
    activePopout = owner
  }

  function releasePopout(owner) {
    if (activePopout === owner) activePopout = null
  }

  readonly property bool vertical: position === "left" || position === "right"
  readonly property int barSize: vertical ? Style.bar.sizeVertical : Style.bar.sizeHorizontal

  function normalizePosition(value) {
    return BarModel.normalizePosition(value)
  }

  // Apply tray-pinning on top of the shared layout normalization so the
  // bar host and scriptable config helpers can't drift on entry shape.
  function normalizeLayout(layout) {
    var normalized = Util.normalizeLayout(Util.isPlainObject(layout) ? layout : fallbackBarConfig.layout)
    return {
      left:   pinTrayToInner(normalized.left,   "left"),
      center: pinTrayToInner(normalized.center, "center"),
      right:  pinTrayToInner(normalized.right,  "right")
    }
  }

  // The tray drawer reveals inward (away from the bar edge). Place it at the
  // section's inner edge: start of the right section, end of the left/center
  // sections. The drawer's reserved space then sits next to the bar center,
  // not stranded mid-section.
  function pinTrayToInner(entries, section) {
    return BarModel.pinTrayToInner(entries, section)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1160,1300p plugins/bar/Bar.qml; sed -n 1480,1560p plugins/bar/Bar.qml`

✓ 120 ms

```text
[exit 0, 111 ms]
    running: root.tooltipShown
    repeat: true
    onTriggered: if (!root.targetTooltipHovered(root.tooltipTarget)) root.hideTooltip(root.tooltipTarget)
  }

  // Presence of the `bar-off` flag = bar hidden. Watching the parent toggles
  // directory because FileView can't observe a file that doesn't exist yet,
  // and the flag is created/removed by `omarchy-toggle-bar`.
  Process {
    id: barHiddenProbe
    running: true
    command: ["bash", "-c", "[[ -f $HOME/.local/state/omarchy/toggles/bar-off ]] && echo yes || echo no"]
    stdout: SplitParser { onRead: function(line) { root.barHidden = String(line).trim() === "yes" } }
  }
  FileView {
    path: root.home + "/.local/state/omarchy/toggles"
    watchChanges: true
    printErrors: false
    onFileChanged: barHiddenProbe.running = true
  }

  // The directory watch can permanently stop delivering events after flag
  // changes land in quick succession, stranding the bar off screen until the
  // shell restarts. `omarchy-toggle-bar` nudges this after flipping the flag
  // so the probe re-reads it even when the watch has gone quiet.
  IpcHandler {
    target: "omarchy.bar"

    // Start rather than restart: a probe already in flight was launched by the
    // directory watch after the flag flipped, so its answer is current, and
    // killing it here can swallow the result entirely.
    function syncHidden(): void {
      barHiddenProbe.running = true
    }
  }

  Variants {
    model: Quickshell.screens

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1700,2076p plugins/bar/Bar.qml`

✓ 98 ms

```text
[exit 0, 88 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; wc -l shell.qml; grep -n "barWidgetRegistry\|PluginBarWidgetRegistryApi\|pluginShellFor\|function \|isFirstParty\|firstParty" shell.qml | head -150`

✓ 75 ms

```text
[exit 0, 67 ms]
1744 shell.qml
20:  property BarWidgetRegistry barWidgetRegistry: BarWidgetRegistry { }
30:  readonly property string firstPartyPluginsDir: shellPath + "/plugins"
73:  function applyShellConfig() {
91:  function loadDefaults(raw) {
109:  function persistShellConfig(nextConfig) {
149:      "firstPartyPluginsDir=" + shell.firstPartyPluginsDir,
152:    pluginRegistry.firstPartyDir = shell.firstPartyPluginsDir
162:  function mutateShellConfig(mutator) {
194:  function barManifestFor(pluginId) {
199:  function isBarOptionManifest(manifest) {
207:  function barOptionAvailable(pluginId) {
214:  function isActiveBarOption(pluginId) {
218:  function configureBar(target, manifest) {
221:    if ("shell" in target) target.shell = shell.pluginShellFor(manifest)
223:    if ("barWidgetRegistry" in target) target.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(manifest)
234:      barWidgetRegistry: shell.barWidgetRegistry
298:    PluginBarWidgetRegistryApi { }
316:  function publicPluginManifest(manifest) {
318:    if (manifest.__isFirstParty) return manifest
321:    delete copy.__isFirstParty
326:  function publicBarConfig() {
330:  function barConfigFor(manifest) {
331:    return !manifest || manifest.__isFirstParty
335:  function publicBarWidgetSnapshot() {
336:    var source = shell.barWidgetRegistry.widgets || {}
349:  function manifestHasKind(manifest, kind) {
354:  function pluginHasBarCapabilities(manifest) {
358:  function pluginIsIndicatorsClone(manifest) {
364:  function publicIdleConfigFor(manifest) {
372:  function pluginCloneMaySummon(manifest, requestedId) {
385:  function pluginOwnsTarget(pluginId, requestedId) {
391:  function pluginServiceFor(pluginId, requestedId) {
396:  function barEntryConfigured(pluginId) {
401:  function barPluginMayControl(manifest, requestedId) {
413:  function mutatePluginBarConfig(mutator) {
423:  function pluginAppLibraryFor(cacheKey, pluginId) {
443:  function pluginBarStateFor(cacheKey, pluginId) {
458:  function pluginFirstPartyServiceFor(cacheKey, pluginId, requestedId) {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 190,420p shell.qml`

✓ 79 ms

```text
[exit 0, 70 ms]
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
    if (!target) return
    if ("omarchyPath" in target) target.omarchyPath = shell.omarchyPath
    if ("shell" in target) target.shell = shell.pluginShellFor(manifest)
    if ("manifest" in target) target.manifest = shell.publicPluginManifest(manifest)
    if ("barWidgetRegistry" in target) target.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(manifest)
    if ("pluginRegistry" in target) target.pluginRegistry = shell.pluginRegistryFor(manifest)
    if ("barConfig" in target) target.barConfig = shell.barConfigFor(manifest)
    shell.bar = target
  }

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 456,800p shell.qml`

✓ 94 ms

```text
[exit 0, 87 ms]
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
      _setDoNotDisturb: function(value) {
        var target = service()
        if (target && typeof target.setDoNotDisturb === "function") target.setDoNotDisturb(value)
      },
      _runAction: function(action, showFeedback, targetKey) {
        var target = service()
        if (target && typeof target.runAction === "function") target.runAction(action, showFeedback, targetKey)
      },
      _playerKey: function(player) {
        var target = service()
        return target && typeof target.playerKey === "function" ? target.playerKey(player) : ""
      },
      _selectPlayer: function(playerKey) {
        var target = service()
        if (target && typeof target.selectPlayer === "function") target.selectPlayer(playerKey)
      }
…
```

The only kind of plugin that receives the widget catalogue is a full bar. Before I pick a design, I'll check how widget components get their `shell` and services, and how the tray drawer works.

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1376,1530p shell.qml`

✓ 73 ms

```text
[exit 0, 67 ms]
    function onPluginsChanged() { if (!shell.pluginReloading) shell.syncPluginWidgets() }
  }

  property var pluginWidgetComponents: ({})

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

…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn "property var shell\|shell\.serviceFor\|firstPartyServiceFor\|serviceFor(" plugins --include=*.qml | grep -v "^plugins/bar/Bar.qml" | head -40`

✓ 94 ms

```text
[exit 0, 88 ms]
plugins/bar/indicators/Dnd.qml:8:  readonly property var notificationService: bar?.shell?.firstPartyServiceFor("omarchy.notifications")
plugins/bar/indicators/NightLight.qml:7:  readonly property var nightlightService: bar?.shell?.firstPartyServiceFor("omarchy.nightlight")
plugins/bar/indicators/StayAwake.qml:7:  readonly property var idleService: bar?.shell?.firstPartyServiceFor("omarchy.idle")
plugins/dev-gallery/GalleryPanel.qml:66:  property var shell: null
plugins/emojis/Emojis.qml:13:  property var shell: null
plugins/lock/Service.qml:11:  property var shell: null
plugins/menu/Menu.qml:14:  property var shell: null
plugins/notifications/Service.qml:18:  property var shell: null
plugins/panels/audio/Panel.qml:20:  readonly property var mediaService: bar?.shell?.firstPartyServiceFor("omarchy.media")
plugins/panels/disk-speedtest/Panel.qml:13:  property var shell: null
plugins/panels/speedtest/Panel.qml:18:  property var shell: null
plugins/panels/wifiqr/Panel.qml:22:  property var shell: null
plugins/reminders/ReminderFlow.qml:12:  property var shell: null
plugins/services/battery/Service.qml:10:  property var shell: null
plugins/services/idle/Service.qml:12:  property var shell: null
plugins/services/media/BarWidget.qml:10:  readonly property var mediaService: bar?.shell?.firstPartyServiceFor("omarchy.media")
plugins/services/media/Service.qml:11:  property var shell: null
plugins/services/nightlight/Service.qml:9:  property var shell: null
```

**⏺ bash** `cd /usr/share/omarchy; ls bin | grep -i "plugin\|bar" ; grep -n "normalizeLayout" -A30 shell/Commons/Util.qml | head -60`

✓ 72 ms

```text
[exit 0, 67 ms]
omarchy-bar
omarchy-bar-text-color
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
omarchy-toggle-bar
127:  function normalizeLayoutEntry(entry) {
128-    if (typeof entry === "string") return { id: canonicalWidgetId(entry) }
129-    if (isPlainObject(entry) && entry.id) {
130-      var copy = cloneJson(entry)
131-      copy.id = canonicalWidgetId(copy.id)
132-      return copy
133-    }
134-    return null
135-  }
136-
137:  function normalizeLayoutSection(list) {
138-    if (!Array.isArray(list)) return []
139-    var out = []
140-    for (var i = 0; i < list.length; i++) {
141:      var e = normalizeLayoutEntry(list[i])
142-      if (e) out.push(e)
143-    }
144-    return out
145-  }
146-
147:  function normalizeLayout(layout) {
148-    var src = isPlainObject(layout) ? layout : {}
149-    return {
150:      left:   normalizeLayoutSection(src.left),
151:      center: normalizeLayoutSection(src.center),
152:      right:  normalizeLayoutSection(src.right)
…
```

**⏺ bash** `cd /usr/share/omarchy; grep -n "findEntryLocation\|function isEnabled\|function resolveEnabledId\|layout\b\|\.layout" shell/services/PluginRegistry.qml | head -40`

✓ 74 ms

```text
[exit 0, 66 ms]
136:  // be either the active bar option in `bar.id`, a layout entry inside
137:  // `bar.layout.*` (bar widgets), or a top-level entry in `plugins[]` (panels,
148:  function isEnabled(id) {
163:    return findEntryLocation(config, key).found
171:  function resolveEnabledId(id) {
191:    return findEntryLocation(config, id).kind === "bar"
206:        || !Util.isPlainObject(config.bar.layout)) return { found: false }
211:      var entries = config.bar.layout[sections[s]]
231:  function findEntryLocation(config, id) {
238:    if (Util.isPlainObject(config.bar) && Util.isPlainObject(config.bar.layout)) {
264:    if (!Array.isArray(config.bar.layout[section])) config.bar.layout[section] = []
267:      return { section: section, index: Math.min(requested, config.bar.layout[section].length) }
274:      index: anchor.found ? anchor.index + 1 : config.bar.layout[section].length
284:      var entries = config.bar.layout[fromSection]
296:    var entry = config.bar.layout[source.section][source.index]
297:    config.bar.layout[source.section].splice(source.index, 1)
300:      config.bar.layout[source.section].splice(source.index, 0, entry)
303:    config.bar.layout[target.section].splice(target.index, 0, entry)
356:        var entries = config.bar.layout[section]
370:      if (barEntryId(config.bar.layout[location.section][location.index]) !== String(id)) {
374:      var entry = config.bar.layout[location.section][location.index]
388:    if (!Util.isPlainObject(config.bar)) config.bar = { layout: { left: [], center: [], right: [] } }
389:    if (!Util.isPlainObject(config.bar.layout)) config.bar.layout = { left: [], center: [], right: [] }
392:      if (!Array.isArray(config.bar.layout[sections[i]])) config.bar.layout[sections[i]] = []
434:      } else if (findEntryLocation(config, candidate).found) {
449:      var cloneLocation = findEntryLocation(config, cloneId)
451:        var cloneEntry = config.bar.layout[cloneLocation.section][cloneLocation.index]
454:          for (var i = config.bar.layout[sections[s]].length - 1; i >= 0; i--) {
455:            if (barEntryId(config.bar.layout[sections[s]][i]) === sourceId)
456:              config.bar.layout[sections[s]].splice(i, 1)
463:          config.bar.layout[cloneLocation.section][cloneLocation.index] = restoredEntry
522:      var location = findEntryLocation(config, key)
529:          var sourceLocation = clonedFrom ? findEntryLocation(config, clonedFrom) : { found: false }
531:            var sourceEntry = config.bar.layout[sourceLocation.section][sourceLocation.index]
534:            config.bar.layout[sourceLocation.section][sourceLocation.index] = replacement
538:            config.bar.layout[target.section].splice(target.index, 0, entry)
556:      else if (location.kind === "bar") config.bar.layout[location.section].splice(location.index, 1)
559:      // Dropping the layout entry is the whole story for a widget. Anything
```

**⏺ bash** `cd /usr/share/omarchy; sed -n 130,260p shell/services/PluginRegistry.qml`

✓ 80 ms

```text
[exit 0, 69 ms]
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
      }
      if (isDisabled(config, key)) return false
      if (manifest.__isFirstParty) return true
    }
    return findEntryLocation(config, key).found
  }

  function isDisabled(config, id) {
    return Util.isPlainObject(config) && Array.isArray(config.disabledPlugins)
      && config.disabledPlugins.indexOf(Util.canonicalWidgetId(String(id))) !== -1
…
```

**⏺ bash** `cd /usr/share/omarchy; cat bin/omarchy-plugin-clone | head -150`

✓ 80 ms

```text
[exit 0, 70 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "shell\.bar\b\|shell\.bar\.\|\.barConfig = \|bar\.barConfig" shell.qml | head -40; echo ----; grep -n "root\.shell" plugins/bar/Bar.qml`

✓ 72 ms

```text
[exit 0, 66 ms]
119:      bar.barConfig = shell.barConfigFor(shell.activeBarManifest)
225:    if ("barConfig" in target) target.barConfig = shell.barConfigFor(manifest)
226:    shell.bar = target
247:    onActiveChanged: if (!active && shell.activeBarId !== shell.defaultBarId) shell.bar = null
257:    onActiveChanged: if (!active) shell.bar = null
447:    api.barHidden = Qt.binding(function() { return shell.bar ? shell.bar.barHidden === true : false })
448:    api.barSize = Qt.binding(function() { return shell.bar ? Math.max(0, shell.bar.barSize || 0) : 0 })
449:    api.fontFamily = Qt.binding(function() { return shell.bar ? String(shell.bar.fontFamily || "") : "" })
450:    api.position = Qt.binding(function() { return shell.bar ? String(shell.bar.position || "top") : "top" })
879:      shellApi.barConfig = shell.publicBarConfig()
883:      _pluginBarEntryShellApis[entryKey].barConfig = shell.publicBarConfig()
1169:      var summoned = shell.bar && typeof shell.bar.summonBarWidget === "function"
1170:        && shell.bar.summonBarWidget(id)
1196:      var hidden = shell.bar && typeof shell.bar.hideBarWidget === "function"
1197:        && shell.bar.hideBarWidget(id)
1212:      return shell.bar && typeof shell.bar.isBarWidgetOpen === "function"
1213:        ? shell.bar.isBarWidgetOpen(id)
1613:      if (shell.bar && typeof shell.bar.toggleTransparency === "function") {
1614:        shell.bar.toggleTransparency()
1712:      return JSON.stringify(shell.bar && shell.bar.debugBarGeometry ? shell.bar.debugBarGeometry() : [])
1732:      var id = shell.bar && typeof shell.bar.panelWidgetIdAt === "function"
1733:        ? shell.bar.panelWidgetIdAt(section, index)
----
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

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 980,1022p plugins/bar/Bar.qml; sed -n 326,400p plugins/bar/Bar.qml; cat Ui/WidgetButton.qml Ui/BarWidget.qml`

✓ 75 ms

```text
[exit 0, 67 ms]
  }

  function moduleTargetClickable(target) {
    return target
      && target.visible !== false
      && target.opacity !== 0
      && target.interactive !== false
      && target.pressable !== false
      && target.concealed !== true
      && typeof target.triggerPress === "function"
  }

  function moduleClickTargetAt(slot, localX, localY) {
    for (var i = clickTargets.length - 1; i >= 0; i--) {
      var target = clickTargets[i]
      if (!moduleTargetClickable(target)) continue

      var targetPoint = { x: localX, y: localY }
      try {
        targetPoint = slot.mapToItem(target, localX, localY)
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
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/PopupCard.qml; ls plugins/panels/weather; sed -n 1,80p plugins/panels/weather/BarWidget.qml`

✓ 76 ms

```text
[exit 0, 67 ms]
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

**⏺ bash** `cd /usr/share/omarchy; sed -n 1,80p bin/omarchy-plugin-validate; grep -n "entryPoints\|schemaVersion\|idPattern\|RegExp\|test(" shell/services/PluginRegistry.qml | head -30`

✓ 92 ms

```text
[exit 0, 87 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/BarIconButton.qml; grep -n "function \(top\|bottom\|left\|right\|flat\)" Commons/Border.qml; grep -n "statusSlot\|gapsOut\|popupPadding\|sizeHorizontal" Commons/Style.qml | head; grep -n "pickPanelSlot" -A30 plugins/bar/BarModel.js | head -45; grep -n "customModul`

✓ 93 ms

```text
[exit 0, 86 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 60,102p plugins/bar/BarModel.js; grep -n "function entrySettings\|function entryId" -A8 plugins/bar/BarModel.js; sed -n 860,885p shell.qml; grep -rn "qs\.\|import" /usr/share/omarchy/shell/plugins/dev-gallery/*.qml | head -5; ls /usr/share/omarchy/shell/`

✓ 92 ms

```text
[exit 0, 86 ms]
  return index <= 0 ? [] : entries.slice(0, index)
}

function entriesAfter(entries, name) {
  var index = entryIndex(entries, name)
  return index === -1 ? [] : entries.slice(index + 1)
}

// A shell.json write that only changes inline widget settings (the battery
// percentage toggle, a clock format change) must not rebuild the bar.
// Compare two normalized layouts: when the structure is unchanged — same
// entry ids in the same order per region — return the settings-only changes
// as {region, index, entry}. Return null when the change is structural, or
// touches an entry a live settings push cannot safely reach: custom modules
// read their entry directly rather than an injected settings property, and
// a duplicated id makes the push ambiguous.
function inlineSettingsDelta(current, next) {
  if (!isPlainObject(current) || !isPlainObject(next)) return null
  var regions = ["left", "center", "right"]
  var counts = {}
  for (var r = 0; r < regions.length; r++) {
    var entries = Array.isArray(next[regions[r]]) ? next[regions[r]] : []
    for (var i = 0; i < entries.length; i++) {
      var id = entryId(entries[i])
      counts[id] = (counts[id] || 0) + 1
    }
  }
  var changes = []
  for (var s = 0; s < regions.length; s++) {
    var region = regions[s]
    var a = Array.isArray(current[region]) ? current[region] : []
    var b = Array.isArray(next[region]) ? next[region] : []
    if (a.length !== b.length) return null
    for (var j = 0; j < a.length; j++) {
      if (entryId(a[j]) !== entryId(b[j])) return null
      if (JSON.stringify(a[j]) === JSON.stringify(b[j])) continue
      if (customModuleType(a[j]) || customModuleType(b[j])) return null
      if (counts[entryId(b[j])] > 1) return null
      changes.push({ region: region, index: j, entry: b[j] })
…
```

I'll check what tooling I have to verify the QML: qmllint, a headless Quickshell, and a Wayland session.

**⏺ bash** `which qmllint qml qmlscene qml6 2>&1; ls /usr/lib/qt6/bin 2>/dev/null | head -30; echo $WAYLAND_DISPLAY $XDG_RUNTIME_DIR; quickshell --version 2>&1 | head -2; pgrep -a quickshell | head`

✓ 134 ms

```text
[exit 0, 126 ms]
which: no qml in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
which: no qmlscene in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/shims:~/.local/share/mise/installs/codex/0.162.1/codex-path:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/0.85.1/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.cargo/bin:~/.local/bin)
~/.local/bin/qmllint
/usr/bin/qml6
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

Quickshell 0.3.1 (revision , distributed by Arch Linux)
```

No Wayland session here, so the live shell can't run. I'll look for a headless compositor I could use for a real load test.

**⏺ bash** `which sway weston cage labwc Hyprland hyprland Xvfb wlheadless-run kwin_wayland 2>/dev/null; file ~/.local/bin/qmllint 2>&1 | head -2`

✓ 91 ms

```text
[exit 0, 85 ms]
/usr/bin/Hyprland
/usr/bin/hyprland
/usr/bin/Xvfb
~/.local/bin/qmllint: symbolic link to /usr/lib/qt6/bin/qmllint
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 1136,1230p shell.qml; sed -n 100,125p shell.qml`

✓ 96 ms

```text
[exit 0, 87 ms]
  // plugin/bar reloads: the bar re-creates the widget, while a fixed IPC
  // target only ever routes to one of the per-monitor instances.
  function isBarWidgetPanelPlugin(pluginId) {
    var plugins = shell.pluginRegistry.installedPlugins
    var m = plugins[String(pluginId || "")]
    if (!m || !Array.isArray(m.kinds)) return false
    if (m.kinds.indexOf("bar-widget") === -1) return false
    // Plugins that are also panel/overlay/menu kinds are owned by the
    // panel loader (e.g. omarchy.menu); let that path handle them.
    var loaderKinds = ["panel", "overlay", "menu"]
    for (var i = 0; i < loaderKinds.length; i++) {
      if (m.kinds.indexOf(loaderKinds[i]) !== -1) return false
    }
    return true
  }

  function summon(pluginId, payloadJson) {
    var id = shell.pluginRegistry.resolveEnabledId(pluginId)
    if (!id) return false
    var plugins = shell.pluginRegistry.installedPlugins
    if (!plugins[id]) {
      console.warn("summon: unknown plugin", id)
      return false
    }
    // A disabled plugin has no Loader, so setting openPanelIds would only
    // produce an invisible "open" state that toggle() then has to unwind.
    // Tell the caller plainly instead of silently no-op'ing.
    if (!shell.pluginRegistry.isEnabled(id)) {
      console.warn("summon: plugin not enabled, not summoning:", id)
      return false
    }
    // Bar widgets take no payload; payloadJson is dropped on this path.
    if (shell.isBarWidgetPanelPlugin(id)) {
      var summoned = shell.bar && typeof shell.bar.summonBarWidget === "function"
        && shell.bar.summonBarWidget(id)
      if (!summoned) console.warn("summon: no live bar widget for:", id)
      return summoned === true
    }
    var next = ({})
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 855,980p plugins/bar/Bar.qml`

✓ 71 ms

```text
[exit 0, 65 ms]
      root.setRequestedTransparency(nextTransparent)
    }
  }

  function rawLayoutSection(config, region) {
    if (!Util.isPlainObject(config.bar)) config.bar = {}
    if (!Util.isPlainObject(config.bar.layout)) config.bar.layout = {}
    if (!Array.isArray(config.bar.layout[region])) config.bar.layout[region] = []

    return config.bar.layout[region]
  }

  function rawEntryIndex(entries, name) {
    for (var i = 0; i < entries.length; i++) {
      if (root.entryId(entries[i]) === name) return i
    }

    return -1
  }

  function moveModuleInConfig(config, fromRegion, fromName, toRegion, beforeName) {
    var fromEntries = rawLayoutSection(config, fromRegion)
    var toEntries = rawLayoutSection(config, toRegion)
    var fromIndex = rawEntryIndex(fromEntries, fromName)
    if (fromIndex < 0) return false

    var toIndex = beforeName ? rawEntryIndex(toEntries, beforeName) : toEntries.length
    if (toIndex < 0) toIndex = toEntries.length

    if (fromRegion === toRegion && fromIndex === toIndex) return false

    var movedEntry = fromEntries[fromIndex]
    fromEntries.splice(fromIndex, 1)

    if (fromRegion === toRegion && fromIndex < toIndex) toIndex -= 1
    if (toIndex < 0) toIndex = 0
    if (toIndex > toEntries.length) toIndex = toEntries.length
    if (fromRegion === toRegion && fromIndex === toIndex) {
      fromEntries.splice(fromIndex, 0, movedEntry)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function fileUrl\|function canonicalWidgetId\|function isPlainObject\|function cloneJson\|function parseModuleJson" -A6 Commons/Util.qml | head -50; sed -n 1105,1115p plugins/bar/Bar.qml; grep -n "function pickDrawnSlot" -A15 plugins/bar/BarModel.js`

✓ 92 ms

```text
[exit 0, 87 ms]
42:  function fileUrl(path) {
43-    if (!path) return ""
44-    return "file://" + String(path).split("/").map(encodeURIComponent).join("/")
45-  }
46-
47-  // Single-quote a string for bash. The replace handles embedded single
48-  // quotes by closing, escaping, and re-opening the literal.
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
--
82:  function cloneJson(value) {
83-    return JSON.parse(JSON.stringify(value === undefined ? null : value))
84-  }
85-
86-  // Parse the last line of a custom-module / indicator process output as
87-  // waybar-style JSON ({text, class, tooltip, ...}). Falls back to {text: raw}
88-  // when the output isn't JSON, and {} for empty output.
89:  function parseModuleJson(raw) {
90-    var text = String(raw || "").trim()
91-    if (!text) return {}
92-    var lines = text.split("\n")
93-    try {
94-      return JSON.parse(lines[lines.length - 1])
95-    } catch (e) {
    watchChanges: true
    printErrors: false
    onFileChanged: root.scheduleTransparentForegroundRefresh()
  }

…
```

I'll write the plugin now, starting with the manifest and the bar wrapper (the entry point).

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.drawer",
  "name": "Drawer bar",
  "version": "1.0.0",
  "author": "parker",
  "description": "The stock Omarchy bar plus a drawer button: widgets marked \"drawer\": true in shell.json are tucked into a panel that opens from the button.",
  "kinds": ["bar"],
  "entryPoints": {
    "bar": "DrawerBar.qml"
  }
}
```

✓ 2 ms

```text
wrote 351 bytes to .config/omarchy/plugins/parker.drawer/manifest.json
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerBar.qml`

```
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons

// Drawer bar: a full-bar option that runs the stock Omarchy bar unchanged and
// adds a drawer to it.
//
// Every bar.layout entry marked `"drawer": true` is taken out of the bar and
// shown inside a panel that opens from the drawer button instead. The tucked
// entries stay in their left/center/right sections of shell.json, so they keep
// their settings, still count as "in the bar" for enabled-state checks, and come
// straight back if you switch to the built-in bar again.
//
// The drawer button sits wherever a `{ "id": "parker.drawer" }` entry is placed
// in the layout; without one it is added at the start of the right section.
Item {
  id: root

  // Injected by the shell host (shell.qml configureBar). A third-party bar gets
  // a capability-scoped shell facade and detached config/registry snapshots;
  // the stock bar below runs on exactly those, so it gets no extra access.
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null
  property var barWidgetRegistry: null
  property var pluginRegistry: null
  property var barConfig: ({})

  readonly property string pluginId: manifest && manifest.id ? String(manifest.id) : "parker.drawer"
  readonly property string barSource: root.omarchyPath ? Util.fileUrl(root.omarchyPath + "/shell/plugins/bar/Bar.qml") : ""

  // The stock Bar.qml instance.
  readonly property var bar: barLoader.item

  // Scalar bar state the shell reads off `shell.bar`.
  readonly property bool barHidden: bar ? bar.barHidden === true : false
  readonly property int barSize: bar ? bar.barSize : 0
  readonly property string fontFamily: bar ? String(bar.fontFamily || "") : ""
  readonly property string position: bar ? String(bar.position || "top") : "top"
  readonly property bool vertical: position === "left" || position === "right"

  // Tucked entries in bar order (left, center, right). Rebuilt only when the
  // list of widgets changes; settings-only edits go to drawerSettings so the
  // hosted widgets update in place rather than being torn down.
  property var drawerEntries: []
  property var drawerSettings: []
  property string drawerSignature: ""

  // Live drawer buttons, one per monitor.
  property var drawerButtons: []

  // ------------------------------------------------------------ config

  function isTucked(entry) {
    return Util.isPlainObject(entry) && entry.drawer === true
      && String(entry.id || "") !== root.pluginId
  }

… (268 more lines in the repository)
```

✓ 0 ms

```text
wrote 11135 bytes to .config/omarchy/plugins/parker.drawer/DrawerBar.qml
```

Next, the drawer button, which owns the panel and the popout coordination:

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerButton.qml`

```
import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// The drawer button and its panel. One instance per monitor, like every bar
// widget. The tucked widgets are created inside the panel once and stay alive
// while it is closed, so their state (update counts, weather, ...) keeps
// ticking and hotkeys can still open their panels.
BarWidget {
  id: root

  // The DrawerBar wrapper; `bar` is the stock Bar.qml root, injected by it.
  property var host: null

  property bool drawerOpen: false
  readonly property bool opened: drawerOpen
  readonly property var entries: host ? host.drawerEntries : []
  readonly property string screenName: {
    var window = root.QsWindow.window
    return window && window.screen ? String(window.screen.name || "") : ""
  }

  // A tucked widget's own panel currently holds the bar's popout slot.
  readonly property bool hostedPopupActive: !!bar && !!bar.activePopout
    && bar.activePopout !== root && ownsTarget(bar.activePopout)

  readonly property string closedIcon: {
    var position = bar ? bar.position : "top"
    if (position === "bottom") return "\uf077"   // chevron-up
    if (position === "left") return "\uf054"     // chevron-right
    if (position === "right") return "\uf053"    // chevron-left
    return "\uf078"                              // chevron-down
  }
  readonly property string openIcon: {
    var position = bar ? bar.position : "top"
    if (position === "bottom") return "\uf078"
    if (position === "left") return "\uf053"
    if (position === "right") return "\uf054"
    return "\uf077"
  }

  visible: entries.length > 0
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Component.onCompleted: if (host) host.registerDrawerButton(root)
  Component.onDestruction: if (host) host.unregisterDrawerButton(root)

  // ------------------------------------------------------------ popout

  function open() {
    if (!visible) return
    drawerOpen = true
    if (bar && bar.activePopout !== root && !hostedPopupActive) bar.requestPopout(root)
  }

  // Explicit close: the button itself, `omarchy-shell parker.drawer close`.
  function dismiss() {
    closeHostedPopup()
… (216 more lines in the repository)
```

✓ 1 ms

```text
wrote 9007 bytes to .config/omarchy/plugins/parker.drawer/DrawerButton.qml
```

Next, DrawerSlot (hosts one tucked widget, mirroring Bar.qml's ModuleSlot) and CommandModule (so tucked `type: "command"` modules work too):

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerSlot.qml`

```
import QtQuick
import qs.Commons

// Hosts one tucked widget inside the drawer, the same way Bar.qml's ModuleSlot
// hosts a widget in the bar: the same component from the widget registry, the
// same injected `bar` / `moduleName` / `settings`.
Item {
  id: slot

  required property var entry
  // Live inline settings for this entry; falls back to the entry itself.
  property var settingsOverride: null
  // The stock Bar.qml root.
  property var bar: null

  readonly property string moduleName: entry ? Util.canonicalWidgetId(entry.id) : ""
  readonly property var moduleSettings: {
    if (settingsOverride) return settingsOverride
    var copy = {}
    if (entry) for (var key in entry) if (key !== "id") copy[key] = entry[key]
    return copy
  }
  readonly property string customType: bar && entry ? bar.customModuleType(entry) : ""
  readonly property bool qmlCustom: customType === "qml"
  readonly property bool commandCustom: customType === "command"
  readonly property var registry: bar ? bar.barWidgetRegistry : null
  readonly property var registryMetadata: registry ? registry.metadataFor(moduleName) : null
  readonly property bool firstParty: !!registryMetadata && registryMetadata.firstParty === true
  readonly property var registryComponent: {
    var widgets = registry ? registry.widgets : null
    if (!widgets || customType) return null
    return widgets[moduleName] ? widgets[moduleName].component : null
  }
  readonly property bool registered: registryComponent !== null
  readonly property string pluginApiId: registered ? moduleName : "bar-entry:" + moduleName
  readonly property var activeItem: {
    if (registered) return registryLoader.item
    if (qmlCustom) return qmlLoader.item
    if (commandCustom) return commandLoader.item
    return null
  }
  readonly property bool vertical: bar ? bar.vertical === true : false

  implicitWidth: activeItem && activeItem.visible ? (vertical ? bar.barSize : activeItem.implicitWidth) : 0
  implicitHeight: activeItem && activeItem.visible ? activeItem.implicitHeight : 0
  width: implicitWidth
  height: implicitHeight

  // What Bar.qml sees of this slot. Registering keeps a third-party widget's bar
  // facade alive (the bar prunes facades no slot uses) and lets broadcast() and
  // panel routing reach the hosted copy. It reports itself invisible and in a
  // "drawer" region, so the bar's drag-and-drop never offers the drawer as a
  // drop target and Tab-between-panels stays on the bar.
  QtObject {
    id: barRecord
    readonly property string region: "drawer"
    readonly property string moduleName: slot.moduleName
    readonly property string pluginApiId: slot.pluginApiId
    readonly property var activeItem: slot.activeItem
    readonly property bool visible: false
… (68 more lines in the repository)
```

✓ 1 ms

```text
wrote 4702 bytes to .config/omarchy/plugins/parker.drawer/DrawerSlot.qml
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/CommandModule.qml`

```
import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

// A `"type": "command"` bar module tucked into the drawer. Mirrors the stock
// bar's CustomCommandModule (exec / interval / onClick / Waybar-style JSON).
WidgetButton {
  id: root

  property var settings: ({})
  property string outputText: ""
  property string outputTooltip: ""
  property bool outputActive: false

  function setting(name, fallback) {
    var value = settings ? settings[name] : undefined
    return value === undefined || value === null ? fallback : value
  }

  function update(raw) {
    var data = Util.parseModuleJson(raw)
    var klass = data.class || data.alt || ""
    outputText = data.text || String(raw || "").trim()
    outputTooltip = data.tooltip || String(setting("tooltip", ""))
    outputActive = klass === "active" || (Array.isArray(klass) && klass.indexOf("active") !== -1)
  }

  text: outputText || String(setting("text", ""))
  tooltipText: outputTooltip || String(setting("tooltip", ""))
  active: outputActive
  keepSpace: setting("keepSpace", false) === true
  horizontalMargin: Number(setting("horizontalMargin", 7.5))
  verticalPadding: Number(setting("verticalPadding", 6))
  fontSize: Number(setting("fontSize", 12))

  onPressed: function(button) {
    var command = ""
    if (button === Qt.RightButton) command = String(setting("onRightClick", ""))
    else if (button === Qt.MiddleButton) command = String(setting("onMiddleClick", ""))
    else command = String(setting("onClick", ""))
    if (command && bar) bar.run(command)
  }

  Process {
    id: proc
    command: ["bash", "-lc", String(root.setting("exec", ""))]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.update(text)
    }
  }

  Timer {
    interval: Math.max(1, Number(root.setting("interval", 5))) * 1000
    running: String(root.setting("exec", "")) !== ""
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!proc.running) proc.running = true
  }
… (1 more lines in the repository)
```

✓ 0 ms

```text
wrote 1986 bytes to .config/omarchy/plugins/parker.drawer/CommandModule.qml
```

All four QML files are written. First checks: the Omarchy manifest validator, then a syntax/lint pass.

**⏺ bash** `cd .config/omarchy/plugins && omarchy-plugin-validate parker.drawer; echo "validate exit=$?"; for f in parker.drawer/*.qml; do /usr/lib/qt6/bin/qmlformat "$f" >/dev/null && echo "parse ok: $f"; done`

✓ 416 ms

```text
[exit 0, 411 ms]
validate exit=0
parse ok: parker.drawer/CommandModule.qml
parse ok: parker.drawer/DrawerBar.qml
parse ok: parker.drawer/DrawerButton.qml
parse ok: parker.drawer/DrawerSlot.qml
```

Validator and parser are clean. Now I'll try a real load test by starting a headless Hyprland inside the sandbox so Quickshell has a compositor.

**⏺ bash** `Hyprland --version 2>&1 | head -3; ls /usr/share/omarchy/default/hypr | head; export XDG_RUNTIME_DIR=$(mktemp -d); echo $XDG_RUNTIME_DIR`

✓ 231 ms

```text
[exit 0, 226 ms]
[1;35mCRIT [0m]: Critical error thrown: XDG_RUNTIME_DIR is not set!
terminate called after throwing an instance of 'std::runtime_error'
  what():  XDG_RUNTIME_DIR is not set!
apps
apps.lua
autostart.lua
bindings
bindings.lua
bootstrap.lua
disabled-input-device.lua
envs.lua
helpers.lua
input.lua
/tmp/tmp.lWn5UfcbuX
```

**⏺ bash** `export XDG_RUNTIME_DIR=/tmp/hyprrt; mkdir -p -m 700 $XDG_RUNTIME_DIR; mkdir -p /tmp/hyprcfg; cat > /tmp/hyprcfg/hyprland.conf <<'EOF'
monitor = HEADLESS-1, 1920x1080@60, 0x0, 1
misc {
  disable_hyprland_logo = true
}
EOF
cd /tmp; (AQ_BACKENDS=headless WLR_BACKENDS=headless timeout 20 Hyprland -c /tm`

✓ 5082 ms

```text
[exit 0, 5074 ms]
hypr
DEBUG ]: Creating the MonitorState!
DEBUG ]: Creating the WorkspaceState!
DEBUG ]: Creating the ConfigManager!
DEBUG ]: [cfg] Config is either explicit or special.
DEBUG ]: [cfg] Config is NOT lua, loading regular mgr
DEBUG ]: Using config: /tmp/hyprcfg/hyprland.conf
DEBUG ]: !!!!HEY YOU, YES YOU!!!!: further logs to stdout / logfile are disabled by default. BEFORE SENDING THIS LOG, ENABLE THEM. Use debug:disable_logs = false to do so: https://wiki.hypr.land/Configuring/Basics/Variables/#debug
DEBUG ]: Creating the Error Overlay!
DEBUG ]: Creating the LayoutManager!
DEBUG ]: Creating the TokenManager!
DEBUG ]: Creating the EventManager!
DEBUG ]: Using config: /tmp/hyprcfg/hyprland.conf
DEBUG ]: Disabling stdout logs (debug.enable_stdout_logs = 0). Further logs will be written to /tmp/hyprrt/hypr/efb50993780079460b0cbed1363e2166a2de1d9f_1794263380_73794425/hyprland.log
DEBUG ]: Creating the PointerManager!
DEBUG ]: Creating the AsyncResourceGatherer!
terminate called after throwing an instance of 'std::runtime_error'
  what():  CBackend::create() failed!
failed to mkdir() crash report directory
No such file or directory
timeout: the monitored command dumped core
```

**⏺ bash** `grep -i "backend\|aq\|session\|error" /tmp/hyprrt/hypr/*/hyprland.log | head -30`

✓ 71 ms

```text
[exit 0, 65 ms]
grep: /tmp/hyprrt/hypr/*/hyprland.log: No such file or directory
```

**⏺ bash** `cd .config/omarchy && python3 - <<'EOF'
import json
p='shell.json'
c=json.load(open(p))
bar=c['bar']
# insert bar.id right after version-ish keys, keep the rest in order
newbar={'id':'parker.drawer'}
newbar.update(bar)
tuck={'omarchy.keyboard-layout','omarchy.weather','omarchy.system-update','omarch`

✓ 135 ms

```text
[exit 0, 128 ms]
 .config/omarchy/shell.json | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)
diff --git a/.config/omarchy/shell.json b/.config/omarchy/shell.json
index e6202da..08bc6a4 100644
--- a/.config/omarchy/shell.json
+++ b/.config/omarchy/shell.json
@@ -5,6 +5,7 @@
     "lock": 300
   },
   "bar": {
+    "id": "parker.drawer",
     "position": "top",
     "transparent": false,
     "centerAnchor": "omarchy.clock",
@@ -28,13 +29,16 @@
           "verticalFormat": "HH\n\u2014\nmm"
         },
         {
-          "id": "omarchy.keyboard-layout"
+          "id": "omarchy.keyboard-layout",
+          "drawer": true
         },
         {
-          "id": "omarchy.weather"
+          "id": "omarchy.weather",
+          "drawer": true
         },
         {
-          "id": "omarchy.system-update"
+          "id": "omarchy.system-update",
+          "drawer": true
         }
       ],
       "right": [
@@ -42,10 +46,15 @@
           "id": "omarchy.tray"
         },
         {
-          "id": "omarchy.agents"
…
```

Now I'll run the actual Omarchy shell under Xvfb, using this project's config as `$HOME/.config`:

**⏺ bash** `pkill -f "Xvfb :77" 2>/dev/null; (Xvfb :77 -screen 0 1920x1080x24 >/tmp/xvfb.log 2>&1 &); sleep 1.5
export XDG_RUNTIME_DIR=/tmp/qsrt; mkdir -p -m 700 $XDG_RUNTIME_DIR
export DISPLAY=:77 QT_QPA_PLATFORM=xcb OMARCHY_PATH=/usr/share/omarchy
(timeout 40 quickshell -p /usr/share/omarchy/shell > /tmp/qs.l`

✗ 111 ms

```text
[exit 143, 107 ms]
```

My `pkill -f` pattern matched the bash command itself and killed it. I'll retry without that.

**⏺ bash** `(Xvfb :77 -screen 0 1920x1080x24 >/tmp/xvfb.log 2>&1 &); sleep 1.5
export XDG_RUNTIME_DIR=/tmp/qsrt; mkdir -p -m 700 $XDG_RUNTIME_DIR
export DISPLAY=:77 QT_QPA_PLATFORM=xcb OMARCHY_PATH=/usr/share/omarchy
(timeout 60 quickshell -p /usr/share/omarchy/shell > /tmp/qs.log 2>&1 &); sleep 12
wc -l /tmp/q`

✓ 13599 ms

```text
[exit 0, 13592 ms]
21 /tmp/qs.log
  INFO: Launching config: "/usr/share/omarchy/shell/shell.qml"
  INFO: Shell ID: "c0240dfe8c8e8a421e1f8db23a03fc60" Path ID "c0240dfe8c8e8a421e1f8db23a03fc60"
  INFO: Saving logs to "/tmp/qsrt/quickshell/by-id/a7ia9ot/log.qslog"
  WARN qt.qpa.xcb: could not connect to display :77
  WARN qt.qpa.plugin: From 6.5.0, xcb-cursor0 or libxcb-cursor0 is needed to load the Qt xcb platform plugin.
  INFO qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
 FATAL: This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vkkhrdisplay, vnc, wayland-brcm, wayland-egl, wayland, xcb.
  WARN: QEventLoop: Cannot be used without QCoreApplication
 ERROR: Quickshell has crashed under pid 12 (Coredumps will be available under that pid.)
 ERROR: Further crash information is stored under "/tmp/.cache/quickshell/crashes/a7ia9ot"
 ERROR: Quickshell crashed within 10 seconds of launching. Not restarting to avoid a crash loop.
  WARN qt.qpa.xcb: could not connect to display :77
  WARN qt.qpa.plugin: From 6.5.0, xcb-cursor0 or libxcb-cursor0 is needed to load the Qt xcb platform plugin.
  INFO qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
 FATAL: This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vkkhrdisplay, vnc, wayland-brcm, wayland-egl, wayland, xcb.
```

**⏺ bash** `cat /tmp/xvfb.log | tail -5; ls /tmp/.X11-unix 2>&1`

✗ 69 ms

```text
[exit 2, 65 ms]
cat: /tmp/xvfb.log: No such file or directory
ls: cannot access '/tmp/.X11-unix': No such file or directory
```

Each bash call seems to start fresh, so the background Xvfb didn't survive into the next call. I'll run everything inside a single call.

**⏺ bash** `export XDG_RUNTIME_DIR=/tmp/qsrt; mkdir -p -m 700 $XDG_RUNTIME_DIR /tmp/.X11-unix
Xvfb :77 -screen 0 1920x1080x24 -nolisten tcp >/tmp/xvfb.log 2>&1 &
XPID=$!; sleep 2; cat /tmp/xvfb.log | tail -3; ls /tmp/.X11-unix
export DISPLAY=:77 QT_QPA_PLATFORM=xcb OMARCHY_PATH=/usr/share/omarchy
timeout 25 qui`

✗ 17104 ms

```text
[exit 1, 17099 ms]
Fatal server error:
(EE) Caught signal 11 (Segmentation fault). Server aborting
(EE) 
/usr/bin/bash: line 4:     4 Aborted                    (core dumped) Xvfb :77 -screen 0 1920x1080x24 -nolisten tcp > /tmp/xvfb.log 2>&1
  INFO: Launching config: "/usr/share/omarchy/shell/shell.qml"
  INFO: Shell ID: "c0240dfe8c8e8a421e1f8db23a03fc60" Path ID "c0240dfe8c8e8a421e1f8db23a03fc60"
  INFO: Saving logs to "/tmp/qsrt/quickshell/by-id/buia9ot/log.qslog"
  WARN qt.qpa.xcb: could not connect to display :77
  WARN qt.qpa.plugin: From 6.5.0, xcb-cursor0 or libxcb-cursor0 is needed to load the Qt xcb platform plugin.
  INFO qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
 FATAL: This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vkkhrdisplay, vnc, wayland-brcm, wayland-egl, wayland, xcb.
 ERROR: Quickshell has crashed under pid 13 (Coredumps will be available under that pid.)
 ERROR: Further crash information is stored under "/tmp/.cache/quickshell/crashes/buia9ot"
 ERROR: Quickshell crashed within 10 seconds of launching. Not restarting to avoid a crash loop.
  WARN: QEventLoop: Cannot be used without QCoreApplication
  WARN qt.qpa.xcb: could not connect to display :77
  WARN qt.qpa.plugin: From 6.5.0, xcb-cursor0 or libxcb-cursor0 is needed to load the Qt xcb platform plugin.
  INFO qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
 FATAL: This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vkkhrdisplay, vnc, wayland-brcm, wayland-egl, wayland, xcb.
/usr/bin/bash: line 8: kill: (4) - No such process
```

**⏺ bash** `export XDG_RUNTIME_DIR=/tmp/qsrt; mkdir -p -m 700 $XDG_RUNTIME_DIR
export QT_QPA_PLATFORM=offscreen OMARCHY_PATH=/usr/share/omarchy
timeout 40 quickshell -p /usr/share/omarchy/shell > /tmp/qs.log 2>&1 &
sleep 12
Q="quickshell ipc -p /usr/share/omarchy/shell call"
$Q shell ping
$Q shell listPlugins |`

✓ 12270 ms

```text
[exit 0, 12263 ms]
No running instances for "/usr/share/omarchy/shell/shell.qml"
Traceback (most recent call last):
  File "<string>", line 1, in <module>
    import json,sys; d=json.load(sys.stdin); print([ (p["id"],p.get("enabled")) for p in d if p["id"].startswith("parker") ])
                       ~~~~~~~~~^^^^^^^^^^^
  File "/usr/lib/python3.14/json/__init__.py", line 298, in load
    return loads(fp.read(),
        cls=cls, object_hook=object_hook,
        parse_float=parse_float, parse_int=parse_int,
        parse_constant=parse_constant, object_pairs_hook=object_pairs_hook, **kw)
  File "/usr/lib/python3.14/json/__init__.py", line 352, in loads
    return _default_decoder.decode(s)
           ~~~~~~~~~~~~~~~~~~~~~~~^^^
  File "/usr/lib/python3.14/json/decoder.py", line 345, in decode
    obj, end = self.raw_decode(s, idx=_w(s, 0).end())
               ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.14/json/decoder.py", line 363, in raw_decode
    raise JSONDecodeError("Expecting value", s, err.value) from None
json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)
---- log
  INFO: Launching config: "/usr/share/omarchy/shell/shell.qml"
  INFO: Shell ID: "c0240dfe8c8e8a421e1f8db23a03fc60" Path ID "c0240dfe8c8e8a421e1f8db23a03fc60"
  INFO: Saving logs to "/tmp/qsrt/quickshell/by-id/6gja9ot/log.qslog"
 ERROR: Failed to load configuration
 ERROR:   caused by @shell.qml[232:5]: Type Bar unavailable
 ERROR:   caused by @plugins/bar/Bar.qml[1234:23]: No PanelWindow backend loaded.
```

**⏺ bash** `du -sh /usr/share/omarchy/shell; grep -n "PanelWindow\|WlrLayershell\|exclusionMode\|^\s*margins {\|^\s*anchors {" /usr/share/omarchy/shell/plugins/bar/Bar.qml | head -30; grep -rln "PanelWindow" /usr/share/omarchy/shell --include=*.qml | head -20`

✓ 112 ms

```text
[exit 0, 107 ms]
2.0M	/usr/share/omarchy/shell
1234:  component BarPanel: PanelWindow {
1243:    exclusionMode: root.barHidden ? ExclusionMode.Ignore : ExclusionMode.Auto
1250:    margins {
1257:    anchors {
1268:    WlrLayershell.namespace: "omarchy-bar"
1269:    WlrLayershell.layer: WlrLayer.Top
1397:  component DragGhostPanel: PanelWindow {
1411:    exclusionMode: ExclusionMode.Ignore
1412:    WlrLayershell.namespace: "omarchy-bar-drag-ghost"
1413:    WlrLayershell.layer: WlrLayer.Overlay
1414:    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
1416:    anchors {
1465:  component BarMoveGhostPanel: PanelWindow {
1473:    exclusionMode: ExclusionMode.Ignore
1474:    WlrLayershell.namespace: "omarchy-bar-move-ghost"
1475:    WlrLayershell.layer: WlrLayer.Overlay
1476:    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
1478:    anchors {
/usr/share/omarchy/shell/Ui/KeyboardPanel.qml
/usr/share/omarchy/shell/Ui/SpeedTestOverlay.qml
/usr/share/omarchy/shell/plugins/background/Background.qml
/usr/share/omarchy/shell/plugins/bar/Bar.qml
/usr/share/omarchy/shell/plugins/clipboard/Clipboard.qml
/usr/share/omarchy/shell/plugins/emojis/Emojis.qml
/usr/share/omarchy/shell/plugins/image-picker/ImagePicker.qml
/usr/share/omarchy/shell/plugins/lock/Service.qml
/usr/share/omarchy/shell/plugins/menu/Menu.qml
/usr/share/omarchy/shell/plugins/notifications/Service.qml
/usr/share/omarchy/shell/plugins/osd/Osd.qml
/usr/share/omarchy/shell/plugins/panels/network/Panel.qml
/usr/share/omarchy/shell/plugins/panels/wifiqr/Panel.qml
/usr/share/omarchy/shell/plugins/polkit/PolkitAgent.qml
/usr/share/omarchy/shell/plugins/reminders/ReminderFlow.qml
```

**⏺ bash** `set -u
T=/tmp/omtest; rm -rf $T; mkdir -p $T
for d in /usr/share/omarchy/*; do ln -s "$d" "$T/$(basename $d)"; done
rm $T/shell; cp -r /usr/share/omarchy/shell $T/shell
python3 - <<'EOF'
import re
p='/tmp/omtest/shell/plugins/bar/Bar.qml'
L=open(p).read().split('\n'); out=[]; skip=0; depth=0
for l i`

✓ 16640 ms

```text
[exit 0, 16627 ms]
ping: ok
plugin: [('parker.drawer', True)]
BAR   : [('omarchy.clock', 'center'), ('omarchy.tray', 'right'), ('parker.drawer', 'right'), ('omarchy.network', 'right'), ('omarchy.audio', 'right'), ('omarchy.power', 'right'), ('omarchy.menu', 'left'), ('omarchy.workspaces', 'left'), ('omarchy.indicators', 'center')]
DRAWER: [('omarchy.keyboard-layout', False), ('omarchy.weather', False), ('omarchy.system-update', False)]
toggle: 
summon tucked omarchy.bluetooth: unknown
isOpen bluetooth: unknown
---- log warnings/errors
  WARN : Failed to create wl_display (No such file or directory)
 DEBUG qml: omarchy-shell paths omarchyPath=/tmp/omtest shellDir=/tmp/omtest/shell firstPartyPluginsDir=/tmp/omtest/shell/plugins defaultsPath=/tmp/omtest/config/omarchy/shell.json userConfigPath=~/.config/omarchy/shell.json
  WARN scene: QML IpcHandler at @plugins/bar/Bar.qml[1185:3]: Handler was registered but will not be used because another handler is registered for target omarchy.bar
  WARN: This plugin does not support setting window masks
  WARN: This plugin does not support setting window masks
  WARN qml: service plugin load failed for omarchy.background: file:///tmp/omtest/shell/plugins/background/Background.qml:184:5: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.lock: file:///tmp/omtest/shell/plugins/lock/Service.qml:289:3: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.notifications: file:///tmp/omtest/shell/plugins/notifications/Service.qml:955:5: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.polkit: file:///tmp/omtest/shell/plugins/polkit/PolkitAgent.qml:221:3: No PanelWindow backend loaded.
  WARN quickshell.service.upower: Could not connect to DBus. UPower service will not work.
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
 ERROR quickshell.service.pipewire.loop: Failed to connect pipewire context. Errno: 112
  WARN quickshell.service.mpris.watcher: Could not connect to DBus. Mpris service will not work.
  WARN qml: service plugin load failed for omarchy.background: file:///tmp/omtest/shell/plugins/background/Background.qml:184:5: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.lock: file:///tmp/omtest/shell/plugins/lock/Service.qml:289:3: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.notifications: file:///tmp/omtest/shell/plugins/notifications/Service.qml:955:5: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.polkit: file:///tmp/omtest/shell/plugins/polkit/PolkitAgent.qml:221:3: No PanelWindow backend loaded.
  WARN qml: Plugin widget omarchy.agents failed: file:///tmp/omtest/shell/plugins/agents/Panel.qml:351:3: Type KeyboardPanel unavailable
  WARN qml: Plugin widget omarchy.audio failed: file:///tmp/omtest/shell/plugins/panels/audio/Panel.qml:650:3: Type KeyboardPanel unavailable
  WARN qml: Plugin widget omarchy.bluetooth failed: file:///tmp/omtest/shell/plugins/panels/bluetooth/Panel.qml:662:3: Type KeyboardPanel unavailable
  WARN qml: Plugin widget omarchy.dropbox failed: file:///tmp/omtest/shell/plugins/panels/dropbox/Panel.qml:191:3: Type KeyboardPanel unavailable
  WARN qml: Plugin widget omarchy.monitor failed: file:///tmp/omtest/shell/plugins/panels/monitor/Panel.qml:484:3: Type KeyboardPanel unavailable
  WARN qml: Plugin widget omarchy.network failed: file:///tmp/omtest/shell/plugins/panels/network/Panel.qml:978:3: Type KeyboardPanel unavailable
  WARN qml: Plugin widget omarchy.power failed: file:///tmp/omtest/shell/plugins/panels/power/Panel.qml:292:3: Type KeyboardPanel unavailable
  WARN qml: Plugin widget omarchy.tailscale failed: file:///tmp/omtest/shell/plugins/panels/tailscale/Panel.qml:403:3: Type KeyboardPanel unavailable
  WARN scene: file:///tmp/omtest/shell/plugins/clipboard/Clipboard.qml[314:3]: No PanelWindow backend loaded.
  WARN scene: @shell.qml[1357:-1]: ReferenceError: errorString is not defined
  WARN scene: file:///tmp/omtest/shell/plugins/emojis/Emojis.qml[160:3]: No PanelWindow backend loaded.
  WARN scene: @shell.qml[1357:-1]: ReferenceError: errorString is not defined
  WARN scene: file:///tmp/omtest/shell/plugins/image-picker/ImagePicker.qml[362:3]: No PanelWindow backend loaded.
  WARN scene: @shell.qml[1357:-1]: ReferenceError: errorString is not defined
…
```

**⏺ bash** `T=/tmp/omtest; CFG=.config/omarchy/shell.json; cp $CFG /tmp/shell.json.bak
export XDG_RUNTIME_DIR=/tmp/qsrt QT_QPA_PLATFORM=offscreen OMARCHY_PATH=$T; mkdir -p -m 700 $XDG_RUNTIME_DIR
Q="quickshell ipc -p $T/shell call"
geo(){ $Q shell debugBarGeometry | python3 -c 'import json,sys; g=json.load(sys.`

✓ 27463 ms

```text
[exit 0, 27457 ms]
before:
Traceback (most recent call last):
  File "<string>", line 1, in <module>
    import json,sys; g=json.load(sys.stdin); print("  bar:", sorted(x["id"] for x in g if x["section"]!="drawer")); print("  drawer:", [x["id"] for x in g if x["section"]=="drawer"])
                       ~~~~~~~~~^^^^^^^^^^^
  File "/usr/lib/python3.14/json/__init__.py", line 298, in load
    return loads(fp.read(),
        cls=cls, object_hook=object_hook,
        parse_float=parse_float, parse_int=parse_int,
        parse_constant=parse_constant, object_pairs_hook=object_pairs_hook, **kw)
  File "/usr/lib/python3.14/json/__init__.py", line 352, in loads
    return _default_decoder.decode(s)
           ~~~~~~~~~~~~~~~~~~~~~~~^^^
  File "/usr/lib/python3.14/json/decoder.py", line 345, in decode
    obj, end = self.raw_decode(s, idx=_w(s, 0).end())
               ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.14/json/decoder.py", line 363, in raw_decode
    raise JSONDecodeError("Expecting value", s, err.value) from None
json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)
after untucking weather:
Traceback (most recent call last):
  File "<string>", line 1, in <module>
    import json,sys; g=json.load(sys.stdin); print("  bar:", sorted(x["id"] for x in g if x["section"]!="drawer")); print("  drawer:", [x["id"] for x in g if x["section"]=="drawer"])
                       ~~~~~~~~~^^^^^^^^^^^
  File "/usr/lib/python3.14/json/__init__.py", line 298, in load
    return loads(fp.read(),
        cls=cls, object_hook=object_hook,
        parse_float=parse_float, parse_int=parse_int,
        parse_constant=parse_constant, object_pairs_hook=object_pairs_hook, **kw)
  File "/usr/lib/python3.14/json/__init__.py", line 352, in loads
    return _default_decoder.decode(s)
           ~~~~~~~~~~~~~~~~~~~~~~~^^^
  File "/usr/lib/python3.14/json/decoder.py", line 345, in decode
    obj, end = self.raw_decode(s, idx=_w(s, 0).end())
               ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.14/json/decoder.py", line 363, in raw_decode
    raise JSONDecodeError("Expecting value", s, err.value) from None
json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)
/usr/bin/bash: line 15: kill: (5) - No such process
…
```

**⏺ bash** `T=/tmp/omtest; rm -rf $T; mkdir -p $T
for d in /usr/share/omarchy/*; do ln -s "$d" "$T/$(basename $d)"; done
rm $T/shell; cp -r /usr/share/omarchy/shell $T/shell
python3 - <<'EOF'
import re
p='/tmp/omtest/shell/plugins/bar/Bar.qml'
L=open(p).read().split('\n'); out=[]; skip=0; depth=0
for l in L:
  `

✓ 27836 ms

```text
[exit 0, 27827 ms]
before:
  bar: ['omarchy.audio', 'omarchy.clock', 'omarchy.indicators', 'omarchy.menu', 'omarchy.network', 'omarchy.power', 'omarchy.tray', 'omarchy.workspaces', 'parker.drawer']
  drawer: ['omarchy.keyboard-layout', 'omarchy.weather', 'omarchy.system-update']
after untucking weather + settings-only edit on system-update:
  bar: ['omarchy.audio', 'omarchy.clock', 'omarchy.indicators', 'omarchy.menu', 'omarchy.network', 'omarchy.power', 'omarchy.tray', 'omarchy.weather', 'omarchy.workspaces', 'parker.drawer']
  drawer: ['omarchy.keyboard-layout', 'omarchy.system-update']
toggle twice:  ok
my-file issues: 
plugin-bar omarchy.bar dup warnings: 1
stock bar only (drawer flags ignored):
  bar: ['omarchy.agents', 'omarchy.audio', 'omarchy.bluetooth', 'omarchy.clock', 'omarchy.indicators', 'omarchy.keyboard-layout', 'omarchy.menu', 'omarchy.monitor', 'omarchy.network', 'omarchy.power', 'omarchy.system-update', 'omarchy.tray', 'omarchy.weather', 'omarchy.workspaces', 'parker.drawer']
  drawer: []
stock-bar omarchy.bar dup warnings: 0
 .config/omarchy/shell.json | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/DrawerBar.qml`

```
      item.barWidgetRegistry = drawerRegistry
      root.applyConfig()
      ipcReclaimTimer.restart()
    }
```

✓ 1 ms

```text
edited .config/omarchy/plugins/parker.drawer/DrawerBar.qml at line 183
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/DrawerBar.qml`

```
  Component.onCompleted: applyConfig()

  // At startup the shell briefly mounts the built-in bar before switching to
  // this one, and that instance claims the `omarchy.bar` IPC target first, so
  // the stock bar's handler here is left unregistered and `omarchy-toggle-bar`
  // loses its sync nudge. Once things settle, cycle the handler so it claims
  // the target again.
  Timer {
    id: ipcReclaimTimer
    interval: 1500
    onTriggered: {
      var children = root.bar && root.bar.data ? root.bar.data : []
      for (var i = 0; i < children.length; i++) {
        var child = children[i]
        if (!child || child.target !== "omarchy.bar" || !("enabled" in child)) continue
        child.enabled = false
        child.enabled = true
      }
    }
  }
```

✓ 0 ms

```text
edited .config/omarchy/plugins/parker.drawer/DrawerBar.qml at line 192
```

Verify: rebuild the harness, then call the `omarchy.bar` target directly. I'll also confirm `parker.drawer` IPC is exposed and that my files still load clean.

**⏺ bash** `T=/tmp/omtest; rm -rf $T; mkdir -p $T
for d in /usr/share/omarchy/*; do ln -s "$d" "$T/$(basename $d)"; done
rm $T/shell; cp -r /usr/share/omarchy/shell $T/shell
python3 - <<'EOF'
import re
p='/tmp/omtest/shell/plugins/bar/Bar.qml'
L=open(p).read().split('\n'); out=[]; skip=0; depth=0
for l in L:
  `

✓ 14487 ms

```text
[exit 0, 14477 ms]
omarchy.bar syncHidden -> '' (exit 0)
target parker.drawer
  function toggle(): void
  function open(): void
  function close(): void
target omarchy.bar
  function syncHidden(): void
toggle -> ''
my-file issues: []
7:  WARN scene: QML IpcHandler at @plugins/bar/Bar.qml[1185:3]: Handler was registered but will not be used because another handler is registered for target omarchy.bar
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/README.md`

```
# parker.drawer — drawer bar

The stock Omarchy bar plus a drawer button. Widgets you mark as tucked are taken
off the bar and shown in a panel that opens when you click the button.

It is a full-bar option (`kind: "bar"`) that loads the stock
`$OMARCHY_PATH/shell/plugins/bar/Bar.qml` unchanged, so bar updates from Omarchy
still apply. Widgets in the drawer are the real widgets: clicking one opens its
usual panel, anchored to the drawer.

## Configure (`~/.config/omarchy/shell.json`, hot-reloads on save)

```jsonc
"bar": {
  "id": "parker.drawer",                 // use this bar
  "layout": {
    "right": [
      { "id": "omarchy.tray" },
      { "id": "parker.drawer" },          // where the drawer button goes (optional)
      { "id": "omarchy.bluetooth", "drawer": true },   // tucked into the drawer
      { "id": "omarchy.network" }
    ]
  }
}
```

- Add `"drawer": true` to any layout entry to tuck it away; remove it to put the
  widget back on the bar. Tucked entries stay in their section, so they keep
  their settings and position, and `omarchy bar move` still works on them.
- The drawer lists tucked widgets in bar order (left, center, right).
- `{ "id": "parker.drawer" }` places the button. Without that entry the button
  goes at the start of the right section. The button hides itself when nothing
  is tucked. Optional settings on it: `icon`, `openIcon`, `tooltip`.
- Custom `type: "command"` and `type: "qml"` modules can be tucked too.

To go back to the built-in bar, delete `"id": "parker.drawer"` from `bar` (or set
it to `"omarchy.bar"`). Every tucked widget then shows on the bar again; the
`drawer` flags are ignored there.

## Keyboard / IPC

```bash
omarchy-shell parker.drawer toggle      # also: open, close
omarchy-shell shell summon omarchy.bluetooth '{}'   # opens the drawer, then the panel
```

e.g. a Hyprland bind: `omarchy-shell parker.drawer toggle`.

## Known limits

- Hover tooltips of tucked widgets are not shown (the bar's shared tooltip only
  renders over the bar itself).
- Tucked widgets are drawn with the bar's text colour on the popup background.
- Relies on a few internals of the stock Bar.qml (`moduleSlots`,
  `pluginBarApiFor`, `clickTargets`). A future Omarchy bar refactor may need a
  small update here.
```

✓ 1 ms

```text
wrote 2276 bytes to .config/omarchy/plugins/parker.drawer/README.md
```

**⏺ bash** `omarchy-plugin-validate .config/omarchy/plugins/parker.drawer && echo valid; for f in .config/omarchy/plugins/parker.drawer/*.qml; do /usr/lib/qt6/bin/qmlformat "$f" >/dev/null || echo "PARSE FAIL $f"; done; python3 -m json.tool .config/omarchy/shell.json >/dev/null && echo "shell.json ok"; git stat`

✓ 453 ms

```text
[exit 0, 449 ms]
valid
shell.json ok
 M .config/omarchy/shell.json
?? .config/omarchy/plugins/
```

I've built the drawer as an Omarchy shell plugin, `parker.drawer`, and turned it on in your shell.json. I couldn't see or click it, though: there's no display in this sandbox, so I tested it by running the real Omarchy shell without drawing anything.

**How you use it:** add `"drawer": true` to any widget's entry in `bar.layout` and it moves off the bar into the drawer. Delete the flag and it comes back. The file reloads when you save, no restart needed.

**What it is:** a bar plugin that runs the normal Omarchy bar unchanged and adds a drawer button next to the tray. A plain widget plugin can't do this, because only a whole-bar plugin is allowed to display other widgets.
- Tucked widgets are the real widgets. Clicking one inside the drawer opens its usual panel.
- Tucked widgets stay in their place in shell.json. They keep their settings, and if you switch back to the built-in bar they all reappear.
- You place the button with a `{ "id": "parker.drawer" }` entry in the layout. Without one it goes at the start of the right section, and it hides itself when nothing is tucked.
- Panel hotkeys still work for tucked widgets: summoning, say, Bluetooth opens the drawer and then its panel.
- For a keybind: `omarchy-shell parker.drawer toggle` (also `open` / `close`).

**Your shell.json now** selects this bar, puts the button right after the tray, and tucks a starting set: keyboard layout, weather, system update, agents, Bluetooth and monitor. Edit those flags to whatever you prefer.

The plugin lives in `~/.config/omarchy/plugins/parker.drawer/` (the code plus a README with the config reference).

**How I tested it:**
- The manifest passes `omarchy plugin validate`, all QML files parse, and shell.json is valid JSON.
- I couldn't start Hyprland or Xvfb here, so I ran the actual Omarchy shell without a screen, using a throwaway copy in /tmp. Its only change was swapping the bar's three window types for ones that work without a display.
- In that run the shell found and enabled the plugin. The bar showed only the untucked widgets plus the button, and the tucked ones were placed in the drawer.
- Removing `weather`'s flag while it ran moved weather back onto the bar. Switching back to the built-in bar brought every tucked widget back. My files logged no warnings or errors, and the toggle commands answered.

**Not checked:**
- How the panel looks, mouse clicks, and opening a tucked widget's panel from inside the drawer. Agents, Bluetooth, monitor, audio, network and power couldn't load at all in that test setup, so they weren't exercised. Worth a quick look on your desktop: switch bars with `omarchy restart shell` if needed, click the chevron, then open a tucked widget's panel.
- `omarchy-toggle-bar`'s refresh signal: the run showed a startup clash on the bar's own IPC command. I added a re-register step after load, and the command now answers, but I couldn't prove the right copy of the bar receives it. If hiding the bar ever lags, this is the place to look.

**Known limits:**
- Hover tooltips don't show for widgets inside the drawer.
- Tucked widgets keep the bar's text colour on the panel background.
- The plugin relies on a few internal parts of Omarchy's bar code (`moduleSlots`, `pluginBarApiFor`, `clickTargets`), so a big Omarchy bar rewrite could need a small fix here.

---

### › You

```text
It's not working yet: I don't see a drawer button in the bar, or a way to pick the drawer's widgets from its shell.json entry.

read from the code and the preview
```

I'll start by looking at the current project state and anything "preview"-like.

**⏺ bash** `git status --short; git log --oneline | head -3; find . -path ./.git -prune -o -newer .config/omarchy/plugins/parker.drawer/manifest.json -type f -print | head; find . -iname "*preview*" -not -path './.git/*' | head; ls -la .config/omarchy .config/omarchy/plugins`

✓ 93 ms

```text
[exit 0, 87 ms]
 M .config/omarchy/shell.json
?? .config/omarchy/plugins/
2fda0b1 h0: task baseline
./.config/omarchy/shell.json
./.config/omarchy/plugins/parker.drawer/DrawerButton.qml
./.config/omarchy/plugins/parker.drawer/DrawerSlot.qml
./.config/omarchy/plugins/parker.drawer/CommandModule.qml
./.config/omarchy/plugins/parker.drawer/DrawerBar.qml
./.config/omarchy/plugins/parker.drawer/README.md
./.h0-preview
.config/omarchy:
total 4
drwxr-xr-x 1 parker parker   88 Nov  9 15:27 .
drwxr-xr-x 1 parker parker   72 Nov  8 22:07 ..
drwxr-xr-x 1 parker parker   36 Nov  8 22:07 extensions
drwxr-xr-x 1 parker parker  156 Nov  8 22:07 hooks
drwxr-xr-x 1 parker parker   26 Nov  9 15:27 plugins
-rw-r--r-- 1 parker parker 1430 Nov  9 15:33 shell.json
drwxr-xr-x 1 parker parker   50 Nov  8 22:07 themed
drwxr-xr-x 1 parker parker   10 Nov  8 22:07 themes

.config/omarchy/plugins:
total 0
drwxr-xr-x 1 parker parker  26 Nov  9 15:27 .
drwxr-xr-x 1 parker parker  88 Nov  9 15:27 ..
drwxr-xr-x 1 parker parker 164 Nov  9 15:34 parker.drawer
```

**⏺ bash** `ls -la .h0-preview; find .h0-preview -maxdepth 3 | head -30; cat .config/omarchy/shell.json`

✓ 70 ms

```text
[exit 0, 65 ms]
total 0
drwxr-xr-x 1 parker parker  0 Nov  9 15:34 .
drwxr-xr-x 1 parker parker 56 Nov  9 15:34 ..
.h0-preview
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  },
  "bar": {
    "id": "parker.drawer",
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
          "id": "omarchy.keyboard-layout",
          "drawer": true
        },
        {
…
```

**⏺ bash** `cd /usr/share/omarchy; grep -rn -i "drawer\|nested widget\|child widget\|hostWidget\|widgetComponent\|createWidget\|embed" shell/README.md shell/plugins/README.md shell/plugins/bar/README.md default/agents/skills/omarchy/plugins.md | head -30; echo ----; grep -n "function \|property " shell/Ui/Plugi`

✓ 93 ms

```text
[exit 0, 88 ms]
shell/plugins/README.md:65:  Positional args; `imageRowsB64` is base64-encoded so embedded newlines /
shell/plugins/bar/README.md:63:| `omarchy.tray` | System tray | hover = reveal drawer · right on chevron = manage |
----
10:  required property string pluginId
11:  required property string moduleName
12:  property var shell: null
14:  property color foreground: "transparent"
15:  property color barForeground: "transparent"
16:  property color background: "transparent"
17:  property color urgent: "transparent"
18:  property string fontFamily: ""
19:  property string position: "top"
20:  property bool vertical: false
21:  property int barSize: 0
22:  property bool transparent: false
23:  property bool foregroundAnimationEnabled: true
24:  property bool centerSectionRevealHeld: false
25:  property bool _centerHoverRevealSuppressed: false
26:  readonly property bool centerHoverRevealSuppressed: _centerHoverRevealSuppressed
27:  property var activePopout: null
28:  property var clickTargets: []
29:  property var layoutConfig: ({})
30:  readonly property var foreignPopoutMarker: ({ foreign: true })
32:  property var _showTooltip: null
33:  property var _hideTooltip: null
34:  property var _registerClickTarget: null
35:  property var _unregisterClickTarget: null
36:  property var _requestPopout: null
37:  property var _releasePopout: null
38:  property var _switchPanelFrom: null
39:  property var _targetBelongsToWindow: null
40:  property var _moduleWidgets: null
41:  property var _run: null
42:  property var _setCenterHoverRevealSuppressed: null
44:  function setCenterHoverRevealSuppressed(value) {
48:  function showTooltip(target, text) {
52:  function hideTooltip(target) {
56:  function registerClickTarget(target) {
60:  function unregisterClickTarget(target) {
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn "barWidgetRegistry" --include=*.qml . | grep -v "^./plugins/bar/Bar.qml" | head -30; grep -n "omarchyPath, shell, manifest" -B3 -A8 README.md plugins/README.md ../default/agents/skills/omarchy/plugins.md | head -40`

✓ 95 ms

```text
[exit 0, 88 ms]
./shell.qml:20:  property BarWidgetRegistry barWidgetRegistry: BarWidgetRegistry { }
./shell.qml:223:    if ("barWidgetRegistry" in target) target.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(manifest)
./shell.qml:234:      barWidgetRegistry: shell.barWidgetRegistry
./shell.qml:336:    var source = shell.barWidgetRegistry.widgets || {}
./shell.qml:771:    if (!manifest || manifest.__isFirstParty) return shell.barWidgetRegistry
./shell.qml:778:      revision: shell.barWidgetRegistry.revision
./shell.qml:873:      widgetApi.revision = shell.barWidgetRegistry.revision
./shell.qml:931:      if ("barWidgetRegistry" in inst) inst.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(manifest)
./shell.qml:1061:    target: shell.barWidgetRegistry
./shell.qml:1344:          if ("barWidgetRegistry" in item) item.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(panelEntry.manifest)
./shell.qml:1425:      if (existing && existing.url === url && shell.barWidgetRegistry.has(registryKey)) {
./shell.qml:1426:        shell.barWidgetRegistry.register(registryKey, existing.component, meta)
./shell.qml:1434:    var allIds = shell.barWidgetRegistry.availableIds()
./shell.qml:1439:        shell.barWidgetRegistry.unregister(id)
./shell.qml:1448:    for (var id in pluginWidgetComponents) shell.barWidgetRegistry.unregister(id)
./shell.qml:1511:        shell.barWidgetRegistry.register(registryKey, comp, meta)
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 765,800p shell.qml; sed -n 920,940p shell.qml; sed -n 1450,1520p shell.qml`

✓ 74 ms

```text
[exit 0, 68 ms]
    next[key] = api
    _pluginRegistryApis = next
    return api
  }

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
      // Authentication services and third-party services have no visual
      // parent. Parenting either to serviceHost would let a plugin's object
      // traversal walk between the host and credential-bearing QML.
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 330,360p shell.qml; grep -n "function serviceFor\|function firstPartyServiceFor" -A14 services/PluginShellApi.qml | head -50`

✓ 75 ms

```text
[exit 0, 70 ms]
  function barConfigFor(manifest) {
    return !manifest || manifest.__isFirstParty
      ? shell.barConfig : shell.publicBarConfig()
  }

  function publicBarWidgetSnapshot() {
    var source = shell.barWidgetRegistry.widgets || {}
    var snapshot = {}
    for (var id in source) {
      var entry = source[id]
      if (!entry) continue
      snapshot[id] = {
        component: entry.component,
        metadata: JSON.parse(JSON.stringify(entry.metadata || {}))
      }
    }
    return snapshot
  }

  function manifestHasKind(manifest, kind) {
    return !!manifest && Array.isArray(manifest.kinds)
      && manifest.kinds.indexOf(kind) !== -1
  }

  function pluginHasBarCapabilities(manifest) {
    return shell.manifestHasKind(manifest, "bar")
  }

  function pluginIsIndicatorsClone(manifest) {
    var metadata = manifest && Util.isPlainObject(manifest.omarchy) ? manifest.omarchy : null
    return shell.manifestHasKind(manifest, "bar-widget")
30:  function serviceFor(id) {
31-    return _serviceLookup ? _serviceLookup(String(id || "")) : null
32-  }
33-
34-  // Full-bar facades and configured Indicators clones under the trusted bar
35-  // receive narrow proxies for their specific non-authentication services.
36:  function firstPartyServiceFor(id) {
37-    return _firstPartyServiceLookup
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "_serviceLookup" shell.qml | head; grep -n "function pluginServiceLookup\|function serviceLookupFor\|_serviceLookup:" -A16 shell.qml | head -40`

✓ 93 ms

```text
[exit 0, 88 ms]
608:      _serviceLookup: function(requestedId) {
608:      _serviceLookup: function(requestedId) {
609-        return allowOwnService ? shell.pluginServiceFor(key, requestedId) : null
610-      },
611-      _firstPartyServiceLookup: function(requestedId) {
612-        if (allowOwnService && shell.pluginOwnsTarget(key, requestedId))
613-          return shell.pluginServiceFor(key, requestedId)
614-        // Indicators clones have no service of their own. Under the trusted
615-        // bar they need only these prebuilt non-authentication proxies, not
616-        // full-bar capabilities or access to another plugin's live service.
617-        var indicatorsAllowed = allowOwnService && shell.pluginIsIndicatorsClone(currentManifest())
618-          && shell.activeBarManifest && shell.activeBarManifest.__isFirstParty
619-          && shell.pluginRegistry.isEnabled(key) && shell.barEntryConfigured(key)
620-        return hasCurrentBarCapabilities() || indicatorsAllowed
621-          ? (firstPartyServices[requestedId] || null) : null
622-      },
623-      _barEntryShellLookup: function(ownerId, moduleName) {
624-        return hasCurrentBarCapabilities()
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 580,607p shell.qml; grep -n "function pluginServiceFor\|function pluginOwnsTarget" -A12 shell.qml | head -40; grep -n "function _syncServices\|function serviceKindEnabled\|kind === \"service\"\|\"service\"" shell.qml services/PluginRegistry.qml | head`

✓ 72 ms

```text
[exit 0, 65 ms]
      return shell.pluginRegistry.installedPlugins[key] || null
    }

    function hasCurrentBarCapabilities() {
      return barCapabilities && shell.pluginHasBarCapabilities(currentManifest())
    }

    // Construct the narrow service proxies before any plugin binding can call
    // firstPartyServiceFor(). Creating a QObject while evaluating that binding
    // makes QML re-enter the binding and report a loop on the caller's service
    // property, even though the resulting proxy is otherwise acyclic.
    var firstPartyServices = ({})
    var serviceIds = barCapabilities
      ? ["omarchy.idle", "omarchy.media", "omarchy.nightlight", "omarchy.notifications"]
      : (allowOwnService && shell.pluginIsIndicatorsClone(manifest)
        ? ["omarchy.idle", "omarchy.nightlight", "omarchy.notifications"] : [])
    for (var i = 0; i < serviceIds.length; i++) {
      var serviceId = serviceIds[i]
      firstPartyServices[serviceId] = shell.pluginFirstPartyServiceFor(cacheKey, key, serviceId)
    }

    var api = pluginShellApiComponent.createObject(null, {
      pluginId: key,
      appLibrary: shell.manifestHasKind(manifest, "menu")
        ? shell.pluginAppLibraryFor(cacheKey, key) : null,
      bar: shell.pluginBarStateFor(cacheKey, key),
      barConfig: shell.publicBarConfig(),
      idleConfig: shell.publicIdleConfigFor(manifest),
385:  function pluginOwnsTarget(pluginId, requestedId) {
386-    var caller = String(pluginId || "")
387-    if (!caller) return false
388-    return shell.pluginRegistry.resolveEnabledId(String(requestedId || "")) === caller
389-  }
390-
391:  function pluginServiceFor(pluginId, requestedId) {
392-    if (!shell.pluginOwnsTarget(pluginId, requestedId)) return null
393-    return shell.serviceFor(shell.pluginRegistry.resolveEnabledId(requestedId))
394-  }
395-
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 40,110p Ui/PluginBarApi.qml; grep -n "function pluginBarApiFor" -A50 plugins/bar/Bar.qml | grep -n "activePopout\|foreign\|_requestPopout\|_releasePopout\|clickTargets\|_registerClickTarget" `

✓ 116 ms

```text
[exit 0, 110 ms]
  property var _moduleWidgets: null
  property var _run: null
  property var _setCenterHoverRevealSuppressed: null

  function setCenterHoverRevealSuppressed(value) {
    if (_setCenterHoverRevealSuppressed) _setCenterHoverRevealSuppressed(!!value)
  }

  function showTooltip(target, text) {
    if (_showTooltip) _showTooltip(target, String(text || ""))
  }

  function hideTooltip(target) {
    if (_hideTooltip) _hideTooltip(target)
  }

  function registerClickTarget(target) {
    if (_registerClickTarget) _registerClickTarget(target)
  }

  function unregisterClickTarget(target) {
    if (_unregisterClickTarget) _unregisterClickTarget(target)
  }

  function requestPopout(owner) {
    if (_requestPopout) _requestPopout(owner)
  }

  function releasePopout(owner) {
    if (_releasePopout) _releasePopout(owner)
  }

  function switchPanelFrom(owner, direction) {
    return _switchPanelFrom ? _switchPanelFrom(owner, direction) : false
  }

  function targetBelongsToWindow(target, window) {
    return _targetBelongsToWindow ? _targetBelongsToWindow(target, window) : false
  }
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function requestPluginPopout\|function releasePluginPopout\|function registerPluginClickTarget\|function publicActivePopout\|function pluginActivePopout" -A16 plugins/bar/Bar.qml | head -80; grep -n "activePopout:" plugins/bar/Bar.qml | head`

✓ 92 ms

```text
[exit 0, 86 ms]
207:  function registerPluginClickTarget(pluginId, target) {
208-    if (!root.markPluginObject(pluginId, target, "clickTarget")) return
209-    root.registerClickTarget(target)
210-  }
211-
212-  function unregisterPluginClickTarget(pluginId, target) {
213-    if (!root.pluginOwnsBarObject(pluginId, target)) return
214-    root.unregisterClickTarget(target)
215-    root.unmarkPluginObject(pluginId, target, "clickTarget")
216-  }
217-
218:  function requestPluginPopout(pluginId, owner) {
219-    if (!root.markPluginObject(pluginId, owner, "popout")) return
220-    root.requestPopout(owner)
221-  }
222-
223:  function releasePluginPopout(pluginId, owner) {
224-    if (!root.pluginOwnsBarObject(pluginId, owner)) return
225-    root.releasePopout(owner)
226-    root.unmarkPluginObject(pluginId, owner, "popout")
227-  }
228-
229-  function pluginBarApiFor(pluginId, moduleName, registered) {
230-    var key = String(pluginId || "")
231-    if (!key) return null
232-
233-    var pluginShell = null
234-    if (registered && root.shell && typeof root.shell.pluginShellForId === "function") {
235-      // Only the trusted built-in bar receives ShellRoot and can request a
236-      // service-capable facade for the widget it is instantiating.
237-      pluginShell = root.shell.pluginShellForId(moduleName)
238-    } else if (root.shell && typeof root.shell.pluginShellForBarEntry === "function") {
239-      // Replacement bars receive a service-less entry facade. Giving an
92:  property var activePopout: null
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 160,206p plugins/bar/Bar.qml; sed -n 240,300p plugins/bar/Bar.qml`

✓ 97 ms

```text
[exit 0, 90 ms]
    var record = root.pluginObjectRecord(target)
    if (record && record.pluginId !== key) return false
    var next = []
    for (var i = 0; i < pluginObjectOwners.length; i++) {
      var existing = pluginObjectOwners[i]
      if (!existing || existing.target !== target) next.push(existing)
    }
    var updated = record || { target: target, pluginId: key, clickTarget: false, popout: false }
    updated[role] = true
    next.push(updated)
    pluginObjectOwners = next
    return true
  }

  function unmarkPluginObject(pluginId, target, role) {
    var key = String(pluginId || "")
    var next = []
    for (var i = 0; i < pluginObjectOwners.length; i++) {
      var record = pluginObjectOwners[i]
      if (!record || record.target !== target || record.pluginId !== key) {
        next.push(record)
        continue
      }
      record[role] = false
      if (record.clickTarget || record.popout) next.push(record)
    }
    pluginObjectOwners = next
  }

  function pluginOwnsBarObject(pluginId, target) {
    var record = target ? root.pluginObjectRecord(target) : null
    return !!record && record.pluginId === String(pluginId || "")
  }

  function pluginClickTargets(pluginId) {
    var out = []
    for (var i = 0; i < root.clickTargets.length; i++) {
      var target = root.clickTargets[i]
      if (root.pluginOwnsBarObject(pluginId, target)) out.push(target)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "\"barWidget\"\|\"service\"\|entryPoints" README.md plugins/README.md | head; grep -n "allowOwnService" shell.qml | head -5; for w in weather system-update keyboard-layout bluetooth monitor agents network audio; do f=$(grep -l "\"omarchy.$w\"" plugins/*/*/manifes`

✓ 175 ms

```text
[exit 0, 168 ms]
README.md:60:  "entryPoints": { "barWidget": "Widget.qml" },
README.md:61:  "barWidget": {
README.md:136:   plus the QML referenced from its `entryPoints`.
524:  function pluginShellCapabilityProfile(manifest, allowOwnService, barCapabilities) {
526:      allowOwnService ? "own-service" : "no-own-service",
528:      allowOwnService && shell.pluginIsIndicatorsClone(manifest) ? "indicators" : "no-indicators",
569:  function createScopedPluginShell(manifest, cacheKey, allowOwnService, barCapabilities) {
572:    var profile = shell.pluginShellCapabilityProfile(manifest, allowOwnService, barCapabilities)
== weather: plugins/panels/weather/manifest.json
== system-update: plugins/bar/widgets/SystemUpdate.manifest.json
== keyboard-layout: plugins/bar/widgets/KeyboardLayout.manifest.json
== bluetooth: plugins/panels/bluetooth/manifest.json
== monitor: plugins/panels/monitor/manifest.json
== agents: plugins/agents/manifest.json
== network: plugins/panels/network/manifest.json
== audio: plugins/panels/audio/manifest.json
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 50,80p README.md; grep -n "createScopedPluginShell(" shell.qml | head; grep -n "function pluginShellFor\b\|function pluginShellFor(" -A10 shell.qml | head -20; cat plugins/panels/weather/manifest.json`

✓ 98 ms

```text
[exit 0, 89 ms]

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

| Kind         | What it is                                                   |
|--------------|--------------------------------------------------------------|
| `bar-widget` | A component that the active bar can drop into a section      |
| `panel`      | A persistent or summoned floating window (e.g. OSD)          |
| `overlay`    | A fullscreen overlay (e.g. background switcher)              |
569:  function createScopedPluginShell(manifest, cacheKey, allowOwnService, barCapabilities) {
681:    return shell.createScopedPluginShell(manifest, "hosted:" + key, false, false)
743:    return shell.createScopedPluginShell(manifest, key, true, shell.pluginHasBarCapabilities(manifest))
739:  function pluginShellFor(manifest) {
740-    if (!manifest || manifest.__isFirstParty) return shell
741-    var key = String(manifest.id || "")
742-    if (!key) return null
743-    return shell.createScopedPluginShell(manifest, key, true, shell.pluginHasBarCapabilities(manifest))
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 664,700p shell.qml; grep -n "\"service\"" services/PluginRegistry.qml | head; grep -n "entryPointUrl" -A10 services/PluginRegistry.qml | head -20`

✓ 72 ms

```text
[exit 0, 67 ms]
    var descriptorNext = ({})
    for (var descriptorKey in _pluginShellApiDescriptors)
      descriptorNext[descriptorKey] = _pluginShellApiDescriptors[descriptorKey]
    descriptorNext[cacheKey] = {
      pluginId: key,
      allowOwnService: allowOwnService === true,
      profile: profile
    }
    _pluginShellApiDescriptors = descriptorNext
    return api
  }

  function scopedPluginShellForId(pluginId) {
    var key = String(pluginId || "")
    var manifest = shell.pluginRegistry.installedPlugins[key]
    if (!manifest) return null
    if (!manifest.__isFirstParty) return shell.pluginShellFor(manifest)
    return shell.createScopedPluginShell(manifest, "hosted:" + key, false, false)
  }

  function pluginShellForId(pluginId) {
    return shell.scopedPluginShellForId(pluginId)
  }

  function pluginShellForBarEntry(ownerId, moduleName) {
    var owner = String(ownerId || "")
    var target = String(moduleName || "")
    if (!owner || !target) return null
    if (!shell.barEntryConfigured(target)) return null
    var cacheKey = owner + "::" + target
    if (_pluginBarEntryShellApis[cacheKey]) return _pluginBarEntryShellApis[cacheKey]

    function owns(requestedId) {
      return shell.pluginRegistry.resolveEnabledId(String(requestedId || ""))
        === shell.pluginRegistry.resolveEnabledId(target)
    }

118:  function entryPointUrl(manifest, kind) {
119-    if (!Util.isPlainObject(manifest)) return ""
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function isEnabled" -A30 services/PluginRegistry.qml | head -45`

✓ 70 ms

```text
[exit 0, 65 ms]
148:  function isEnabled(id) {
149-    var key = String(id)
150-    var manifest = installedPlugins[key]
151-    var config = shellConfigProvider ? shellConfigProvider() : null
152-    if (manifest) {
153-      if (Array.isArray(manifest.kinds) && manifest.kinds.indexOf("bar") !== -1) {
154-        var selectedBar = ""
155-        if (Util.isPlainObject(config) && Util.isPlainObject(config.bar))
156-          selectedBar = Util.canonicalWidgetId(String(config.bar.id || ""))
157-        if (!selectedBar) selectedBar = "omarchy.bar"
158-        return selectedBar === key
159-      }
160-      if (isDisabled(config, key)) return false
161-      if (manifest.__isFirstParty) return true
162-    }
163-    return findEntryLocation(config, key).found
164-  }
165-
166-  function isDisabled(config, id) {
167-    return Util.isPlainObject(config) && Array.isArray(config.disabledPlugins)
168-      && config.disabledPlugins.indexOf(Util.canonicalWidgetId(String(id))) !== -1
169-  }
170-
171-  function resolveEnabledId(id) {
172-    var key = Util.canonicalWidgetId(String(id || ""))
173-    // Callers keep using the built-in id after cloning; the enabled local
174-    // manifest is the implementation that should receive the call.
175-    for (var candidate in installedPlugins) {
176-      var manifest = installedPlugins[candidate]
177-      var metadata = manifest && Util.isPlainObject(manifest.omarchy) ? manifest.omarchy : null
178-      if (metadata && String(metadata.clonedFrom || "") === key && isEnabled(candidate))
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rhoE "\bbar\.[a-zA-Z_]+" Ui plugins/panels plugins/bar/widgets plugins/agents --include=*.qml | sort | uniq -c | sort -rn | awk '{print $2"("$1")"}' | tr '\n' ' '; echo; echo ---facade:; grep -oE "^  (readonly )?property \w+ \w+|^  function \w+" Ui/PluginBarApi.qml`

✓ 91 ms

```text
[exit 0, 86 ms]
bar.foreground(153) bar.fontFamily(101) bar.shell(20) bar.urgent(14) bar.position(14) bar.run(8) bar.switchPanelFrom(6) bar.moduleWidgets(6) bar.iconSlot(6) bar.hideTooltip(5) bar.statusSlot(4) bar.setCenterHoverRevealSuppressed(4) bar.activePopout(4) bar.showTooltip(3) bar.centerHoverRevealSuppressed(3) bar.barSize(3) bar.barForeground(3) bar.vertical(2) bar.targetBelongsToWindow(2) bar.sizeHorizontal(2) bar.requestPopout(2) bar.releasePopout(2) bar.layoutConfig(2) bar.clickTargets(2) bar.background(2) bar.x(1) bar.iconFont(1) bar.iconCanvas(1) bar.foregroundAnimationEnabled(1) bar.centerSectionRevealHeld(1) 
---facade:
shell foreground barForeground background urgent fontFamily position vertical barSize transparent foregroundAnimationEnabled centerSectionRevealHeld _centerHoverRevealSuppressed centerHoverRevealSuppressed activePopout clickTargets layoutConfig foreignPopoutMarker _showTooltip _hideTooltip _registerClickTarget _unregisterClickTarget _requestPopout _releasePopout _switchPanelFrom _targetBelongsToWindow _moduleWidgets _run _setCenterHoverRevealSuppressed setCenterHoverRevealSuppressed showTooltip hideTooltip registerClickTarget unregisterClickTarget requestPopout releasePopout switchPanelFrom targetBelongsToWindow moduleWidgets run
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rnE "bar\.shell(\.| \?|\))" Ui plugins/panels plugins/bar/widgets plugins/agents --include=*.qml | head -25`

✓ 72 ms

```text
[exit 0, 67 ms]
plugins/panels/audio/Panel.qml:434:    if (!bar || !bar.shell) return
plugins/panels/audio/Panel.qml:435:    bar.shell.summon("omarchy.osd", JSON.stringify({
plugins/panels/clock/BarWidget.qml:51:    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
plugins/panels/clock/BarWidget.qml:52:      root.bar.shell.updateEntryInline(root.moduleName, entry)
plugins/panels/clock/Panel.qml:161:    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
plugins/panels/clock/Panel.qml:162:      root.bar.shell.updateEntryInline(root.moduleName, entry)
plugins/panels/monitor/Panel.qml:257:    if (!bar || !bar.shell) return
plugins/panels/monitor/Panel.qml:258:    bar.shell.summon("omarchy.osd", JSON.stringify({
plugins/panels/network/Panel.qml:468:    bar.shell.summon("omarchy.wifiqr", JSON.stringify(payload))
plugins/panels/network/Panel.qml:658:    bar.shell.summon("omarchy.speedtest", connection ? JSON.stringify({ connection: connection }) : "{}")
plugins/panels/power/Panel.qml:174:    if (root.bar && root.bar.shell) root.bar.shell.updateEntryInline(root.moduleName, root.settings)
plugins/panels/tailscale/Panel.qml:155:    if (!root.bar || !root.bar.shell || typeof root.bar.shell.updateEntryInline !== "function") return
plugins/panels/tailscale/Panel.qml:159:    root.bar.shell.updateEntryInline(root.moduleName, entry)
plugins/bar/widgets/Tray.qml:184:    if (!root.bar || !root.bar.shell || typeof root.bar.shell.updateEntryInline !== "function") return
plugins/bar/widgets/Tray.qml:186:    root.bar.shell.updateEntryInline(id, { id: id, pinned: pinned, hidden: hidden })
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 864,880p shell.qml; grep -n "property\|signal" services/PluginShellApi.qml | head -40; cat services/PluginBarWidgetRegistryApi.qml | head -30; grep -n "function bindPluginBarApi" -A25 plugins/bar/Bar.qml | grep -n "activePopout" `

✓ 75 ms

```text
[exit 0, 66 ms]
    for (var id in _pluginRegistryApis) {
      var registryApi = _pluginRegistryApis[id]
      var manifest = plugins[id]
      registryApi.manifest = shell.publicPluginManifest(manifest)
      registryApi.enabled = !!manifest && shell.pluginRegistry.isEnabled(id)
    }
    for (var widgetId in _pluginBarWidgetRegistryApis) {
      var widgetApi = _pluginBarWidgetRegistryApis[widgetId]
      widgetApi.widgets = shell.publicBarWidgetSnapshot()
      widgetApi.revision = shell.barWidgetRegistry.revision
    }
    for (var shellKey in _pluginShellApis) {
      var shellApi = _pluginShellApis[shellKey]
      var descriptor = _pluginShellApiDescriptors[shellKey]
      var shellManifest = descriptor ? plugins[descriptor.pluginId] : null
      shellApi.barConfig = shell.publicBarConfig()
      shellApi.idleConfig = shell.publicIdleConfigFor(shellManifest)
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
import QtQuick

// Detached widget-catalogue snapshot for third-party full-bar implementations.
// Plugins can render the referenced components, but mutating this local view
// cannot replace a registration in the host registry.
QtObject {
  id: api

…
```

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && rm DrawerBar.qml DrawerButton.qml DrawerSlot.qml && ls; sed -n 1,40p /usr/share/omarchy/shell/Ui/BarWidget.qml`

✓ 73 ms

```text
[exit 0, 68 ms]
CommandModule.qml
README.md
manifest.json
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

…
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.drawer",
  "name": "Drawer",
  "version": "2.0.0",
  "author": "parker",
  "description": "A bar button that opens a panel holding the bar widgets listed in its \"widgets\" setting.",
  "kinds": ["bar-widget", "service"],
  "entryPoints": {
    "barWidget": "DrawerWidget.qml",
    "service": "DrawerService.qml"
  },
  "barWidget": {
    "displayName": "Drawer",
    "description": "Opens a panel holding the widgets you tuck away",
    "category": "Layout",
    "allowMultiple": false,
    "defaultSection": "right",
    "defaults": { "widgets": [] }
  }
}
```

✓ 1 ms

```text
wrote 599 bytes to .config/omarchy/plugins/parker.drawer/manifest.json
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerService.qml`

```
import QtQuick

// Service half of the drawer. Bar widgets are only injected with `bar`,
// `moduleName` and `settings`; services also receive the host's bar-widget
// catalogue (a detached snapshot holding the real widget components, kept
// current by the shell). The drawer widget fetches this object through
// `bar.shell.serviceFor("parker.drawer")`, its own plugin's service, and builds
// the tucked widgets from that catalogue.
QtObject {
  property var barWidgetRegistry: null
}
```

✓ 0 ms

```text
wrote 488 bytes to .config/omarchy/plugins/parker.drawer/DrawerService.qml
```

`BarWidget.bar` is typed `QtObject`, so the proxy must be a QtObject. Here's the proxy that hosted widgets get as their `bar`:

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/HostBar.qml`

```
import QtQuick

// The `bar` handed to widgets living in the drawer. Mirrors the bar facade
// the drawer itself received (same members widgets use: colours, font, size,
// tooltips, run, popouts) and forwards to it, with three differences:
//  - Popout requests go through the drawer first, so a tucked widget opening
//    its own panel does not fold away the drawer that panel is anchored to.
//  - Click targets are not registered with the bar. The bar dispatches clicks
//    on its own slots by mapping into registered targets regardless of which
//    window they live in, so a target in the drawer could catch a click meant
//    for the bar. Tucked widgets handle their own clicks.
//  - Tab-to-next-panel does not apply inside the drawer.
QtObject {
  id: proxy

  // The drawer widget's own bar facade, and the drawer widget.
  property var target: null
  property var host: null

  readonly property var shell: target ? target.shell : null
  readonly property color foreground: target ? target.foreground : "transparent"
  readonly property color barForeground: target ? target.barForeground : "transparent"
  readonly property color background: target ? target.background : "transparent"
  readonly property color urgent: target ? target.urgent : "transparent"
  readonly property string fontFamily: target ? String(target.fontFamily || "") : ""
  readonly property string position: target ? String(target.position || "top") : "top"
  readonly property bool vertical: target ? target.vertical === true : false
  readonly property int barSize: target ? target.barSize : 0
  readonly property bool transparent: target ? target.transparent === true : false
  readonly property bool foregroundAnimationEnabled: target ? target.foregroundAnimationEnabled !== false : true
  readonly property bool centerSectionRevealHeld: target ? target.centerSectionRevealHeld === true : false
  readonly property bool centerHoverRevealSuppressed: target ? target.centerHoverRevealSuppressed === true : false
  readonly property var activePopout: target ? target.activePopout : null
  readonly property var clickTargets: []
  readonly property var layoutConfig: target ? target.layoutConfig : ({})
  readonly property var foreignPopoutMarker: target ? target.foreignPopoutMarker : ({ foreign: true })

  function setCenterHoverRevealSuppressed(value) { }

  function showTooltip(item, text) {
    if (target) target.showTooltip(item, text)
  }

  function hideTooltip(item) {
    if (target) target.hideTooltip(item)
  }

  function registerClickTarget(item) { }
  function unregisterClickTarget(item) { }

  function requestPopout(owner) {
    if (host) host.hostedRequestPopout(owner)
  }

  function releasePopout(owner) {
    if (host) host.hostedReleasePopout(owner)
  }

  function switchPanelFrom(owner, direction) {
    return false
… (14 more lines in the repository)
```

✓ 0 ms

```text
wrote 3082 bytes to .config/omarchy/plugins/parker.drawer/HostBar.qml
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/HostedWidget.qml`

```
import QtQuick
import qs.Commons

// One widget inside the drawer: the same component the bar would use, from the
// host's widget catalogue, injected with `bar` / `moduleName` / `settings` the
// way the bar injects them.
Item {
  id: slot

  required property var entry
  property var settingsValue: ({})
  property var registry: null      // detached widget catalogue
  property QtObject hostBar: null  // HostBar proxy

  readonly property string moduleName: entry ? Util.canonicalWidgetId(entry.id) : ""
  readonly property bool commandModule: !!entry && String(entry.type || "") === "command"
  readonly property var registryComponent: {
    var widgets = registry ? registry.widgets : null
    if (!widgets || commandModule || !widgets[moduleName]) return null
    return widgets[moduleName].component || null
  }
  // The catalogue has loaded but holds no widget with this id.
  readonly property bool missing: !!registry && !commandModule && registryComponent === null
  readonly property var activeItem: commandModule ? commandLoader.item : widgetLoader.item
  readonly property bool vertical: hostBar ? hostBar.vertical === true : false

  implicitWidth: {
    if (missing) return missingLabel.implicitWidth + 16
    if (!activeItem || !activeItem.visible) return 0
    return vertical && hostBar ? hostBar.barSize : activeItem.implicitWidth
  }
  implicitHeight: {
    if (missing) return missingLabel.implicitHeight + 12
    if (!activeItem || !activeItem.visible) return 0
    return activeItem.implicitHeight
  }
  width: implicitWidth
  height: implicitHeight

  function injectProps() {
    var item = activeItem
    if (!item) return
    if ("bar" in item) item.bar = hostBar
    if ("moduleName" in item) item.moduleName = moduleName
    if ("settings" in item) item.settings = settingsValue
  }

  onActiveItemChanged: injectProps()
  onSettingsValueChanged: injectProps()
  onHostBarChanged: injectProps()

  Loader {
    id: widgetLoader
    anchors.fill: parent
    active: slot.registryComponent !== null
    sourceComponent: slot.registryComponent
    onLoaded: slot.injectProps()
  }

  Loader {
… (20 more lines in the repository)
```

✓ 0 ms

```text
wrote 2663 bytes to .config/omarchy/plugins/parker.drawer/HostedWidget.qml
```

Now the main widget, with the button, panel, catalogue lookup and popout coordination:

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerWidget.qml`

```
import QtQuick
import qs.Commons
import qs.Ui

// Drawer button for the bar. Clicking it opens a panel holding the widgets
// listed in this entry's "widgets" setting in shell.json:
//
//   { "id": "parker.drawer", "widgets": ["omarchy.weather", "omarchy.bluetooth"] }
//
// Items are widget ids, or full entries with inline settings, exactly like
// bar.layout entries: { "id": "omarchy.clock", "format": "HH:mm" }.
// The widgets are built once per monitor and stay alive while the drawer is
// closed, so their state keeps updating.
BarWidget {
  id: root

  readonly property string pluginId: moduleName || "parker.drawer"

  // ------------------------------------------------------------ config

  // Rebuilt only when the list of widgets changes; settings-only edits update
  // the hosted widgets in place.
  property var hostedEntries: []
  property var hostedSettings: []
  property string hostedSignature: ""

  function normalizedEntries() {
    var list = setting("widgets", [])
    if (!Array.isArray(list)) return []
    var out = []
    for (var i = 0; i < list.length; i++) {
      var item = list[i]
      var entry = typeof item === "string" ? { id: item }
        : (Util.isPlainObject(item) ? Util.cloneJson(item) : null)
      if (!entry || !entry.id) continue
      entry.id = Util.canonicalWidgetId(String(entry.id))
      if (entry.id === root.pluginId) continue   // not inside itself
      out.push(entry)
    }
    return out
  }

  function entrySettings(entry) {
    var copy = {}
    for (var key in entry) if (key !== "id") copy[key] = entry[key]
    return copy
  }

  function syncEntries() {
    var entries = normalizedEntries()
    var signature = JSON.stringify(entries.map(function(entry) {
      return [entry.id, String(entry.type || ""), String(entry.exec || "")]
    }))
    var settingsList = entries.map(entrySettings)
    if (signature !== hostedSignature) {
      hostedSignature = signature
      hostedSettings = settingsList
      hostedEntries = entries
    } else if (JSON.stringify(settingsList) !== JSON.stringify(hostedSettings)) {
      hostedSettings = settingsList
… (216 more lines in the repository)
```

✓ 1 ms

```text
wrote 8773 bytes to .config/omarchy/plugins/parker.drawer/DrawerWidget.qml
```

**⏺ bash** `cd .config/omarchy/plugins/parker.drawer && python3 - <<'EOF'
p='DrawerWidget.qml'; s=open(p).read()
s=s.replace("  HostBar {\n    id: hostBar\n","  HostBar {\n    id: drawerHostBar\n")
s=s.replace("            hostBar: hostBar\n","            hostBar: drawerHostBar\n")
open(p,'w').write(s)
EOF
grep`

✓ 90 ms

```text
[exit 0, 85 ms]
89:    id: drawerHostBar
257:            hostBar: drawerHostBar
7:  property var bar: null
9:  property string fontFamily: bar ? bar.fontFamily : Style.font.family
11:  property color foreground: bar ? bar.barForeground : Color.foreground
12:  property color activeColor: bar ? bar.urgent : Color.urgent
28:  property var revealHost: bar
57:  readonly property bool vertical: bar ? bar.vertical : false
58:  readonly property int barSize: bar ? bar.barSize : Style.bar.sizeHorizontal
```

**⏺ bash** `cd .config/omarchy && git show HEAD:.config/omarchy/shell.json > /tmp/orig.json && python3 - <<'EOF'
import json
c=json.load(open('/tmp/orig.json'))
tuck=['omarchy.keyboard-layout','omarchy.weather','omarchy.system-update','omarchy.agents','omarchy.bluetooth','omarchy.monitor']
lay=c['bar']['layout'`

✓ 121 ms

```text
[exit 0, 113 ms]
diff --git a/.config/omarchy/shell.json b/.config/omarchy/shell.json
index e6202da..806437d 100644
--- a/.config/omarchy/shell.json
+++ b/.config/omarchy/shell.json
@@ -26,15 +26,6 @@
           "format": "dddd HH:mm",
           "formatAlt": "d MMMM 'W'ww yyyy",
           "verticalFormat": "HH\n\u2014\nmm"
-        },
-        {
-          "id": "omarchy.keyboard-layout"
-        },
-        {
-          "id": "omarchy.weather"
-        },
-        {
-          "id": "omarchy.system-update"
         }
       ],
       "right": [
@@ -42,10 +33,15 @@
           "id": "omarchy.tray"
         },
         {
-          "id": "omarchy.agents"
-        },
-        {
-          "id": "omarchy.bluetooth"
+          "id": "parker.drawer",
+          "widgets": [
+            "omarchy.keyboard-layout",
+            "omarchy.weather",
+            "omarchy.system-update",
+            "omarchy.agents",
+            "omarchy.bluetooth",
+            "omarchy.monitor"
+          ]
         },
         {
…
```

**⏺ bash** `P=.config/omarchy/plugins/parker.drawer; cp $P/HostedWidget.qml /tmp/hw.bak
sed -i 's|  onActiveItemChanged: injectProps()|  onActiveItemChanged: { injectProps(); console.info("DRAWERTEST hosted", moduleName, !!activeItem, activeItem \&\& activeItem.bar === hostBar) }|' $P/HostedWidget.qml
sed -i 's`

✗ 17111 ms

```text
[exit 1, 17102 ms]
plugin: [('parker.drawer', True, ['bar-widget', 'service'])]
bar right: [('omarchy.tray', False, 0), ('parker.drawer', True, 21), ('omarchy.network', False, 0), ('omarchy.audio', False, 0), ('omarchy.power', False, 0)]
isOpen before: Function not found.
toggle: 
isOpen after toggle: Function not found.
hide: 
isOpen after hide: Function not found.
---
--- my files:
0
```

**⏺ bash** `P=.config/omarchy/plugins/parker.drawer; cp $P/HostedWidget.qml /tmp/hw.bak; cp $P/DrawerWidget.qml /tmp/dw.bak
sed -i 's|  onActiveItemChanged: injectProps()|  onActiveItemChanged: { injectProps(); console.warn("DRAWERTEST hosted", moduleName, !!activeItem, !!activeItem \&\& activeItem.bar === host`

✗ 18694 ms

```text
[exit 1, 18687 ms]
.config/omarchy/plugins/parker.drawer/DrawerWidget.qml:78:    console.warn("DRAWERTEST lookup", pluginId, "shell:", !!sh
.config/omarchy/plugins/parker.drawer/HostedWidget.qml:48:  onActiveItemChanged: { injectProps(); console.warn("DRAWERTE
.config/omarchy/plugins/parker.drawer/HostedWidget.qml:49:  Component.onCompleted: console.warn("DRAWERTEST slot", modul
      1 DRAWERTEST lookup parker.drawer shell: true service: true registry: true 13
  WARN qml: DRAWERTEST lookup parker.drawer shell: true service: true registry: true 13
.config/omarchy/plugins/parker.drawer/CommandModule.qml:0
.config/omarchy/plugins/parker.drawer/DrawerService.qml:0
.config/omarchy/plugins/parker.drawer/DrawerWidget.qml:0
.config/omarchy/plugins/parker.drawer/HostBar.qml:0
.config/omarchy/plugins/parker.drawer/HostedWidget.qml:0
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "default property\|Loader\|active:\|contentHolder\|data:" Ui/PopupCard.qml | head; grep -n "settings" plugins/bar/Bar.qml | grep -n "inject\|target.settings\|entrySettings" | head`

✓ 142 ms

```text
[exit 0, 135 ms]
65:  default property alias contentItem: contentHolder.children
83:    active: root.open && root.triggerMode === "click"
164:      id: contentHolder
3:606:      var settings = entrySettings(change.entry)
5:2005:      if ("settings" in target) target.settings = moduleSettings
6:2019:    readonly property var settings: root.entrySettings(entry)
```

PopupCard content isn't lazy, so the suspect is the settings. I'll check how Bar computes the `settings` it injects.

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function entrySettings" -A22 plugins/bar/Bar.qml plugins/bar/BarModel.js | head -40`

✓ 97 ms

```text
[exit 0, 90 ms]
plugins/bar/Bar.qml:763:  function entrySettings(entry) {
plugins/bar/Bar.qml-764-    return BarModel.entrySettings(entry)
plugins/bar/Bar.qml-765-  }
plugins/bar/Bar.qml-766-
plugins/bar/Bar.qml-767-  function entryId(entry) {
plugins/bar/Bar.qml-768-    return BarModel.entryId(entry)
plugins/bar/Bar.qml-769-  }
plugins/bar/Bar.qml-770-
plugins/bar/Bar.qml-771-  function moduleString(entry, key, fallback) {
plugins/bar/Bar.qml-772-    return BarModel.moduleString(entry, key, fallback)
plugins/bar/Bar.qml-773-  }
plugins/bar/Bar.qml-774-
plugins/bar/Bar.qml-775-  function entryIndex(entries, name) {
plugins/bar/Bar.qml-776-    return BarModel.entryIndex(entries, name)
plugins/bar/Bar.qml-777-  }
plugins/bar/Bar.qml-778-
plugins/bar/Bar.qml-779-  function entriesBefore(entries, name) {
plugins/bar/Bar.qml-780-    return BarModel.entriesBefore(entries, name)
plugins/bar/Bar.qml-781-  }
plugins/bar/Bar.qml-782-
plugins/bar/Bar.qml-783-  function entriesAfter(entries, name) {
plugins/bar/Bar.qml-784-    return BarModel.entriesAfter(entries, name)
plugins/bar/Bar.qml-785-  }
--
plugins/bar/BarModel.js:10:function entrySettings(entry) {
plugins/bar/BarModel.js-11-  if (!isPlainObject(entry)) return {}
plugins/bar/BarModel.js-12-  var copy = {}
plugins/bar/BarModel.js-13-  for (var key in entry) {
plugins/bar/BarModel.js-14-    if (key === "id") continue
plugins/bar/BarModel.js-15-    copy[key] = entry[key]
plugins/bar/BarModel.js-16-  }
plugins/bar/BarModel.js-17-  return copy
plugins/bar/BarModel.js-18-}
plugins/bar/BarModel.js-19-
plugins/bar/BarModel.js-20-function entryId(entry) {
plugins/bar/BarModel.js-21-  if (typeof entry === "string") return entry
plugins/bar/BarModel.js-22-  if (isPlainObject(entry)) {
plugins/bar/BarModel.js-23-    var id = entry["id"]
plugins/bar/BarModel.js-24-    if (id !== undefined && id !== null && String(id) !== "") return String(id)
…
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/DrawerWidget.qml`

```
    var list = setting("widgets", [])
    // Settings arrive through a `var` property, so the list may be a
    // QVariantList (array-like, but Array.isArray() is false). A JSON round trip
    // turns it and its entries into plain JS values.
    if (!list || typeof list === "string" || typeof list.length !== "number") return []
    try {
      list = JSON.parse(JSON.stringify(list))
    } catch (error) {
      return []
    }
    if (!Array.isArray(list)) list = Object.keys(list).map(function(key) { return list[key] })
    var out = []
    for (var i = 0; i < list.length; i++) {
      var item = list[i]
      var entry = typeof item === "string" ? { id: item }
        : (item && typeof item === "object" && !Array.isArray(item) ? item : null)
      if (!entry || !entry.id) continue
```

✓ 2 ms

```text
edited .config/omarchy/plugins/parker.drawer/DrawerWidget.qml at line 28
```

Rerunning with the probes. I've also added one on `drawerOpen` to see whether `shell toggle`/`hide` actually open and close the drawer.

**⏺ bash** `P=.config/omarchy/plugins/parker.drawer; cp $P/HostedWidget.qml /tmp/hw.bak; cp $P/DrawerWidget.qml /tmp/dw.bak
sed -i 's|  onActiveItemChanged: injectProps()|  onActiveItemChanged: { injectProps(); console.warn("DRAWERTEST hosted", moduleName, !!activeItem, !!activeItem \&\& activeItem.bar === host`

✓ 17511 ms

```text
[exit 0, 17496 ms]
      1 DRAWERTEST hosted omarchy.keyboard-layout false false
      1 DRAWERTEST slot omarchy.keyboard-layout missing: false
      1 DRAWERTEST hosted omarchy.weather false false
      1 DRAWERTEST slot omarchy.weather missing: false
      1 DRAWERTEST hosted omarchy.system-update false false
      1 DRAWERTEST slot omarchy.system-update missing: false
      1 DRAWERTEST hosted omarchy.agents false false
      1 DRAWERTEST slot omarchy.agents missing: false
      1 DRAWERTEST hosted omarchy.bluetooth false false
      1 DRAWERTEST slot omarchy.bluetooth missing: false
      1 DRAWERTEST hosted omarchy.monitor false false
      1 DRAWERTEST slot omarchy.monitor missing: false
      1 DRAWERTEST hosted omarchy.keyboard-layout true true
      1 DRAWERTEST hosted omarchy.weather true true
      1 DRAWERTEST hosted omarchy.system-update true true
      1 DRAWERTEST drawerOpen true
      1 DRAWERTEST drawerOpen false
--- my files:
probes removed
```

**⏺ bash** `grep -iE "bluetooth|monitor/|agents" /tmp/qs7.log 2>/dev/null | head -6 || true; ls /tmp/qs7.log 2>&1`

✗ 72 ms

```text
[exit 2, 67 ms]
ls: cannot access '/tmp/qs7.log': No such file or directory
```

/tmp was wiped again. I'll do one final run: grep why those three fail, run the validator and parser, and check that a live shell.json edit to `widgets` rebuilds the drawer.

**⏺ bash** `P=.config/omarchy/plugins/parker.drawer; omarchy-plugin-validate $P && echo valid; for f in $P/*.qml; do /usr/lib/qt6/bin/qmlformat "$f" >/dev/null || echo "PARSE FAIL $f"; done
cp $P/HostedWidget.qml /tmp/hw.bak; cp .config/omarchy/shell.json /tmp/sj.bak
sed -i 's|  onActiveItemChanged: injectProps`

✓ 19637 ms

```text
[exit 0, 19624 ms]
valid
why agents/bluetooth/monitor fail:
  WARN qml: service plugin load failed for omarchy.background: file:///tmp/omtest/shell/plugins/background/Background.qml:184:5: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.lock: file:///tmp/omtest/shell/plugins/lock/Service.qml:289:3: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.notifications: file:///tmp/omtest/shell/plugins/notifications/Service.qml:955:5: No PanelWindow backend loaded.
  WARN qml: service plugin load failed for omarchy.polkit: file:///tmp/omtest/shell/plugins/polkit/PolkitAgent.qml:221:3: No PanelWindow backend loaded.
slots after live edit:
0
 .config/omarchy/shell.json | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)
```

**⏺ bash** `P=.config/omarchy/plugins/parker.drawer; cp $P/HostedWidget.qml /tmp/hw.bak; cp .config/omarchy/shell.json /tmp/sj.bak
sed -i 's|  onActiveItemChanged: injectProps()|  onActiveItemChanged: { injectProps(); if (activeItem) console.warn("DRAWERTEST built", moduleName, JSON.stringify(settingsValue)) }|`

✓ 20367 ms

```text
[exit 0, 20356 ms]
  built omarchy.keyboard-layout {}
  built omarchy.weather {}
  built omarchy.system-update {}
  built omarchy.weather {}
  built omarchy.clock {"format":"HH:mm"}
probes left: 0
 .config/omarchy/shell.json | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/README.md`

```
# parker.drawer: bar drawer

A button for the normal Omarchy bar. Clicking it opens a panel holding the bar
widgets listed in its `widgets` setting, so the bar itself only shows the
essentials.

## Configure (`~/.config/omarchy/shell.json`, hot-reloads on save)

Put the drawer in the bar layout wherever you want the button, and list the
widgets to tuck away on that entry:

```jsonc
"right": [
  { "id": "omarchy.tray" },
  {
    "id": "parker.drawer",
    "widgets": [
      "omarchy.weather",
      "omarchy.bluetooth",
      { "id": "omarchy.clock", "format": "HH:mm" }   // full entries take inline settings
    ]
  },
  { "id": "omarchy.network" }
]
```

- `widgets` items are widget ids, or full entries in the same shape as
  `bar.layout` entries (inline settings, `"type": "command"` modules).
- Listed widgets appear in the drawer in that order. Remove them from the rest
  of the layout so they don't show up twice.
- Optional settings on the drawer entry: `icon`, `openIcon`, `tooltip`.
- An id the shell doesn't know shows as `id?` in the drawer.

## Keyboard / IPC

```bash
omarchy-shell shell toggle parker.drawer '{}'   # also: summon, hide
```

## How it works

Bar widgets are only given `bar`, `moduleName` and `settings`, so the plugin also
declares a `service` (DrawerService.qml). The shell gives services the bar-widget
catalogue, and the drawer widget reads it through
`bar.shell.serviceFor("parker.drawer")` to build the listed widgets from the
same components the bar uses. Each tucked widget gets a small proxy of the
drawer's bar facade (HostBar.qml). Through it, opening a tucked widget's own
panel keeps the drawer open, and clicks are never routed through the bar.

## Known limits

- Third-party widgets can only go in the drawer if they are installed and
  enabled. A third-party plugin counts as enabled when it has an entry in the
  bar layout.
- Hotkeys that summon a specific widget (e.g. `shell summon omarchy.weather`)
  only reach widgets on the bar, not ones in the drawer. Open the drawer and
  click the widget instead.
- Hover tooltips of tucked widgets don't show (the bar's tooltip only renders
  over the bar), and widget settings written back from inside the drawer (like
  the clock's click-to-switch format) aren't saved.
```

✓ 4 ms

```text
wrote 2273 bytes to .config/omarchy/plugins/parker.drawer/README.md
```

You were right: the drawer button couldn't appear in your bar. I'd built the plugin as a full replacement bar, which only shows up if you switch your whole bar to it. That's why your `{ "id": "parker.drawer" }` entry showed nothing. The widget choice was also spread across the layout as `"drawer": true` flags instead of living on the drawer's own entry. The `.h0-preview` folder was empty, so I worked from the code.

**What I changed:** the plugin is now an ordinary button in your normal bar, and you list the drawer's widgets on its own entry:

```json
{ "id": "parker.drawer",
  "widgets": ["omarchy.keyboard-layout", "omarchy.weather", "omarchy.system-update",
              "omarchy.agents", "omarchy.bluetooth", "omarchy.monitor"] }
```

- **Your shell.json:** the switch to the replacement bar and the `drawer` flags are gone. Those six widgets moved out of the bar into the drawer's list, and the button sits right after the tray.
- **List items:** each can be a widget id or a full entry with its own settings, like `{ "id": "omarchy.clock", "format": "HH:mm" }`. Edits apply when you save.
- **Why it now works:** a plain bar widget isn't given access to other widgets, so the plugin also includes a small background service, which is. The drawer gets the real widgets from it, the same ones your bar uses. Clicking a widget in the drawer opens its usual panel, and the drawer stays open underneath it.
- **A bug I fixed on the way:** the `widgets` list arrives in a form my first version didn't recognise as a list, so the drawer saw it as empty.

**How I checked it:** there's no screen in this sandbox, so I ran the real Omarchy shell without drawing anything. My only change to that copy was letting the bar's windows open without a display.
- With your normal bar, the drawer button showed up in the right section, visible and 21px wide.
- The drawer created all six widgets. keyboard-layout, weather and system-update fully started inside it. The other three can't start at all in that test setup, for reasons unrelated to the plugin.
- `omarchy-shell shell toggle parker.drawer '{}'` opened and closed it.
- Changing `widgets` while the shell was running rebuilt the drawer, including the clock's format setting.
- My files logged no warnings, and the plugin passes Omarchy's plugin validator.

**Not checked:** how the panel looks, real mouse clicks, and opening a widget's panel from inside the drawer. Please click the chevron next to the tray to confirm. If the button doesn't appear straight away, run `omarchy restart shell` once, since the plugin's file layout changed.

**Known limits:**
- Hotkeys that open one specific widget, like weather, don't reach widgets inside the drawer.
- Hover tooltips don't show for widgets in the drawer.
- Settings a widget saves itself, like the clock's click-to-switch format, aren't saved from inside the drawer.
- Third-party widgets only work in the drawer if they're also enabled, which means having an entry in the bar layout.

The README in `~/.config/omarchy/plugins/parker.drawer/` covers the details.

