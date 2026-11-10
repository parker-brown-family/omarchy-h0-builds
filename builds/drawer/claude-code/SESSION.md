# Claude Code building Bar Drawer

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools claude-code

---

### › You

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

**⏺ Skill** `{"skill": "omarchy"}`

✓  ms

```text
Launching skill: omarchy
```

**⏺ bash** `cat ~/.claude/skills/omarchy/plugins.md; echo ---; echo $HOME; ls ~/.config/omarchy/ ~/.config/omarchy/plugins 2>&1; cat ~/.config/omarchy/shell.json`

✓  ms

```text
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

**⏺ bash** `echo $OMARCHY_PATH; S=${OMARCHY_PATH:-/usr/share/omarchy}/shell; ls $S $S/plugins; find $S -maxdepth 2 | head -80; ls $S/plugins/omarchy.tray $S/plugins/omarchy.clock; cat $S/plugins/omarchy.clock/*`

✗  ms

```text
Exit code 1
/usr/share/omarchy
/usr/share/omarchy/shell:
Commons
README.md
Ui
plugins
services
shell.qml

/usr/share/omarchy/shell/plugins:
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
/usr/share/omarchy/shell
/usr/share/omarchy/shell/Commons
/usr/share/omarchy/shell/Ui
/usr/share/omarchy/shell/plugins
/usr/share/omarchy/shell/services
/usr/share/omarchy/shell/README.md
/usr/share/omarchy/shell/shell.qml
/usr/share/omarchy/shell/Commons/Border.qml
/usr/share/omarchy/shell/Commons/BorderGeometry.js
/usr/share/omarchy/shell/Commons/Color.qml
/usr/share/omarchy/shell/Commons/Style.qml
/usr/share/omarchy/shell/Commons/Util.qml
/usr/share/omarchy/shell/Commons/qmldir
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; cat $S/README.md $S/plugins/README.md; ls -R $S/plugins/bar | head -100`

✓  ms

```text
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
    osd/
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; cat $S/plugins/bar/README.md; wc -l $S/plugins/bar/Bar.qml $S/plugins/bar/BarModel.js $S/services/*.qml $S/Ui/*.qml`

✓  ms

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

Quick update: I've read the Omarchy shell docs. Next I'm reading how the built-in bar loads widgets, since the drawer has to host other widgets inside its own panel.

**⏺ bash** `S=/usr/share/omarchy/shell; cat $S/Ui/PluginBarApi.qml $S/services/BarWidgetRegistry.qml $S/services/PluginBarWidgetRegistryApi.qml $S/services/PluginBarStateApi.qml $S/Ui/BarWidget.qml $S/Ui/WidgetButton.qml`

✓  ms

```text
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
  property var _moduleWidgets: null
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; grep -n "createObject\|Loader\|component\|function \|property " $S/plugins/bar/Bar.qml | head -250`

✓  ms

```text
15:  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
17:  property var barWidgetRegistry: fallbackBarWidgetRegistry
20:  property var pluginRegistry: null
25:  property var barConfig: ({})
28:  property var shell: null
31:  property var manifest: null
34:    property var widgets: ({})
35:    property int revision: 0
36:    function metadataFor(id) { return null }
41:  property bool barHidden: false
42:  property string home: Quickshell.env("HOME")
43:  property string stateHome: home + "/.local/state"
44:  property string omarchyConfigDir: home + "/.config/omarchy"
45:  property var fallbackBarConfig: ({
51:  property var layoutConfig: fallbackBarConfig.layout
52:  property string centerAnchor: ""
53:  property bool requestedTransparent: false
54:  property bool useTransparentForeground: false
55:  property bool transparent: false
56:  property bool centerSectionHovered: false
61:  property int barHoverCount: 0
63:  readonly property bool barHovered: barHoverCount > 0
64:  property bool centerSectionRevealHeld: false
65:  property bool centerHoverRevealSuppressed: false
66:  property int barConfigSerial: 0
67:  property string position: "top"
71:  property string fontFamily: Style.font.family
74:  property color themeForeground: Color.bar.text
75:  property color themeContrastForeground: Color.background
76:  property color transparentForeground: Color.bar.text
77:  property color foreground: themeForeground
78:  property color barForeground: useTransparentForeground ? transparentForeground : themeForeground
79:  property bool foregroundAnimationEnabled: true
80:  property color background: Color.bar.background
81:  property color urgent: Color.bar.active
86:  property var tooltipTarget: null
87:  property var pendingTooltipTarget: null
88:  property string tooltipText: ""
89:  property string pendingTooltipText: ""
90:  property bool tooltipShown: false
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 110,330p $S/plugins/bar/Bar.qml; sed -n 540,830p $S/plugins/bar/Bar.qml`

✓  ms

```text
  property var clickTargets: []
  property var moduleSlots: []
  property var pluginBarApis: ({})
  property var pluginObjectOwners: []

  Component {
    id: pluginBarApiComponent
    PluginBarApi { }
  }

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
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 1180,1400p $S/plugins/bar/Bar.qml; sed -n 1715,2076p $S/plugins/bar/Bar.qml`

✓  ms

```text
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

    delegate: Component {
      BarPanel {
        required property var modelData

        screen: modelData
      }
    }
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      DragGhostPanel {
        required property var modelData

        screen: modelData
        ghostScreen: modelData
      }
    }
  }

…
```

**⏺ bash** `S=/usr/share/omarchy/shell; cat $S/services/PluginShellApi.qml $S/services/PluginRegistryApi.qml; grep -n "pluginShellFor\|barWidgetRegistry\|clone\|sourcePluginId\|clonedFrom\|injectHost\|isFirstParty\|firstParty" $S/shell.qml $S/services/PluginRegistry.qml | head -80`

✓  ms

```text
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

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 200,240p $S/shell.qml; sed -n 310,420p $S/shell.qml; sed -n 570,900p $S/shell.qml`

✓  ms

```text
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

  Component {
    id: defaultBarComponent

    Bar {
      omarchyPath: shell.omarchyPath
      barWidgetRegistry: shell.barWidgetRegistry
      barConfig: shell.barConfig
      shell: shell
      manifest: shell.barManifestFor(shell.defaultBarId)
    }
  }
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 1395,1530p $S/shell.qml; ls $S/plugins/panels/audio; grep -n "shell\b\|shell\.\|property var shell\|barWidgetRegistry" $S/plugins/panels/audio/Panel.qml | head; whoami; omarchy-shell shell ping; omarchy-shell shell listPlugins | head -c 600`

✓  ms

```text
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
      if (existing && existing.url === url && !existing.component) continue

      // If the component URL is unchanged, just refresh the metadata in
      // place. We can't skip this even when the URL matches: manifests can
      // change schema, defaults, or sourceDir between rescans, and the
      // settings panel reads metadata from the registry.
      if (existing && existing.url === url && shell.barWidgetRegistry.has(registryKey)) {
        shell.barWidgetRegistry.register(registryKey, existing.component, meta)
        continue
      }

      loadPluginWidget(registryKey, url, meta)
    }

    // Drop registrations for plugins that are no longer present or enabled.
    var allIds = shell.barWidgetRegistry.availableIds()
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 1,40p $S/plugins/bar/Bar.qml; grep -n "manifest\b\|root.manifest\|pluginRegistry\." $S/plugins/bar/Bar.qml | head; grep -n "function canonicalWidgetId\|function normalizeLayout\|function normalizeEntry" -A25 $S/Commons/Util.qml | head -90`

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 140,220p $S/services/PluginRegistry.qml; grep -n "activeBarId\|activeBarManifest" $S/shell.qml | head -20; grep -n "id: \"\|kinds\|entryPoints" $S/plugins/bar/manifest.json; cat $S/plugins/bar/manifest.json`

✓  ms

```text
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
  // without an exclusion zone; updated by the FileView watcher further down.
…
```

✓  ms

```text
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
        return candidate
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 105,125p $S/shell.qml; sed -n 240,270p $S/shell.qml; grep -n "shell\.bar\b\|shell\.bar\.\|bar\.[a-zA-Z]*(" $S/shell.qml | grep -v "barWidgetRegistry\|barConfig\b" | head -40; grep -rn "shell\.bar\.\|\.bar\.\(summon\|moduleWidgets\|findPanel\)" $S/plugins --include=`

✓  ms

```text
    }
    applyShellConfig()
  }

  function persistShellConfig(nextConfig) {
    var payload = JSON.parse(JSON.stringify(nextConfig))
    payload.version = 1
    shellConfig = payload
    userConfigFile.setText(JSON.stringify(payload, null, 2) + "\n")
  }

  readonly property var barConfig: shellConfig && Util.isPlainObject(shellConfig.bar) ? shellConfig.bar : builtinShellConfig.bar
  onBarConfigChanged: {
    if (bar && "barConfig" in bar)
      bar.barConfig = shell.barConfigFor(shell.activeBarManifest)
  }
  FileView {
    id: defaultsFile
    path: shell.defaultsPath
    watchChanges: true
    printErrors: false

  Loader {
    id: defaultBarLoader

    active: shell.activeBarId === shell.defaultBarId
    sourceComponent: defaultBarComponent
    onLoaded: shell.configureBar(item, shell.barManifestFor(shell.defaultBarId))
    onActiveChanged: if (!active && shell.activeBarId !== shell.defaultBarId) shell.bar = null
  }

  Loader {
    id: pluginBarLoader

    active: !shell.pluginReloading && shell.activeBarId !== shell.defaultBarId && shell.activeBarSourceUrl !== ""
    source: shell.activeBarId !== shell.defaultBarId ? shell.activeBarSourceUrl : ""
    asynchronous: true
    onLoaded: shell.configureBar(item, shell.activeBarManifest)
    onActiveChanged: if (!active) shell.bar = null
    onStatusChanged: {
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; cat $S/Ui/Panel.qml $S/Ui/PanelController.qml $S/Ui/BarIconButton.qml; sed -n 1,80p $S/Ui/PopupCard.qml; ls $S/plugins/panels/*; cat $S/plugins/bar/BarModel.js | sed -n 1,80p`

✓  ms

```text
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
    var value = settings ? settings[name] : undefined
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 80,176p $S/Ui/PopupCard.qml; echo "WD=$WAYLAND_DISPLAY XDG=$XDG_RUNTIME_DIR HYP=$HYPRLAND_INSTANCE_SIGNATURE"; which quickshell qs qmllint qmllint6 /usr/lib/qt6/bin/qmllint 2>&1; pgrep -a quickshell; pgrep -a Hyprland`

✗  ms

```text
Exit code 1
  // grab and we close the popup. Skipped for hover-mode popups so the cursor
  // can move freely between the trigger and the popup.
  HyprlandFocusGrab {
    active: root.open && root.triggerMode === "click"
    windows: root.anchorWindow ? [root, root.anchorWindow] : [root]
    onCleared: root.close()
  }

  anchor {
    id: popupAnchor
    window: anchorItem ? anchorItem.QsWindow.window : null
    adjustment: PopupAdjustment.Slide
    edges: Edges.Top | Edges.Left
    gravity: Edges.Bottom | Edges.Right
    rect.width: 1
    rect.height: 1

    onAnchoring: {
      if (!root.anchorItem || !root.bar) return

      var target = root.anchorItem
      var popupWidth = root.implicitWidth
      var popupHeight = root.implicitHeight
      var localX = target.width / 2 - popupWidth / 2
      var localY = target.height + root.margin

      if (root.bar.position === "bottom") {
        localY = -popupHeight - root.margin
      } else if (root.bar.position === "left") {
        localX = target.width + root.margin
        localY = target.height / 2 - popupHeight / 2
      } else if (root.bar.position === "right") {
        localX = -popupWidth - root.margin
        localY = target.height / 2 - popupHeight / 2
      }

      var window = target.QsWindow.window
      if (!window) return

…
```

**⏺ bash** `cd /tmp && QT_QPA_PLATFORM=offscreen timeout 10 quickshell -p /usr/share/omarchy/shell 2>&1 | tail -30`

✓  ms

```text
  INFO: Launching config: "/usr/share/omarchy/shell/shell.qml"
  INFO: Shell ID: "c0240dfe8c8e8a421e1f8db23a03fc60" Path ID "c0240dfe8c8e8a421e1f8db23a03fc60"
  INFO: Saving logs to "/run/user/1000/quickshell/by-id/q7wte9ot/log.qslog"
 ERROR: Failed to load configuration
 ERROR:   caused by @shell.qml[232:5]: Type Bar unavailable
 ERROR:   caused by @plugins/bar/Bar.qml[1234:23]: No PanelWindow backend loaded.
Shell cwd was reset to ~
```

**⏺ bash** `which weston sway Hyprland start-hyprland cage labwc grim 2>&1 | grep -v "no "`

✓  ms

```text
/usr/bin/Hyprland
/usr/bin/start-hyprland
/usr/bin/grim
```

**⏺ bash** `S=/usr/share/omarchy/shell; grep -n "layout" $S/services/PluginRegistry.qml | head -40; grep -n "prune\|unknown" $S/shell.qml | head -20`

✓  ms

```text
136:  // be either the active bar option in `bar.id`, a layout entry inside
137:  // `bar.layout.*` (bar widgets), or a top-level entry in `plugins[]` (panels,
206:        || !Util.isPlainObject(config.bar.layout)) return { found: false }
211:      var entries = config.bar.layout[sections[s]]
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
451:        var cloneEntry = config.bar.layout[cloneLocation.section][cloneLocation.index]
454:          for (var i = config.bar.layout[sections[s]].length - 1; i >= 0; i--) {
455:            if (barEntryId(config.bar.layout[sections[s]][i]) === sourceId)
456:              config.bar.layout[sections[s]].splice(i, 1)
463:          config.bar.layout[cloneLocation.section][cloneLocation.index] = restoredEntry
531:            var sourceEntry = config.bar.layout[sourceLocation.section][sourceLocation.index]
534:            config.bar.layout[sourceLocation.section][sourceLocation.index] = replacement
538:            config.bar.layout[target.section].splice(target.index, 0, entry)
556:      else if (location.kind === "bar") config.bar.layout[location.section].splice(location.index, 1)
559:      // Dropping the layout entry is the whole story for a widget. Anything
795:  function prunePluginApis() {
862:    shell.prunePluginApis()
1157:      console.warn("summon: unknown plugin", id)
1282:    if (!loader || !loader.item) return "unknown"
1283:    if (typeof loader.item[method] !== "function") return "unknown"
1553:      return shell.summon("omarchy.image-picker", payload) ? "ok" : "unknown"
1621:      return shell.pluginRegistry.setEnabled(id, enabled === "true") ? "ok" : "unknown"
1628:        return shell.pluginRegistry.lastEnableError || "unknown"
1716:      return shell.summon(id, payloadJson) ? "ok" : "unknown"
1729:    // it after the bar is rearranged. Returns the id it acted on, or "unknown"
1735:      if (!id) return "unknown"
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 340,400p $S/plugins/bar/Bar.qml; sed -n 905,1020p $S/plugins/bar/Bar.qml; grep -n "function pickPanelSlot" -A30 $S/plugins/bar/BarModel.js`

✓  ms

```text
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
        width: Math.round(slot.width),
        height: Math.round(slot.height),
        visible: slot.visible === true && slot.width > 0 && slot.height > 0,
        itemVisible: slot.activeItem.visible === true,
        itemWidth: Math.round(slot.activeItem.implicitWidth || 0),
        itemHeight: Math.round(slot.activeItem.implicitHeight || 0)
      })
    }
    return out
  }

…
```

**⏺ bash** `S=/usr/share/omarchy/shell; cat $S/plugins/bar/widgets/SystemUpdate.qml $S/plugins/bar/widgets/SystemUpdate.manifest.json; sed -n 1,80p $S/plugins/panels/monitor/Panel.qml; cat $S/Commons/Style.qml | head -120`

✓  ms

```text
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
    if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation omarchy-update")
  }

  visible: updateAvailable
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  IpcHandler {
    target: "omarchy.system-update"

    function refresh(): void {
      root.broadcast("refresh")
    }

    function clear(): void {
      root.broadcast("clear")
    }
  }

  Process {
    id: updateProc
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; grep -n "bar: \|property var bar\|iconSlot\|statusSlot\|iconFont\|sizeHorizontal\|function space\b\|function space(\|popupPadding\|gapsOut" $S/Commons/Style.qml | head -30; grep -n "function \(surfaceSpec\|localOrSurfaceSpec\|flat\)" $S/Commons/Border.qml; grep -n "popups`

✓  ms

```text
11:// `cornerRadius` mirrors Hyprland's `decoration:rounding`. `gapsOut` is
32:  property int gapsOut: 5
219:  function space(px) {
260:    readonly property int popupPadding: root.spacingToken("popup-padding", 14)
282:  property var barOverrides: ({})
341:  readonly property QtObject bar: QtObject {
342:    readonly property int sizeHorizontal: root.barToken("size-horizontal", 26)
344:    readonly property int iconSlot:       root.barToken("icon-slot",       27)
346:    readonly property int iconFont:       root.barToken("icon-font",       13)
347:    readonly property int statusSlot:     root.barToken("status-slot",     21)
352:    gapsOutProc.running = true
375:      if (isFinite(n) && n >= 0) gapsOut = Math.max(0, Math.round(n / 2))
451:  property Process gapsOutProc: Process {
452:    id: gapsOutProc
16:  function flat(color, width) {
105:  function localOrSurfaceSpec(section, token, localColor, defaultColor, fallbackWidth, alphaKey) {
140:  function surfaceSpec(section, token, fallbackColor, fallbackWidth, alphaKey) {
73:  readonly property QtObject bar: QtObject {
78:  readonly property QtObject popups: QtObject {
79:    property color background: root.composed("popups.background", "popups.background-alpha", root.background, 1.0)
80:    property color text: root.pick("popups.text", root.foreground)
81:    property color border: root.composed("popups.border", "popups.border-alpha", root.accent, 1.0)
import QtQuick
import qs.Commons

// Rectangle-compatible surface with Omarchy border specs. Uses native
// Rectangle.border for cheap flat/uniform borders and BorderOverlay for
// gradients or per-side widths.
Rectangle {
  id: root

  property var borderSpec: Border.none()
  property real padding: 0
  property real topPadding: padding
  property real rightPadding: padding
  property real bottomPadding: padding
  property real leftPadding: padding

  readonly property real borderTop: Border.top(borderSpec)
  readonly property real borderRight: Border.right(borderSpec)
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 1145,1220p $S/shell.qml`

✓  ms

```text
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
    for (var k in openPanelIds) next[k] = openPanelIds[k]
    next[id] = true
    openPanelIds = next

    // Stash payload so the Loader.onLoaded handler can hand it to open().
    var pending = ({})
    for (var p in pendingPayloads) pending[p] = pendingPayloads[p].slice()
    var queue = pending[id] || []
    queue.push(payloadJson || "")
    pending[id] = queue
…
```

Next I'm writing the plugin files in `~/.config/omarchy/plugins/parker.drawer/`.

**⏺ bash** `S=/usr/share/omarchy/shell; grep -n "function fileUrl\|function isPlainObject" -A4 $S/Commons/Util.qml; grep -n "function pickDrawnSlot" -A15 $S/plugins/bar/BarModel.js; grep -rn "\"omarchy\":\|clonedFrom" ~/.config/omarchy/plugins 2>/dev/null | head -2; grep -n "omarchy-plugin-clone\|manifest" $(wh`

✓  ms

```text
42:  function fileUrl(path) {
43-    if (!path) return ""
44-    return "file://" + String(path).split("/").map(encodeURIComponent).join("/")
45-  }
46-
--
66:  function isPlainObject(value) {
67-    return value !== null && typeof value === "object" && !Array.isArray(value)
68-  }
69-
70-  function canonicalWidgetId(id) {
146:function pickDrawnSlot(slots) {
147-  var placeholder = null
148-  var list = slots || []
149-  for (var i = 0; i < list.length; i++) {
150-    if (!list[i]) continue
151-    if (isDrawnSlot(list[i])) return list[i]
152-    if (!placeholder) placeholder = list[i]
153-  }
154-  return placeholder
155-}
156-
157-// A bar surface is built per monitor, so a panel hotkey has several live
158-// copies of the same widget to route to, and the panel opens on whichever
159-// monitor's copy answers. Candidates are `{ slot, screenName, opened }`.
160-//
161-// An open copy wins first: hide and toggle have to reach the panel the user
12:  echo "omarchy-plugin-clone: $*" >&2
18:  local manifest="$2"
21:  if [[ ${manifest##*/} == "manifest.json" ]]; then
26:  cp -aL "$manifest" "$target_dir/manifest.json"
50:  ' "$manifest")
53:update_manifest() {
58:  local manifest="$target_dir/manifest.json"
61:  # uses clonedFrom to route those calls to this local manifest id.
78:    ' "$manifest" >"$manifest.tmp"
79:  mv "$manifest.tmp" "$manifest"
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.drawer",
  "name": "Drawer bar",
  "version": "1.0.0",
  "author": "parker",
  "description": "The stock Omarchy bar plus a drawer button that tucks chosen widgets into a pop-out panel",
  "kinds": [
    "bar"
  ],
  "entryPoints": {
    "bar": "Bar.qml"
  }
}
```

✓  ms

```text
File created successfully at: ~/.config/omarchy/plugins/parker.drawer/manifest.json (file state is current in your context — no need to Read it back)
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/Bar.qml`

```
import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons

// Full-bar option that wraps the stock Omarchy bar instead of forking it.
//
// The stock Bar.qml is loaded straight from $OMARCHY_PATH, so it keeps
// tracking Omarchy updates. This wrapper only edits what the stock bar sees:
//   - widgets listed in a drawer entry's `items` are filtered out of the
//     layout handed to the stock bar, so they leave the bar itself;
//   - the drawer id is added to the widget catalogue, so a
//     `{ "id": "parker.drawer", "items": [...] }` layout entry renders as the
//     drawer button (Drawer.qml), which hosts the tucked widgets in a panel.
//
// Tucked widgets stay in `bar.layout`, so enable state, inline settings and
// `omarchy bar` commands keep working on them exactly as before.
Item {
  id: root

  // Injected by omarchy-shell (see configureBar in shell.qml). barConfig is
  // assigned last, so it doubles as the "fully configured" signal.
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null
  property var barWidgetRegistry: null
  property var pluginRegistry: null
  property var barConfig: ({})
  property bool configured: false
  onBarConfigChanged: configured = true

  readonly property string drawerId: manifest && manifest.id ? String(manifest.id) : "parker.drawer"
  readonly property var stockBar: stockLoader.item
  property var drawers: []

  // Read by shell.qml, the bar-state facade and notifications.
  readonly property bool barHidden: stockBar ? stockBar.barHidden === true : false
  readonly property int barSize: stockBar ? stockBar.barSize : 0
  readonly property string fontFamily: stockBar ? stockBar.fontFamily : ""
  readonly property string position: stockBar ? stockBar.position : "top"

  function layoutSection(config, region) {
    var layout = config && Util.isPlainObject(config.layout) ? config.layout : null
    return layout && Array.isArray(layout[region]) ? layout[region] : []
  }

  function entryId(entry) {
    var normalized = Util.normalizeLayoutEntry(entry)
    return normalized ? String(normalized.id) : ""
  }

  function entrySettings(entry) {
    var normalized = Util.normalizeLayoutEntry(entry)
    if (!normalized) return {}
    delete normalized.id
    return normalized
  }

  function findLayoutEntry(config, id) {
    var regions = ["left", "center", "right"]
… (190 more lines in the repository)
```

✓  ms

```text
File created successfully at: ~/.config/omarchy/plugins/parker.drawer/Bar.qml (file state is current in your context — no need to Read it back)
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/Drawer.qml`

```
import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// Drawer button plus the panel holding the tucked widgets.
//
// The stock bar injects itself as `bar` (the wrapper flags this widget
// first-party), so each tucked widget is built and wired the way the bar's own
// module slots do it: same component, same `bar`, same inline settings. Each
// holder also registers as a bar module slot, which keeps broadcasts, plugin
// bar facades and panel lookups aware of the widgets living in here.
//
// The panel is a plain popup rather than a bar popout: tucked widgets open
// their own popouts on top of it, and taking the bar's single popout slot
// would make the first one close the drawer underneath it.
Panel {
  id: root

  property var host: null

  readonly property bool vertical: bar ? bar.vertical : false
  readonly property int barSize: bar ? bar.barSize : Style.bar.sizeHorizontal
  readonly property var barWindow: button.QsWindow.window
  readonly property string screenName: barWindow && barWindow.screen ? String(barWindow.screen.name || "") : ""

  // Ids only change when `items` does. Keeping the model a joined string means
  // unrelated shell.json writes do not rebuild every tucked widget.
  readonly property string itemsKey: host ? host.drawerItemIds(settings).join("\n") : ""
  readonly property var itemIds: itemsKey ? itemsKey.split("\n") : []

  readonly property bool hostedPopoutOpen: bar ? isHosted(bar.activePopout) : false
  property var pendingItem: null

  function hosts(id) {
    return itemIds.indexOf(String(id || "")) !== -1
  }

  function holders() {
    var out = []
    for (var i = 0; i < repeater.count; i++) {
      var holder = repeater.itemAt(i)
      if (holder) out.push(holder)
    }
    return out
  }

  function hostedItem(id) {
    var list = holders()
    for (var i = 0; i < list.length; i++)
      if (list[i].moduleName === id) return list[i].activeItem
    return null
  }

  function inPanelWindow(target) {
    try {
      return !!target && !!target.QsWindow && target.QsWindow.window === panel
    } catch (e) {
      return false
… (352 more lines in the repository)
```

✓  ms

```text
File created successfully at: ~/.config/omarchy/plugins/parker.drawer/Drawer.qml (file state is current in your context — no need to Read it back)
```

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 1110,1180p $S/plugins/bar/Bar.qml`

✓  ms

```text
  function runProcess(process) {
    if (!process.running)
      process.running = true
  }

  function showTooltip(target, text) {
    clearTooltip()

    if (!targetTooltipHovered(target) || !text) {
      tooltipRequest += 1
      return
    }

    var request = tooltipRequest + 1
    tooltipRequest = request
    pendingTooltipTarget = target
    pendingTooltipText = text

    Qt.callLater(function() {
      if (request !== tooltipRequest) return
      if (!targetTooltipHovered(pendingTooltipTarget)) {
        clearTooltip()
        return
      }
      tooltipTarget = pendingTooltipTarget
      tooltipText = pendingTooltipText
      pendingTooltipTarget = null
      pendingTooltipText = ""
      tooltipTimer.restart()
    })
  }

  function hideTooltip(target) {
    if (tooltipTarget !== target && pendingTooltipTarget !== target) return

    tooltipRequest += 1
    clearTooltip()
  }

  Timer {
…
```

Good, tooltips will work. Fixing two bugs I spotted in my draft: the default icon was empty, which would hide the button, and a handler parameter shadowed the `button` id.

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && python3 - <<'EOF'
p='Drawer.qml'; s=open(p).read()
s=s.replace('''    text: String(root.setting("icon", ""))''','''    text: String(root.setting("icon", "\\uf141"))''')
s=s.replace('''    onPressed: function(button) {
      if (button === Qt.LeftButton) `

✓  ms

```text
171:    onPressed: function(mouseButton) {
172:      if (mouseButton === Qt.LeftButton) root.toggle()
Usage: /usr/lib/qt6/bin/qmllint [options] files
QML syntax verifier and analyzer

All warnings can be set to three levels:
    disable - Fully disables the warning.
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && grep -n 'setting("icon"' Drawer.qml`

✓  ms

```text
168:    text: String(root.setting("icon", ""))
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && sed -n 168p Drawer.qml | od -c | head -3`

✓  ms

```text
0000000                   t   e   x   t   :       S   t   r   i   n   g
0000020   (   r   o   o   t   .   s   e   t   t   i   n   g   (   "   i
0000040   c   o   n   "   ,       " 357 205 201   "   )   )  \n
```

The icon glyph was already there, just invisible in the terminal. I'll switch it to an explicit `\uf141` escape so it's readable, matching how stock widgets write glyphs. Then I'll lint.

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && sed -i '168s/"icon", "[^"]*"/"icon", "\\uf141"/' Drawer.qml && sed -n 168p Drawer.qml && for f in Bar.qml Drawer.qml; do echo "== $f"; /usr/lib/qt6/bin/qmllint -I /usr/lib/qt6/qml "$f" 2>&1 | grep -iv "unqualified\|import qs\|Warning: .*qs\.\|was not fou`

✓  ms

```text
    text: String(root.setting("icon", "\uf141"))
== Bar.qml
^^^^^^
---
---

// `omarchy bar` commands keep working on them exactly as before.
^^^^^
Warning: Bar.qml:165:5: Type Drawer is used but it is not resolved [unresolved-type]
    Drawer {
    ^^^^^^
    var layout = config && Util.isPlainObject(config.layout) ? config.layout : null
                           ^^^^
    var normalized = Util.normalizeLayoutEntry(entry)
                     ^^^^
    var normalized = Util.normalizeLayoutEntry(entry)
                     ^^^^
      if (Util.isPlainObject(items[i]) && entryId(items[i]) === id) return entrySettings(items[i])
          ^^^^
    var config = Util.isPlainObject(barConfig) ? barConfig : ({})
                 ^^^^
    if (tucked.length === 0 || !Util.isPlainObject(config.layout)) return config
                                ^^^^
    var copy = Util.cloneJson(config)
               ^^^^
      host: root
            ^^^^
Info: Set "pragma ComponentBehavior: Bound" in order to use IDs from outer components in nested components.
pragma ComponentBehavior: Bound
import QtQuick
      setSource(Util.fileUrl(root.omarchyPath + "/shell/plugins/bar/Bar.qml"), {
                ^^^^
== Drawer.qml
^^^^^^
---
---

^^^^^^
---
---
…
```

**⏺ bash** `Hyprland --version | head -3; strings /usr/lib/libaquamarine.so* 2>/dev/null | grep -i "headless\|AQ_" | head -20`

✓  ms

```text
terminate called after throwing an instance of 'std::runtime_error'
  what():  XDG_RUNTIME_DIR is not set!
[1;35mCRIT [0m]: Critical error thrown: XDG_RUNTIME_DIR is not set!
_ZN9Hyprutils6Memory14CSharedPointerIN10Aquamarine16CHeadlessBackendEE7_deleteEPv
_ZTSN10Aquamarine16CHeadlessBackendE
_ZTIN10Aquamarine16CHeadlessBackendE
_ZTVN10Aquamarine16CHeadlessBackendE
_ZN10Aquamarine15CHeadlessOutput4testEv
_ZN10Aquamarine15CHeadlessOutput16getRenderFormatsEv
_ZN10Aquamarine15CHeadlessOutput15pendingPageFlipEv
_ZN10Aquamarine15CHeadlessOutput16pendingIdleFrameEv
_ZN10Aquamarine16CHeadlessBackend4typeEv
_ZN10Aquamarine16CHeadlessBackend5startEv
_ZN10Aquamarine16CHeadlessBackend5drmFDEv
_ZN10Aquamarine16CHeadlessBackend15drmRenderNodeFDEv
_ZN10Aquamarine16CHeadlessBackend14dispatchEventsEv
_ZN10Aquamarine16CHeadlessBackend12capabilitiesEv
_ZN10Aquamarine16CHeadlessBackend9setCursorEN9Hyprutils6Memory14CSharedPointerINS_7IBufferEEERKNS1_4Math8Vector2DE
_ZN10Aquamarine16CHeadlessBackend7onReadyEv
_ZN10Aquamarine16CHeadlessBackend16getCursorFormatsEv
_ZN10Aquamarine16CHeadlessBackend18preferredAllocatorEv
_ZN10Aquamarine16CHeadlessBackend10getPrimaryEv
_ZN10Aquamarine16CHeadlessBackendD2Ev
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerModel.js`

```
.pragma library

// Pure layout helpers for the drawer bar. Kept free of QML so they can be
// exercised outside the shell.

var REGIONS = ["left", "center", "right"]

function isPlainObject(value) {
  return value !== null && typeof value === "object" && !Array.isArray(value)
}

function entryId(entry) {
  if (typeof entry === "string") return entry
  if (isPlainObject(entry) && entry.id !== undefined && entry.id !== null) return String(entry.id)
  return ""
}

function entrySettings(entry) {
  if (!isPlainObject(entry)) return {}
  var copy = JSON.parse(JSON.stringify(entry))
  delete copy.id
  return copy
}

function layoutSection(config, region) {
  var layout = isPlainObject(config) && isPlainObject(config.layout) ? config.layout : null
  return layout && Array.isArray(layout[region]) ? layout[region] : []
}

function findLayoutEntry(config, id) {
  for (var r = 0; r < REGIONS.length; r++) {
    var entries = layoutSection(config, REGIONS[r])
    for (var i = 0; i < entries.length; i++)
      if (entryId(entries[i]) === id) return entries[i]
  }
  return null
}

// Ordered, de-duplicated widget ids from one drawer's `items` setting.
// Items are ids ("omarchy.audio") or entries ({ "id": "omarchy.audio", ... }).
function drawerItemIds(settings, drawerId) {
  var items = isPlainObject(settings) && Array.isArray(settings.items) ? settings.items : []
  var ids = []
  for (var i = 0; i < items.length; i++) {
    var id = entryId(items[i])
    if (id && id !== drawerId && ids.indexOf(id) === -1) ids.push(id)
  }
  return ids
}

// Every id tucked by any drawer entry in the layout. A layout without a
// drawer entry tucks nothing, so widgets can never become unreachable.
function tuckedIds(config, drawerId) {
  var out = []
  for (var r = 0; r < REGIONS.length; r++) {
    var entries = layoutSection(config, REGIONS[r])
    for (var i = 0; i < entries.length; i++) {
      if (entryId(entries[i]) !== drawerId) continue
      var ids = drawerItemIds(entrySettings(entries[i]), drawerId)
      for (var j = 0; j < ids.length; j++) if (out.indexOf(ids[j]) === -1) out.push(ids[j])
… (42 more lines in the repository)
```

✓  ms

```text
File created successfully at: ~/.config/omarchy/plugins/parker.drawer/DrawerModel.js (file state is current in your context — no need to Read it back)
```

**⏺ bash** `tail -5 /usr/share/omarchy/shell/plugins/bar/BarModel.js; ls /usr/share/omarchy/shell/plugins/bar/ /usr/share/omarchy/test* 2>/dev/null | head; grep -rln "BarModel.js" /usr/share/omarchy --include=*.js --include=*.mjs --include=*.sh 2>/dev/null | head`

✓  ms

```text
    customModuleSafeName: customModuleSafeName,
    customModuleType: customModuleType,
    customModulePath: customModulePath
  }
}
/usr/share/omarchy/shell/plugins/bar/:
Bar.qml
BarModel.js
README.md
indicators
manifest.json
widgets
```

The stock `BarModel.js` uses the same `module.exports` guard and no `.pragma`, so I'll match it. Then I'll point `Bar.qml` at the model.

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && sed -i '1{/^\.pragma library$/d};1{/^$/d}' DrawerModel.js && head -3 DrawerModel.js && python3 - <<'EOF'
p='Bar.qml'; s=open(p).read()
start=s.index('  function layoutSection(config, region) {')
end=s.index('  // The host\'s widget catalogue plus the dra`

✓  ms

```text
// Pure layout helpers for the drawer bar. Kept free of QML so they can be
// exercised outside the shell.
import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import "DrawerModel.js" as DrawerModel

// Full-bar option that wraps the stock Omarchy bar instead of forking it.
//
// The stock Bar.qml is loaded straight from $OMARCHY_PATH, so it keeps
// tracking Omarchy updates. This wrapper only edits what the stock bar sees:
//   - widgets listed in a drawer entry's `items` are filtered out of the
//     layout handed to the stock bar, so they leave the bar itself;
//   - the drawer id is added to the widget catalogue, so a
//     `{ "id": "parker.drawer", "items": [...] }` layout entry renders as the
//     drawer button (Drawer.qml), which hosts the tucked widgets in a panel.
//
// Tucked widgets stay in `bar.layout`, so enable state, inline settings and
// `omarchy bar` commands keep working on them exactly as before.
Item {
  id: root

  // Injected by omarchy-shell (see configureBar in shell.qml). barConfig is
  // assigned last, so it doubles as the "fully configured" signal.
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null
  property var barWidgetRegistry: null
  property var pluginRegistry: null
  property var barConfig: ({})
  property bool configured: false
  onBarConfigChanged: configured = true

  readonly property string drawerId: manifest && manifest.id ? String(manifest.id) : "parker.drawer"
  readonly property var stockBar: stockLoader.item
  property var drawers: []

  // Read by shell.qml, the bar-state facade and notifications.
  readonly property bool barHidden: stockBar ? stockBar.barHidden === true : false
…
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && sed -i '1{/^$/d}' DrawerModel.js && head -2 DrawerModel.js && mkdir -p /tmp/drawer-test && cat > /tmp/drawer-test/model.test.js <<'EOF'
const assert = require("assert")
const M = require(process.argv[2])
const D = "parker.drawer"
const config = {
  posit`

✗  ms

```text
Exit code 1
// Pure layout helpers for the drawer bar. Kept free of QML so they can be
// exercised outside the shell.
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise WARN  Remote versions cannot be fetched for openai/codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for codex: [~/.config/mise/config.toml] codex@latest: unable to fetch versions for codex: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for charmbracelet/crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for crush: [~/.config/mise/config.toml] crush@latest: unable to fetch versions for crush: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for cli/cli: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for anthropics/claude-code: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for claude: [~/.config/mise/config.toml] claude@latest: unable to fetch versions for claude: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for gh: [~/.config/mise/config.toml] gh@latest: unable to fetch versions for gh: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for earendil-works/pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for pi: [~/.config/mise/config.toml] pi@latest: unable to fetch versions for pi: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Remote versions cannot be fetched for astral-sh/uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for uv: [~/.config/mise/config.toml] uv@latest: unable to fetch versions for uv: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for npm:playwright: [~/.config/mise/config.toml] npm:playwright@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for gemini: [~/.config/mise/config.toml] gemini@latest: timed out after 3.00s
mise WARN  Failed to resolve tool version list for opencode: [~/.config/mise/config.toml] opencode@latest: timed out after 3.00s
mise by @jdx – installing 1 tool
mise ░░░░░░░░░░░░░░░░ 0/1 · 3.0s
  node@26.7.0  downloading  3.0s
mise ░░░░░░░░░░░░░░░░ 0/1 · 6.0s
  node@26.7.0  downloading  6.0s
mise ░░░░░░░░░░░░░░░░ 0/1 · 9.0s
  node@26.7.0  downloading  9.0s
mise ░░░░░░░░░░░░░░░░ 0/1 · 12.0s
  node@26.7.0  downloading  12.0s
mise ░░░░░░░░░░░░░░░░ 0/1 · 15.0s
  node@26.7.0  downloading  15.0s
mise ✗ node@26.7.0  16.9s · failed: error sending request
mise ████████████████ 1/1 · installed 0 tools · 1 failed in 16.9s
mise WARN  Failed to resolve tool version list for bun: [~/.config/mise/config.toml] bun@latest: HTTP host https://api.github.com:443 is unavailable after an earlier connection failure: error sending request
mise WARN  Failed to resolve tool version list for cursor-agent: [~/.config/mise/config.toml] cursor-agent@latest: HTTP host https://cursor.com:443 is unavailable after an earlier connection failure: error sending request
mise ERROR Failed to install core:node@26.7.0: error sending request: client error (Connect): dns error: error resolving DNS: failed to lookup address information: Temporary failure in name resolution
mise ERROR Version: 2026.10.9 linux-x64 (2026-10-13)
mise ERROR Run with --verbose or MISE_VERBOSE=1 for more information
```

Node isn't installed and the network is offline, so I'll run the same tests inside Quickshell's own JS engine. That also exercises the real QML import path.

**⏺ bash** `T=/tmp/drawer-test/qs; mkdir -p $T && cd $T && ln -sfn /usr/share/omarchy/shell/Commons Commons && ln -sfn /usr/share/omarchy/shell/Ui Ui && P=~/.config/omarchy/plugins/parker.drawer && sed -e 's/^const assert = require("assert")$//' -e 's/^const M = require(process.argv\[2\])$//' -e 's/^console.log`

✓  ms

```text
  WARN quickshell.qmlscanner: Ignoring unresolvable import "/tmp/drawer-test/qs/file://~/.config/omarchy/plugins/parker.drawer/DrawerModel.js" from "/tmp/drawer-test/qs/shell.qml"
 DEBUG qml: all model tests passed
  WARN: Signal QQmlEngine::quit() emitted, but no receivers connected to handle it.
  INFO: Configuration Loaded
Shell cwd was reset to ~
```

The model tests pass. Next I'll compile-check both QML files in Quickshell with the real Omarchy UI modules.

**⏺ bash** `T=/tmp/drawer-test/qs; cd $T && rm -rf plugin && cp -r ~/.config/omarchy/plugins/parker.drawer plugin && cat > shell.qml <<'EOF'
import QtQuick
import Quickshell

ShellRoot {
  Component.onCompleted: {
    var files = ["plugin/DrawerModel.js", "plugin/Drawer.qml", "plugin/Bar.qml"]
    for (var i = `

✓  ms

```text
 DEBUG qml: COMPILE plugin/Drawer.qml: ready
 DEBUG qml: COMPILE plugin/Bar.qml: qs:@/qs/plugin/Bar.qml:96:5: Drawer is not a type

  INFO: Configuration Loaded
Shell cwd was reset to ~
```

**⏺ bash** `grep -n "function entryPointUrl" -A25 /usr/share/omarchy/shell/services/PluginRegistry.qml`

✓  ms

```text
118:  function entryPointUrl(manifest, kind) {
119-    if (!Util.isPlainObject(manifest)) return ""
120-    var ep = manifest.entryPoints ? manifest.entryPoints[kind] : null
121-    if (!ep) return ""
122-    var dir = manifest.__sourceDir || ""
123-    if (!dir) return ""
124-    // Defense in depth: even after validateManifest, confirm the resolved
125-    // path stays inside the plugin's sourceDir.
126-    var resolved = dir.replace(/\/$/, "") + "/" + String(ep)
127-    var expectedPrefix = dir.replace(/\/$/, "") + "/"
128-    if (resolved.indexOf(expectedPrefix) !== 0) {
129-      console.warn("PluginRegistry: entry point escapes sourceDir: " + resolved)
130-      return ""
131-    }
132-    return Util.fileUrl(resolved)
133-  }
134-
135-  // Enabled = the plugin id is referenced somewhere in shell.json. That can
136-  // be either the active bar option in `bar.id`, a layout entry inside
137-  // `bar.layout.*` (bar widgets), or a top-level entry in `plugins[]` (panels,
138-  // overlays, services).
139-  //
140-  // Special cases (implicitly always enabled, no shell.json entry needed):
141-  //   - the built-in bar option (`omarchy.bar`) is active when `bar.id` is
142-  //     missing or set to `omarchy.bar`.
143-  //   - first-party non-bar plugins are shell infrastructure (settings,
```

**⏺ bash** `T=/tmp/drawer-test/qs; cd $T && rm -rf plugin && P=~/.config/omarchy/plugins/parker.drawer && cat > shell.qml <<EOF
import QtQuick
import Quickshell

ShellRoot {
  Component.onCompleted: {
    var files = ["Drawer.qml", "Bar.qml"]
    for (var i = 0; i < files.length; i++) {
      var c = Qt.createC`

✓  ms

```text
 DEBUG qml: COMPILE Drawer.qml: ready
 DEBUG qml: COMPILE Bar.qml: ready
  INFO: Configuration Loaded
Shell cwd was reset to ~
```

Both files compile against the real Omarchy modules. Next is a runtime test: I'll instantiate the drawer with a fake bar and fake widgets to check hosting, settings, and popout handling.

**⏺ bash** `T=/tmp/drawer-test/qs; cd $T && P=~/.config/omarchy/plugins/parker.drawer && cat > FakeWidget.qml <<'EOF'
import QtQuick
Item {
  property QtObject bar: null
  property string moduleName: ""
  property var settings: ({})
  property bool opened: false
  property int settingsPushes: 0
  onSettingsChan`

✓  ms

```text
  WARN quickshell.qmlscanner: Ignoring unresolvable import "/tmp/drawer-test/qs/file://~/.config/omarchy/plugins/parker.drawer/DrawerModel.js" from "/tmp/drawer-test/qs/shell.qml"
  WARN scene: @Ui/WidgetButton.qml[12:3]: Unable to assign [undefined] to QColor
  WARN scene: @Ui/WidgetButton.qml[90:7]: Unable to assign [undefined] to bool
  INFO: Configuration Loaded
 DEBUG qml: PASS registered with host
 DEBUG qml: PASS itemIds
 DEBUG qml: PASS hosts()
 DEBUG qml: PASS hosted items built
 DEBUG qml: PASS first-party gets real bar
 DEBUG qml: PASS third-party gets plugin api
 DEBUG qml: PASS settings injected from layout entry
 DEBUG qml: PASS slots registered with bar (3 holders)
 DEBUG qml: PASS drawer starts closed
 DEBUG qml: PASS unrelated config write: no settings push
 DEBUG qml: PASS own settings change pushed
 DEBUG qml: PASS drawer open
 DEBUG qml: PASS opening drawer closed other popout
 DEBUG qml: PASS hosted popout keeps drawer open
 DEBUG qml: PASS foreign popout closes drawer
 DEBUG qml: PASS closing drawer closed hosted popout
 DEBUG qml: PASS openHosted returns true
 DEBUG qml: PASS openHosted opened drawer
 DEBUG qml: PASS openHosted opened widget after delay
 DEBUG qml: PASS closeHosted
 DEBUG qml: PASS self-opened hosted widget reopens drawer
 DEBUG qml: PASS hosted widget re-opened inside drawer
 DEBUG qml: PASS bar drag closes drawer
 DEBUG qml: PASS items change rebuilds holders
 DEBUG qml: PASS destroy unregisters slots
Shell cwd was reset to ~
```

**⏺ bash** `T=/tmp/drawer-test/qs; F=/tmp/drawer-test/fakeomarchy/shell/plugins/bar; mkdir -p $F && cd $T && P=~/.config/omarchy/plugins/parker.drawer && cat > $F/Bar.qml <<'EOF'
import QtQuick
Item {
  property string omarchyPath
  property var shell
  property var manifest
  property var pluginRegistry
  prop`

✓  ms

```text
 DEBUG qml: PASS stock bar not loaded before configure
  INFO: Configuration Loaded
 DEBUG qml: PASS stock bar loaded
 DEBUG qml: PASS stock bar got shell
 DEBUG qml: PASS tucked widget filtered from stock layout
 DEBUG qml: PASS catalogue has drawer + host widgets
 DEBUG qml: PASS drawer flagged first-party
 DEBUG qml: PASS mirrors barSize/position
 DEBUG qml: PASS config updates flow through (no drawer => nothing tucked)
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
 DEBUG qml: PASS summon falls through to stock bar when no drawer hosts it
 DEBUG qml: PASS panelWidgetIdAt forwarded
 DEBUG qml: PASS drawer from catalogue registers with wrapper
 DEBUG qml: PASS drawer unregisters on destroy
Shell cwd was reset to ~
```

The wrapper passes all 12 checks. Next I'll turn it on in `shell.json`, after a backup, with a starter drawer, and write a short README.

**⏺ bash** `cd ~/.config/omarchy && cp shell.json shell.json.bak.$(date +%s) && python3 - <<'EOF'
import json
p='shell.json'; c=json.load(open(p))
bar=c['bar']
bar['id']='parker.drawer'
right=bar['layout']['right']
drawer={"id":"parker.drawer","items":["omarchy.agents","omarchy.bluetooth","omarchy.monitor","oma`

✓  ms

```text
parker.drawer
[{"id": "omarchy.tray"}, {"id": "parker.drawer", "items": ["omarchy.agents", "omarchy.bluetooth", "omarchy.monitor", "omarchy.weather", "omarchy.keyboard-layout"]}]
shell.json.bak.1794269529
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/README.md`

```
# Drawer bar (`parker.drawer`)

The stock Omarchy bar plus a drawer button. Clicking the button opens a panel
holding the widgets you have tucked away, so the bar itself shows only the
essentials.

## Choosing what goes in the drawer

Everything lives in `~/.config/omarchy/shell.json` and hot-reloads on save.

```json
{
  "bar": {
    "id": "parker.drawer",
    "layout": {
      "right": [
        { "id": "omarchy.tray" },
        { "id": "parker.drawer", "items": ["omarchy.bluetooth", "omarchy.monitor"] },
        { "id": "omarchy.bluetooth" },
        { "id": "omarchy.monitor" },
        { "id": "omarchy.audio" }
      ]
    }
  }
}
```

- `"bar": { "id": "parker.drawer" }` selects this bar. Remove it (or set it to
  `omarchy.bar`) to go back to the stock bar; nothing else needs undoing.
- The `parker.drawer` layout entry is the drawer button. Put it wherever you
  want the button to sit.
- `items` lists the widget ids to tuck away, in the order they appear in the
  panel. Add an id to move a widget into the drawer; remove it to put the
  widget back on the bar.
- Tucked widgets keep their normal entry in `bar.layout`. That entry still
  holds their settings and keeps third-party widgets enabled; the drawer just
  stops the bar from drawing them. A first-party widget that is not in the
  layout can still be tucked, with settings given inline:
  `{ "id": "omarchy.clock", "format": "HH:mm" }`.
- Several drawers are fine: add more `parker.drawer` entries, each with its own
  `items`.

Optional drawer settings:

| Key       | Default    | Meaning                         |
|-----------|------------|---------------------------------|
| `items`   | `[]`       | Widget ids (or entries) to tuck |
| `icon`    | `` (…) | Nerd Font glyph for the button  |
| `tooltip` | `"Drawer"` | Button tooltip                  |

## Behaviour

- Left-click the button to open or close the drawer. Clicking outside it, or
  opening another bar panel, closes it.
- Tucked widgets work as they do on the bar: their own panels open from inside
  the drawer.
- Panel hotkeys (`omarchy-shell shell toggle omarchy.audio`, etc.) still work
  for tucked widgets: the drawer opens and then the widget's panel.
- `omarchy-shell shell toggle parker.drawer` toggles the drawer itself.

… (14 more lines in the repository)
```

✓  ms

```text
File created successfully at: ~/.config/omarchy/plugins/parker.drawer/README.md (file state is current in your context — no need to Read it back)
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && grep -n '`icon`' README.md | od -c | sed -n 1,4p; grep -n "function validateManifest" -A45 /usr/share/omarchy/shell/services/PluginRegistry.qml | head -60`

✓  ms

```text
0000000   4   8   :   |       `   i   c   o   n   `                   |
0000020       ` 357 205 201   `       ( 342 200 246   )       |       N
0000040   e   r   d       F   o   n   t       g   l   y   p   h       f
0000060   o   r       t   h   e       b   u   t   t   o   n           |
43:  function validateManifest(manifest, sourcePath) {
44-    if (!Util.isPlainObject(manifest)) {
45-      console.warn("PluginRegistry: manifest is not an object at " + sourcePath)
46-      return null
47-    }
48-    if (manifest.schemaVersion !== 1) {
49-      console.warn("PluginRegistry: unsupported schemaVersion at " + sourcePath)
50-      return null
51-    }
52-    var required = ["id", "name", "version", "kinds", "entryPoints"]
53-    for (var i = 0; i < required.length; i++) {
54-      if (manifest[required[i]] === undefined) {
55-        console.warn("PluginRegistry: missing required field '" + required[i] + "' at " + sourcePath)
56-        return null
57-      }
58-    }
59-    var id = String(manifest.id)
60-    if (!id || id.indexOf("/") !== -1 || id.indexOf("..") !== -1 || id.charAt(0) === "/") {
61-      console.warn("PluginRegistry: invalid plugin id '" + id + "' at " + sourcePath)
62-      return null
63-    }
64-    if (!Array.isArray(manifest.kinds) || manifest.kinds.length === 0) {
65-      console.warn("PluginRegistry: kinds must be a non-empty array at " + sourcePath)
66-      return null
67-    }
68-    if (!Util.isPlainObject(manifest.entryPoints)) {
69-      console.warn("PluginRegistry: entryPoints must be an object at " + sourcePath)
70-      return null
71-    }
72-    if (manifest.barWidget !== undefined && Util.isPlainObject(manifest.barWidget)
73-        && manifest.barWidget.defaultSection !== undefined) {
74-      var defaultSection = String(manifest.barWidget.defaultSection)
75-      if (["left", "center", "right"].indexOf(defaultSection) === -1) {
76-        console.warn("PluginRegistry: invalid barWidget.defaultSection at " + sourcePath)
77-        return null
78-      }
…
```

The manifest passes Omarchy's validator. I'll make the README's icon default readable and then run the model against your actual `shell.json`.

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && python3 - <<'EOF'
p='README.md'; s=open(p).read()
s=s.replace('| `icon`    | `` (…) | Nerd Font glyph for the button  |','| `icon`    | `"\\uf141"` (ellipsis) | Nerd Font glyph for the button |')
open(p,'w').write(s)
EOF
grep -n '`icon`' README.md
T=/tm`

✓  ms

```text
48:| `icon`    | `"\uf141"` (ellipsis) | Nerd Font glyph for the button |
 ERROR: Failed to load configuration
 ERROR:   caused by @shell.qml[5:3]: FileView is not a type
```

I missed the `Quickshell.Io` import, so I'll re-run with it.

**⏺ bash** `T=$(mktemp -d); P=~/.config/omarchy/plugins/parker.drawer; cat > $T/shell.qml <<EOF
import QtQuick
import Quickshell
import Quickshell.Io
import "file://$P/DrawerModel.js" as M
ShellRoot {
  FileView { id: f; path: "$HOME/.config/omarchy/shell.json"; blockLoading: true }
  Component.onCompleted: {
 `

✓  ms

```text
 DEBUG qml: BAR left: omarchy.menu, omarchy.workspaces
 DEBUG qml: BAR center: omarchy.indicators, omarchy.clock, omarchy.system-update
 DEBUG qml: BAR right: omarchy.tray, parker.drawer, omarchy.network, omarchy.audio, omarchy.power
 DEBUG qml: DRAWER: omarchy.agents, omarchy.bluetooth, omarchy.monitor, omarchy.weather, omarchy.keyboard-layout
```

I've built the drawer plugin and switched your bar to use it. I couldn't see it on screen, though: there's no running desktop session here and `omarchy-shell` isn't running. So check it the first time the shell starts. The logic and the QML did pass tests in Quickshell itself (details below).

**How you choose what's tucked away** (`~/.config/omarchy/shell.json`, reloads when you save):

```json
"bar": {
  "id": "parker.drawer",
  "layout": {
    "right": [
      { "id": "omarchy.tray" },
      { "id": "parker.drawer", "items": ["omarchy.agents", "omarchy.bluetooth", "omarchy.monitor", "omarchy.weather", "omarchy.keyboard-layout"] },
      ...
```

- **The button:** the `parker.drawer` entry is the drawer button. Move it to wherever you want it on the bar.
- **The contents:** `items` lists the widgets in the drawer, in the order they appear in the panel. Add an id to tuck a widget away; remove it to put it back on the bar.
- **The rest of the layout:** tucked widgets keep their normal entry in the bar layout, so their settings and enabled state don't change.
- **Starter set:** I picked the five widgets above as a starting point. Change them to whatever you like.

**How it behaves:**
- Clicking the button opens a small bar-style panel under it.
- Tucked widgets work as they do on the bar, including opening their own panels from inside the drawer.
- Clicking outside the drawer, or opening another bar panel, closes it.
- Panel shortcuts for tucked widgets still work: they open the drawer, then the widget's panel.
- Optional `icon` and `tooltip` settings change the button.

**How it's built:** the plugin is in `~/.config/omarchy/plugins/parker.drawer/`. It loads Omarchy's own bar from `$OMARCHY_PATH` instead of copying it, so you keep getting Omarchy's bar updates. It only removes the tucked widgets from the bar and adds the drawer button. There's a README in that folder.

**Testing:**
- Both QML files load cleanly in Quickshell against Omarchy's real UI modules.
- 25 checks on the drawer passed, covering hosting widgets, passing in settings, opening and closing panels, and shortcuts.
- 12 checks on the wrapper passed, using a stand-in for the stock bar.
- On your actual `shell.json`, the bar keeps menu, workspaces, indicators, clock, update, tray, the drawer button, network, audio and power; the five starter widgets go in the drawer.

**Limitations:**
- Tucking works by widget id, so if you have two of the same widget (two clocks, say), both get tucked.
- Custom `command`/`qml` modules can't be tucked.

**To try it:** run `omarchy restart shell`. If anything looks wrong, delete the `"id": "parker.drawer"` line under `bar` to go back to the stock bar. Your original config is backed up at `~/.config/omarchy/shell.json.bak.1794269529`.

---

### › You

```text
It's not working yet: I don't see a drawer button in the bar, or a way to pick the drawer's widgets from its shell.json entry.

read from the code and the preview
```

**⏺ bash** `cd ~; git status --short | head -30; ls -la .h0-api .pi .agents 2>&1 | head -40; omarchy-shell shell ping 2>&1; echo "WD=$WAYLAND_DISPLAY HYP=$HYPRLAND_INSTANCE_SIGNATURE"`

✓  ms

```text
 M .config/omarchy/shell.json
 D .config/omarchy/themes/ember/README.md
 D .config/omarchy/themes/ember/colors.toml
 D .config/omarchy/themes/ember/hyprland.lua
 D .config/omarchy/themes/ember/icons.theme
 D .config/omarchy/themes/ember/install.sh
 D .config/omarchy/themes/ember/neovim.lua
?? .agents/
?? .claude.json
?? .claude/
?? .codex/
?? .config/omarchy/plugins/
?? .config/omarchy/shell.json.bak.1794269529
?? .h0-api/
?? .local/
?? .pi/
.agents:
total 0
drwxr-xr-x 1 parker parker  12 Nov  9 17:00 .
drwxr-xr-x 1 parker parker 140 Nov  9 17:13 ..
drwxr-xr-x 1 parker parker  42 Nov  9 17:00 skills

.h0-api:
total 1216
drwxr-xr-x 1 parker parker     124 Nov  9 17:13 .
drwxr-xr-x 1 parker parker     140 Nov  9 17:13 ..
srw------- 1 parker parker       0 Nov  9 17:00 api.sock
-rw-r--r-- 1 parker parker     763 Nov  9 17:00 bridge.py
-rw-r--r-- 1 parker parker 1215358 Nov  9 17:13 round1.jsonl
-rw-r--r-- 1 parker parker    6039 Nov  9 17:13 round2.jsonl
-rw-r--r-- 1 parker parker       0 Nov  9 17:00 stderr.txt
-rw-r--r-- 1 parker parker   16372 Nov  9 17:13 usage.jsonl

.pi:
total 0
drwxr-xr-x 1 parker parker  10 Nov  9 17:00 .
drwxr-xr-x 1 parker parker 140 Nov  9 17:13 ..
drwxr-xr-x 1 parker parker  12 Nov  9 17:00 agent
omarchy-shell is not running
WD= HYP=
```

**⏺ bash** `cd ~; find .local -type f -newer .config/omarchy/shell.json.bak.1794269529 2>/dev/null | head; find .local -maxdepth 4 | head -30; ls -la .config/omarchy/plugins/parker.drawer; git diff --stat; md5sum .config/omarchy/plugins/parker.drawer/*`

✓  ms

```text
.local
.local/state
.local/share
.local/state/mise
.local/share/mise
.local/state/mise/tracked-configs
.local/state/mise/incomplete-installs
.local/share/mise/installs
.local/share/mise/downloads
.local/state/mise/tracked-configs/8689d62d58dd82ae
.local/state/mise/tracked-configs/3a8292bc9105163d
.local/state/mise/incomplete-installs/node
.local/share/mise/downloads/node
total 36
drwxr-xr-x 1 parker parker   106 Nov  9 17:12 .
drwxr-xr-x 1 parker parker    26 Nov  9 17:06 ..
-rw-r--r-- 1 parker parker  6140 Nov  9 17:09 Bar.qml
-rw-r--r-- 1 parker parker 13802 Nov  9 17:08 Drawer.qml
-rw-r--r-- 1 parker parker  3529 Nov  9 17:09 DrawerModel.js
-rw-r--r-- 1 parker parker  2955 Nov  9 17:12 README.md
-rw-r--r-- 1 parker parker   301 Nov  9 17:06 manifest.json
 .config/omarchy/shell.json                | 13 ++++++++++++-
 .config/omarchy/themes/ember/README.md    |  7 -------
 .config/omarchy/themes/ember/colors.toml  | 31 -------------------------------
 .config/omarchy/themes/ember/hyprland.lua |  2 --
 .config/omarchy/themes/ember/icons.theme  |  1 -
 .config/omarchy/themes/ember/install.sh   |  5 -----
 .config/omarchy/themes/ember/neovim.lua   | 11 -----------
 7 files changed, 12 insertions(+), 58 deletions(-)
2c0b6359710a808e2c4aab6ebf778883  .config/omarchy/plugins/parker.drawer/Bar.qml
c60e8632a41b8c175a67423f533d43ee  .config/omarchy/plugins/parker.drawer/Drawer.qml
11f07f9321ba810cbf188c7705ed0002  .config/omarchy/plugins/parker.drawer/DrawerModel.js
a06f79bfdd37aefbccb6a929a49233d0  .config/omarchy/plugins/parker.drawer/README.md
f824a742849fc01e01e3eff09767cb89  .config/omarchy/plugins/parker.drawer/manifest.json
```

**⏺ bash** `S=/usr/share/omarchy/shell; grep -rl '"schema"' $S/plugins | head -20; cat $S/plugins/bar/widgets/Indicators.manifest.json; grep -rn "\"type\": \"" $S/plugins --include=*.json | sed 's/.*"type": //' | sort | uniq -c`

✓  ms

```text
/usr/share/omarchy/shell/plugins/agents/manifest.json
/usr/share/omarchy/shell/plugins/bar/widgets/Indicators.manifest.json
/usr/share/omarchy/shell/plugins/panels/dropbox/manifest.json
/usr/share/omarchy/shell/plugins/panels/tailscale/manifest.json
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
        "noSelectionText": "All indicators",
        "placeholderText": "Search indicators...",
        "emptyText": "No indicators",
        "options": [
          {
            "value": "Dictation",
            "label": "Dictation",
            "description": "Voice typing status"
          },
          {
            "value": "ScreenRecording",
            "label": "Screen recording",
…
```

**⏺ bash** `S=/usr/share/omarchy/shell; grep -rn "multiselect\|optionsSource\|\.options\b" $S --include=*.qml --include=*.js | grep -v "^.*MultiSelect.qml" | head -20`

✓  ms

```text
/usr/share/omarchy/shell/Ui/Dropdown.qml:152:        implicitHeight: Math.min(root.options.length * root.popupRowHeight + Math.max(0, root.options.length - 1) * Style.spacing.labelGap + Style.spacing.xxs,
/usr/share/omarchy/shell/Ui/Dropdown.qml:180:              optionList.currentIndex = Math.min(root.options.length - 1, optionList.currentIndex + 1)
/usr/share/omarchy/shell/Ui/Dropdown.qml:192:          model: root.options
/usr/share/omarchy/shell/Ui/Dropdown.qml:196:            for (var i = 0; i < root.options.length; i++)
/usr/share/omarchy/shell/Ui/Dropdown.qml:197:              if (root.optionValue(root.options[i]) === v) return i
/usr/share/omarchy/shell/Ui/Dropdown.qml:202:            if (currentIndex < 0 || currentIndex >= root.options.length) return
/usr/share/omarchy/shell/Ui/Dropdown.qml:203:            var v = root.optionValue(root.options[currentIndex])
/usr/share/omarchy/shell/Ui/ButtonGroup.qml:106:    model: root.options
/usr/share/omarchy/shell/plugins/menu/Menu.qml:823:    dmenuOptions = Array.isArray(payload.options) ? payload.options : []
```

Multiselect options in a manifest are a static list, so the drawer's manifest will list the selectable widgets. Next I'll look at `dev-gallery`, which may be the "preview" you mentioned.

**⏺ bash** `S=/usr/share/omarchy/shell/plugins/dev-gallery; ls -R $S | head; cat $S/manifest.json; grep -n "barWidget\|registry\|layout\|settings" $S/*.qml | head -40`

✓  ms

```text
/usr/share/omarchy/shell/plugins/dev-gallery:
GalleryPanel.qml
manifest.json
{
  "schemaVersion": 1,
  "id": "omarchy.dev-gallery",
  "name": "Dev gallery",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Visual reference for omarchy-shell common UI components. Summon with: omarchy-shell shell summon omarchy.dev-gallery '{}' (or run: omarchy dev ui-preview).",
  "kinds": [
    "panel"
  ],
  "entryPoints": {
    "panel": "GalleryPanel.qml"
  }
}
1140:                  tooltipText: "Focusable (settings form button)"
1396:              text: "Labeled spin box for integer settings. Up/down arrows step the value; the field accepts typed input. Pair with `from`/`to`/`stepSize` to constrain range."
```

**⏺ bash** `S=/usr/share/omarchy/shell; grep -rhoE "\bbar\??\.[a-zA-Z_]+" $S/plugins $S/Ui --include=*.qml | grep -v "plugins/bar/Bar.qml" | sed 's/?//' | sort | uniq -c | sort -rn; which jq`

✓  ms

```text
    168 bar.foreground
    111 bar.fontFamily
     25 bar.shell
     15 bar.position
     14 bar.urgent
     12 bar.run
      7 bar.sizeHorizontal
      6 bar.switchPanelFrom
      6 bar.moduleWidgets
      6 bar.iconSlot
      6 bar.hideTooltip
      6 bar.barForeground
      5 bar.sizeVertical
      5 bar.layout
      4 bar.vertical
      4 bar.statusSlot
      4 bar.showTooltip
      4 bar.setCenterHoverRevealSuppressed
      4 bar.barSize
      4 bar.activePopout
      3 bar.centerHoverRevealSuppressed
      3 bar.background
      2 bar.text
      2 bar.targetBelongsToWindow
      2 bar.requestPopout
      2 bar.releasePopout
      2 bar.layoutConfig
      2 bar.foregroundAnimationEnabled
      2 bar.clickTargets
      1 bar.x
      1 bar.transparent
      1 bar.iconFont
      1 bar.iconCanvas
      1 bar.centerSectionRevealHeld
      1 bar.barHidden
      1 bar.active
/usr/bin/jq
```

**⏺ bash** `S=/usr/share/omarchy/shell; grep -n "PluginBarApi\|Panel \|BarIconButton" $S/Ui/qmldir; find -L $S/plugins \( -name manifest.json -o -name '*.manifest.json' \) -print0 | xargs -0 jq -c 'select((.kinds//[])|index("bar-widget")) | {id, label: (.barWidget.displayName // .name), d: (.barWidget.descripti`

✓  ms

```text
4:BarIconButton 1.0 BarIconButton.qml
13:KeyboardPanel 1.0 KeyboardPanel.qml
17:Panel 1.0 Panel.qml
26:PluginBarApi 1.0 PluginBarApi.qml
{"id":"omarchy.agents","label":"Agents","d":"One bar icon and one panel: rate-limit meters with pace, today, the last week, and the all-time model breakdown for every subscription."}
{"id":"omarchy.menu","label":"Omarchy menu","d":"Launches the Omarchy menu"}
{"id":"omarchy.active-window","label":"Active window","d":"Title of the focused window"}
{"id":"omarchy.indicators","label":"Indicators","d":"Manual state indicators"}
{"id":"omarchy.keyboard-layout","label":"Keyboard layout","d":"Current xkb layout, click cycles"}
{"id":"omarchy.microphone","label":"Microphone","d":"Mic input state and mute toggle"}
{"id":"omarchy.spacer","label":"Spacer","d":"Configurable blank space"}
{"id":"omarchy.system-update","label":"Omarchy update","d":"Indicates available Omarchy updates"}
{"id":"omarchy.tray","label":"System tray","d":"Status notifier items"}
{"id":"omarchy.workspaces","label":"Workspaces","d":"Workspace number indicators"}
{"id":"omarchy.tailscale","label":"Tailscale","d":"Toggle Tailscale, switch connections, browse machines, and copy machine IPs or names."}
{"id":"omarchy.dropbox","label":"Dropbox","d":"Log in to Dropbox, view storage usage, and open recent synced files."}
{"id":"omarchy.monitor","label":"Display","d":"Brightness slider and laptop display controls"}
{"id":"omarchy.network","label":"Network","d":"Wi-Fi list and connection state"}
{"id":"omarchy.power","label":"Power","d":"Battery, power profile, and system stats"}
{"id":"omarchy.weather","label":"Weather","d":"Weather pill with detail popup"}
{"id":"omarchy.audio","label":"Audio","d":"Volume slider, output picker, per-app mixer"}
{"id":"omarchy.bluetooth","label":"Bluetooth","d":"Bluetooth device list with connect/disconnect"}
{"id":"omarchy.clock","label":"Clock","d":"Date/time label with a calendar popup"}
{"id":"omarchy.media","label":"Media","d":"MPRIS now-playing with playback controls"}
```

Writing the new manifest. It's a `bar-widget` with an `items` multiselect listing every stock widget, plus `icon` and `tooltip` settings.

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && rm Bar.qml && S=/usr/share/omarchy/shell && find -L $S/plugins \( -name manifest.json -o -name '*.manifest.json' \) -print0 | xargs -0 jq -c 'select((.kinds//[])|index("bar-widget")) | select(.id != "omarchy.spacer") | {value: .id, label: (.barWidget.dis`

✓  ms

```text
["bar-widget"] "omarchy.active-window" "omarchy.agents" "omarchy.audio" "omarchy.bluetooth" "omarchy.clock" "omarchy.monitor" "omarchy.dropbox" "omarchy.indicators" "omarchy.keyboard-layout" "omarchy.media" "omarchy.microphone" "omarchy.network" "omarchy.menu" "omarchy.system-update" "omarchy.power" "omarchy.tray" "omarchy.tailscale" "omarchy.weather" "omarchy.workspaces"
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerModel.js`

```
// Pure helpers for the drawer widget. Kept free of QML so they can be
// exercised outside the shell.

function isPlainObject(value) {
  return value !== null && typeof value === "object" && !Array.isArray(value)
}

function entryId(entry) {
  if (typeof entry === "string") return entry
  if (isPlainObject(entry) && entry.id !== undefined && entry.id !== null) return String(entry.id)
  return ""
}

// Ordered, de-duplicated widget ids from the drawer's `items` setting.
// Items are ids ("omarchy.audio") or entries ({ "id": "omarchy.clock", ... }).
function itemIds(settings, selfId) {
  var items = isPlainObject(settings) && Array.isArray(settings.items) ? settings.items : []
  var ids = []
  for (var i = 0; i < items.length; i++) {
    var id = entryId(items[i])
    if (id && id !== selfId && ids.indexOf(id) === -1) ids.push(id)
  }
  return ids
}

// Inline settings for one tucked widget: the extra fields on its object form
// in `items`, the same shape as a bar layout entry.
function itemSettings(settings, id) {
  var items = isPlainObject(settings) && Array.isArray(settings.items) ? settings.items : []
  for (var i = 0; i < items.length; i++) {
    if (!isPlainObject(items[i]) || entryId(items[i]) !== id) continue
    var copy = JSON.parse(JSON.stringify(items[i]))
    delete copy.id
    return copy
  }
  return {}
}

// Parse the catalogue scan: one JSON object per line, `{ id, file }`, where
// `file` is the widget's barWidget entry point. Later lines win, so user
// plugins override built-ins with the same id. Entry points that climb out
// of their plugin directory are dropped, as the shell's own registry does.
function parseCatalogue(text) {
  var out = {}
  var lines = String(text || "").split("\n")
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i].trim()
    if (!line) continue
    var row = null
    try { row = JSON.parse(line) } catch (e) { continue }
    if (!isPlainObject(row) || !row.id || !row.file) continue
    var file = String(row.file)
    if (file.charAt(0) !== "/" || file.split("/").indexOf("..") !== -1) continue
    out[String(row.id)] = file
  }
  return out
}

if (typeof module !== "undefined") {
  module.exports = {
… (6 more lines in the repository)
```

✓  ms

```text
The file ~/.config/omarchy/plugins/parker.drawer/DrawerModel.js has been updated successfully. (file state is current in your context — no need to Read it back)
```

Now the drawer widget itself.

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/Drawer.qml`

```
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Ui
import "DrawerModel.js" as DrawerModel

// Drawer button plus the panel holding the tucked widgets.
//
// Configured inline on its bar layout entry:
//   { "id": "parker.drawer", "items": ["omarchy.bluetooth", "omarchy.monitor"] }
//
// Each item is built from the widget's own manifest entry point, found by
// scanning the built-in and user plugin directories, and receives a bar
// facade that forwards to this widget's facade. Tucked widgets therefore get
// the same bar surface a third-party widget gets on the bar itself.
//
// The panel is a plain popup rather than a bar popout: tucked widgets open
// their own popouts on top of it, and taking the bar's single popout slot
// would make the first one close the drawer underneath it.
Panel {
  id: root

  readonly property string selfId: moduleName || "parker.drawer"
  readonly property bool vertical: bar ? bar.vertical : false
  readonly property int barSize: bar ? bar.barSize : Style.bar.sizeHorizontal
  readonly property var barWindow: button.QsWindow.window

  // Ids only change when `items` does. Keeping the model a joined string means
  // unrelated shell.json writes do not rebuild every tucked widget.
  readonly property string itemsKey: DrawerModel.itemIds(settings, selfId).join("\n")
  readonly property var itemIds: itemsKey ? itemsKey.split("\n") : []

  // Widget id -> absolute path of its barWidget QML entry point.
  property var catalogue: ({})

  readonly property bool hostedPopoutOpen: bar ? isHosted(bar.activePopout) : false
  property var pendingItem: null

  property var tooltipTarget: null
  property string tooltipText: ""
  property bool tooltipShown: false

  function holders() {
    var out = []
    for (var i = 0; i < repeater.count; i++) {
      var holder = repeater.itemAt(i)
      if (holder) out.push(holder)
    }
    return out
  }

  function hostedItems(id) {
    var out = []
    var list = holders()
    for (var i = 0; i < list.length; i++)
      if (list[i].moduleName === id && list[i].activeItem) out.push(list[i].activeItem)
    return out
  }
… (406 more lines in the repository)
```

✓  ms

```text
The file ~/.config/omarchy/plugins/parker.drawer/Drawer.qml has been updated successfully. (file state is current in your context — no need to Read it back)
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && python3 - <<'EOF'
p='Drawer.qml'; s=open(p).read()
a='    text: String(root.setting("icon", "") || "")'
assert a in s
s=s.replace(a,'    text: String(root.setting("icon", "") || "\\uf141")')
a='''      var current = root.bar.activePopout
      if (!curre`

✓  ms

```text
Traceback (most recent call last):
  File "<stdin>", line 3, in <module>
AssertionError
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && grep -n 'setting("icon"' Drawer.qml | od -c | head -4`

✓  ms

```text
0000000   2   0   3   :                   t   e   x   t   :       S   t
0000020   r   i   n   g   (   r   o   o   t   .   s   e   t   t   i   n
0000040   g   (   "   i   c   o   n   "   ,       "   "   )       |   |
0000060       " 357 205 201   "   )  \n
```

The icon fallback already contains the glyph, written as a raw character. I'll swap it for a readable `\uf141` escape and apply the self-close guard.

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && python3 - <<'EOF'
p='Drawer.qml'; s=open(p).read()
s=s.replace('root.setting("icon", "") || ""','root.setting("icon", "") || "\\uf141"')
a='''      if (!current) return
      if (!root.isHosted(current)) {'''
assert a in s
s=s.replace(a,'''      if (!cu`

✓  ms

```text
182:      if (!current || current === root) return
203:    text: String(root.setting("icon", "") || "\uf141")
```

Next I'll update `shell.json`: remove the `bar.id` override and take the five drawer widgets out of the bar layout, leaving them only in the drawer's `items`.

**⏺ bash** `cd ~/.config/omarchy && python3 - <<'EOF'
import json
p='shell.json'; c=json.load(open(p)); bar=c['bar']
bar.pop('id', None)
drawer=next(e for e in bar['layout']['right'] if e.get('id')=='parker.drawer')
items=set(drawer['items'])
for sec in ('left','center','right'):
    bar['layout'][sec]=[e for e`

✓  ms

```text
diff --git a/.config/omarchy/shell.json b/.config/omarchy/shell.json
index e6202da..81f9889 100644
--- a/.config/omarchy/shell.json
+++ b/.config/omarchy/shell.json
@@ -27,12 +27,6 @@
           "formatAlt": "d MMMM 'W'ww yyyy",
           "verticalFormat": "HH\n\u2014\nmm"
         },
-        {
-          "id": "omarchy.keyboard-layout"
-        },
-        {
-          "id": "omarchy.weather"
-        },
         {
           "id": "omarchy.system-update"
         }
@@ -42,10 +36,14 @@
           "id": "omarchy.tray"
         },
         {
-          "id": "omarchy.agents"
-        },
-        {
-          "id": "omarchy.bluetooth"
+          "id": "parker.drawer",
+          "items": [
+            "omarchy.agents",
+            "omarchy.bluetooth",
+            "omarchy.monitor",
+            "omarchy.weather",
+            "omarchy.keyboard-layout"
+          ]
         },
         {
           "id": "omarchy.network"
@@ -53,9 +51,6 @@
         {
           "id": "omarchy.audio"
         },
…
```

Next I'll test against Omarchy's real `PluginRegistry`. That checks the drawer is discovered, its manifest validates, it counts as enabled from your `shell.json`, and its entry point resolves.

**⏺ bash** `S=/usr/share/omarchy/shell; sed -n 1,42p $S/services/PluginRegistry.qml; grep -n "property \|signal \|function rescan" $S/services/PluginRegistry.qml | sed -n 1,40p; grep -n "PluginRegistry {" -A12 $S/shell.qml`

✓  ms

```text
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

// Instance, not a singleton — see BarWidgetRegistry for rationale.
QtObject {
  id: registry

  property string home: Quickshell.env("HOME")
  property string pluginsDir: home + "/.config/omarchy/plugins"

  // Set by shell.qml at startup so we can also scan bundled first-party plugins.
  property string firstPartyDir: ""

  // Wired by shell.qml so the registry can read the canonical shell.json
  // without owning file IO itself. shellConfigProvider returns the current
  // effective shell config; shellConfigMutator takes a function that receives
  // a deep-cloned config it can mutate in place and persists the result.
  property var shellConfigProvider: null
  property var shellConfigMutator: null

  // { pluginId: manifest } — manifests have source/trust metadata stamped in.
  property var installedPlugins: ({})
  property int registryRevision: 0
  property bool scanning: false
  property string lastEnableError: ""

  signal pluginsChanged()
  signal scanFinished()
  signal pluginLoadFailed(string id, string error)
  signal localPluginChanged(string id)

  // ---------------------------------------------------------------- helpers

  function isSafeEntryPoint(value) {
    if (typeof value !== "string" || value.length === 0) return false
    if (value.charAt(0) === "/") return false
    if (value.indexOf("..") !== -1) return false
    return true
…
```

**⏺ bash** `T=$(mktemp -d); S=/usr/share/omarchy/shell; for d in Commons Ui services; do ln -s $S/$d $T/$d; done; cat > $T/shell.qml <<'EOF'
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

ShellRoot {
  FileView { id: cfg; path: Quickshell.env("HOME") + "/.config/omarchy/shell.json"; b`

✓  ms

```text
  INFO: Configuration Loaded
 DEBUG qml: DISCOVERED true
 DEBUG qml: KINDS ["bar-widget"] FIRSTPARTY false
 DEBUG qml: ENABLED true INBAR true
 DEBUG qml: ENTRY file://~/.config/omarchy/plugins/parker.drawer/Drawer.qml
 DEBUG qml: SCHEMA items:multiselect,icon:string,tooltip:string
T=/tmp/tmp.dPGFj1YotV
```

**⏺ bash** `T=/tmp/tmp.dPGFj1YotV; P=~/.config/omarchy/plugins/parker.drawer; cat > $T/FakeOther.qml <<'EOF'
import QtQuick
Item { property bool opened: false; function open() { opened = true } function close() { opened = false } }
EOF
cat > $T/shell.qml <<EOF
import QtQuick
import Quickshell
import Quickshell.`

✓  ms

```text
 DEBUG qml: PASS button visible with default icon
 DEBUG qml: PASS catalogue scanned (21 widgets)
 DEBUG qml: FAIL itemIds from shell.json
 DEBUG qml: FAIL all tucked widgets built:
```

**⏺ bash** `T=/tmp/tmp.dPGFj1YotV; sed -i 's|check("itemIds from shell.json"|console.log("IDS=" + JSON.stringify(d.itemIds) + " settings=" + JSON.stringify(d.settings)); check("itemIds from shell.json"|' $T/shell.qml; QT_QPA_PLATFORM=offscreen timeout 30 quickshell -p $T 2>&1 | grep -v "^  INFO: \(Launching\|Sh`

✓  ms

```text
  INFO: Configuration Loaded
 DEBUG qml: PASS button visible with default icon
 DEBUG qml: PASS catalogue scanned (21 widgets)
 DEBUG qml: IDS=[] settings={"items":["omarchy.agents","omarchy.bluetooth","omarchy.monitor","omarchy.weather","omarchy.keyboard-layout"]}
 DEBUG qml: FAIL itemIds from shell.json
 DEBUG qml: FAIL all tucked widgets built: 
  WARN scene: @shell.qml[47:-1]: TypeError: Cannot read property 'bar' of undefined
```

Found a real bug. Settings arrive correctly, but `itemIds` comes back empty. My guess is that `items` isn't a real JS array after QML property conversion, so `Array.isArray` fails. Checking:

**⏺ bash** `T=/tmp/tmp.dPGFj1YotV; sed -i 's|console.log("IDS="|console.log("ISARR=" + Array.isArray(d.settings.items) + " typeof=" + typeof d.settings.items + " len=" + d.settings.items.length + " str=" + Object.prototype.toString.call(d.settings.items)); console.log("IDS="|' $T/shell.qml; QT_QPA_PLATFORM=offs`

✓  ms

```text
 DEBUG qml: ISARR=false typeof=object len=5 str=[object V4Sequence]
```

Confirmed: `items` arrives as a `V4Sequence`, an array-like Qt type, not a JS array. I'll check how the stock Indicators widget reads its own `items`.

**⏺ bash** `grep -n "items" /usr/share/omarchy/shell/plugins/bar/widgets/Indicators.qml | head`

✓  ms

```text
45:    if (settings.items && typeof settings.items.length === "number" && settings.items.length > 0) source = settings.items
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && python3 - <<'EOF'
p='DrawerModel.js'; s=open(p).read()
s=s.replace('''function entryId(entry) {''','''// Settings arrays can reach a widget as Qt sequences rather than JS arrays
// (Array.isArray is false for them), so accept anything array-like.
functio`

✓  ms

```text
5:  return value !== null && typeof value === "object" && !Array.isArray(value)
9:// (Array.isArray is false for them), so accept anything array-like.
10:function itemList(settings) {
27:  var items = itemList(settings)
39:  var items = itemList(settings)
  WARN scene: file:///usr/share/omarchy/shell/plugins/agents/Panel.qml[351:3]: Type KeyboardPanel unavailable
  WARN scene: @Ui/KeyboardPanel.qml[37:1]: No PanelWindow backend loaded.
  WARN scene: file:///usr/share/omarchy/shell/plugins/panels/bluetooth/Panel.qml[662:3]: Type KeyboardPanel unavailable
  WARN scene: @Ui/KeyboardPanel.qml[37:1]: No PanelWindow backend loaded.
  WARN scene: file:///usr/share/omarchy/shell/plugins/panels/monitor/Panel.qml[484:3]: Type KeyboardPanel unavailable
  WARN scene: @Ui/KeyboardPanel.qml[37:1]: No PanelWindow backend loaded.
  WARN scene: file:///usr/share/omarchy/shell/plugins/panels/weather/Panel.qml[489:3]: Type KeyboardPanel unavailable
  WARN scene: @Ui/KeyboardPanel.qml[37:1]: No PanelWindow backend loaded.
 DEBUG qml: PASS button visible with default icon
 DEBUG qml: PASS catalogue scanned (21 widgets)
 DEBUG qml: PASS itemIds from shell.json
 DEBUG qml: FAIL all tucked widgets built: omarchy.weather,omarchy.keyboard-layout
  WARN scene: @shell.qml[47:-1]: TypeError: Cannot read property 'bar' of undefined
```

**⏺ bash** `T=/tmp/tmp.dPGFj1YotV; cd $T && python3 - <<'EOF'
s=open('shell.qml').read()
s=s.replace('check("all tucked widgets built: " + built.join(","), built.length === 5)','check("loadable tucked widgets built (offscreen): " + built.join(","), built.indexOf("omarchy.weather") !== -1 && built.indexOf("omarc`

✓  ms

```text
 DEBUG qml: PASS button visible with default icon
 DEBUG qml: PASS catalogue scanned (21 widgets)
 DEBUG qml: PASS itemIds from shell.json
 DEBUG qml: PASS loadable tucked widgets built (offscreen): omarchy.weather,omarchy.keyboard-layout
 DEBUG qml: weather popout-capable: true
 DEBUG qml: PASS hosted widget got slot facade
 DEBUG qml: PASS broadcast reaches hosted instance
 DEBUG qml: FAIL other popout open
 DEBUG qml: PASS drawer opened and stays open
 DEBUG qml: PASS opening drawer closed other bar popout
 DEBUG qml: FAIL hosted panel open; drawer stays open
 DEBUG qml: PASS foreign popout closes drawer + hosted panel
 DEBUG qml: FAIL hosted widget opened while shut reopens drawer
 DEBUG qml: FAIL hosted panel reopened inside drawer
 DEBUG qml: PASS items change rebuilds; inline settings applied
Shell cwd was reset to ~
```

**⏺ bash** `T=/tmp/tmp.dPGFj1YotV; cd $T && cat > FakeHosted.qml <<'EOF'
import QtQuick
import qs.Ui
Panel {
  implicitWidth: 30; implicitHeight: 26
  onOpenedChanged: if (bar) { if (opened) bar.requestPopout(this); else bar.releasePopout(this) }
}
EOF
python3 - <<'EOF'
s=open('shell.qml').read()
s=s.replace('v`

✓  ms

```text
 DEBUG qml: PASS button visible with default icon
 DEBUG qml: PASS catalogue scanned (21 widgets)
 DEBUG qml: PASS itemIds from shell.json
 DEBUG qml: PASS loadable tucked widgets built (offscreen): omarchy.weather,omarchy.keyboard-layout
  WARN scene: @shell.qml[48:-1]: TypeError: Cannot read property 'bar' of undefined
Shell cwd was reset to ~
```

**⏺ bash** `T=/tmp/tmp.dPGFj1YotV; cd $T && mkdir -p ext && mv FakeHosted.qml ext/ && sed -i 's#"/tmp/tmp.dPGFj1YotV/FakeHosted.qml"#"/tmp/tmp.dPGFj1YotV/ext/FakeHosted.qml"#; s#id: stage2; interval: 100#id: stage2; interval: 800#' shell.qml && QT_QPA_PLATFORM=offscreen timeout 30 quickshell -p $T 2>&1 | grep -`

✓  ms

```text
 DEBUG qml: PASS button visible with default icon
 DEBUG qml: PASS catalogue scanned (21 widgets)
 DEBUG qml: PASS itemIds from shell.json
 DEBUG qml: PASS loadable tucked widgets built (offscreen): omarchy.weather,omarchy.keyboard-layout
  WARN scene: @shell.qml[48:-1]: TypeError: Cannot read property 'bar' of undefined
Shell cwd was reset to ~
```

The test entry was being wiped: changing `items` triggers a catalogue rescan, which replaced my injected test entry. That's correct behaviour. I'll inject the test widget after the rescan finishes.

**⏺ bash** `T=/tmp/tmp.dPGFj1YotV; cd $T && python3 - <<'EOF'
s=open('shell.qml').read()
old='var cat = JSON.parse(JSON.stringify(d.catalogue)); cat["test.panel"] = "/tmp/tmp.dPGFj1YotV/ext/FakeHosted.qml"; d.catalogue = cat; d.settings = { items: ["test.panel", "omarchy.weather"] }; stage2.start() } }\n  Timer`

✓  ms

```text
 DEBUG qml: PASS button visible with default icon
 DEBUG qml: PASS catalogue scanned (21 widgets)
 DEBUG qml: PASS itemIds from shell.json
 DEBUG qml: PASS loadable tucked widgets built (offscreen): omarchy.weather,omarchy.keyboard-layout
 DEBUG qml: PASS hosted widget got slot facade
 DEBUG qml: PASS broadcast reaches hosted instance
 DEBUG qml: PASS other popout open
 DEBUG qml: PASS drawer opened and stays open
 DEBUG qml: PASS opening drawer closed other bar popout
 DEBUG qml: PASS hosted panel open; drawer stays open
 DEBUG qml: PASS foreign popout closes drawer + hosted panel
 DEBUG qml: PASS hosted widget opened while shut reopens drawer
 DEBUG qml: PASS hosted panel reopened inside drawer
 DEBUG qml: PASS items change rebuilds; inline settings applied
Shell cwd was reset to ~
```

All 14 checks pass. Cleaning up the test files and rewriting the README for the new design.

**⏺ bash** `rm -rf /tmp/tmp.dPGFj1YotV; cat > ~/.config/omarchy/plugins/parker.drawer/README.md <<'EOF'
# Drawer (`parker.drawer`)

A bar widget for the stock Omarchy bar: a button that opens a panel holding
the widgets you have tucked away, so the bar itself shows only the essentials.

## Choosing what goes in`

✓  ms

```text
Drawer.qml
DrawerModel.js
README.md
manifest.json
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.drawer && sed -i 's/^| `icon`    |.*$/| `icon`    | `""` (falls back to `\\uf141`, an ellipsis) | Nerd Font glyph for the button |/' README.md && grep -n '`icon`' README.md && jq empty manifest.json ~/.config/omarchy/shell.json && echo json-ok`

✓  ms

```text
33:| `icon`    | `""` (falls back to `\uf141`, an ellipsis) | Nerd Font glyph for the button |
json-ok
```

The drawer should now show up as a button on your normal bar, and you choose its widgets with the `items` list on its entry in `shell.json`. I still couldn't see it on screen: there's no running desktop session here, and I found no preview file anywhere in the workspace. So I went by the code and checked it with offscreen tests inside Quickshell.

**What was wrong:**
1. **The drawer wasn't a normal bar widget.** I'd built it as a replacement for the whole bar, so `omarchy.bar` treated the `parker.drawer` entry as unknown and drew nothing. Its manifest also had no settings schema, so `items` wasn't a setting the shell knew about.
2. **`items` was being ignored.** When the shell hands settings to a widget, `items` can arrive as a Qt list type rather than a plain array. My code only accepted plain arrays, so the drawer always ended up empty. Omarchy's own Indicators widget handles `items` the same tolerant way my fix now does.

**What I changed:**
- **Plugin type:** `parker.drawer` is now an ordinary `bar-widget` plugin that runs inside the stock bar. The bar-replacement file is deleted.
- **Picker:** the manifest declares `items` as a multiselect of all the built-in widgets, the same way `omarchy.indicators` declares its `items`, plus optional `icon` and `tooltip` settings.
- **`shell.json`:** I removed the `bar.id` override. The drawer entry sits after the tray, and its five widgets (agents, bluetooth, display, weather, keyboard layout) are now listed only in its `items`:
  ```json
  { "id": "parker.drawer", "items": ["omarchy.agents", "omarchy.bluetooth", "omarchy.monitor", "omarchy.weather", "omarchy.keyboard-layout"] }
  ```
  To tuck a widget away, move its id from the bar layout into `items`; to bring it back, move it back. If an id is in both places, it shows in both.

**Testing:**
- Omarchy's own plugin registry finds `parker.drawer`, accepts it as a third-party bar widget, counts it as enabled from your `shell.json`, and reads its three settings.
- 14 checks on the drawer passed using your real `shell.json`. They cover the button showing, reading `items`, building the tucked widgets, and opening and closing panels.
- Agents, bluetooth and display couldn't be built offscreen because their panels need a real display. The stock bar fails on them the same way in that environment, so it's not a drawer bug, but I couldn't confirm those three load.

**Limitations:**
- Tucked widgets get the same limited bar access as any third-party widget, so a few extras (for example the audio panel's media controls) may not work inside the drawer.
- `omarchy-shell shell toggle omarchy.audio` won't reach a tucked widget. The widget's own target (`omarchy-shell omarchy.audio toggle`) does, and the drawer opens around it.

Run `omarchy restart shell` to load it. If the button still doesn't appear, the output of `omarchy-shell shell listPlugins` and the shell log would show me what's going on.

