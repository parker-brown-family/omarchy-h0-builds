# opencode building Bar Drawer

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools opencode

---

### › You

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

**⏺ skill** `{"id": "omarchy"}`

✓ 83 ms

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

**⏺ shell** `{"command": "ls -la; git log --oneline | head"}`

✓ 463 ms

```text
total 0
drwxr-xr-x 1 parker parker  94 Nov  9 21:01 .
drwx------ 3 parker parker  60 Nov  9 21:01 ..
drwxr-xr-x 1 parker parker  12 Nov  9 21:01 .agents
drwxr-xr-x 1 parker parker  12 Nov  9 21:01 .claude
drwxr-xr-x 1 parker parker  12 Nov  9 21:01 .codex
drwxr-xr-x 1 parker parker  88 Nov  9 21:01 .config
drwxr-xr-x 1 parker parker 160 Nov  9 21:01 .git
drwxr-xr-x 1 parker parker 100 Nov  9 21:01 .h0-api
drwxr-xr-x 1 parker parker  20 Nov  9 21:01 .local
drwxr-xr-x 1 parker parker  10 Nov  9 21:01 .pi
85ebacf h0: task baseline
```

**⏺ shell** `{"command": "ls .agents/skills/omarchy; find .config .local .h0-api .pi -maxdepth 4 | head -100; echo $HOME; echo $OMARCHY_PATH"}`

✓ 866 ms

```text
SKILL.md
capture.md
contributing.md
hooks.md
hyprland.md
plugins.md
theming.md
.config
.config/hypr
.config/hypr/.luarc.json
.config/hypr/autostart.lua
.config/hypr/bindings.lua
.config/hypr/hyprland.lua
.config/hypr/hyprsunset.conf
.config/hypr/input.lua
.config/hypr/looknfeel.lua
.config/hypr/monitors.lua
.config/hypr/xdph.conf
.config/omarchy
.config/omarchy/extensions
.config/omarchy/extensions/omarchy-menu.jsonc
.config/omarchy/hooks
.config/omarchy/hooks/battery-low.d
.config/omarchy/hooks/battery-low.d/play-warning-sound.sample
.config/omarchy/hooks/font-set.d
.config/omarchy/hooks/font-set.d/show-font-notification.sample
.config/omarchy/hooks/post-boot.d
.config/omarchy/hooks/post-boot.d/weather.sample
.config/omarchy/hooks/post-update.d
.config/omarchy/hooks/post-update.d/show-update-notification.sample
.config/omarchy/hooks/pre-refresh-pacman.d
.config/omarchy/hooks/pre-refresh-pacman.d/add-custom-repo.sample
.config/omarchy/hooks/theme-set.d
.config/omarchy/hooks/theme-set.d/show-theme-notification.sample
.config/omarchy/themed
.config/omarchy/themed/alacritty.toml.tpl.sample
.config/omarchy/shell.json
.config/omarchy/themes
.config/alacritty
.config/alacritty/alacritty.toml
…
```

**⏺ read** `~/.agents/skills/omarchy/plugins.md`

✓ 468 ms

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

**⏺ shell** `{"command": "cat .config/omarchy/shell.json; ls /usr/share/omarchy/ /usr/share/omarchy/shell /usr/share/omarchy/shell/plugins 2>&1 | head -80; which omarchy omarchy-shell"}`

✓ 542 ms

```text
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
      "right": [
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; cat README.md plugins/README.md; find plugins/bar plugins/panels | head -100"}`

✓ 541 ms

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

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; cat plugins/bar/README.md; wc -l plugins/bar/Bar.qml plugins/bar/BarModel.js services/*.qml; ls services Commons Ui"}`

✓ 663 ms

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

**⏺ read** `/usr/share/omarchy/shell/plugins/bar/Bar.qml`

✓ 500 ms

```text
Read file /usr/share/omarchy/shell/plugins/bar/Bar.qml, lines 1-1501
1: import Quickshell
2: import Quickshell.Hyprland
3: import Quickshell.Io
4: import Quickshell.Wayland
5: import QtQuick
6: import QtQuick.Layouts
7: import qs.Commons
8: import qs.Ui
9: import "BarModel.js" as BarModel
10: 
11: Item {
12:   id: root
13: 
14:   // The omarchy-shell host injects omarchyPath from OMARCHY_PATH.
15:   property string omarchyPath: Quickshell.env("OMARCHY_PATH")
16:   // Injected by the host shell so bar slots can resolve enabled widgets.
17:   property var barWidgetRegistry: fallbackBarWidgetRegistry
18:   // Read-only registry view for third-party full bars; the built-in bar does
19:   // not otherwise need it, but declaring it keeps clone construction atomic.
20:   property var pluginRegistry: null
21:   // Injected by the host shell every time shell.json is reloaded. Holds the
22:   // `bar:` subtree: position, centerAnchor, layout. The host owns file IO;
23:   // the bar just renders whatever it's handed. The bar font follows the
24:   // OS-level fontconfig monospace binding — it is not stored in shell.json.
25:   property var barConfig: ({})
26:   // Injected by the host shell. Used for shell-wide actions such as opening
27:   // settings and persisting inline widget state.
28:   property var shell: null
29:   // Manifest for the active bar option. Present for custom bars and useful for
30:   // diagnostics; the built-in bar does not otherwise need it.
31:   property var manifest: null
32:   QtObject {
33:     id: fallbackBarWidgetRegistry
34:     property var widgets: ({})
35:     property int revision: 0
36:     function metadataFor(id) { return null }
37:   }
38:   // Mirrors the on-disk `bar-off` flag so the user can hide the bar without
39:   // killing the entire shell. Hidden panels stay mapped but park off-screen
…
```

**⏺ read** `/usr/share/omarchy/shell/plugins/bar/Bar.qml`

✓ 500 ms

```text
Read file /usr/share/omarchy/shell/plugins/bar/Bar.qml, lines 1502-2076
1502:         x: modelData === "right" ? parent.width - edgeSize : 0
1503:         y: modelData === "bottom" ? parent.height - edgeSize : 0
1504:         width: edgeVertical ? edgeSize : parent.width
1505:         height: edgeVertical ? parent.height : edgeSize
1506:         color: root.transparent ? "transparent" : root.background
1507:         borderSpec: Border.flat(root.barForeground, 1)
1508:         visible: opacity > 0
1509:         opacity: root.barMoveCandidate === modelData ? (root.transparent ? 0.45 : 0.7) : 0
1510: 
1511:         Behavior on opacity {
1512:           NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
1513:         }
1514:       }
1515:     }
1516:   }
1517: 
1518:   function findCenterAnchorEntry() {
1519:     var entries = root.layoutEntries("center")
1520:     var idx = root.entryIndex(entries, root.centerAnchor)
1521:     return idx === -1 ? null : entries[idx]
1522:   }
1523: 
1524:   component LeftModules: ModuleList {
1525:     entries: root.layoutEntries("left")
1526:     region: "left"
1527:   }
1528: 
1529:   component RightModules: ModuleList {
1530:     entries: root.layoutEntries("right")
1531:     region: "right"
1532:   }
1533: 
1534:   component CenterModules: Item {
1535:     id: centerRoot
1536: 
1537:     property var entries: root.layoutEntries("center")
1538:     readonly property bool hasAnchor: root.entryIndex(entries, root.centerAnchor) !== -1
1539:     readonly property var anchorEntry: root.findCenterAnchorEntry()
1540: 
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; cat Ui/PluginBarApi.qml services/PluginShellApi.qml services/BarWidgetRegistry.qml services/PluginBarWidgetRegistryApi.qml services/PluginBarStateApi.qml serv`

✓ 932 ms

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

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n \"barWidgetRegistry\\|pluginShellFor\\|PluginBarWidgetRegistryApi\\|PluginRegistryApi\\|injectHost\\|\\\"shell\\\" in\\|omarchyPath\\\" in\\|manifest\`

✓ 1205 ms

```text
shell.qml:20:  property BarWidgetRegistry barWidgetRegistry: BarWidgetRegistry { }
shell.qml:220:    if ("omarchyPath" in target) target.omarchyPath = shell.omarchyPath
shell.qml:221:    if ("shell" in target) target.shell = shell.pluginShellFor(manifest)
shell.qml:222:    if ("manifest" in target) target.manifest = shell.publicPluginManifest(manifest)
shell.qml:223:    if ("barWidgetRegistry" in target) target.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(manifest)
shell.qml:234:      barWidgetRegistry: shell.barWidgetRegistry
shell.qml:293:    PluginRegistryApi { }
shell.qml:298:    PluginBarWidgetRegistryApi { }
shell.qml:336:    var source = shell.barWidgetRegistry.widgets || {}
shell.qml:625:          ? shell.pluginShellForBarEntry(cacheKey + ":" + ownerId, moduleName) : null
shell.qml:680:    if (!manifest.__isFirstParty) return shell.pluginShellFor(manifest)
shell.qml:684:  function pluginShellForId(pluginId) {
shell.qml:688:  function pluginShellForBarEntry(ownerId, moduleName) {
shell.qml:739:  function pluginShellFor(manifest) {
shell.qml:771:    if (!manifest || manifest.__isFirstParty) return shell.barWidgetRegistry
shell.qml:778:      revision: shell.barWidgetRegistry.revision
shell.qml:873:      widgetApi.revision = shell.barWidgetRegistry.revision
shell.qml:928:      if ("omarchyPath" in inst) inst.omarchyPath = shell.omarchyPath
shell.qml:929:      if ("shell" in inst) inst.shell = shell.pluginShellFor(manifest)
shell.qml:930:      if ("manifest" in inst) inst.manifest = shell.publicPluginManifest(manifest)
shell.qml:931:      if ("barWidgetRegistry" in inst) inst.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(manifest)
shell.qml:976:          if (kept && "shell" in kept) kept.shell = shell.pluginShellFor(m)
shell.qml:977:          if (kept && "manifest" in kept) kept.manifest = shell.publicPluginManifest(m)
shell.qml:1061:    target: shell.barWidgetRegistry
shell.qml:1341:          if ("omarchyPath" in item) item.omarchyPath = shell.omarchyPath
shell.qml:1342:          if ("shell" in item) item.shell = shell.pluginShellFor(panelEntry.manifest)
shell.qml:1343:          if ("manifest" in item) item.manifest = shell.publicPluginManifest(panelEntry.manifest)
shell.qml:1344:          if ("barWidgetRegistry" in item) item.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(panelEntry.manifest)
shell.qml:1425:      if (existing && existing.url === url && shell.barWidgetRegistry.has(registryKey)) {
shell.qml:1426:        shell.barWidgetRegistry.register(registryKey, existing.component, meta)
shell.qml:1434:    var allIds = shell.barWidgetRegistry.availableIds()
shell.qml:1439:        shell.barWidgetRegistry.unregister(id)
shell.qml:1448:    for (var id in pluginWidgetComponents) shell.barWidgetRegistry.unregister(id)
shell.qml:1511:        shell.barWidgetRegistry.register(registryKey, comp, meta)
```

**⏺ read** `/usr/share/omarchy/shell/shell.qml`

✓ 599 ms

```text
Read file /usr/share/omarchy/shell/shell.qml, lines 200-899
200:     return manifest
201:       && Array.isArray(manifest.kinds)
202:       && manifest.kinds.indexOf("bar") !== -1
203:       && manifest.entryPoints
204:       && manifest.entryPoints.bar
205:   }
206: 
207:   function barOptionAvailable(pluginId) {
208:     var id = String(pluginId || "")
209:     if (id === "" || id === shell.defaultBarId) return true
210:     var manifest = shell.barManifestFor(id)
211:     return shell.isBarOptionManifest(manifest) && shell.pluginRegistry.entryPointUrl(manifest, "bar") !== ""
212:   }
213: 
214:   function isActiveBarOption(pluginId) {
215:     return String(pluginId || "") === shell.activeBarId
216:   }
217: 
218:   function configureBar(target, manifest) {
219:     if (!target) return
220:     if ("omarchyPath" in target) target.omarchyPath = shell.omarchyPath
221:     if ("shell" in target) target.shell = shell.pluginShellFor(manifest)
222:     if ("manifest" in target) target.manifest = shell.publicPluginManifest(manifest)
223:     if ("barWidgetRegistry" in target) target.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(manifest)
224:     if ("pluginRegistry" in target) target.pluginRegistry = shell.pluginRegistryFor(manifest)
225:     if ("barConfig" in target) target.barConfig = shell.barConfigFor(manifest)
226:     shell.bar = target
227:   }
228: 
229:   Component {
230:     id: defaultBarComponent
231: 
232:     Bar {
233:       omarchyPath: shell.omarchyPath
234:       barWidgetRegistry: shell.barWidgetRegistry
235:       barConfig: shell.barConfig
236:       shell: shell
237:       manifest: shell.barManifestFor(shell.defaultBarId)
238:     }
…
```

**⏺ read** `/usr/share/omarchy/shell/shell.qml`

✓ 549 ms

```text
Read file /usr/share/omarchy/shell/shell.qml, lines 900-1549
900: 
901:   function ensureService(pluginId) {
902:     var key = String(pluginId)
903:     if (_services[key]) return _services[key]
904:     var manifest = pluginRegistry && pluginRegistry.installedPlugins
905:       ? pluginRegistry.installedPlugins[key] : null
906:     if (!manifest) return null
907:     if (!Array.isArray(manifest.kinds) || manifest.kinds.indexOf("service") === -1) return null
908:     if (!manifest.entryPoints || !manifest.entryPoints.service) return null
909:     var url = pluginRegistry.entryPointUrl(manifest, "service")
910:     if (!url) return null
911:     var authenticationService = shell.isAuthenticationService(manifest, key)
912:     if (authenticationService && AuthServiceStore.has(key)) return null
913: 
914:     var comp = Qt.createComponent(url, Component.PreferSynchronous)
915:     function finalize() {
916:       if (comp.status !== Component.Ready) {
917:         console.warn("service plugin load failed for " + key + ": " + comp.errorString())
918:         return
919:       }
920:       // Authentication services and third-party services have no visual
921:       // parent. Parenting either to serviceHost would let a plugin's object
922:       // traversal walk between the host and credential-bearing QML.
923:       var inst = comp.createObject(manifest.__isFirstParty && !authenticationService ? serviceHost : null)
924:       if (!inst) {
925:         console.warn("service plugin createObject returned null for", key)
926:         return
927:       }
928:       if ("omarchyPath" in inst) inst.omarchyPath = shell.omarchyPath
929:       if ("shell" in inst) inst.shell = shell.pluginShellFor(manifest)
930:       if ("manifest" in inst) inst.manifest = shell.publicPluginManifest(manifest)
931:       if ("barWidgetRegistry" in inst) inst.barWidgetRegistry = shell.pluginBarWidgetRegistryFor(manifest)
932:       if ("pluginRegistry" in inst) inst.pluginRegistry = shell.pluginRegistryFor(manifest)
933:       if (authenticationService) {
934:         // Never publish lock/polkit through ShellRoot._services. The private JS
935:         // import retains their lifetime without adding a traversable property
936:         // or QObject parent back to the host shell.
937:         AuthServiceStore.put(key, inst)
938:       } else {
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy; cat version; grep -rln -i \"drawer\" shell bin | head -30; ls ~/.config/omarchy/plugins 2>&1; ls ~/.config/omarchy/plugins 2>&1"}`

✓ 910 ms

```text
4.0.0.alpha
shell/plugins/bar/widgets/Tray.qml
shell/plugins/bar/Bar.qml
shell/plugins/bar/README.md
ls: cannot access '~/.config/omarchy/plugins': No such file or directory
ls: cannot access '~/.config/omarchy/plugins': No such file or directory
```

**⏺ shell** `{"command": "pgrep -a quickshell; timeout 5 omarchy-shell shell ping; echo rc=$?; which quickshell qs qmllint qmllint6 2>&1; ls /usr/lib/qt6/bin 2>/dev/null | head"}`

✓ 756 ms

```text
omarchy-shell is not running
rc=1
which: no qmllint6 in (/usr/local/bin:/usr/bin:/usr/share/omarchy/bin:~/.local/share/mise/installs/bun/latest/bin:~/.local/share/mise/installs/claude/latest:~/.local/share/mise/installs/codex/latest/bin:~/.local/share/mise/installs/crush/latest/crush_0.98.1_Linux_x86_64:~/.local/share/mise/installs/cursor-agent/latest/bin:~/.local/share/mise/installs/gemini/latest/node_modules/.bin:~/.local/share/mise/installs/gh/latest/gh_2.102.0_linux_amd64/bin:~/.local/share/mise/installs/node/26.7.0/bin:~/.local/share/mise/installs/npm-playwright/latest/node_modules/.bin:~/.local/share/mise/installs/opencode/latest/node_modules/.bin:~/.local/share/mise/installs/pi/latest/pi:~/.local/share/mise/installs/shellcheck/0.11.0/shellcheck-v0.11.0:~/.local/share/mise/installs/uv/latest/.mise-bins:~/.local/share/mise/shims:~/.cargo/bin:~/.local/bin)
/usr/bin/quickshell
/usr/bin/qs
~/.local/bin/qmllint
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
```

**⏺ shell** `{"command": "echo \"W=$WAYLAND_DISPLAY D=$DISPLAY X=$XDG_RUNTIME_DIR\"; cd /usr/share/omarchy; ls bin | grep -i -E \"plugin|bar\"; cat bin/omarchy-plugin-clone 2>/dev/null | head -150"}`

✓ 1052 ms

```text
W= D= X=
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
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n \"isEnabled\\|findEntryLocation\" -A25 services/PluginRegistry.qml | sed -n 1,200p"}`

✓ 567 ms

```text
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
163:    return findEntryLocation(config, key).found
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
178:      if (metadata && String(metadata.clonedFrom || "") === key && isEnabled(candidate))
179-        return candidate
180-    }
181-    return key
182-  }
183-
184-  // A bar widget is on when it sits in the bar, whoever shipped it. That is a
185:  // different question from isEnabled(), which decides whether the widget's
186-  // component is loaded at all — a built-in stays loadable so it can be put
187-  // back, and so a plugin that is both a widget and a menu (omarchy.menu)
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -rhoE \"\\bbar\\.[a-zA-Z_]+\" plugins Ui | sort | uniq -c | sort -rn; grep -rn \"barWidgetRegistry\\|pluginShellFor\\|bar\\.shell\\|root\\.shell\\b\" plu`

✓ 1518 ms

```text
    170 bar.foreground
    113 bar.fontFamily
     20 bar.shell
     16 bar.position
     15 bar.urgent
     14 bar.run
      7 bar.sizeHorizontal
      7 bar.hideTooltip
      6 bar.switchPanelFrom
      6 bar.moduleWidgets
      6 bar.layout
      6 bar.iconSlot
      6 bar.barSize
      6 bar.barForeground
      5 bar.vertical
      5 bar.sizeVertical
      5 bar.showTooltip
      4 bar.statusSlot
      4 bar.setCenterHoverRevealSuppressed
      4 bar.background
      4 bar.activePopout
      3 bar.requestPopout
      3 bar.releasePopout
      3 bar.centerHoverRevealSuppressed
      2 bar.text
      2 bar.targetBelongsToWindow
      2 bar.layoutConfig
      2 bar.foregroundAnimationEnabled
      2 bar.clickTargets
      1 bar.x
      1 bar.transparent
      1 bar.shellQuote
      1 bar.iconFont
      1 bar.iconCanvas
      1 bar.centerSectionRevealHeld
      1 bar.barHidden
      1 bar.active
plugins/panels/audio/Panel.qml:434:    if (!bar || !bar.shell) return
plugins/panels/audio/Panel.qml:435:    bar.shell.summon("omarchy.osd", JSON.stringify({
plugins/panels/clock/BarWidget.qml:51:    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -rn \"bar\\.shell\" plugins Ui | grep -v \"panels/\\(audio\\|clock\\|monitor\\|network\\|power\\|tailscale\\)/Panel\\|Tray.qml:18\" ; cat Ui/BarWidget.qm`

✓ 1138 ms

```text
plugins/bar/README.md:164:- `bar.shellQuote(value)` — safe shell-quote a string
plugins/panels/clock/BarWidget.qml:51:    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
plugins/panels/clock/BarWidget.qml:52:      root.bar.shell.updateEntryInline(root.moduleName, entry)
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
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; wc -l Ui/Panel.qml Ui/PanelController.qml Ui/WidgetButton.qml Ui/BarIconButton.qml; grep -n \"bar\\.\\|anchor\\|window\\|QsWindow\\|PopupWindow\\|PanelWindow\`

✓ 1130 ms

```text
  59 Ui/Panel.qml
  16 Ui/PanelController.qml
 119 Ui/WidgetButton.qml
  63 Ui/BarIconButton.qml
 257 total
Ui/Panel.qml:22:  readonly property color barForeground: bar ? bar.barForeground : Color.foreground
Ui/Panel.qml:33:    if (bar && typeof bar.switchPanelFrom === "function") return bar.switchPanelFrom(root, direction)
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; cat Ui/Panel.qml Ui/PanelController.qml Ui/WidgetButton.qml Ui/BarIconButton.qml Ui/qmldir Commons/qmldir; cat plugins/panels/weather/manifest.json"}`

✓ 935 ms

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

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; sed -n 1,147p services/PluginRegistry.qml"}`

✓ 418 ms

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

**⏺ shell** `{"command": "cd /usr/share/omarchy; cat bin/omarchy-plugin-validate; cat bin/omarchy-plugin-enable | head -60"}`

✓ 599 ms

```text
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
# just as the QML `schemaVersion !== 1` check rejects it.
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins; cat panels/weather/BarWidget.qml | head -120; grep -n \"PopupWindow\\|PanelWindow\\|anchor\\.\\|QsWindow\\|requestPopout\\|releasePopout\\|HyprlandFoc`

✓ 1259 ms

```text
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

  // Forwarded so this widget can stand in for the panel as the bar's popout
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; cat Ui/KeyboardPanel.qml; sed -n 1,80p plugins/panels/weather/Panel.qml"}`

✓ 679 ms

```text
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
// `cardOrigin`. We use the bar window's height/width for the perpendicular
// axis (away-from-bar) because mapToItem on the anchor returns
// bar-content-relative coords with internal layout offsets baked in
// (e.g. ~13px from the bar's vertical centering of its widget row). The
// parallel axis (along-the-bar) uses the anchor's content x/y since the
// bar spans full screen on that axis.
//
// Outside-click dismissal: an overlay MouseArea catches clicks, with the
// QsWindow.mask subtracting the bar strip so clicks on the bar still
// reach the bar widgets (activePopout coordinator hands off to another
// popup if the user clicks a different bar icon).
PanelWindow {
  id: root

  required property Item anchorItem
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -rn \"serviceFor\\|firstPartyServiceFor\\|\\.shell\\b\" plugins/bar/widgets plugins/bar/indicators plugins/services/media/BarWidget.qml plugins/menu/BarW`

✓ 1467 ms

```text
plugins/bar/widgets/Tray.qml:184:    if (!root.bar || !root.bar.shell || typeof root.bar.shell.updateEntryInline !== "function") return
plugins/bar/widgets/Tray.qml:186:    root.bar.shell.updateEntryInline(id, { id: id, pinned: pinned, hidden: hidden })
plugins/bar/indicators/Dnd.qml:8:  readonly property var notificationService: bar?.shell?.firstPartyServiceFor("omarchy.notifications")
plugins/bar/indicators/NightLight.qml:7:  readonly property var nightlightService: bar?.shell?.firstPartyServiceFor("omarchy.nightlight")
plugins/bar/indicators/StayAwake.qml:7:  readonly property var idleService: bar?.shell?.firstPartyServiceFor("omarchy.idle")
plugins/services/media/BarWidget.qml:10:  readonly property var mediaService: bar?.shell?.firstPartyServiceFor("omarchy.media")
services/PluginRegistry.qml:29:  signal pluginsChanged()
services/PluginRegistry.qml:315:    pluginsChanged()
services/PluginRegistry.qml:383:    pluginsChanged()
services/PluginRegistry.qml:565:    pluginsChanged()
services/PluginRegistry.qml:641:    pluginsChanged()
shell.qml:70:    pluginRegistry.pluginsChanged()
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
```

**⏺ read** `/usr/share/omarchy/shell/shell.qml`

✓ 561 ms

```text
Read file /usr/share/omarchy/shell/shell.qml, lines 1-200
1: import QtQuick
2: import QtQml.Models
3: import Quickshell
4: import Quickshell.Io
5: 
6: import qs.Commons
7: 
8: import "plugins/bar"
9: import "services"
10: import "services/AuthServiceStore.js" as AuthServiceStore
11: 
12: ShellRoot {
13:   id: shell
14: 
15:   // Shared service instances. Plugins receive these via property injection
16:   // rather than re-importing them as singletons — relative-path imports do
17:   // not share singleton state, which silently leaves consumers with their
18:   // own empty copies.
19:   property PluginRegistry pluginRegistry: PluginRegistry { }
20:   property BarWidgetRegistry barWidgetRegistry: BarWidgetRegistry { }
21:   property AppLibrary appLibrary: AppLibrary { }
22: 
23:   property string home: Quickshell.env("HOME")
24: 
25:   // The omarchy-shell host is the long-running entry point. Plugins live in
26:   // sibling directories under plugins/. OMARCHY_PATH is provided by the uwsm
27:   // session environment and is the single source of truth for this checkout.
28:   property string omarchyPath: Quickshell.env("OMARCHY_PATH")
29:   readonly property string shellPath: omarchyPath + "/shell"
30:   readonly property string firstPartyPluginsDir: shellPath + "/plugins"
31:   readonly property string defaultsPath: omarchyPath + "/config/omarchy/shell.json"
32:   readonly property string userConfigPath: home + "/.config/omarchy/shell.json"
33: 
34:   // Bundled fallback so the shell can start even when the default shell.json is
35:   // missing or unreadable. The bar config here mirrors the on-disk defaults
36:   // closely enough to render a usable bar; not authoritative.
37:   readonly property var builtinShellConfig: ({
38:     version: 1,
39:     idle: {
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -rn \"bar\\.layoutConfig\\|bar\\.barHidden\\|bar\\.shellQuote\\|bar\\.centerSectionRevealHeld\\|bar\\.transparent\\b\\|bar\\.activePopout\\|registerClick`

✓ 1231 ms

```text
plugins/bar/widgets/Indicators.qml:18:  readonly property bool revealInactiveIndicators: alwaysShowIndicators || indicatorAreaHovered || indicatorItemHovered || (bar && bar.centerSectionRevealHeld === true && bar.centerHoverRevealSuppressed !== true)
plugins/bar/widgets/Tray.qml:163:    var layout = root.bar && root.bar.layoutConfig ? root.bar.layoutConfig : null
plugins/bar/README.md:164:- `bar.shellQuote(value)` — safe shell-quote a string
plugins/notifications/Service.qml:51:  readonly property int liveBarSize: shell && shell.bar && !shell.bar.barHidden ? Math.max(0, shell.bar.barSize) : defaultBarSize
Ui/KeyboardPanel.qml:240:      popoutSwitching = bar.activePopout && bar.activePopout !== coordinatorKey
Ui/KeyboardPanel.qml:246:      if (bar.activePopout === coordinatorKey) bar.releasePopout(coordinatorKey)
Ui/PluginBarApi.qml:34:  property var _registerClickTarget: null
Ui/PluginBarApi.qml:35:  property var _unregisterClickTarget: null
Ui/PluginBarApi.qml:56:  function registerClickTarget(target) {
Ui/PluginBarApi.qml:57:    if (_registerClickTarget) _registerClickTarget(target)
Ui/PluginBarApi.qml:60:  function unregisterClickTarget(target) {
Ui/PluginBarApi.qml:61:    if (_unregisterClickTarget) _unregisterClickTarget(target)
Ui/PopupCard.qml:75:    else if (bar.activePopout === coordinatorKey) bar.releasePopout(coordinatorKey)
Ui/WidgetButton.qml:45:    if (registeredBar && registeredBar.unregisterClickTarget) registeredBar.unregisterClickTarget(root)
Ui/WidgetButton.qml:47:    if (registeredBar && registeredBar.registerClickTarget) registeredBar.registerClickTarget(root)
Ui/WidgetButton.qml:55:  Component.onDestruction: if (registeredBar && registeredBar.unregisterClickTarget) registeredBar.unregisterClickTarget(root)
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; sed -n 1,80p Ui/PopupCard.qml; grep -rln \"PopupCard\\b\" plugins | head; grep -rln \"KeyboardPanel\" plugins | head -20"}`

✓ 772 ms

```text
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

  function fittedContentWidth(width, cap) {
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; sed -n 80,200p Ui/PopupCard.qml"}`

✓ 447 ms

```text
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

      if (root.centerOnBar) {
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; sed -n 1,140p plugins/bar/widgets/Tray.qml"}`

✓ 56 ms

```text
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Services.SystemTray
import qs.Commons
import qs.Ui
import "TrayModel.js" as TrayModel

BarWidget {
  id: root
  moduleName: "omarchy.tray"

  property bool expanded: false
  property bool managePopupOpen: false
  property bool trayMenuOpen: false
  property var activeTrayItem: null
  property var activeTrayAnchor: null
  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property var pinnedIds: settings.pinned instanceof Array ? settings.pinned : []
  readonly property var hiddenIds: settings.hidden instanceof Array ? settings.hidden : []
  readonly property var pinnedItems: bucket("pinned")
  readonly property var drawerItems: bucket("drawer")
  readonly property var allItems: bucket("all")
  readonly property int drawerCount: drawerItems.length
  readonly property int trayItemExtent: Style.bar.iconSlot
  readonly property int trayItemGap: 0
  readonly property int trayJoinGap: 0
  readonly property int drawerExtent: drawerCount > 0 ? drawerCount * trayItemExtent + (drawerCount - 1) * trayItemGap : 0
  // Match Waybar's group/tray-expander drawer transition-duration.
  readonly property int animationDuration: 600
  property real revealProgress: expanded ? 1 : 0
  readonly property real revealExtent: drawerExtent * revealProgress

  // Submenu drill-down state. QsMenuEntry.display() renders a *platform* menu,
  // which Quickshell refuses unless the shell root sets `//@ pragma
  // UseQApplication` - omarchy's shell.qml does not, so every submenu click was
  // a silent no-op ("Cannot display PlatformMenuEntry as quickshell was not
  // started in QApplication mode" in the shell log) and apps whose whole UI is
…
```

**⏺ shell** `{"command": "ls /usr/lib/qt6/qml/Quickshell/ | head -30; which sway weston cage Hyprland hyprland labwc 2>&1 | grep -v \"no \"; cat ~/.local/bin/qmllint 2>/dev/null | head -20; file ~/.local/bin/qmlli`

✓ 999 ms

```text
Bluetooth
DBusMenu
Hyprland
I3
Io
Networking
Services
Wayland
Widgets
WindowManager
X11
_Window
qmldir
quickshell-core.qmltypes
/usr/bin/Hyprland
/usr/bin/hyprland
~/.local/bin/qmllint: cannot open `~/.local/bin/qmllint' (No such file or directory)
```

**⏺ shell** `{"command": "ls -la ~/.local/bin/qmllint; head -c 300 ~/.local/bin/qmllint | strings | head; ls /usr/lib/qt6/bin | grep -i lint"}`

✓ 860 ms

```text
lrwxrwxrwx 1 parker parker 24 Aug 28 14:32 ~/.local/bin/qmllint -> /usr/lib/qt6/bin/qmllint
qmllint
```

**⏺ shell** `{"command": "cd /usr/share/omarchy; grep -rn \"shell toggle\\|shell summon\\|omarchy-shell\" default/hypr bin 2>/dev/null | grep -v \"^bin/omarchy-shell:\" | head -40"}`

✓ 871 ms

```text
default/hypr/bindings/clipboard.lua:48:o.bind("SUPER + CTRL + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")
default/hypr/bindings/media.lua:24:o.bind("XF86AudioNext", "Next track", "omarchy-shell media next", { locked = true })
default/hypr/bindings/media.lua:25:o.bind("ALT + XF86AudioPlay", "Next track", "omarchy-shell media next", { locked = true })
default/hypr/bindings/media.lua:26:o.bind("XF86AudioPause", "Pause", "omarchy-shell media playPause", { locked = true })
default/hypr/bindings/media.lua:27:o.bind("XF86AudioPlay", "Play", "omarchy-shell media playPause", { locked = true })
default/hypr/bindings/media.lua:28:o.bind("XF86AudioPrev", "Previous track", "omarchy-shell media previous", { locked = true })
default/hypr/bindings/media.lua:29:o.bind("ALT + SHIFT + XF86AudioPlay", "Previous track", "omarchy-shell media previous", { locked = true })
default/hypr/bindings/utilities.lua:3:o.bind("SUPER + CTRL + E", "Emojis", "omarchy-shell shell toggle omarchy.emojis")
default/hypr/bindings/utilities.lua:24:o.bind("SUPER + comma", "Dismiss last notification", "omarchy-shell notifications dismissOne")
default/hypr/bindings/utilities.lua:25:o.bind("SUPER + SHIFT + comma", "Dismiss all notifications", "omarchy-shell notifications dismissAll")
default/hypr/bindings/utilities.lua:27:o.bind("SUPER + ALT + comma", "Invoke last notification", "omarchy-shell notifications invokeLast")
default/hypr/bindings/utilities.lua:28:o.bind("SUPER + SHIFT + ALT + comma", "Open notification history", "omarchy-shell notifications showHistory")
default/hypr/bindings/utilities.lua:97:o.bind("SUPER + CTRL + A", "Audio", "omarchy-shell shell toggle omarchy.audio")
default/hypr/bindings/utilities.lua:98:o.bind("SUPER + CTRL + B", "Bluetooth", "omarchy-shell shell toggle omarchy.bluetooth")
default/hypr/bindings/utilities.lua:99:o.bind("SUPER + CTRL + D", "Display", "omarchy-shell shell toggle omarchy.monitor")
default/hypr/bindings/utilities.lua:100:o.bind("SUPER + CTRL + ALT + D", "Calendar", "omarchy-shell shell toggle omarchy.clock")
default/hypr/bindings/utilities.lua:101:o.bind("SUPER + CTRL + W", "Network", "omarchy-shell shell toggle omarchy.network")
default/hypr/bindings/utilities.lua:102:o.bind("SUPER + CTRL + P", "Power", "omarchy-shell shell toggle omarchy.power")
default/hypr/bindings/utilities.lua:113:    "omarchy-shell -q shell togglePanelAt right " .. panel
```

**⏺ shell** `{"command": "cd /usr/share/omarchy; sed -n 90,120p default/hypr/bindings/utilities.lua; cat ~/.config/hypr/bindings.lua | head -40"}`

✓ 610 ms

```text
o.bind("SUPER + SHIFT + CTRL + R", "Clear reminders", "omarchy-reminder clear")

o.bind("SUPER + CTRL + ALT + T", "Show time", "omarchy-notification-time")
o.bind("SUPER + CTRL + ALT + B", "Show battery remaining", "omarchy-notification-battery")
o.bind("SUPER + CTRL + ALT + W", "Toggle weather", "omarchy-notification-weather")

o.bind("SUPER + SHIFT + CTRL + A", "Agent", "omarchy-agent --pick")
o.bind("SUPER + CTRL + A", "Audio", "omarchy-shell shell toggle omarchy.audio")
o.bind("SUPER + CTRL + B", "Bluetooth", "omarchy-shell shell toggle omarchy.bluetooth")
o.bind("SUPER + CTRL + D", "Display", "omarchy-shell shell toggle omarchy.monitor")
o.bind("SUPER + CTRL + ALT + D", "Calendar", "omarchy-shell shell toggle omarchy.clock")
o.bind("SUPER + CTRL + W", "Network", "omarchy-shell shell toggle omarchy.network")
o.bind("SUPER + CTRL + P", "Power", "omarchy-shell shell toggle omarchy.power")
o.bind("SUPER + CTRL + T", "Activity", { tui = "btop" })

-- The letters above name a panel; the numbers count them. 1 is the leftmost
-- panel in the bar's right section, and a widget with no panel of its own (the
-- tray) is not counted, so the number matches the icon a user would point at.
-- A bar with fewer panels than this leaves the tail of the range doing nothing.
for panel = 1, 9 do
  o.bind(
    "SUPER + CTRL + code:" .. tostring(panel + 9),
    "Bar panel " .. panel,
    "omarchy-shell -q shell togglePanelAt right " .. panel
  )
end

o.bind("SUPER + CTRL + Z", "Zoom in", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)
-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n \"function \\|readonly property\" Commons/Util.qml | head -60; grep -n \"gapsOut\\|cornerRadius\\|property.*bar\\b\\|sizeHorizontal\\|sizeVertical\\|i`

✓ 1172 ms

```text
10:  function clamp(value, min, max) {
16:  function clampAlpha(value) {
20:  function wheelSteps(accumulator, delta) {
33:  function alpha(c, opacity) {
42:  function fileUrl(path) {
49:  function shellQuote(value) {
53:  function execDetached(command) {
62:  function execArgv(argv) {
66:  function isPlainObject(value) {
70:  function canonicalWidgetId(id) {
76:  function decodeBase64(value) {
82:  function cloneJson(value) {
89:  function parseModuleJson(raw) {
107:  function editsFilter(event, text) {
117:  function editedFilter(event, text) {
127:  function normalizeLayoutEntry(entry) {
137:  function normalizeLayoutSection(list) {
147:  function normalizeLayout(layout) {
11:// `cornerRadius` mirrors Hyprland's `decoration:rounding`. `gapsOut` is
31:  property int cornerRadius: 0
32:  property int gapsOut: 5
213:  function spaceReal(px) {
219:  function space(px) {
260:    readonly property int popupPadding: root.spacingToken("popup-padding", 14)
329:    readonly property int body:         root.fontToken("body",          root.fontPx(1.0))     // 12
341:  readonly property QtObject bar: QtObject {
342:    readonly property int sizeHorizontal: root.barToken("size-horizontal", 26)
343:    readonly property int sizeVertical:   root.barToken("size-vertical",   28)
344:    readonly property int iconSlot:       root.barToken("icon-slot",       27)
346:    readonly property int iconFont:       root.barToken("icon-font",       13)
347:    readonly property int statusSlot:     root.barToken("status-slot",     21)
352:    gapsOutProc.running = true
363:      if (isFinite(n) && n >= 0) cornerRadius = n
375:      if (isFinite(n) && n >= 0) gapsOut = Math.max(0, Math.round(n / 2))
451:  property Process gapsOutProc: Process {
452:    id: gapsOutProc
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; sed -n 40,80p Commons/Util.qml; grep -n \"property\" Commons/Color.qml | grep -i \"bar\\|popups\\|tooltip\\|accent\\|foreground\\b\" | head -20; grep -n \"rea`

✓ 1321 ms

```text
  // file:// URL with each path segment percent-encoded so spaces and
  // special chars in user paths don't break Image.source.
  function fileUrl(path) {
    if (!path) return ""
    return "file://" + String(path).split("/").map(encodeURIComponent).join("/")
  }

  // Single-quote a string for bash. The replace handles embedded single
  // quotes by closing, escaping, and re-opening the literal.
  function shellQuote(value) {
    return "'" + String(value || "").replace(/'/g, "'\\''") + "'"
  }

  function execDetached(command) {
    Quickshell.execDetached(["bash", "-lc", command])
  }

  // Run an argv vector without a shell interpreting it: the constant `exec "$@"`
  // means the args only ever land in positional parameters, which bash expands
  // without re-tokenizing — so untrusted data ($(id), a filename) stays literal.
  // The login shell (-l) keeps the PATH/session env GUI targets (tensaku, mpv,
  // xdg-open) need. Prefer this over execDetached for anything built from input.
  function execArgv(argv) {
    Quickshell.execDetached(["bash", "-lc", 'exec "$@"', "bash"].concat(argv))
  }

  function isPlainObject(value) {
    return value !== null && typeof value === "object" && !Array.isArray(value)
  }

  function canonicalWidgetId(id) {
    return String(id || "")
  }

  // Best-effort base64 decode. Returns "" on parse failure rather than
  // surfacing garbage downstream.
  function decodeBase64(value) {
    var s = String(value || "")
    if (!s) return ""
    try { return Qt.atob(s) } catch (e) { return "" }
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n \"property\\|function\" Ui/BorderSurface.qml | head -40; grep -n \"function surfaceSpec\\|function flat\\|function top\\b\\|function top(\" Commons/Bo`

✓ 1011 ms

```text
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
140:  function surfaceSpec(section, token, fallbackColor, fallbackWidth, alphaKey) {
236:  function top(spec) { return spec && spec.widths ? spec.widths.top : 0 }
    var current = String(configuredFormat)
    var next = Model.nextClockFormat(formatRing, current)
    if (next === "" || next === current) return

    var entry = { id: root.moduleName }
    for (var key in root.settings) if (key !== "id") entry[key] = root.settings[key]
    entry[vertical ? "verticalFormat" : "format"] = next

    // Applied locally first so the label changes on the click itself; the
    // shell.json write comes back through the bar as the same value.
    root.settings = entry
    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
      root.bar.shell.updateEntryInline(root.moduleName, entry)
  }

  function formatted(date) {
    return Qt.formatDateTime(date, activeFormat.replace(/ww/g, Model.isoWeekLiteral(date.getFullYear(), date.getMonth(), date.getDate())))
```

**⏺ shell** `{"command": "echo $USER; id -un; cat /usr/share/omarchy/shell/plugins/agents/manifest.json; cat /usr/share/omarchy/shell/plugins/services/media/manifest.json"}`

✓ 576 ms

```text
parker
parker
{
  "schemaVersion": 1,
  "id": "omarchy.agents",
  "name": "Agents",
  "version": "1.0.0",
  "author": "Omarchy",
  "license": "MIT",
  "description": "Claude Code, Codex, and Fireworks usage, limits, and pace in a native Omarchy bar panel.",
  "kinds": ["bar-widget"],
  "activation": "on-demand",
  "entryPoints": {
    "barWidget": "Panel.qml"
  },
  "barWidget": {
    "displayName": "Agents",
    "description": "One bar icon and one panel: rate-limit meters with pace, today, the last week, and the all-time model breakdown for every subscription.",
    "category": "AI",
    "aliases": ["agents", "model-usage"],
    "allowMultiple": false,
    "defaults": {
      "providers": {
        "claude": { "enabled": true },
        "codex": { "enabled": true },
        "fireworks": { "enabled": true }
      },
      "refreshIntervalSec": 900,
      "syncMode": "Off",
      "syncDir": "",
      "syncFileName": "",
      "syncDeviceId": ""
    },
    "schema": [
      { "key": "refreshIntervalSec", "type": "integer", "label": "Refresh interval (seconds)", "min": 30, "max": 3600, "step": 30, "defaultValue": 900 },
      { "key": "syncMode", "type": "enum", "label": "Synced aggregation", "options": ["Off", "On"], "defaultValue": "Off", "description": "When On, write this machine's local usage snapshot and merge snapshots from other machines." },
      { "key": "syncDir", "type": "path", "label": "Sync folder", "defaultValue": "", "description": "A folder synced by Syncthing, Dropbox, rsync, etc." },
      { "key": "syncFileName", "type": "string", "label": "Snapshot file name", "defaultValue": "", "description": "Optional. Defaults to <hostname>.json. Use a different file name on each machine, such as laptop.json or desktop.json." },
      { "key": "syncDeviceId", "type": "string", "label": "Device id", "defaultValue": "", "description": "Optional stable device name used inside synced aggregate snapshots." }
    ]
…
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.drawer",
  "name": "Drawer",
  "version": "1.0.0",
  "author": "parker",
  "description": "A bar button that opens a drawer holding the bar widgets you tucked away.",
  "kinds": [
    "bar-widget",
    "service"
  ],
  "entryPoints": {
    "barWidget": "Widget.qml",
    "service": "Service.qml"
  },
  "barWidget": {
    "displayName": "Drawer",
    "description": "Click to open a drawer with the widgets listed in this entry's items.",
    "category": "Layout",
    "allowMultiple": false,
    "defaultSection": "right",
    "defaults": {
      "items": [],
      "icon": ""
    },
    "schema": [
      { "key": "icon", "type": "string", "label": "Button icon", "defaultValue": "", "description": "Optional glyph for the drawer button. Empty uses a chevron that points toward the drawer." }
    ]
  }
}
```

✓ 3575 ms

```text
Created file successfully: .config/omarchy/plugins/parker.drawer/manifest.json
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/Service.qml`

```
import QtQuick
import Quickshell.Hyprland
import Quickshell.Io

// Shared state for every drawer button (one per monitor's bar).
//
// Bar widgets are not handed the widget catalogue, but a plugin's own service
// is: the host injects a read-only barWidgetRegistry snapshot here, and each
// drawer button looks this service up through bar.shell.serviceFor(<own id>).
QtObject {
  id: service

  property var shell: null
  property var manifest: null
  property var barWidgetRegistry: null

  readonly property string pluginId: manifest && manifest.id ? String(manifest.id) : "parker.drawer"

  // Live drawer buttons, one per bar surface.
  property var hosts: []

  function registerHost(host) {
    if (!host || hosts.indexOf(host) !== -1) return
    var next = hosts.slice()
    next.push(host)
    hosts = next
  }

  function unregisterHost(host) {
    hosts = hosts.filter(function(item) { return item && item !== host })
  }

  // Every hosted instance of a widget id across all monitors, so a hosted
  // widget's broadcast() still reaches its peers the way it does on the bar.
  function hostedWidgets(id) {
    var out = []
    for (var i = 0; i < hosts.length; i++) {
      var host = hosts[i]
      if (host && typeof host.hostedItems === "function") out = out.concat(host.hostedItems(id))
    }
    return out
  }

  // The drawer on the focused monitor, falling back to any live drawer.
  function focusedHost() {
    var monitor = Hyprland.focusedMonitor
    var name = monitor ? String(monitor.name || "") : ""
    for (var i = 0; i < hosts.length; i++) {
      if (hosts[i] && name && hosts[i].screenName === name) return hosts[i]
    }
    return hosts.length > 0 ? hosts[0] : null
  }

  // Panel hotkeys such as `omarchy-shell shell toggle omarchy.bluetooth` only
  // reach widgets mounted directly on the bar. For a widget tucked into the
  // drawer, bind the key to `omarchy-shell parker.drawer togglePanel <id>`.
  property IpcHandler ipc: IpcHandler {
    target: service.pluginId

    function toggle(): void {
… (10 more lines in the repository)
```

✓ 7663 ms

```text
Created file successfully: .config/omarchy/plugins/parker.drawer/Service.qml
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/DrawerBar.qml`

```
import QtQuick
import qs.Commons

// The `bar` handed to widgets hosted inside the drawer. It mirrors the bar
// surface widgets expect (colors, geometry, tooltips, popout coordination,
// click targets) but scopes everything to this drawer, and its `shell` only
// forwards to the drawer plugin's own scoped shell — hosting a widget here
// never grants it more than the drawer itself was given.
QtObject {
  id: api

  // The drawer button (Widget.qml) that owns this surface.
  property var host: null
  // The bar facade the host bar injected into the drawer button.
  property var hostBar: null

  readonly property var hostShell: hostBar ? hostBar.shell : null

  // Hosted widgets sit on an opaque card, so they always use the theme's bar
  // text color rather than the wallpaper-derived transparent-bar color.
  readonly property color foreground: hostBar ? hostBar.foreground : Color.bar.text
  readonly property color barForeground: foreground
  readonly property color background: Color.bar.background
  readonly property color urgent: hostBar ? hostBar.urgent : Color.bar.active
  readonly property string fontFamily: hostBar && hostBar.fontFamily ? hostBar.fontFamily : Style.font.family
  readonly property string position: hostBar ? String(hostBar.position || "top") : "top"
  readonly property bool vertical: position === "left" || position === "right"
  readonly property int barSize: hostBar && hostBar.barSize > 0
    ? hostBar.barSize : (vertical ? Style.bar.sizeVertical : Style.bar.sizeHorizontal)
  readonly property bool transparent: false
  readonly property bool foregroundAnimationEnabled: hostBar ? hostBar.foregroundAnimationEnabled !== false : true
  readonly property bool barHidden: false
  // Indicators reveal their inactive items while the bar's center is hovered;
  // inside an open drawer they should simply be shown.
  readonly property bool centerSectionRevealHeld: true
  property bool centerHoverRevealSuppressed: false
  readonly property var layoutConfig: hostBar && hostBar.layoutConfig ? hostBar.layoutConfig : ({})

  property var activePopout: null
  property var clickTargets: []

  function run(command) {
    if (hostBar && command) hostBar.run(String(command))
  }

  function shellQuote(value) {
    return Util.shellQuote(value)
  }

  function showTooltip(target, text) {
    if (host) host.showTooltip(target, String(text || ""))
  }

  function hideTooltip(target) {
    if (host) host.hideTooltip(target)
  }

  function registerClickTarget(target) {
    if (!target || clickTargets.indexOf(target) !== -1) return
    var next = clickTargets.slice()
… (89 more lines in the repository)
```

✓ 15090 ms

```text
Created file successfully: .config/omarchy/plugins/parker.drawer/DrawerBar.qml
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/Widget.qml`

```
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

// Drawer button for the bar. Clicking it opens a card next to the bar that
// hosts the widgets listed in this entry's `items` setting in shell.json:
//
//   { "id": "parker.drawer", "items": ["omarchy.weather", { "id": "omarchy.clock", "format": "HH:mm" }] }
//
// Hosted widgets stay mounted while the drawer is closed, so their state,
// timers, and IPC targets keep working exactly as they did on the bar.
BarWidget {
  id: root

  // Bar-shaped popup contract: lets `omarchy-shell shell toggle parker.drawer`
  // and the numbered panel hotkeys open the drawer, and lets the bar's
  // one-popup-at-a-time coordinator close it when another panel opens.
  readonly property bool opened: drawerOpen
  property bool drawerOpen: false

  property QtObject service: null
  readonly property var registry: service ? service.barWidgetRegistry : null

  readonly property var barWindow: root.QsWindow.window
  readonly property string screenName: barWindow && barWindow.screen ? String(barWindow.screen.name || "") : ""
  readonly property string position: bar ? String(bar.position || "top") : "top"
  readonly property real barThickness: barWindow
    ? (vertical ? barWindow.width : barWindow.height)
    : barSize
  readonly property int gap: Style.gapsOut
  readonly property int margin: Style.gapsOut

  readonly property var configuredItems: Array.isArray(settings.items) ? settings.items : []

  // Only the identity of the hosted list drives the Repeater: settings edits
  // (a clock format cycling, say) patch the live widgets instead of rebuilding
  // them, because an unchanged string property does not notify.
  readonly property string hostedKey: JSON.stringify(computeHostedEntries())
  readonly property var hostedEntries: JSON.parse(hostedKey)

  property var hostedSlots: []
  property var openAfterShow: null

  property var tooltipTarget: null
  property string tooltipText: ""
  property bool tooltipShown: false
  property bool focusPrimed: false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // ------------------------------------------------------------- lifecycle

  function open() {
    if (drawerOpen) return
    drawerOpen = true
    if (bar) bar.requestPopout(root)
  }
… (566 more lines in the repository)
```

✓ 58348 ms

```text
Created file successfully: .config/omarchy/plugins/parker.drawer/Widget.qml
```

**⏺ shell** `{"command": "mkdir -p /tmp/opencode/qsimports && ln -sfn /usr/share/omarchy/shell /tmp/opencode/qsimports/qs; cd ~/.config/omarchy/plugins/parker.drawer && qmllint -I /tmp/opencode/qsimports -I /usr/l`

✓ 1275 ms

```text
Warning: Widget.qml:334:3: Type PanelWindow is not creatable. [uncreatable-type]
  PanelWindow {
  ^^^^^^^^^^^
Warning: Widget.qml:535:13: id declarations are only allowed in objects [syntax]
        id: tooltipAnchor
            ^^^^^^^^^^^^^
Warning: Widget.qml:600:7: Type PanelWindow is not creatable. [uncreatable-type]
      PanelWindow {
      ^^^^^^^^^^^
Warning: Widget.qml:537:9: No type found for property "adjustment". This may be due to a missing import statement or incomplete qmltypes files. [missing-type]
        adjustment: PopupAdjustment.Slide
        ^^^^^^^^^^
Warning: Widget.qml:538:9: No type found for property "edges". This may be due to a missing import statement or incomplete qmltypes files. [missing-type]
        edges: Edges.Top | Edges.Left
        ^^^^^
Warning: Widget.qml:539:9: No type found for property "gravity". This may be due to a missing import statement or incomplete qmltypes files. [missing-type]
        gravity: Edges.Bottom | Edges.Right
        ^^^^^^^
Warning: Widget.qml:24:53: Member "barWidgetRegistry" not found on type "QObject" [missing-property]
  readonly property var registry: service ? service.barWidgetRegistry : null
                                                    ^^^^^^^^^^^^^^^^^
Warning: Widget.qml:28:55: Member "position" not found on type "QObject" [missing-property]
  readonly property string position: bar ? String(bar.position || "top") : "top"
                                                      ^^^^^^^^
Warning: Widget.qml:59:18: Member "requestPopout" not found on type "QObject" [missing-property]
    if (bar) bar.requestPopout(root)
                 ^^^^^^^^^^^^^
Warning: Widget.qml:68:18: Member "releasePopout" not found on type "QObject" [missing-property]
    if (bar) bar.releasePopout(root)
                 ^^^^^^^^^^^^^
Warning: Widget.qml:87:33: Member "shell" not found on type "QObject" [missing-property]
    if (service || !bar || !bar.shell || typeof bar.shell.serviceFor !== "function") return
                                ^^^^^
Warning: Widget.qml:87:53: Member "shell" not found on type "QObject" [missing-property]
    if (service || !bar || !bar.shell || typeof bar.shell.serviceFor !== "function") return
                                                    ^^^^^
Warning: Widget.qml:88:21: Member "shell" not found on type "QObject" [missing-property]
    var found = bar.shell.serviceFor(root.moduleName)
                    ^^^^^
Warning: Widget.qml:126:29: Member "layoutConfig" not found on type "QObject" [missing-property]
…
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.drawer && qmllint -I /tmp/opencode/qsimports -I /usr/lib/qt6/qml Widget.qml DrawerBar.qml Service.qml 2>&1 | grep \"^Warning\\|^Error\" | grep -v \"mis`

✓ 2253 ms

```text
Warning: Widget.qml:535:13: id declarations are only allowed in objects [syntax]
Warning: Widget.qml:459:51: Unqualified access [unqualified]
Warning: Widget.qml:459:70: Unqualified access [unqualified]
Warning: Widget.qml:461:31: Unqualified access [unqualified]
Warning: Widget.qml:461:47: Unqualified access [unqualified]
Warning: Widget.qml:465:50: Cannot assign binding of type QObject to QQuickItem [incompatible-type]
Warning: Widget.qml:467:66: Unqualified access [unqualified]
Warning: Widget.qml:467:82: Unqualified access [unqualified]
Warning: Widget.qml:475:51: Unqualified access [unqualified]
Warning: Widget.qml:481:38: Unqualified access [unqualified]
Warning: Widget.qml:482:40: Unqualified access [unqualified]
Warning: Widget.qml:499:86: Unqualified access [unqualified]
Warning: Widget.qml:502:26: Unqualified access [unqualified]
Warning: Widget.qml:502:52: Unqualified access [unqualified]
Warning: Widget.qml:505:24: Unqualified access [unqualified]
Warning: Widget.qml:506:25: Unqualified access [unqualified]
Warning: Widget.qml:507:20: Unqualified access [unqualified]
Warning: Widget.qml:508:22: Unqualified access [unqualified]
Warning: Widget.qml:510:20: Unqualified access [unqualified]
Warning: Widget.qml:512:22: Unqualified access [unqualified]
Warning: Widget.qml:563:11: Unqualified access [unqualified]
Warning: Widget.qml:564:11: Unqualified access [unqualified]
Warning: Widget.qml:621:22: Unqualified access [unqualified]
---
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1295:13: id declarations are only allowed in objects [syntax]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1618:9: ModuleSlot was not found. Did you add all imports and dependencies? [import]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1250:5: unknown grouped property scope margins. [unqualified]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1250:5: Type margins is used but it is not resolved [unresolved-type]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1243:20: Unqualified access [unqualified]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1264:20: Unqualified access [unqualified]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1264:36: Unqualified access [unqualified]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1265:21: Unqualified access [unqualified]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1265:41: Unqualified access [unqualified]
Warning: /usr/share/omarchy/shell/plugins/bar/Bar.qml:1266:12: Unqualified access [unqualified]
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/Widget.qml`

```
              readonly property var activeItem: loader.item
```

✓ 1172 ms

```text
Edited .config/omarchy/plugins/parker.drawer/Widget.qml (1 replacement)
```

**⏺ shell** `{"command": "mkdir -p /tmp/opencode/xdg && chmod 700 /tmp/opencode/xdg; cat > /tmp/opencode/hypr-test.conf <<'EOF'\nmonitor = HEADLESS-1, 1920x1080@60, 0x0, 1\nmisc {\n  disable_hyprland_logo = true\n`

✓ 2281 ms

```text
/usr/bin/bash: line 7:   469 Aborted                    XDG_RUNTIME_DIR=/tmp/opencode/xdg HYPRLAND_HEADLESS_ONLY=1 timeout 8 Hyprland -c /tmp/opencode/hypr-test.conf > /tmp/opencode/hypr.log 2>&1
rc=134


[1;33mWARN [0m]: Failed to change process scheduling strategy
[!!WARNING!!] XDG_RUNTIME_DIR looks non-standard. Proceeding anyways...
DEBUG ]: Old rlimit: soft -> 524288, hard -> 524288
DEBUG ]: New rlimit: soft -> 524288, hard -> 524288
WARN ]: WARNING: Hyprland is being launched without start-hyprland. This is highly advised against.
DEBUG ]: Creating the EventLoopManager!
DEBUG ]: Creating the KeybindManager!
DEBUG ]: Creating the AnimationManager!
DEBUG ]: Creating the DynamicPermissionManager!
DEBUG ]: Creating the MonitorState!
DEBUG ]: Creating the WorkspaceState!
DEBUG ]: Creating the ConfigManager!
DEBUG ]: [cfg] Config is either explicit or special.
DEBUG ]: [cfg] Config is NOT lua, loading regular mgr
DEBUG ]: Using config: /tmp/opencode/hypr-test.conf
DEBUG ]: !!!!HEY YOU, YES YOU!!!!: further logs to stdout / logfile are disabled by default. BEFORE SENDING THIS LOG, ENABLE THEM. Use debug:disable_logs = false to do so: https://wiki.hypr.land/Configuring/Basics/Variables/#debug
DEBUG ]: Creating the Error Overlay!
DEBUG ]: Creating the LayoutManager!
DEBUG ]: Creating the TokenManager!
DEBUG ]: Creating the EventManager!
DEBUG ]: Using config: /tmp/opencode/hypr-test.conf
DEBUG ]: Disabling stdout logs (debug.enable_stdout_logs = 0). Further logs will be written to /tmp/opencode/xdg/hypr/efb50993780079460b0cbed1363e2166a2de1d9f_1794283891_530563488/hyprland.log
DEBUG ]: Creating the PointerManager!
DEBUG ]: Creating the AsyncResourceGatherer!
terminate called after throwing an instance of 'std::runtime_error'
  what():  CBackend::create() failed!
Hyprland has crashed :( Consult the crash report at /tmp/.cache/hyprland/hyprlandCrashReport47.txt for more information.
timeout: the monitored command dumped core
```

**⏺ shell** `{"command": "ls -la /dev/dri 2>&1; grep -i \"backend\\|headless\\|fail\\|error\" /tmp/opencode/xdg/hypr/*/hyprland.log | head -20"}`

✓ 650 ms

```text
ls: cannot access '/dev/dri': No such file or directory
```

**⏺ shell** `{"command": "mkdir -p /tmp/opencode/qstest && cd /tmp/opencode/qstest && ln -sfn /usr/share/omarchy/shell/Commons Commons && ln -sfn /usr/share/omarchy/shell/Ui Ui && cat > shell.qml <<'EOF'\nimport Q`

✓ 11886 ms

```text
  INFO: Launching config: "/tmp/opencode/qstest/shell.qml"
  INFO: Shell ID: "23396922f93d7e0aa61ee03c051d72e4" Path ID "23396922f93d7e0aa61ee03c051d72e4"
  INFO: Saving logs to "/tmp/opencode/xdg/quickshell/by-id/qdgbq9ot/log.qslog"
 DEBUG qml: HELLO 1
  WARN: Signal QQmlEngine::quit() emitted, but no receivers connected to handle it.
  INFO: Configuration Loaded
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins; sed -n 1,40p panels/clock/BarWidget.qml; ls bar/widgets; grep -n \"settingsForm\\|ipcTarget\\|IpcHandler\" panels/power/Panel.qml | head"}`

✓ 933 ms

```text
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

  function refresh() {
    displayDate = new Date()
    if (panelLoader.item && panelLoader.item.refresh) panelLoader.item.refresh()
  }

  function cycleFormat() {
    var current = String(configuredFormat)
…
```

Now a test harness that loads the real plugin files and real first‑party widgets (clock, weather, power, system‑update) under an offscreen Quickshell.

**⏺ write** `/tmp/opencode/qstest/shell.qml`

```
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

ShellRoot {
  id: shellRoot

  readonly property string pluginDir: Quickshell.env("HOME") + "/.config/omarchy/plugins/parker.drawer"
  readonly property string fp: "/usr/share/omarchy/shell/plugins"

  property var widgetComponents: ({})
  property var service: null
  property var savedEntries: []
  property var drawerSettings: ({
    items: [
      "omarchy.clock",
      { id: "omarchy.weather" },
      "omarchy.power",
      "omarchy.audio",
      "parker.drawer",
      "omarchy.clock",
      "does.not.exist"
    ]
  })

  QtObject {
    id: registry
    property var widgets: ({})
    property int revision: 0
    function metadataFor(id) { var e = widgets[String(id)]; return e ? e.metadata : null }
    function availableIds() { return Object.keys(widgets) }
    function has(id) { return widgets[String(id)] !== undefined }
  }

  function loadWidget(id, path) {
    var comp = Qt.createComponent("file://" + path, Component.PreferSynchronous)
    if (comp.status !== Component.Ready) { console.log("TEST comp fail", id, comp.errorString()); return }
    var next = {}
    for (var k in registry.widgets) next[k] = registry.widgets[k]
    next[id] = { component: comp, metadata: { allowMultiple: false } }
    registry.widgets = next
    registry.revision++
  }

  QtObject {
    id: scopedShell
    property var bar: null
    property var barConfig: ({})
    function serviceFor(id) { return id === "parker.drawer" ? shellRoot.service : null }
    function firstPartyServiceFor(id) { return null }
    function summon(id, p) { console.log("TEST summon", id); return false }
    function hide(id) { return false }
    function toggle(id, p) { return false }
    function isPluginOpen(id) { return false }
    function updateEntryInline(id, settings) {
      console.log("TEST updateEntryInline", id, JSON.stringify(settings))
      shellRoot.savedEntries.push({ id: id, settings: settings })
      if (id === "parker.drawer") shellRoot.drawerSettings = settings
… (123 more lines in the repository)
```

✓ 21916 ms

```text
Wrote file successfully: /tmp/opencode/qstest/shell.qml
```

**⏺ shell** `{"command": "cd /tmp/opencode/qstest && XDG_RUNTIME_DIR=/tmp/opencode/xdg QT_QPA_PLATFORM=offscreen timeout 20 quickshell -p /tmp/opencode/qstest/shell.qml 2>&1 | grep -v \"^  INFO\" | head -80"}`

✓ 1031 ms

```text
 ERROR: Failed to load configuration
 ERROR:   caused by @shell.qml[86:3]: No PanelWindow backend loaded.
```

**⏺ shell** `{"command": "which Xvfb xvfb-run Xwayland 2>&1"}`

✓ 366 ms

```text
/usr/bin/Xvfb
/usr/bin/xvfb-run
/usr/bin/Xwayland
```

**⏺ shell** `{"command": "cd /tmp/opencode/qstest && XDG_RUNTIME_DIR=/tmp/opencode/xdg QT_QPA_PLATFORM=xcb timeout 40 xvfb-run -a quickshell -p /tmp/opencode/qstest/shell.qml 2>&1 | grep -v \"^  INFO\" | head -80"`

✓ 4358 ms

```text
/usr/bin/xvfb-run: line 173:   542 Aborted                    (core dumped) XAUTHORITY=$AUTHFILE Xvfb ":$SERVERNUM" $XVFBARGS $LISTENTCP >> "$ERRORFILE" 2>&1
  WARN qt.qpa.xcb: could not connect to display :99
  WARN qt.qpa.plugin: From 6.5.0, xcb-cursor0 or libxcb-cursor0 is needed to load the Qt xcb platform plugin.
 FATAL: This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.

Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vkkhrdisplay, vnc, wayland-brcm, wayland-egl, wayland, xcb.

  WARN: QEventLoop: Cannot be used without QCoreApplication
 ERROR: Quickshell has crashed under pid 547 (Coredumps will be available under that pid.)
 ERROR: Further crash information is stored under "/tmp/.cache/quickshell/crashes/5fvcq9ot"
 ERROR: Quickshell crashed within 10 seconds of launching. Not restarting to avoid a crash loop.
/usr/bin/xvfb-run: line 185: kill: (542) - No such process
  WARN qt.qpa.xcb: could not connect to display :99
  WARN qt.qpa.plugin: From 6.5.0, xcb-cursor0 or libxcb-cursor0 is needed to load the Qt xcb platform plugin.
 FATAL: This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.

Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vkkhrdisplay, vnc, wayland-brcm, wayland-egl, wayland, xcb.

```

**⏺ shell** `{"command": "(Xvfb :77 -screen 0 1920x1080x24 > /tmp/opencode/xvfb.log 2>&1 &) ; sleep 2; tail -5 /tmp/opencode/xvfb.log; ls /tmp/.X11-unix 2>&1"}`

✓ 2659 ms

```text
(EE) Segmentation fault at address 0x0
(EE) 
Fatal server error:
(EE) Caught signal 11 (Segmentation fault). Server aborting
(EE) 
```

**⏺ shell** `{"command": "head -30 /tmp/opencode/xvfb.log"}`

✓ 307 ms

```text
_XSERVTransmkdir: Owner of /tmp/.X11-unix should be set to root
(EE) 
(EE) Backtrace:
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 0: Xvfb (?+0x0) [0x648bb8aaabd5]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 1: /usr/lib/libc.so.6 (?+0x0) [0x77094fa3e6f0]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 2: /usr/lib/libnvidia-egl-gbm.so.1 (?+0x0) [0x77094e979653]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 3: /usr/lib/libEGL_nvidia.so.0 (?+0x0) [0x77094eb320f9]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 4: /usr/lib/libEGL_nvidia.so.0 (?+0x0) [0x77094ead330f]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 5: /usr/lib/libEGL.so.1 (?+0x0) [0x77094ebb825e]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 6: /usr/lib/dri/swrast_dri.so (?+0x0) [0x77094ec11363]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 7: Xvfb (?+0x0) [0x648bb8ab9e37]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 8: Xvfb (?+0x0) [0x648bb8ab6e46]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 9: Xvfb (?+0x0) [0x648bb89cc43c]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 10: Xvfb (?+0x0) [0x648bb8ae08bc]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 11: Xvfb (?+0x0) [0x648bb8974ea2]
(EE) unw_get_proc_name failed: no unwind info found [-10]
(EE) 12: /usr/lib/libc.so.6 (?+0x0) [0x77094fa27781]
(EE) 13: /usr/lib/libc.so.6 (__libc_start_main+0x89) [0x77094fa278b9]
```

Crash in the NVIDIA EGL loader (GLX init). Retry with GLX disabled and Mesa forced:

**⏺ shell** `{"command": "(__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json Xvfb :77 -screen 0 1920x1080x24 -extension GLX > /tmp/opencode/xvfb.log 2>&1 &) ; sleep 2; tail -3 /tmp/opencode`

✓ 3305 ms

```text
> Warning:          Could not resolve keysym XF86ContextualInsert
> Warning:          Could not resolve keysym XF86ContextualQuery
Errors from xkbcomp are not fatal to the X server
566 Xvfb :77 -screen 0 1920x1080x24 -extension GLX
```

**⏺ shell** `{"command": "cd /tmp/opencode/qstest && DISPLAY=:77 XDG_RUNTIME_DIR=/tmp/opencode/xdg QT_QPA_PLATFORM=xcb QT_QUICK_BACKEND=software __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa`

✓ 6066 ms

```text
  WARN scene: file://~/.config/omarchy/plugins/parker.drawer/Widget.qml[342:5]: Could not create attached properties object 'qs::wayland::layershell::WlrLayershell'
 DEBUG qml: TEST widget load error
 DEBUG qml: TEST EXCEPTION at step 2 TypeError: Cannot read property 'service' of null expression for onTriggered@qs:@/qs/shell.qml:135
 DEBUG qml: TEST EXCEPTION at step 3 TypeError: Cannot read property 'hostedSlots' of null dump@qs:@/qs/shell.qml:112
expression for onTriggered@qs:@/qs/shell.qml:141
 DEBUG qml: TEST EXCEPTION at step 4 TypeError: Cannot read property 'hostedSlots' of null dump@qs:@/qs/shell.qml:112
expression for onTriggered@qs:@/qs/shell.qml:144
 DEBUG qml: TEST EXCEPTION at step 5 TypeError: Cannot read property 'hostedSlots' of null dump@qs:@/qs/shell.qml:112
expression for onTriggered@qs:@/qs/shell.qml:151
 DEBUG qml: TEST EXCEPTION at step 6 TypeError: Cannot read property 'hostedItems' of null expression for onTriggered@qs:@/qs/shell.qml:156
 DEBUG qml: TEST EXCEPTION at step 7 TypeError: Cannot read property 'hostedItems' of null expression for onTriggered@qs:@/qs/shell.qml:160
 DEBUG qml: TEST EXCEPTION at step 8 TypeError: Cannot read property 'hostedItems' of null expression for onTriggered@qs:@/qs/shell.qml:164
 DEBUG qml: TEST EXCEPTION at step 9 TypeError: Cannot read property 'opened' of null expression for onTriggered@qs:@/qs/shell.qml:168
 DEBUG qml: TEST EXCEPTION at step 10 TypeError: Cannot read property 'hostedSlots' of null dump@qs:@/qs/shell.qml:112
expression for onTriggered@qs:@/qs/shell.qml:171
 DEBUG qml: TEST hosts after unload: 0
 DEBUG qml: TEST DONE
```

**⏺ shell** `{"command": "mkdir -p /tmp/opencode/drawercopy && cp ~/.config/omarchy/plugins/parker.drawer/*.qml /tmp/opencode/drawercopy/ && cd /tmp/opencode/drawercopy && python3 - <<'EOF'\nimport re\ns=open('Wid`

✓ 8372 ms

```text
 DEBUG qml: TEST service found: true hosts: 1 icon: 1
  WARN scene: @Ui/KeyboardPanel.qml[85:3]: Could not create attached properties object 'qs::wayland::layershell::WlrLayershell'
  WARN scene: @Ui/KeyboardPanel.qml[85:3]: Could not create attached properties object 'qs::wayland::layershell::WlrLayershell'
  WARN scene: @Ui/KeyboardPanel.qml[85:3]: Could not create attached properties object 'qs::wayland::layershell::WlrLayershell'
 DEBUG qml: TEST after registry open=false entries=[{"id":"omarchy.clock","index":0},{"id":"omarchy.weather","index":1},{"id":"omarchy.power","index":2},{"id":"does.not.exist","index":6}] slots=omarchy.clock[item 104x26],omarchy.weather[item 0x0],omarchy.power[none],does.not.exist[none]
 DEBUG qml: TEST bar.requestPopout
 DEBUG qml: TEST opened open=true entries=[{"id":"omarchy.clock","index":0},{"id":"omarchy.weather","index":1},{"id":"omarchy.power","index":2},{"id":"does.not.exist","index":6}] slots=omarchy.clock[item 104x26],omarchy.weather[item 0x0],omarchy.power[none],does.not.exist[none]
 DEBUG qml: TEST activePopout is drawer: true
 DEBUG qml: TEST clock bar is drawer facade: true text: Monday 21:12
 DEBUG qml: TEST updateEntryInline parker.drawer {"items":[{"id":"omarchy.clock","format":"dddd h:mm AP"},{"id":"omarchy.weather"},"omarchy.power","omarchy.audio","parker.drawer","omarchy.clock","does.not.exist"]}
 DEBUG qml: TEST after cycle open=true entries=[{"id":"omarchy.clock","index":0},{"id":"omarchy.weather","index":1},{"id":"omarchy.power","index":2},{"id":"does.not.exist","index":6}] slots=omarchy.clock[item 118x26],omarchy.weather[item 0x0],omarchy.power[none],does.not.exist[none]
 DEBUG qml: TEST clock settings now: {"format":"dddd h:mm AP"}
 DEBUG qml: TEST clock panel opened: false drawer open: true
 DEBUG qml: TEST bar.releasePopout
 DEBUG qml: TEST after close: drawer false clock panel false bar popout cleared: true
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
 DEBUG qml: TEST bar.requestPopout
 DEBUG qml: TEST ipc togglePanel: drawer true clock panel false
 DEBUG qml: TEST bar.releasePopout
 DEBUG qml: TEST ipc toggle closes: true
 DEBUG qml: TEST empty open=false entries=[] slots=
 DEBUG qml: TEST bar.releasePopout
 DEBUG qml: TEST hosts after unload: 0
 DEBUG qml: TEST DONE
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins/panels; grep -n \"function open\\|function close\\|property bool opened\\|readonly property bool opened\\|function openFromHotkey\\|function toggle\" c`

✓ 1204 ms

```text
clock/BarWidget.qml:62:  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false
clock/BarWidget.qml:64:  function open() {
clock/BarWidget.qml:68:  function close() {
clock/BarWidget.qml:72:  function togglePanel() {
clock/BarWidget.qml:76:  function toggleWeekStart() {
clock/BarWidget.qml:93:  function closeForPopoutSwitch() {
clock/BarWidget.qml:134:    function toggleWeekStart(): void { root.toggleWeekStart() }
clock/BarWidget.qml:135:    function open(): void { root.open() }
clock/BarWidget.qml:136:    function close(): void { root.close() }
clock/BarWidget.qml:139:    function toggle(): void { root.togglePanel() }
clock/Panel.qml:87:  function open() {
clock/Panel.qml:100:  function close() {
clock/Panel.qml:108:  function toggle() {
clock/Panel.qml:218:  function toggleWeekStart() {
power/Panel.qml:172:  function togglePercentage() {
power/Panel.qml:180:    function open() { root.open() }
power/Panel.qml:181:    function close() { root.close() }
power/Panel.qml:184:    function toggle() { root.toggle() }
power/Panel.qml:185:    function togglePercentage() { root.togglePercentage() }
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import qs.Commons
import qs.Ui
import "Model.js" as Model

Panel {
  id: root
  moduleName: "omarchy.power"
  ipcTarget: "omarchy.power"
  // manageIpc: false so this panel can own the single IpcHandler the target
  // permits — needed for the togglePercentage method below.
  manageIpc: false
  property var batteryInfo: ({})
  property var systemInfo: ({})
  property var profiles: []
  property string activeProfile: ""
  property int profileIndex: 0
  property bool cursorActive: false
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins/panels; sed -n 55,100p clock/BarWidget.qml; sed -n 80,110p clock/Panel.qml"}`

✓ 672 ms

```text
  function formatted(date) {
    return Qt.formatDateTime(date, activeFormat.replace(/ww/g, Model.isoWeekLiteral(date.getFullYear(), date.getMonth(), date.getDate())))
  }

  // ---- Calendar popup. Shape contract for shell.summon/hide/toggle
  //      routing: Bar.findPanelWidget requires open/close/opened on the
  //      bar-widget root.
  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item) panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item) panelLoader.item.close()
  }

  function togglePanel() {
    if (panelLoader.item) panelLoader.item.toggle()
  }

  function toggleWeekStart() {
    if (panelLoader.item) panelLoader.item.toggleWeekStart()
  }

  // The clock fills more slot than it paints a mark for, at both
  // orientations: horizontally it is a text label in a padded slot, so the
  // dot takes the label width; vertically it is a stack of icon-sized lines,
  // so the dot takes one line — the same mark every icon widget gets, rather
  // than a rule running the height of the whole stack.
  readonly property real openPanelIndicatorWidth: button.labelWidth
  readonly property real openPanelIndicatorHeight: Math.max(Style.space(10), Math.round(Style.bar.iconSlot * 0.55))

  // Forwarded so this widget can stand in for the panel as the bar's popout
  // identity: Bar.requestPopout prefers closeForPopoutSwitch over close, and
  // KeyboardPanel reads popoutSwitchClosing back off its owner.
  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false

  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
…
```

**⏺ shell** `{"command": "cd /tmp/opencode/qstest && python3 - <<'EOF'\ns=open('shell.qml').read()\ns=s.replace('''  function loadWidget(id, path) {''','''  Component {\n    id: testPanelComp\n    WidgetButton {\n`

✓ 13998 ms

```text
 DEBUG qml: TEST service found: true hosts: 1 icon: 1
  WARN scene: QML IpcHandler at file:///usr/share/omarchy/shell/plugins/panels/clock/BarWidget.qml[129:3]: Handler was registered but will not be used because another handler is registered for target omarchy.clock
  WARN scene: file:///tmp/opencode/drawercopy/Widget.qml[469:-1]: Error: Cannot assign [undefined] to QObject* (exception occurred during delayed function evaluation)
  WARN scene: file:///tmp/opencode/drawercopy/Widget.qml[469:-1]: Error: Cannot assign [undefined] to QObject* (exception occurred during delayed function evaluation)
 DEBUG qml: TEST after registry open=false entries=[{"id":"omarchy.clock","index":0},{"id":"omarchy.weather","index":1},{"id":"omarchy.power","index":2},{"id":"does.not.exist","index":6},{"id":"test.a","index":7},{"id":"test.b","index":8}] slots=omarchy.clock[item 104x26],omarchy.weather[item 0x0],omarchy.power[none],does.not.exist[none],test.a[item 24x26],test.b[item 24x26]
 DEBUG qml: TEST bar.requestPopout
 DEBUG qml: TEST opened open=true entries=[{"id":"omarchy.clock","index":0},{"id":"omarchy.weather","index":1},{"id":"omarchy.power","index":2},{"id":"does.not.exist","index":6},{"id":"test.a","index":7},{"id":"test.b","index":8}] slots=omarchy.clock[item 104x26],omarchy.weather[item 0x0],omarchy.power[none],does.not.exist[none],test.a[item 24x26],test.b[item 24x26]
 DEBUG qml: TEST activePopout is drawer: true
 DEBUG qml: TEST clock bar is drawer facade: true text: Monday 21:13
 DEBUG qml: TEST updateEntryInline parker.drawer {"items":[{"id":"omarchy.clock","format":"dddd h:mm AP"},{"id":"omarchy.weather"},"omarchy.power","omarchy.audio","parker.drawer","omarchy.clock","does.not.exist","test.a","test.b"]}
 DEBUG qml: TEST after cycle open=true entries=[{"id":"omarchy.clock","index":0},{"id":"omarchy.weather","index":1},{"id":"omarchy.power","index":2},{"id":"does.not.exist","index":6},{"id":"test.a","index":7},{"id":"test.b","index":8}] slots=omarchy.clock[item 118x26],omarchy.weather[item 0x0],omarchy.power[none],does.not.exist[none],test.a[item 24x26],test.b[item 24x26]
 DEBUG qml: TEST clock settings now: {"format":"dddd h:mm AP"}
 DEBUG qml: TEST a open, facade active is a: true
 DEBUG qml: TEST b open, a closed: true active is b: true clickTargets: 4
 DEBUG qml: TEST switchPanelFrom b->next opens a: true false false
 DEBUG qml: TEST window h: 69 implicitH 69 screen screen
 DEBUG qml: TEST card geom: 1736 31 179 38
 DEBUG qml: TEST bar.releasePopout
 DEBUG qml: TEST close closes hosted popup: true facade active null: true
 DEBUG qml: TEST bar.requestPopout
 DEBUG qml: TEST toggleHostedPanel test.b: drawer true b true
 DEBUG qml: TEST bar.releasePopout
 DEBUG qml: TEST toggleHostedPanel again closes drawer: true true
 DEBUG qml: TEST clock panel opened: false drawer open: false
 DEBUG qml: TEST after close: drawer false clock panel false bar popout cleared: true
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
 DEBUG qml: TEST bar.requestPopout
 DEBUG qml: TEST ipc togglePanel: drawer true clock panel false
 DEBUG qml: TEST bar.releasePopout
 DEBUG qml: TEST ipc toggle closes: true
 DEBUG qml: TEST empty open=false entries=[] slots=
 DEBUG qml: TEST bar.releasePopout
 DEBUG qml: TEST hosts after unload: 0
 DEBUG qml: TEST DONE
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/Widget.qml`

```
              function injectProps() {
                var target = activeItem
                // A deferred call can land after the Repeater rebuilt this slot.
                var api = typeof drawerBar === "undefined" ? null : drawerBar
                if (!target || !api) return
                if ("bar" in target) target.bar = api
```

✓ 1970 ms

```text
Edited .config/omarchy/plugins/parker.drawer/Widget.qml (1 replacement)
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/Widget.qml`

```
              Component.onCompleted: root.registerSlot(slot)
              Component.onDestruction: root.unregisterSlot(slot)

              Timer {
                interval: 5000
                running: true
                onTriggered: {
                  if (!slot.registryComponent)
                    console.warn("parker.drawer: no enabled bar widget named '" + slot.moduleName + "'; check the id in shell.json")
                }
              }
```

✓ 2143 ms

```text
Edited .config/omarchy/plugins/parker.drawer/Widget.qml (1 replacement)
```

**⏺ shell** `{"command": "cd /tmp/opencode/drawercopy && cp ~/.config/omarchy/plugins/parker.drawer/*.qml . && python3 - <<'EOF'\nimport re\ns=open('Widget.qml').read()\ns=re.sub(r'\\n\\s*WlrLayershell\\.keyboardF`

✓ 7188 ms

```text
  WARN scene: QML IpcHandler at file:///usr/share/omarchy/shell/plugins/panels/clock/BarWidget.qml[129:3]: Handler was registered but will not be used because another handler is registered for target omarchy.clock
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
```

**⏺ shell** `{"command": "cd /usr/lib/qt6/qml/Quickshell; grep -rn -A8 'name: \"ExclusionMode\"' . | head -20; grep -rn -B2 -A30 'name: \"qs::Region\"\\|exports: \\[\"Quickshell/Region' . | grep -E \"Property|name`

✓ 1322 ms

```text
./_Window/quickshell-window.qmltypes:25:        name: "ExclusionMode"
./_Window/quickshell-window.qmltypes-26-        accessSemantics: "none"
./_Window/quickshell-window.qmltypes-27-        exports: ["Quickshell._Window/ExclusionMode 0.0"]
./_Window/quickshell-window.qmltypes-28-        isCreatable: false
./_Window/quickshell-window.qmltypes-29-        exportMetaObjectRevisions: [0]
./_Window/quickshell-window.qmltypes-30-        Enum {
./_Window/quickshell-window.qmltypes-31-            name: "Enum"
./_Window/quickshell-window.qmltypes-32-            type: "quint8"
./_Window/quickshell-window.qmltypes-33-            lineNumber: 61
./quickshell-core.qmltypes-644-        defaultProperty: "regions"
./quickshell-core.qmltypes-648-        Property {
./quickshell-core.qmltypes-649-            name: "shape"
./quickshell-core.qmltypes-655-        Property {
./quickshell-core.qmltypes-656-            name: "intersection"
./quickshell-core.qmltypes-662-        Property {
./quickshell-core.qmltypes-663-            name: "item"
./quickshell-core.qmltypes-671-        Property { name: "x"; type: "int"; notify: "xChanged"; index: 3; lineNumber: 62 }
./quickshell-core.qmltypes-672-        Property { name: "y"; type: "int"; notify: "yChanged"; index: 4; lineNumber: 64 }
./quickshell-core.qmltypes-673-        Property { name: "width"; type: "int"; notify: "widthChanged"; index: 5; lineNumber: 66 }
./quickshell-core.qmltypes-674-        Property { name: "height"; type: "int"; notify: "heightChanged"; index: 6; lineNumber: 68 }
./quickshell-core.qmltypes-675-        Property {
./quickshell-core.qmltypes-676-            name: "radius"
./quickshell-core.qmltypes-1314-        name: "RegionShape"
./quickshell-core.qmltypes-1320-            name: "Enum"
./quickshell-core.qmltypes-1329-        name: "ReloadPropagator"
./quickshell-core.qmltypes-1331-        defaultProperty: "children"
./quickshell-core.qmltypes-1335-        Property {
./quickshell-core.qmltypes-1336-            name: "children"
```

**⏺ shell** `{"command": "cd /usr/lib/qt6/qml/Quickshell; sed -n 30,45p _Window/quickshell-window.qmltypes; grep -rn \"mask: Region\\|Region {\" /usr/share/omarchy/shell --include=*.qml | head"}`

✓ 906 ms

```text
        Enum {
            name: "Enum"
            type: "quint8"
            lineNumber: 61
            values: ["Normal", "Ignore", "Auto"]
        }
    }
    Component {
        file: "floatingwindow.hpp"
        lineNumber: 86
        name: "FloatingWindowInterface"
        accessSemantics: "reference"
        defaultProperty: "data"
        prototype: "WindowInterface"
        exports: ["Quickshell._Window/FloatingWindow 0.0"]
        exportMetaObjectRevisions: [0]
/usr/share/omarchy/shell/Ui/KeyboardPanel.qml:124:  mask: Region {
/usr/share/omarchy/shell/plugins/bar/Bar.qml:1425:    mask: Region {}
/usr/share/omarchy/shell/plugins/bar/Bar.qml:1487:    mask: Region {}
/usr/share/omarchy/shell/plugins/notifications/Service.qml:978:      mask: Region { item: popupColumn }
/usr/share/omarchy/shell/plugins/osd/Osd.qml:137:    mask: Region {}
```

**⏺ shell** `{"command": "cd ~/.config/omarchy && cp shell.json shell.json.bak.$(date +%s) && ls shell.json*"}`

✓ 478 ms

```text
shell.json
shell.json.bak.1794284063
```

**⏺ edit** `~/.config/omarchy/shell.json`

```
        {
          "id": "omarchy.system-update"
        }
      ],
      "right": [
        {
          "id": "omarchy.tray"
        },
        {
          "id": "parker.drawer",
          "items": [
            "omarchy.weather",
            "omarchy.keyboard-layout",
            "omarchy.agents"
          ]
        },
        {
```

✓ 2308 ms

```text
Edited .config/omarchy/shell.json (1 replacement)
```

**⏺ shell** `{"command": "cd ~/.config/omarchy && jq -c '.bar.layout' shell.json && omarchy-plugin-validate plugins/parker.drawer && echo VALID"}`

✓ 733 ms

```text
{"left":[{"id":"omarchy.menu"},{"id":"omarchy.workspaces"}],"center":[{"id":"omarchy.indicators"},{"id":"omarchy.clock","format":"dddd HH:mm","formatAlt":"d MMMM 'W'ww yyyy","verticalFormat":"HH\n—\nmm"},{"id":"omarchy.system-update"}],"right":[{"id":"omarchy.tray"},{"id":"parker.drawer","items":["omarchy.weather","omarchy.keyboard-layout","omarchy.agents"]},{"id":"omarchy.bluetooth"},{"id":"omarchy.network"},{"id":"omarchy.audio"},{"id":"omarchy.monitor"},{"id":"omarchy.power"}]}
VALID
```

**⏺ shell** `{"command": "cd /tmp/opencode/qstest && sed -e 's#shellRoot.loadWidget(\"omarchy.clock\", shellRoot.fp + \"/panels/clock/BarWidget.qml\")#shellRoot.loadWidget(\"omarchy.keyboard-layout\", shellRoot.fp`

✓ 9131 ms

```text
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
 DEBUG qml: TEST comp fail omarchy.power <Unknown File>: No such file or directory
  WARN scene: QML IpcHandler at file:///usr/share/omarchy/shell/plugins/panels/clock/BarWidget.qml[129:3]: Handler was registered but will not be used because another handler is registered for target omarchy.clock
 DEBUG qml: TEST after registry open=false entries=[{"id":"omarchy.clock","index":0},{"id":"omarchy.weather","index":1},{"id":"omarchy.power","index":2},{"id":"omarchy.keyboard-layout","index":3},{"id":"omarchy.agents","index":4},{"id":"does.not.exist","index":8},{"id":"test.a","index":9},{"id":"test.b","index":10}] slots=omarchy.clock[item 104x26],omarchy.weather[item 0x0],omarchy.power[none],omarchy.keyboard-layout[item 0x0],omarchy.agents[none],does.not.exist[none],test.a[item 24x26],test.b[item 24x26]
```

**⏺ shell** `{"command": "pkill -f \"Xvfb :77\"; echo done"}`

✓ 364 ms

```text
(no output)
```

**⏺ write** `~/.config/omarchy/plugins/parker.drawer/README.md`

```
# Drawer

A bar button that opens a drawer holding the bar widgets you tucked away.

## Choosing what goes in the drawer

Add the drawer to the bar in `~/.config/omarchy/shell.json` and list the
widgets it should hold under `items`. Take those widgets out of the bar
layout itself; a widget that is still on the bar stays on the bar.

```json
{
  "id": "parker.drawer",
  "items": [
    "omarchy.weather",
    { "id": "omarchy.clock", "format": "HH:mm" },
    "omarchy.agents"
  ]
}
```

- Items use the same ids as the bar (`omarchy plugin list`). An item can be a
  plain id or an object with the same inline settings the widget takes on the
  bar.
- Widgets appear in the drawer in the order listed. Settings a widget saves
  itself (cycling the clock format, for example) are written back into
  `items`.
- `icon` (optional) replaces the default chevron with any glyph.
- `shell.json` hot-reloads, so edits apply on save.

## Using it

- Click the button (or `omarchy-shell shell toggle parker.drawer`) to open or
  close the drawer. Press Escape or click anywhere else to close it.
- Hosted widgets work as they do on the bar, including their popups and
  tooltips. They stay mounted while the drawer is closed.
- Panel hotkeys such as `omarchy-shell shell toggle omarchy.bluetooth` only
  reach widgets on the bar. To open a drawer widget's panel from a key, bind
  `omarchy-shell parker.drawer togglePanel omarchy.bluetooth` instead.

## Limits

- Widgets that need a shell service only the built-in bar grants
  (`omarchy.media` and the Do Not Disturb, Night Light, and Stay Awake
  indicators) cannot work from the drawer.
- Custom `"type": "command"` and `"type": "qml"` bar modules are not supported
  in the drawer.
- A third-party widget is only loaded while it is enabled. If it lives only in
  the drawer, also list `{ "id": "<its id>" }` under the top-level `plugins`
  array so it stays enabled.
```

✓ 7206 ms

```text
Created file successfully: .config/omarchy/plugins/parker.drawer/README.md
```

I've built the drawer plugin and added it to your top bar. It hasn't been run inside your live shell yet. My test setup had no compositor, so I tested the plugin's logic using your real first-party widgets on a stand-in bar. That covered opening and closing, one popup at a time, settings being saved, and the hotkey command. The panels inside the drawer and exactly where the drawer lands on screen still need checking on your desktop. The shell picks up the changes when they're saved, and `omarchy-shell shell rescanPlugins` forces a reload if it doesn't.

**What it does**
- A chevron button sits in the right section of the bar, next to the tray. Clicking it opens a card just below the bar holding the widgets you've tucked away.
- Those widgets work the same as on the bar, including their popups and tooltips. They keep running while the drawer is closed.
- Escape, a click anywhere else, or opening another bar panel closes the drawer.
- `omarchy-shell shell toggle parker.drawer` opens it from a key.

**Choosing what goes in the drawer** (`~/.config/omarchy/shell.json`):
```json
{ "id": "parker.drawer", "items": ["omarchy.weather", "omarchy.keyboard-layout", "omarchy.agents"] }
```
I moved weather, keyboard-layout and agents in as a starting point. Edit the list however you like:
- Use the same ids as on the bar. An item can also be an object with its usual settings, e.g. `{ "id": "omarchy.clock", "format": "HH:mm" }`.
- Take a widget off the bar when you add it here. If it's still on the bar, the drawer skips it so you don't get two copies.
- An optional `"icon"` replaces the chevron.
- Settings a widget saves itself, like the clock format, are written back into `items`.

**Things to know**
- **Panel hotkeys:** keys like `SUPER+CTRL+B` (Bluetooth) and `SUPER+CTRL+D` (Display) only reach widgets on the bar. That's why I left Bluetooth and Monitor out of the starting list. If you move them in, rebind those keys to `omarchy-shell parker.drawer togglePanel omarchy.bluetooth` (or `omarchy.monitor`).
- **Some widgets can't go in the drawer.** Media, and the Do Not Disturb, Night Light and Stay Awake indicators, need access that only the built-in bar gives. Custom command and QML modules aren't supported either.
- **System updates:** I left the update indicator on the bar so you'll still see when updates are available.

The plugin is in `~/.config/omarchy/plugins/parker.drawer/`, with a short `README.md` covering the options above. Your previous config is saved as `~/.config/omarchy/shell.json.bak.1794284063`.

---

### › You

```text
It's not working yet: it doesn't load in the shell. The shell says:

plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
  barWidget: Widget.qml: errors; drew no text
    picture: ~/.h0-preview/parker.drawer-barWidget.png
    WARN scene: file://~/.config/omarchy/plugins/parker.drawer/Widget.qml[334:3]: No PanelWindow backend loaded.
    WARN qml: PREVIEW_LOAD_ERROR file://~/.config/omarchy/plugins/parker.drawer/Widget.qml
  service: Service.qml: loaded; drew no text
PREVIEW: FAILED
```

**⏺ shell** `{"command": "cd ~; ls -la .h0-preview 2>&1; ls .h0-preview | head; grep -rl \"PREVIEW_LOAD_ERROR\" .h0-preview .h0-api 2>/dev/null | head"}`

✓ 825 ms

```text
total 4
drwxr-xr-x 1 parker parker  54 Nov  9 21:15 .
drwxr-xr-x 1 parker parker 116 Nov  9 21:15 ..
-rw-r--r-- 1 parker parker 222 Nov  9 21:15 parker.drawer-barWidget.png
parker.drawer-barWidget.png
```

**⏺ read** `~/.config/omarchy/plugins/parker.drawer/Widget.qml`

✓ 867 ms

```text
Read file ~/.config/omarchy/plugins/parker.drawer/Widget.qml, lines 1-75
1: import QtQuick
2: import Quickshell
3: import Quickshell.Wayland
4: import qs.Commons
5: import qs.Ui
6: 
7: // Drawer button for the bar. Clicking it opens a card next to the bar that
8: // hosts the widgets listed in this entry's `items` setting in shell.json:
9: //
10: //   { "id": "parker.drawer", "items": ["omarchy.weather", { "id": "omarchy.clock", "format": "HH:mm" }] }
11: //
12: // Hosted widgets stay mounted while the drawer is closed, so their state,
13: // timers, and IPC targets keep working exactly as they did on the bar.
14: BarWidget {
15:   id: root
16: 
17:   // Bar-shaped popup contract: lets `omarchy-shell shell toggle parker.drawer`
18:   // and the numbered panel hotkeys open the drawer, and lets the bar's
19:   // one-popup-at-a-time coordinator close it when another panel opens.
20:   readonly property bool opened: drawerOpen
21:   property bool drawerOpen: false
22: 
23:   property QtObject service: null
24:   readonly property var registry: service ? service.barWidgetRegistry : null
25: 
26:   readonly property var barWindow: root.QsWindow.window
27:   readonly property string screenName: barWindow && barWindow.screen ? String(barWindow.screen.name || "") : ""
28:   readonly property string position: bar ? String(bar.position || "top") : "top"
29:   readonly property real barThickness: barWindow
30:     ? (vertical ? barWindow.width : barWindow.height)
31:     : barSize
32:   readonly property int gap: Style.gapsOut
33:   readonly property int margin: Style.gapsOut
34: 
35:   readonly property var configuredItems: Array.isArray(settings.items) ? settings.items : []
36: 
37:   // Only the identity of the hosted list drives the Repeater: settings edits
38:   // (a clock format cycling, say) patch the live widgets instead of rebuilding
39:   // them, because an unchanged string property does not notify.
…
```

I'll do the split with a script: everything from the `PanelWindow` onward moves to `Drawer.qml`, with references rewritten to `host`/`api`.

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.drawer && grep -n \"^  // ----------------------------------------------------------------- drawer\\|^  PanelWindow {\\|^  Variants {\\|^}\" Widget.qml`

✓ 756 ms

```text
332:  // ----------------------------------------------------------------- drawer
334:  PanelWindow {
607:  Variants {
637:}
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.drawer && python3 - <<'EOF'\nimport re\nlines = open('Widget.qml').read().split('\\n')\n# lines index: line N is lines[N-1]\nhead = lines[:331]        `

✓ 4838 ms

```text
15:  required property var api
20:      if (drawer.host.drawerOpen)
21:        Qt.callLater(function() { if (drawer.host.drawerOpen) keyCatcher.forceActiveFocus() })
26:    if (host.drawerOpen) Qt.callLater(function() { keyCatcher.forceActiveFocus() })
32:    screen: host.barWindow ? host.barWindow.screen : null
      if (mouseButton === Qt.LeftButton || mouseButton === Qt.MiddleButton) root.toggle()
    }
  }

}
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.drawer && grep -n \"\\broot\\b\\|drawerBar\" Drawer.qml"}`

✓ 599 ms

```text
65:      b: root
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.drawer && sed -i '65s/b: root/b: drawer.host/' Drawer.qml && sed -n 60,72p Drawer.qml && grep -n \"host.mapToItem\\|host.width\" Drawer.qml"}`

✓ 858 ms

```text
    readonly property real spanH: screen ? screen.height : height

    TransformWatcher {
      id: anchorWatcher
      a: host.barWindow ? host.barWindow.contentItem : null
      b: drawer.host
    }

    readonly property point anchorCenter: {
      anchorWatcher.transform
      if (!host.barWindow || !host.barWindow.contentItem) return Qt.point(spanW / 2, spanH / 2)
      return host.mapToItem(host.barWindow.contentItem, host.width / 2, host.height / 2)
    }
71:      return host.mapToItem(host.barWindow.contentItem, host.width / 2, host.height / 2)
```

Now update `Widget.qml`: add the lazy loader, drop the inline-window imports, and make the hotkey bridge work even before the drawer has been mounted.

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/Widget.qml`

```
import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// Drawer button for the bar. Clicking it opens a card next to the bar that
// hosts the widgets listed in this entry's `items` setting in shell.json:
//
//   { "id": "parker.drawer", "items": ["omarchy.weather", { "id": "omarchy.clock", "format": "HH:mm" }] }
//
// The drawer surfaces (Drawer.qml) load the first time the drawer opens, so
// the button itself never creates a window. From then on hosted widgets stay
// mounted while the drawer is closed, keeping their state and timers.
BarWidget {
```

✓ 3715 ms

```text
Edited .config/omarchy/plugins/parker.drawer/Widget.qml (1 replacement)
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/Widget.qml`

```
  function open() {
    if (drawerOpen) return
    mountDrawer()
    drawerOpen = true
```

✓ 1241 ms

```text
Edited .config/omarchy/plugins/parker.drawer/Widget.qml (1 replacement)
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.drawer && grep -n \"openAfterShow\\|focusPrime\\|onDrawerOpenChanged\" -A0 Widget.qml; sed -n 76,90p Widget.qml; grep -n \"function toggleHostedPanel\"`

✓ 1035 ms

```text
44:  property var openAfterShow: null
--
49:  property bool focusPrimed: false
--
67:    openAfterShow = null
--
76:  onDrawerOpenChanged: {
77:    focusPrimeTimer.stop()
78:    focusPrimed = false
--
80:      focusPrimeTimer.start()
--
225:    openAfterShow = item
226:    openAfterShowTimer.restart()
--
230:    id: openAfterShowTimer
--
233:      var item = root.openAfterShow
234:      root.openAfterShow = null
--
299:    id: focusPrimeTimer
--
301:    onTriggered: if (root.drawerOpen) root.focusPrimed = true
  onDrawerOpenChanged: {
    focusPrimeTimer.stop()
    focusPrimed = false
    if (drawerOpen) {
      focusPrimeTimer.start()
      Qt.callLater(function() { if (root.drawerOpen) keyCatcher.forceActiveFocus() })
    }
  }

  // ------------------------------------------------------- service lookup

  function lookupService() {
    if (service || !bar || !bar.shell || typeof bar.shell.serviceFor !== "function") return
    var found = bar.shell.serviceFor(root.moduleName)
    if (!found) return
206:  function toggleHostedPanel(id) {
207-    var key = Util.canonicalWidgetId(String(id || ""))
…
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.drawer && python3 - <<'EOF'\ns = open('Widget.qml').read()\ns = s.replace('''      focusPrimeTimer.start()\n      Qt.callLater(function() { if (root.dr`

✓ 6817 ms

```text

    onPressed: function(mouseButton) {
      if (mouseButton === Qt.LeftButton || mouseButton === Qt.MiddleButton) root.toggle()
    }
  }

  // ----------------------------------------------------------------- drawer

  function mountDrawer() {
    if (drawerLoader.status !== Loader.Null) return
    drawerLoader.setSource(Qt.resolvedUrl("Drawer.qml"), { host: root, api: drawerBar })
  }

  Loader {
    id: drawerLoader
    onStatusChanged: {
      if (status === Loader.Error) console.warn("parker.drawer: drawer surfaces failed to load")
    }
  }
}
```

Now I'll reproduce the preview's conditions: an offscreen Quickshell with no window backend, loading just `Widget.qml`.

**⏺ shell** `{"command": "mkdir -p /tmp/opencode/preview && cd /tmp/opencode/preview && ln -sfn /usr/share/omarchy/shell/Commons Commons && ln -sfn /usr/share/omarchy/shell/Ui Ui && cat > shell.qml <<'EOF'\nimport`

✓ 5218 ms

```text
 DEBUG qml: RESULT status ready size 27x26
```

The widget now loads cleanly with no backend: no warnings, and the button renders at 27×26. Next I'll rerun the full behaviour test on the X11 harness.

**⏺ shell** `{"command": "(__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json Xvfb :77 -screen 0 1920x1080x24 -extension GLX > /tmp/opencode/xvfb.log 2>&1 &); sleep 2\nrm -f /tmp/opencode/dr`

✓ 5656 ms

```text
cp: target '/tmp/opencode/drawercopy/': No such file or directory
/usr/bin/bash: line 7: cd: /tmp/opencode/qstest: No such file or directory
```

The scratch test files from earlier are gone, so I'll recreate the harness.

**⏺ shell** `{"command": "mkdir -p /tmp/opencode/qstest /tmp/opencode/drawercopy /tmp/opencode/xdg && chmod 700 /tmp/opencode/xdg && cd /tmp/opencode/qstest && ln -sfn /usr/share/omarchy/shell/Commons Commons && l`

✓ 2554 ms

```text
0
```

**⏺ write** `/tmp/opencode/qstest/shell.qml`

```
import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

ShellRoot {
  id: shellRoot

  readonly property string pluginDir: "/tmp/opencode/drawercopy"
  readonly property string fp: "/usr/share/omarchy/shell/plugins"
  property var service: null
  property var activePopout: null
  property var drawerSettings: ({ items: ["omarchy.clock", "omarchy.keyboard-layout", "omarchy.audio", "parker.drawer", "omarchy.clock", "test.a", "test.b"] })

  QtObject {
    id: registry
    property var widgets: ({})
    property int revision: 0
    function metadataFor(id) { var e = widgets[String(id)]; return e ? e.metadata : null }
  }

  Component {
    id: testPanelComp
    WidgetButton {
      id: tp
      property bool opened: false
      text: "T"
      function open() { opened = true; if (bar) bar.requestPopout(tp) }
      function close() { opened = false; if (bar) bar.releasePopout(tp) }
    }
  }

  function register(id, comp) {
    var next = {}
    for (var k in registry.widgets) next[k] = registry.widgets[k]
    next[id] = { component: comp, metadata: { allowMultiple: false } }
    registry.widgets = next
  }

  function loadWidget(id, path) {
    var comp = Qt.createComponent("file://" + path, Component.PreferSynchronous)
    if (comp.status !== Component.Ready) { console.log("TEST comp fail", id, comp.errorString()); return }
    register(id, comp)
  }

  QtObject {
    id: scopedShell
    function serviceFor(id) { return id === "parker.drawer" ? shellRoot.service : null }
    function firstPartyServiceFor(id) { return null }
    function updateEntryInline(id, settings) {
      console.log("TEST updateEntryInline", id, JSON.stringify(settings))
      if (id === "parker.drawer") shellRoot.drawerSettings = settings
      return true
    }
  }

  PluginBarApi {
    id: pluginBar
    pluginId: "parker.drawer"
    moduleName: "parker.drawer"
… (82 more lines in the repository)
```

✓ 15702 ms

```text
Created file successfully: /tmp/opencode/qstest/shell.qml
```

**⏺ shell** `{"command": "(__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json Xvfb :77 -screen 0 1920x1080x24 -extension GLX > /tmp/opencode/xvfb.log 2>&1 &); sleep 2; cd /tmp/opencode/qstes`

✓ 6542 ms

```text
 DEBUG qml: TEST service found: true slots before open: 0
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
 DEBUG qml: TEST opened: true bar popout is drawer: true slots: omarchy.clock(104x26),omarchy.keyboard-layout(0x0),test.a(24x26),test.b(24x26)
 DEBUG qml: TEST one hosted popup at a time: false
 DEBUG qml: TEST drawer window h: 69 card: 1750 31 165 38
 DEBUG qml: TEST close: drawer false hosted popup closed: false bar popout cleared: true
 DEBUG qml: TEST still mounted after close: 4
 DEBUG qml: TEST ipc togglePanel: drawer true b true
 DEBUG qml: TEST ipc toggle closes: true
 DEBUG qml: TEST hosts after unload: 0
 DEBUG qml: TEST DONE
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.drawer && grep -n \"typeof api\" -B2 -A4 Drawer.qml"}`

✓ 564 ms

```text
168-                var target = activeItem
169-                // A deferred call can land after the Repeater rebuilt this slot.
170:                var api = typeof api === "undefined" ? null : api
171-                if (!target || !api) return
172-                if ("bar" in target) target.bar = api
173-                if ("moduleName" in target) target.moduleName = moduleName
174-                if ("settings" in target) target.settings = itemSettings
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/Drawer.qml`

```
                var surface = typeof drawer === "undefined" || !drawer ? null : drawer.api
                if (!target || !surface) return
                if ("bar" in target) target.bar = surface
```

✓ 1646 ms

```text
Edited .config/omarchy/plugins/parker.drawer/Drawer.qml (1 replacement)
```

**⏺ shell** `{"command": "cp ~/.config/omarchy/plugins/parker.drawer/*.qml /tmp/opencode/drawercopy/ && cd /tmp/opencode/drawercopy && python3 -c \"\nimport re\ns=open('Drawer.qml').read()\ns=re.sub(r'\\n\\s*WlrLa`

✓ 8572 ms

```text
 DEBUG qml: TEST service found: true slots before open: 0
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
 DEBUG qml: TEST opened: true bar popout is drawer: true slots: omarchy.clock(104x26),omarchy.keyboard-layout(0x0),test.a(24x26),test.b(24x26)
 DEBUG qml: TEST one hosted popup at a time: true
 DEBUG qml: TEST drawer window h: 69 card: 1750 31 165 38
 DEBUG qml: TEST updateEntryInline parker.drawer {"items":[{"id":"omarchy.clock","format":"dddd h:mm AP"},"omarchy.keyboard-layout","omarchy.audio","parker.drawer","omarchy.clock","test.a","test.b"]}
 DEBUG qml: TEST close: drawer false hosted popup closed: true bar popout cleared: true
 DEBUG qml: TEST still mounted after close: 4
 DEBUG qml: TEST ipc togglePanel: drawer true b true
 DEBUG qml: TEST ipc toggle closes: true
 DEBUG qml: TEST hosts after unload: 0
 DEBUG qml: TEST DONE
```

All behaviour checks pass now. The `pkill` also killed that command chain, so I'll rerun the preview check and the validator on their own:

**⏺ shell** `{"command": "cd /tmp/opencode/preview && XDG_RUNTIME_DIR=/tmp/opencode/xdg QT_QPA_PLATFORM=offscreen timeout 15 quickshell -p /tmp/opencode/preview/shell.qml 2>&1 | grep -v \"^  INFO\"; omarchy-plugin`

✓ 2366 ms

```text
 DEBUG qml: RESULT status ready size 27x26
VALID
Drawer.qml
DrawerBar.qml
README.md
Service.qml
Widget.qml
manifest.json
```

**⏺ edit** `~/.config/omarchy/plugins/parker.drawer/README.md`

```
- Hosted widgets work as they do on the bar, including their popups and
  tooltips. They load the first time the drawer opens and then stay mounted
  while it is closed.
```

✓ 1490 ms

```text
Edited .config/omarchy/plugins/parker.drawer/README.md (1 replacement)
```

I fixed the load error, so the drawer button now loads without needing a window backend. It still hasn't been run inside your live shell.

**What was wrong:** the drawer's windows were built directly into `Widget.qml`, the button's own file. The preview has no way to create windows, so that one failure stopped the whole widget from loading, button included.

**The fix:** the windows now live in a separate file, `Drawer.qml`, which only loads the first time you open the drawer. The button itself never creates a window, so it loads anywhere.

**One change in behaviour:** the tucked-away widgets now start up the first time you open the drawer, not when the shell starts. After that they keep running while it's closed, as before. The same applies to the hotkey bridge (`omarchy-shell parker.drawer togglePanel <id>`): it opens the drawer first, then the panel.

While retesting I also found and fixed a bug from the split. Widgets inside the drawer weren't being connected to it, so only one popup at a time wasn't enforced and the clock couldn't save its format.

**Tests:**
- **Preview conditions:** loading `Widget.qml` alone with no window backend now gives no warnings, and the button draws at 27×26.
- **Behaviour:** I ran the plugin on a stand-in bar on a virtual screen (no Wayland), with the real clock and keyboard-layout widgets. Opening and closing, one popup at a time, the clock saving its format into `items`, widgets staying loaded after closing, the hotkey commands and cleanup all work.
- **Not covered:** the Wayland-specific parts (exact drawer placement and keyboard focus) can only be checked on your desktop. The Wayland-only lines were removed for these tests. Panels that open from widgets inside the drawer, like the clock's calendar, also didn't open there.

The plugin still passes `omarchy plugin validate`. To reload it, run `omarchy-shell shell rescanPlugins`.

