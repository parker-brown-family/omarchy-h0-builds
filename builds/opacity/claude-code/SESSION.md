# Claude Code building Window Opacity

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools claude-code

---

### › You

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

**⏺ Skill** `{"skill": "omarchy"}`

✓  ms

```text
Launching skill: omarchy
```

**⏺ bash** `cat ~/.claude/skills/omarchy/plugins.md; echo ----; cat ~/.claude/skills/omarchy/hyprland.md | head -150`

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

**⏺ bash** `echo HOME=$HOME; pwd; ls -la; ls -la .config .config/omarchy .config/hypr 2>&1; echo $OMARCHY_PATH; which omarchy omarchy-shell hyprctl`

✓  ms

```text
HOME=~
~
total 4
drwxr-xr-x 1 parker parker 106 Nov  9 16:46 .
drwx------ 3 parker parker  60 Nov  9 16:46 ..
drwxr-xr-x 1 parker parker  12 Nov  9 16:46 .agents
drwxr-xr-x 1 parker parker 136 Nov  9 16:46 .claude
-rw------- 1 parker parker 822 Nov  9 16:46 .claude.json
drwxr-xr-x 1 parker parker  12 Nov  9 16:46 .codex
drwxr-xr-x 1 parker parker  72 Nov  8 22:07 .config
drwxr-xr-x 1 parker parker 160 Nov  9 16:46 .git
drwxr-xr-x 1 parker parker 100 Nov  9 16:46 .h0-api
drwxr-xr-x 1 parker parker  10 Nov  9 16:46 .pi
.config:
total 0
drwxr-xr-x 1 parker parker  72 Nov  8 22:07 .
drwxr-xr-x 1 parker parker 106 Nov  9 16:46 ..
drwxr-xr-x 1 parker parker  28 Nov  8 22:07 alacritty
drwxr-xr-x 1 parker parker  16 Nov  8 22:07 foot
drwxr-xr-x 1 parker parker  12 Nov  8 22:07 ghostty
drwxr-xr-x 1 parker parker 212 Nov  8 22:07 hypr
drwxr-xr-x 1 parker parker  20 Nov  8 22:07 kitty
drwxr-xr-x 1 parker parker  74 Nov  8 22:07 omarchy

.config/hypr:
total 36
drwxr-xr-x 1 parker parker  212 Nov  8 22:07 .
drwxr-xr-x 1 parker parker   72 Nov  8 22:07 ..
-rw-r--r-- 1 parker parker  159 Nov  8 22:07 .luarc.json
-rw-r--r-- 1 parker parker   65 Nov  8 22:07 autostart.lua
-rw-r--r-- 1 parker parker 1181 Nov  8 22:07 bindings.lua
-rw-r--r-- 1 parker parker 1043 Nov  8 22:07 hyprland.lua
-rw-r--r-- 1 parker parker  364 Nov  8 22:07 hyprsunset.conf
-rw-r--r-- 1 parker parker 2118 Nov  8 22:07 input.lua
-rw-r--r-- 1 parker parker 1246 Nov  8 22:07 looknfeel.lua
-rw-r--r-- 1 parker parker  646 Nov  8 22:07 monitors.lua
-rw-r--r-- 1 parker parker  106 Nov  8 22:07 xdph.conf

.config/omarchy:
total 4
…
```

**⏺ bash** `cd ~; cat .config/omarchy/shell.json; cat .config/hypr/looknfeel.lua .config/hypr/hyprland.lua; ls /usr/share/omarchy/shell /usr/share/omarchy/shell/plugins; omarchy plugin --help; omarchy bar --help`

✓  ms

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

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/README.md; ls plugins/bar plugins/panels plugins/services; ls Commons Ui services`

✓  ms

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

Quick update: I've confirmed your home is this workspace and read the Omarchy plugin guide. Now studying a built-in panel plugin (audio, which already has a slider) to model the new one on.

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/panels; ls audio monitor power; cat audio/manifest.json; wc -l audio/*.qml monitor/*.qml power/*.qml`

✓  ms

```text
audio:
Model.js
Panel.qml
manifest.json

monitor:
Model.js
Panel.qml
manifest.json

power:
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
 1248 audio/Panel.qml
  929 monitor/Panel.qml
  536 power/Panel.qml
 2713 total
Shell cwd was reset to ~
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat plugins/panels/power/Panel.qml; cat Ui/PanelSlider.qml`

✓  ms

```text
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
  readonly property bool showPercentage: setting("showPercentage", false) === true
  // With the percentage shown the button paints a text block wider than an
  // icon, so the open-panel mark takes the painted width instead of the
  // icon-sized fraction of the slot the fallback assumes.
  readonly property real openPanelIndicatorWidth: showPercentage && !button.vertical ? button.glyphPaintedWidth : 0
  readonly property bool batteryPresent: {
    var device = UPower.displayDevice
    return !!(device && device.isPresent)
  }

  function upowerStates() {
    return {
      Charging: UPowerDeviceState.Charging,
      Discharging: UPowerDeviceState.Discharging,
      FullyCharged: UPowerDeviceState.FullyCharged,
      PendingCharge: UPowerDeviceState.PendingCharge
    }
  }

…
```

**⏺ bash** `cd /usr/share/omarchy; cat shell/Ui/Panel.qml; grep -n "PanelSlider" -A25 shell/plugins/panels/audio/Panel.qml | head -80; cat default/hypr/toggles.lua 2>/dev/null | head -60; hyprctl version | head -3`

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

**⏺ bash** `cd /usr/share/omarchy; grep -rn "hyprctl" bin shell --include=* 2>/dev/null | grep -Ev "hyprctl (dispatch|clients|monitors|activewindow|activeworkspace|workspaces|-j|reload|configerrors|getoption)" | head -40; grep -rn "opacity" default/hypr/*.lua | head -20`

✓  ms

```text
shell/Commons/Style.qml:351:    hyprctlProc.running = true
shell/Commons/Style.qml:365:      // hyprctl missing / Hyprland not running — leave the previous value.
shell/Commons/Style.qml:377:      // hyprctl missing / Hyprland not running — leave the previous value.
shell/Commons/Style.qml:442:  property Process hyprctlProc: Process {
shell/Commons/Style.qml:443:    id: hyprctlProc
shell/Commons/Style.qml:444:    command: ["hyprctl", "-j", "getoption", "decoration:rounding"]
shell/Commons/Style.qml:453:    command: ["hyprctl", "-j", "getoption", "general:gaps_out"]
shell/Commons/Style.qml:490:  // so racing it with an immediate hyprctl gives the old value. 200ms is
shell/Commons/Style.qml:500:  // reloads its config when sourced files change, then hyprctl reflects
shell/plugins/bar/widgets/KeyboardLayoutModel.js:5:// the description hyprctl reports as the active keymap:
shell/plugins/services/nightlight/Service.qml:51:      "hyprctl hyprsunset temperature " + Number(temp)]
shell/plugins/services/nightlight/Service.qml:57:    command: ["hyprctl", "hyprsunset", "temperature"]
shell/plugins/bar/widgets/KeyboardLayout.qml:65:  // switchxkblayout is a hyprctl command rather than a dispatcher, so it has to
shell/plugins/bar/widgets/KeyboardLayout.qml:76:    root.bar.run("hyprctl switchxkblayout " + Util.shellQuote(root.keyboardName) + " next")
shell/plugins/bar/widgets/KeyboardLayout.qml:106:    command: ["hyprctl", "-j", "devices"]
shell/plugins/bar/widgets/KeyboardLayout.qml:129:        // hyprctl gets to speak for the seat.
shell/plugins/bar/widgets/KeyboardLayout.qml:196:  // spawning hyprctl forever for an answer that cannot change.
shell/plugins/panels/monitor/Panel.qml:303:    actionProc.command = ["hyprctl", "keyword", "monitor", name + (enabled ? ",disable" : ",preferred,auto,auto")]
default/hypr/windows.lua:5:-- Tag all windows for default opacity (apps can override with -default-opacity tag).
default/hypr/windows.lua:6:o.window(".*", { tag = "+default-opacity" })
default/hypr/windows.lua:21:-- App-specific tweaks (may remove default-opacity tag).
default/hypr/windows.lua:24:-- Apply default opacity after apps have had a chance to opt out.
default/hypr/windows.lua:25:o.window({ tag = "default-opacity" }, { opacity = "0.985 0.96" })
Shell cwd was reset to ~
```

**⏺ bash** `hyprctl --help 2>&1 | head -50; pacman -Q hyprland quickshell 2>/dev/null; sed -n 480,520p /usr/share/omarchy/shell/Commons/Style.qml`

✓  ms

```text
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
                          notification system
    output ...          → Allows you to add and remove fake outputs to your
                          preferred backend
    plugin ...          → Issue a plugin request
    reload [config-only] → Issue a reload to force reload the config. Pass
                          'config-only' to disable monitor reload
…
```

**⏺ bash** `cd /usr/share/omarchy; grep -rn "hyprctl eval\|\"eval\"\|hyprctl keyword\|\"keyword\"" bin shell default 2>/dev/null | head; grep -rn "rawEvent\|configreloaded" shell | head; grep -rn "updateEntryInline" shell | head -5`

✓  ms

```text
shell/plugins/panels/monitor/Panel.qml:303:    actionProc.command = ["hyprctl", "keyword", "monitor", name + (enabled ? ",disable" : ",preferred,auto,auto")]
default/themed/vscode-theme.json.tpl:40:        "keyword": "{{ bright_magenta }}",
default/themed/vscode-theme.json.tpl:819:            "scope": ["keyword", "storage.type.class", "storage.type.function"],
default/themed/helix.toml.tpl:2:"keyword" = "color5"
shell/plugins/bar/widgets/KeyboardLayout.qml:100:      if (name.indexOf("activelayout") !== -1 || name === "configreloaded") root.refresh()
shell/shell.qml:649:        if (shell.pluginOwnsTarget(key, requestedId)) return shell.updateEntryInline(key, settings)
shell/shell.qml:651:          return shell.updateEntryInline(requestedId, settings)
shell/shell.qml:728:          ? shell.updateEntryInline(target, settings) : false
shell/shell.qml:1078:  function updateEntryInline(moduleName, settings) {
shell/plugins/bar/widgets/Tray.qml:184:    if (!root.bar || !root.bar.shell || typeof root.bar.shell.updateEntryInline !== "function") return
Shell cwd was reset to ~
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 85,110p plugins/bar/widgets/KeyboardLayout.qml; sed -n 1070,1110p shell.qml; cat plugins/bar/widgets/Workspaces.manifest.json; ls plugins/bar/widgets | head -40; omarchy plugin list 2>&1 | head`

✓  ms

```text
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
    }
  }

  // Writes inline settings to a bar layout entry or top-level plugin entry in
  // shell.json. moduleName is the entry id; settings is the merged plugin
  // state. Returns true if anything actually changed. Compute the proposed
  // new shellConfig in a local clone, and only persist if anything actually
  // changed so reactive bindings do not dirty shell.json unnecessarily.
  function updateEntryInline(moduleName, settings) {
    var stripped = Util.canonicalWidgetId(moduleName)
    var copy = JSON.parse(JSON.stringify(shellConfig || builtinShellConfig))
    if (!Util.isPlainObject(copy.bar)) copy.bar = { layout: { left: [], center: [], right: [] } }
    if (!Util.isPlainObject(copy.bar.layout)) copy.bar.layout = { left: [], center: [], right: [] }
    if (!Array.isArray(copy.plugins)) copy.plugins = []
…
```

**⏺ bash** `cd /usr/share/omarchy/bin; ls | grep -i plugin; grep -n "id\b\|regex\|=~" omarchy-plugin-validate 2>/dev/null | head -30; grep -rn "local\.\|whoami\|USER" omarchy-plugin-clone | head`

✓  ms

```text
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
25:point for each kind that needs one, no symlinks, and an id that is not reserved.
26:Exits 0 if valid — handy for plugin authors before publishing.
36:jq -e . "$MANIFEST" >/dev/null 2>&1 || fail "manifest.json is not valid JSON: $MANIFEST"
44:for field in id name version kinds entryPoints; do
49:ID=$(jq -r '.id // ""' "$MANIFEST")
50:[[ -n $ID ]] || fail "manifest 'id' is empty"
51:[[ $ID =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || fail "invalid plugin id '$ID'"
52:[[ $ID != *".."* ]] || fail "invalid plugin id '$ID'"
53:[[ $ID != omarchy.* ]] || fail "plugin id '$ID' uses the reserved omarchy.* namespace"
omarchy-plugin-clone:131:new_id="${USER:-$(id -un)}.${source_id#omarchy.}"
Shell cwd was reset to ~
```

**⏺ bash** `cd /usr/share/omarchy/bin; sed -n 55,120p omarchy-plugin-validate; cat omarchy-plugin-enable | head -80; echo USER=$USER`

✓  ms

```text
# kinds must be a non-empty array.
jq -e '(.kinds | type) == "array" and (.kinds | length) > 0' "$MANIFEST" >/dev/null 2>&1 \
  || fail "'kinds' must be a non-empty array"

# entryPoints must be an object and every value a safe relative path that exists.
jq -e '(.entryPoints | type) == "object"' "$MANIFEST" >/dev/null 2>&1 \
  || fail "'entryPoints' must be an object"

# A bar widget may declare where it should land when enabled without an
# explicit placement.
jq -e '
  if ((.barWidget? | type) == "object" and (.barWidget | has("defaultSection"))) then
    .barWidget.defaultSection as $section
    | ($section | type) == "string"
      and (["left", "center", "right"] | index($section)) != null
  else
    true
  end
' "$MANIFEST" >/dev/null 2>&1 \
  || fail "'barWidget.defaultSection' must be left, center, or right"

# Read each entry point as a JSON-encoded string (one per line), then decode it,
# so a value that itself contains a newline stays one literal path instead of
# being split into fragments that each pass the checks.
while IFS= read -r ep_json; do
  [[ -n $ep_json ]] || continue
  ep=$(jq -r '.' <<<"$ep_json")
  [[ -n $ep ]] || fail "entry point path is empty"
  [[ $ep != *$'\n'* ]] || fail "entry point may not contain a newline"
  [[ $ep != /* ]] || fail "entry point must be a relative path: '$ep'"
  [[ $ep != *".."* ]] || fail "entry point may not contain '..': '$ep'"
  [[ -f "$PLUGIN_DIR/$ep" ]] || fail "entry point file not found: '$ep'"
done < <(jq -c '.entryPoints | to_entries[] | .value' "$MANIFEST")

# A kind is a promise to supply something to load, and the shell looks for that
# something under a fixed key: entryPoints.bar to draw a bar, entryPoints.menu
# to open a menu, and so on. Claiming a kind without its entry point is accepted
# everywhere else -- the bar falls back to the built-in, the widget is skipped --
# leaving a plugin that installs, enables, and does nothing, explained only by a
# line on the shell's console. Refuse it here, while there is still someone to
…
```

**⏺ bash** `hyprctl --help 2>&1 | sed -n 50,90p; strings /usr/bin/Hyprland 2>/dev/null | grep -i "keyword" | head -20`

✓  ms

```text
    setprop ...         → Sets a window property
    getprop ...         → Gets a window property
    splash              → Get the current splash
    status              → Get internal status information
    switchxkblayout ... → Sets the xkb layout index for a keyboard
    systeminfo          → Get system info
    version             → Prints the hyprland version, meaning flags, commit
                          and branch of build.
    workspacerules      → Lists all workspace rules
    workspaces          → Lists all workspaces with their properties

flags:
    -j                  → Output in JSON
    -r                  → Refresh state after issuing command (e.g. for
                          updating variables)
    --batch             → Execute a batch of commands, separated by ';'
    --instance (-i)     → use a specific instance. Can be either signature or
                          index in hyprctl instances (0, 1, etc)
    --quiet (-q)        → Disable the output of hyprctl

--help:
    Can be used to print command's arguments that did not fit into this page
    (three dots)
_Z25getPlusMinusKeywordResultNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEf
addConfigKeyword
_ZN6Config6Legacy14CConfigManager12parseKeywordERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEES9_
_ZN6Config6Legacy14CConfigManager16addPluginKeywordEPvRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPFN8Hyprlang12CParseResultEPKcSE_ENSB_15SHandlerOptionsE
keyword
Hyprctl: keyword {} : {}
constexpr std::vector< <template-parameter-1-1>, <template-parameter-1-2> >::reference std::vector< <template-parameter-1-1>, <template-parameter-1-2> >::back() [with _Tp = Config::Legacy::SPluginKeyword; _Alloc = std::allocator<Config::Legacy::SPluginKeyword>; reference = Config::Legacy::SPluginKeyword&]
cannot remove a real display. Use the monitor keyword.
keyword can't work with non-legacy parsers. Use eval.
Invalid arg "{}" in getPlusMinusKeywordResult!
*ZL15dispatchKeyword20eHyprCtlOutputFormatNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEEUlvE_
*ZL15dispatchKeyword20eHyprCtlOutputFormatNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEEUlvE0_
*ZL15dispatchKeyword20eHyprCtlOutputFormatNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEEUlN9Hyprutils6Memory14CSharedPointerI10CWorkspaceEENS8_IN7Monitor8CMonitorEEEbE_
```

**⏺ bash** `strings /usr/bin/Hyprland | grep -E "^configreloaded|active_opacity|inactive_opacity" | head; grep -n "^import" /usr/share/omarchy/shell/plugins/bar/widgets/KeyboardLayout.qml; grep -rn "pixelSize\|text:" /usr/share/omarchy/shell/plugins/bar/widgets/Microphone.qml | head; wc -l /usr/share/omarchy/sh`

✓  ms

```text
configreloaded
decoration:active_opacity
decoration:inactive_opacity
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
1:import QtQuick
2:import Quickshell
3:import Quickshell.Hyprland
4:import Quickshell.Io
5:import qs.Ui
6:import qs.Commons
7:import "KeyboardLayoutModel.js" as KeyboardLayoutModel
/usr/share/omarchy/shell/plugins/bar/widgets/Microphone.qml:41:    text: root.muted ? "󰍭" : "󰍬"
54 /usr/share/omarchy/shell/plugins/bar/widgets/Microphone.qml
```

**⏺ bash** `cd /usr/share/omarchy/shell/Ui; grep -n "signal\|property" PanelKeyCatcher.qml BarIconButton.qml KeyboardPanel.qml PanelSectionHeader.qml | head -60`

✓  ms

```text
BarIconButton.qml:8:  property Component iconComponent: null
BarIconButton.qml:9:  property real slotSize: Style.bar.iconSlot
BarIconButton.qml:10:  property real opticalSize: Style.bar.iconCanvas
BarIconButton.qml:11:  property bool debugOpticalBounds: Quickshell.env("OMARCHY_DEBUG_BAR_ICONS") === "1"
BarIconButton.qml:12:  readonly property real opticalCenterErrorX: glyph.visible ? glyph.paintedCenterX - opticalCanvas.width / 2 : 0
BarIconButton.qml:13:  readonly property real glyphPaintedWidth: glyph.visible ? glyph.tightWidth : 0
BarIconButton.qml:14:  readonly property real glyphBaselineY: glyph.visible ? glyph.baselineY : 0
BarIconButton.qml:15:  readonly property int glyphFontSize: glyph.visible ? glyph.renderedFontSize : 0
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
KeyboardPanel.qml:40:  required property Item anchorItem
KeyboardPanel.qml:41:  required property QtObject bar
KeyboardPanel.qml:42:  property var owner: null
KeyboardPanel.qml:43:  property int margin: Style.gapsOut
KeyboardPanel.qml:44:  property int padding: Style.spacing.popupPadding
KeyboardPanel.qml:45:  property int contentWidth: Style.space(280)
KeyboardPanel.qml:46:  property int contentHeight: Style.space(200)
KeyboardPanel.qml:47:  property var borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, Math.max(1, Style.space(2)))
KeyboardPanel.qml:48:  property bool centerOnBar: false
KeyboardPanel.qml:49:  property bool open: false
KeyboardPanel.qml:50:  property int gap: Style.gapsOut  // distance between bar edge and panel
KeyboardPanel.qml:51:  property bool popoutSwitching: false
KeyboardPanel.qml:52:  property bool popoutSwitchClosing: false
KeyboardPanel.qml:53:  property bool focusPrimed: false
KeyboardPanel.qml:61:  property Item focusTarget: null
KeyboardPanel.qml:63:  default property alias contentItem: contentHolder.children
KeyboardPanel.qml:65:  readonly property var coordinatorKey: owner || root
KeyboardPanel.qml:66:  readonly property var anchorWindow: anchorItem ? anchorItem.QsWindow.window : null
KeyboardPanel.qml:67:  readonly property string barPos: bar ? bar.position : "top"
…
```

**⏺ bash** `sed -n 340,380p /usr/share/omarchy/shell/Commons/Style.qml; sed -n 440,460p /usr/share/omarchy/shell/Commons/Style.qml`

✓  ms

```text
  readonly property QtObject bar: QtObject {
    readonly property int sizeHorizontal: root.barToken("size-horizontal", 26)
    readonly property int sizeVertical:   root.barToken("size-vertical",   28)
    readonly property int iconSlot:       root.barToken("icon-slot",       27)
    readonly property int iconCanvas:     root.barToken("icon-canvas",     16)
    readonly property int iconFont:       root.barToken("icon-font",       13)
    readonly property int statusSlot:     root.barToken("status-slot",     21)
  }

  function refresh() {
    hyprctlProc.running = true
    gapsOutProc.running = true
  }

  function scheduleRefresh() {
    refreshTimer.restart()
  }

  function applyRoundingJson(raw) {
    try {
      var json = JSON.parse(raw || "{}")
      var n = Number(json.int)
      if (isFinite(n) && n >= 0) cornerRadius = n
    } catch (e) {
      // hyprctl missing / Hyprland not running — leave the previous value.
    }
  }

  function applyGapsOutJson(raw) {
    try {
      var json = JSON.parse(raw || "{}")
      var css = String(json.css || "")
      var parts = css.match(/-?\d+(?:\.\d+)?/g) || []
      var n = parts.length > 0 ? Number(parts[0]) : Number(json.int)
      if (isFinite(n) && n >= 0) gapsOut = Math.max(0, Math.round(n / 2))
    } catch (e) {
      // hyprctl missing / Hyprland not running — leave the previous value.
    }
  }

…
```

I now have what I need. Writing the plugin to `~/.config/omarchy/plugins/parker.window-opacity/`.

**⏺ bash** `mkdir -p ~/.config/omarchy/plugins/parker.window-opacity && cat > ~/.config/omarchy/plugins/parker.window-opacity/manifest.json <<'EOF'
{
  "schemaVersion": 1,
  "id": "parker.window-opacity",
  "name": "Window Opacity",
  "version": "1.0.0",
  "author": "parker",
  "description": "Live sliders for `

✓  ms

```text
(Bash completed with no output)
```

**⏺ write** `~/.config/omarchy/plugins/parker.window-opacity/Panel.qml`

```
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Ui

// Bar button + popup with two sliders driving Hyprland's
// decoration:active_opacity and decoration:inactive_opacity live.
//
// Values persist as inline settings on this widget's shell.json entry
// ({ "id": "parker.window-opacity", "active": 0.9, "inactive": 0.8 }) and are
// re-applied whenever the shell starts or Hyprland reloads its config, so the
// Hyprland Lua files are never touched. Until a slider is first moved, nothing
// is applied and Hyprland's own config stays in charge.
Panel {
  id: root
  moduleName: "parker.window-opacity"
  ipcTarget: "parker.window-opacity"

  readonly property real minimumOpacity: 0.2
  readonly property bool hasSaved: setting("active", null) !== null || setting("inactive", null) !== null
  readonly property real savedActive: clamp(setting("active", 1.0))
  readonly property real savedInactive: clamp(setting("inactive", 1.0))

  // What the sliders show; follows saved values except mid-drag.
  property real liveActive: savedActive
  property real liveInactive: savedInactive
  property bool dragging: false
  property int selectedRow: 0
  property bool cursorActive: false

  // Pending values for the single hyprctl process; drags coalesce into
  // whatever is newest when the previous call exits.
  property var pending: null

  onSavedActiveChanged: if (!dragging) liveActive = savedActive
  onSavedInactiveChanged: if (!dragging) liveInactive = savedInactive
  onHasSavedChanged: if (hasSaved) apply(savedActive, savedInactive)
  Component.onCompleted: if (hasSaved) apply(savedActive, savedInactive)

  function clamp(v) {
    var n = Number(v)
    if (!isFinite(n)) n = 1.0
    return Math.round(Math.max(minimumOpacity, Math.min(1.0, n)) * 100) / 100
  }

  function apply(active, inactive) {
    pending = { active: clamp(active), inactive: clamp(inactive) }
    // Our own eval may echo back as a configreloaded event; ignore those.
    echoGuard.restart()
    if (!applyProc.running) flush()
  }

  function flush() {
    if (!pending) return
    var lua = "hl.config({ decoration = { active_opacity = " + pending.active.toFixed(2)
      + ", inactive_opacity = " + pending.inactive.toFixed(2) + " } })"
    pending = null
    applyProc.command = ["hyprctl", "-q", "eval", lua]
… (172 more lines in the repository)
```

✓  ms

```text
File created successfully at: ~/.config/omarchy/plugins/parker.window-opacity/Panel.qml (file state is current in your context — no need to Read it back)
```

**⏺ bash** `cd ~/.config/omarchy/plugins/parker.window-opacity && python3 - <<'EOF'
p="Panel.qml"; s=open(p).read()
s=s.replace("@@ICON@@","\U000F05CB")
s=s.replace("""  onSavedActiveChanged: if (!dragging) liveActive = savedActive
  onSavedInactiveChanged: if (!dragging) liveInactive = savedInactive
  onHasSav`

✓  ms

```text
119:    text: "󰗋"
153:          text: "WINDOW OPACITY"
VALID
```

The plugin validates. Now adding it to the bar's right section.

**⏺ bash** `cd ~; cp .config/omarchy/shell.json /tmp/shell.json.bak; omarchy plugin enable parker.window-opacity --section right --before omarchy.audio; echo rc=$?; git diff .config/omarchy/shell.json`

✓  ms

```text
omarchy-shell is not running
rc=1
```

The shell isn't running in this environment, so the enable command can't reach it. Checking what `enable` would write so I can make the same edit to `shell.json` directly.

**⏺ bash** `sed -n 80,200p /usr/share/omarchy/bin/omarchy-plugin-enable`

✓  ms

```text
    + (if $index == "" then {} else {index: ($index | tonumber)} end)
    + (if $before == "" then {} else {before: $before} end)
    + (if $after == "" then {} else {after: $after} end)
  ')

result=$(omarchy-shell shell enablePlugin "$id" "$placement")
if [[ $result == "unknown" ]]; then
  fail "plugin '$id' is not known; run: omarchy-shell shell rescanPlugins"
elif [[ $result != "ok" ]]; then
  fail "$result"
fi

if [[ $placement != "{}" ]]; then
  echo "Enabled and moved $id"
elif omarchy-plugin-catalog | jq -e --arg id "$id" '
  any(.[]; .id == $id and (.kinds | index("bar")))
' >/dev/null; then
  echo "Now using $id as the bar"
else
  echo "Enabled $id"
fi
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function enablePlugin" -A45 shell.qml | head -70`

✓  ms

```text
1624:    function enablePlugin(id: string, placementJson: string): string {
1625-      try {
1626-        var placement = JSON.parse(placementJson || "{}")
1627-        if (shell.pluginRegistry.setEnabled(id, true, placement)) return "ok"
1628-        return shell.pluginRegistry.lastEnableError || "unknown"
1629-      } catch (e) {
1630-        return "invalid placement: " + e
1631-      }
1632-    }
1633-
1634-    // Enable, but only where the widget is not on the bar already, so a caller
1635-    // that cannot know whether it ran before leaves a placed widget alone.
1636-    function putBarWidget(id: string, placementJson: string): string {
1637-      try {
1638-        var error = shell.pluginRegistry.putBarWidget(id, JSON.parse(placementJson || "{}"))
1639-        return error ? error : "ok"
1640-      } catch (e) {
1641-        return "invalid placement: " + e
1642-      }
1643-    }
1644-
1645-    function moveBarWidget(id: string, placementJson: string): string {
1646-      try {
1647-        var error = shell.pluginRegistry.moveBarWidget(id, JSON.parse(placementJson || "{}"))
1648-        return error ? error : "ok"
1649-      } catch (e) {
1650-        return "invalid placement: " + e
1651-      }
1652-    }
1653-
1654-    function setBarWidget(id: string, key: string, valueJson: string, selectorJson: string): string {
1655-      try {
1656-        var value = JSON.parse(valueJson)
1657-        var selector = JSON.parse(selectorJson || "{}")
1658-        var error = shell.pluginRegistry.setBarWidget(id, key, value, selector)
1659-        return error ? error : "ok"
1660-      } catch (e) {
1661-        return "invalid widget setting: " + e
1662-      }
1663-    }
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function setEnabled" -A60 services/PluginRegistry.qml | grep -n "plugins\|layout\|disabled\|bar-widget" | head -30`

✓  ms

```text
14:487-    var isBarWidget = manifest && Array.isArray(manifest.kinds) && manifest.kinds.indexOf("bar-widget") !== -1
16:489-      && manifest.kinds.some(function(kind) { return kind !== "bar-widget" })
58:531-            var sourceEntry = config.bar.layout[sourceLocation.section][sourceLocation.index]
61:534-            config.bar.layout[sourceLocation.section][sourceLocation.index] = replacement
Shell cwd was reset to ~
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "function setEnabled" services/PluginRegistry.qml; sed -n 474,530p services/PluginRegistry.qml; sed -n 540,620p services/PluginRegistry.qml | grep -n "plugins\|layout\|push\|splice" `

✓  ms

```text
474:  function setEnabled(id, value, placement) {
  function setEnabled(id, value, placement) {
    var key = Util.canonicalWidgetId(String(id))
    lastEnableError = ""
    if (!shellConfigMutator) {
      console.warn("PluginRegistry.setEnabled called before shellConfigMutator wired")
      return false
    }
    var manifest = installedPlugins[key]
    if (value && !manifest) {
      console.warn("PluginRegistry.setEnabled: unknown plugin " + key)
      return false
    }
    var isBarOption = manifest && Array.isArray(manifest.kinds) && manifest.kinds.indexOf("bar") !== -1
    var isBarWidget = manifest && Array.isArray(manifest.kinds) && manifest.kinds.indexOf("bar-widget") !== -1
    var hasNonWidgetKind = manifest && Array.isArray(manifest.kinds)
      && manifest.kinds.some(function(kind) { return kind !== "bar-widget" })
    var metadata = manifest && Util.isPlainObject(manifest.omarchy) ? manifest.omarchy : null
    var clonedFrom = metadata ? Util.canonicalWidgetId(String(metadata.clonedFrom || "")) : ""
    shellConfigMutator(function(config) {
      ensureConfigShape(config)

      if (value && placement && (placement.before || placement.after)) {
        var relativeId = String(placement.before || placement.after)
        if (!findRelativeBarLocation(config, relativeId, String(placement.section || "")).found) {
          lastEnableError = "could not find target widget " + relativeId
          return
        }
      }

      if (value && manifest && manifest.__isFirstParty) {
        var activeClone = activeCloneFor(config, key)
        if (activeClone) {
          restoreCloneSource(config, activeClone, key)
          removeDisabled(config, key)
        }
      }

      if (isBarOption) {
        if (value) {
…
```

For a pure bar widget, enabling it just adds an entry to the bar layout, so I'll make that same edit with jq.

**⏺ bash** `cd ~/.config/omarchy; jq '.bar.layout.right |= (index({"id":"omarchy.audio"}) as $i | .[:$i] + [{"id":"parker.window-opacity"}] + .[$i:])' shell.json > /tmp/shell.json.new && mv /tmp/shell.json.new shell.json && jq -c '.bar.layout.right' shell.json && git -C ~ diff --stat`

✓  ms

```text
[{"id":"omarchy.tray"},{"id":"omarchy.agents"},{"id":"omarchy.bluetooth"},{"id":"omarchy.network"},{"id":"parker.window-opacity"},{"id":"omarchy.audio"},{"id":"omarchy.monitor"},{"id":"omarchy.power"}]
 .config/omarchy/shell.json                |  5 ++++-
 .config/omarchy/themes/ember/README.md    |  7 -------
 .config/omarchy/themes/ember/colors.toml  | 31 -------------------------------
 .config/omarchy/themes/ember/hyprland.lua |  2 --
 .config/omarchy/themes/ember/icons.theme  |  1 -
 .config/omarchy/themes/ember/install.sh   |  5 -----
 .config/omarchy/themes/ember/neovim.lua   | 11 -----------
 7 files changed, 4 insertions(+), 58 deletions(-)
```

**⏺ bash** `git -C ~ diff .config/omarchy/shell.json; which qmllint qmllint6 /usr/lib/qt6/bin/qmllint 2>/dev/null`

✗  ms

```text
Exit code 1
diff --git a/.config/omarchy/shell.json b/.config/omarchy/shell.json
index e6202da..d1c8738 100644
--- a/.config/omarchy/shell.json
+++ b/.config/omarchy/shell.json
@@ -25,7 +25,7 @@
           "id": "omarchy.clock",
           "format": "dddd HH:mm",
           "formatAlt": "d MMMM 'W'ww yyyy",
-          "verticalFormat": "HH\n\u2014\nmm"
+          "verticalFormat": "HH\n—\nmm"
         },
         {
           "id": "omarchy.keyboard-layout"
@@ -50,6 +50,9 @@
         {
           "id": "omarchy.network"
         },
+        {
+          "id": "parker.window-opacity"
+        },
         {
           "id": "omarchy.audio"
         },
~/.local/bin/qmllint
/usr/lib/qt6/bin/qmllint
```

The em-dash escape got rewritten by jq (same value, but I'll restore the original form), then lint the QML.

**⏺ bash** `cd ~/.config/omarchy; sed -i 's/"HH\\n—\\nmm"/"HH\\n\\u2014\\nmm"/' shell.json; git -C ~ diff --stat .config/omarchy/shell.json; jq . shell.json >/dev/null && echo json-ok; /usr/lib/qt6/bin/qmllint plugins/parker.window-opacity/Panel.qml 2>&1 | grep -v "qs\.\|Quickshell\|unqualified\|Unqualified\|im`

✓  ms

```text
 .config/omarchy/shell.json | 3 +++
 1 file changed, 3 insertions(+)
json-ok
^^^^^^
---
---

^^^^^^
---
---

  BarIconButton {
  ^^^^^^^^^^^^^
        PanelSectionHeader {
        ^^^^^^^^^^^^^^^^^^
    PanelSlider {
    ^^^^^^^^^^^
Warning: plugins/parker.window-opacity/Panel.qml:16:1: Panel is part of an inheritance cycle: Panel -> Panel [inheritance-cycle]
Panel {
^^^^^
  KeyboardPanel {
  ^^^^^^^^^^^^^
    PanelKeyCatcher {
    ^^^^^^^^^^^^^^^
    anchors.fill: parent
    ^^^^^^^
      anchors.fill: parent
      ^^^^^^^
Warning: plugins/parker.window-opacity/Panel.qml:16:1: Type Panel is used but it is not resolved [unresolved-type]
Panel {
^^^^^
    onExited: root.flush()
    ^^^^^^^^
```

**⏺ bash** `cat /usr/bin/omarchy-shell | head -40`

✓  ms

```text
#!/bin/bash

# omarchy:summary=Send an IPC call to the running Omarchy shell
# omarchy:args=[-q] <target> <method> [args...]
# omarchy:examples=omarchy shell shell ping | omarchy-shell shell toggle omarchy.menu '{"menu":"root"}'

QUIET=0
if [[ ${1:-} == "-q" ]]; then
  QUIET=1
  shift
fi

fail() {
  (( QUIET )) && exit 0
  echo "$1" >&2
  exit 1
}

if (( $# == 0 )) || [[ $1 == "-h" || $1 == "--help" ]]; then
  cat <<USAGE
Usage: omarchy-shell [-q] <target> <method> [args...]

Forwards an IPC call to the running Omarchy shell. The shell is expected
to already be running; this command does not start it.

Options:
  -q  Quiet best-effort mode. Suppress output and return success even when
      the shell, target, method, or arguments are unavailable.

Examples:
  omarchy-shell shell ping
  omarchy-shell -q omarchy.indicators refresh
  omarchy-shell shell listPlugins
  omarchy-shell shell toggle omarchy.menu '{"menu":"root"}'
USAGE
  exit 0
fi

(( $# >= 2 )) || fail "Usage: omarchy-shell <target> <method> [args...]"
[[ -n ${OMARCHY_PATH:-} ]] || fail "OMARCHY_PATH is not set"
```

**⏺ bash** `cd /tmp; timeout 20 env QT_QPA_PLATFORM=offscreen qs -p /usr/share/omarchy/shell --no-duplicate 2>&1 | grep -iE "window-opacity|parker|error|Panel.qml" | head -30; echo done`

✓  ms

```text
 ERROR: Failed to load configuration
 ERROR:   caused by @shell.qml[232:5]: Type Bar unavailable
 ERROR:   caused by @plugins/bar/Bar.qml[1234:23]: No PanelWindow backend loaded.
done
Shell cwd was reset to ~
```

The full shell needs a Wayland session, which this sandbox doesn't have. I'll compile just the plugin file in a small Quickshell harness to catch syntax and type errors.

**⏺ bash** `mkdir -p /tmp/oph && cd /tmp/oph && rm -rf * && cp -r /usr/share/omarchy/shell/Commons /usr/share/omarchy/shell/Ui /usr/share/omarchy/shell/services . 2>/dev/null; cat > shell.qml <<EOF
import QtQuick
import Quickshell
Scope {
  Component.onCompleted: {
    var c = Qt.createComponent("file://$HOME/.`

✗  ms

```text
Dangerous rm operation detected: '~/*'

This command changes directories before the removal, so the relative glob target cannot be statically resolved. This requires explicit approval and cannot be auto-allowed by permission rules.
```

**⏺ bash** `mkdir -p /tmp/oph && cp -r /usr/share/omarchy/shell/Commons /usr/share/omarchy/shell/Ui /usr/share/omarchy/shell/services /tmp/oph/ && cat > /tmp/oph/shell.qml <<EOF
import QtQuick
import Quickshell
Scope {
  Component.onCompleted: {
    var c = Qt.createComponent("file://$HOME/.config/omarchy/plugi`

✓  ms

```text
  INFO: Launching config: "/tmp/oph/shell.qml"
  INFO: Shell ID: "5c071305b7667ba0a0cc160c647f9e95" Path ID "5c071305b7667ba0a0cc160c647f9e95"
  INFO: Saving logs to "/run/user/1000/quickshell/by-id/eg78e9ot/log.qslog"
 DEBUG qml: STATUS 3 ERR file://~/.config/omarchy/plugins/parker.window-opacity/Panel.qml:124:3: Type KeyboardPanel unavailable
qs:@/qs/Ui/KeyboardPanel.qml:37:1: No PanelWindow backend loaded.
  WARN: Signal QQmlEngine::quit() emitted, but no receivers connected to handle it.
  INFO: Configuration Loaded
```

Everything resolves up to `KeyboardPanel`, which needs a real Wayland window. I'll stub it in the harness copy so the rest of the plugin logic can run.

**⏺ bash** `cat > /tmp/oph/Ui/KeyboardPanel.qml <<'EOF'
import QtQuick
Item {
  required property Item anchorItem
  required property QtObject bar
  property var owner: null
  property bool open: false
  property Item focusTarget: null
  property int contentWidth: 0
  property int contentHeight: 0
  function fi`

✓  ms

```text
 DEBUG qml: STATUS 1 ERR 
  WARN: $HYPRLAND_INSTANCE_SIGNATURE is unset. Cannot connect to hyprland.
 DEBUG qml: OBJ 0.9 0.75 true 0.9 0.2 1 0.33
 DEBUG qml: LIVE 0.6 0.5 null
 DEBUG qml: SAVE parker.window-opacity {"active":0.6,"inactive":0.5}
 DEBUG qml: SAVED {"active":0.6,"inactive":0.5} 0.6
 DEBUG qml: SAVE parker.window-opacity {"active":0.9,"inactive":0.8}
 DEBUG qml: NUDGE 0.5
 DEBUG qml: EMPTY false 1 null
  WARN scene: @Ui/WidgetButton.qml[58:3]: Unable to assign [undefined] to int
  WARN scene: @Ui/WidgetButton.qml[12:3]: Unable to assign [undefined] to QColor
  WARN scene: @Ui/WidgetButton.qml[90:7]: Unable to assign [undefined] to bool
  WARN scene: @Ui/WidgetButton.qml[58:3]: Unable to assign [undefined] to int
  WARN scene: @Ui/WidgetButton.qml[12:3]: Unable to assign [undefined] to QColor
  WARN scene: @Ui/WidgetButton.qml[90:7]: Unable to assign [undefined] to bool
  WARN scene: QML IpcHandler at @Ui/Panel.qml[48:3]: Handler was registered but will not be used because another handler is registered for target parker.window-opacity
```

The logic mostly works, but the harness exposed a bug: a keyboard nudge after a save saved the old values (0.9/0.8 instead of 0.6/0.55). Tracing it now.

**⏺ bash** `cd /tmp/oph && sed -i 's|o.nudge(1, 0.05);|console.log("PRE", o.liveActive, o.liveInactive, o.dragging, JSON.stringify(o.settings)); o.nudge(1, 0.05);|' shell.qml && timeout 10 env QT_QPA_PLATFORM=offscreen qs -p /tmp/oph 2>&1 | grep -E "qml:" | head`

✓  ms

```text
 DEBUG qml: STATUS 1 ERR 
 DEBUG qml: OBJ 0.9 0.75 true 0.9 0.2 1 0.33
 DEBUG qml: LIVE 0.6 0.5 null
 DEBUG qml: SAVE parker.window-opacity {"active":0.6,"inactive":0.5}
 DEBUG qml: SAVED {"active":0.6,"inactive":0.5} 0.6
 DEBUG qml: PRE 0.9 0.75 false {"active":0.6,"inactive":0.5}
 DEBUG qml: SAVE parker.window-opacity {"active":0.9,"inactive":0.8}
 DEBUG qml: NUDGE 0.5
 DEBUG qml: EMPTY false 1 null
Shell cwd was reset to ~
```

Root cause: the `onSettingsChanged` handler runs before the `savedActive`/`savedInactive` bindings re-evaluate, so it reads stale values. Fix: read straight from `settings` inside the sync.

**⏺ edit** `~/.config/omarchy/plugins/parker.window-opacity/Panel.qml`

```
  // Reads settings directly: inside onSettingsChanged the saved* bindings
  // may not have re-evaluated yet.
  function syncFromSettings() {
    if (dragging) return
    liveActive = clamp(setting("active", 1.0))
    liveInactive = clamp(setting("inactive", 1.0))
    if (setting("active", null) !== null || setting("inactive", null) !== null) apply(liveActive, liveInactive)
  }
```

**⏺ bash** `cd /tmp/oph && sed -i 's|var e = |o.preview(1.5, 0.1); o.save(); console.log("CLAMP", JSON.stringify(o.settings)); var e = |' shell.qml && timeout 10 env QT_QPA_PLATFORM=offscreen qs -p /tmp/oph 2>&1 | grep -E "qml:|ERROR" | head -12`

✓  ms

```text
The file ~/.config/omarchy/plugins/parker.window-opacity/Panel.qml has been updated successfully.
```

✓  ms

```text
 DEBUG qml: STATUS 1 ERR 
 DEBUG qml: OBJ 0.9 0.75 true 0.9 0.2 1 0.33
 DEBUG qml: LIVE 0.6 0.5 null
 DEBUG qml: SAVE parker.window-opacity {"active":0.6,"inactive":0.5}
 DEBUG qml: SAVED {"active":0.6,"inactive":0.5} 0.6
 DEBUG qml: PRE 0.6 0.5 false {"active":0.6,"inactive":0.5}
 DEBUG qml: SAVE parker.window-opacity {"active":0.6,"inactive":0.55}
 DEBUG qml: NUDGE 0.55
 DEBUG qml: SAVE parker.window-opacity {"active":1,"inactive":0.2}
 DEBUG qml: CLAMP {"active":1,"inactive":0.2}
 DEBUG qml: EMPTY false 1 null
Shell cwd was reset to ~
```

Fixed and verified: values persist correctly through save and nudge, and out-of-range values clamp to 20–100%. Cleaning up the temporary harness.

**⏺ bash** `rm -rf /tmp/oph /tmp/shell.json.bak; omarchy plugin validate ~/.config/omarchy/plugins/parker.window-opacity && echo VALID; git -C ~ status --short`

✓  ms

```text
VALID
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
?? .h0-api/
?? .pi/
```

I've built the window opacity plugin and added it to your top bar, just left of the audio icon. I couldn't watch it change real windows: there's no running Hyprland or bar here. It will show up the next time the bar loads, or right away with `omarchy-shell shell rescanPlugins`.

**What it does**
- A droplet icon in the bar opens a small panel with two sliders, **Focused** and **Unfocused**, each showing its percentage. They go from 20% to 100%, so a window can never turn invisible.
- Dragging a slider changes opacity live. The mouse wheel and arrow keys also work (up/down picks a slider, left/right moves it by 5%).
- **Your settings are kept** in `~/.config/omarchy/shell.json`, e.g. `{ "id": "parker.window-opacity", "active": 0.9, "inactive": 0.8 }`. They're applied again when the bar starts and whenever Hyprland reloads its config. Your Hyprland config files aren't touched.
- Until you move a slider for the first time, the plugin does nothing and your current Hyprland config controls opacity.

**Things you should know**
- **The usual opacity command doesn't work on your setup.** Your Hyprland version rejects `hyprctl keyword` with Lua config ("keyword can't work with non-legacy parsers. Use eval."), so the plugin uses `hyprctl eval` instead. Omarchy's built-in monitor panel still uses `keyword` (to turn a display on or off), so that button may fail on your system.
- **Opacity stacks with Omarchy's default.** Omarchy already makes most windows slightly transparent (98.5% focused, 96% unfocused). The sliders multiply on top of that, so 100% on a slider means "Omarchy's default", and 80% ends up a bit under 80%.

**What I tested**
- The plugin passes `omarchy plugin validate`.
- I loaded it in a stripped-down copy of the bar without the popup window, since that needs a desktop session. That run caught a bug where a keyboard nudge right after a change saved the old values. It's fixed, and saving, nudging and limits now behave correctly.
- Not tested: the popup itself, the live `hyprctl eval` call, and re-applying after a Hyprland reload.

**Files**
- New: `~/.config/omarchy/plugins/parker.window-opacity/manifest.json` and `Panel.qml`
- Changed: `~/.config/omarchy/shell.json` (one bar entry added). The bar wasn't running, so `omarchy plugin enable` couldn't reach it and I made the same edit directly.

The `ember` theme deletions in `git status` were already there before I started; I didn't touch them. Nothing has been committed.

