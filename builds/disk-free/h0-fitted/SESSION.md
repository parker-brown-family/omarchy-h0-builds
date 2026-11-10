# h0 + Omarchy fitting building Disk Free

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `omarchy-v4` · tools read, edit, write, grep, glob, bash, check

---

### › You

```text
Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.
```

I'll start by reading the plugin guide and looking at existing plugins.

**⏺ bash** `cat /usr/share/omarchy/default/agents/skills/omarchy/plugins.md; ls .config/omarchy/plugins 2>/dev/null; ls $OMARCHY_PATH/shell/plugins/ 2>/dev/null || ls /usr/share/omarchy/shell/plugins/`

✓ 72 ms

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

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; cat README.md; ls -R bar | head -80; cat ~/.config/omarchy/shell.json`

✓ 71 ms

```text
[exit 0, 65 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; cat bar/README.md; cat bar/widgets/SystemUpdate.manifest.json bar/widgets/SystemUpdate.qml; ls panels/clock; cat panels/clock/manifest.json panels/clock/BarWidget.qml`

✓ 97 ms

```text
[exit 0, 86 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; sed -n 1,200p bar/widgets/SystemUpdate.qml; ls ..; find .. -name WidgetButton.qml -o -name BarWidget.qml | grep -v plugins`

✓ 49 ms

```text
[exit 0, 44 ms]
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
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "property\|signal" Ui/WidgetButton.qml | head -60; grep -n "property\|function" Ui/BarWidget.qml | head -40; grep -rn "urgent\|critical" Commons/*.qml | head -20`

✓ 122 ms

```text
[exit 0, 111 ms]
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
61:  readonly property bool tooltipHovered: visible && interactive && !concealed && mouseArea.containsMouse
64:  readonly property real labelWidth: label.visible ? label.implicitWidth : 0
15:  property QtObject bar: null
16:  property string moduleName: ""
17:  property var settings: ({})
22:  readonly property bool vertical: bar ? bar.vertical : false
23:  readonly property int barSize: bar ? bar.barSize : Style.bar.sizeHorizontal
29:  function broadcast(method) {
30:    var items = bar && typeof bar.moduleWidgets === "function"
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 60,200p Ui/WidgetButton.qml | grep -n "color\|active" ; cat ../shell/README.md 2>/dev/null | grep -n -i "manifest" | head; ls ~/.config/omarchy/plugins 2>&1; which omarchy-plugin-validate`

✓ 95 ms

```text
[exit 0, 87 ms]
2:  readonly property bool tooltipHovered: visible && interactive && !concealed && mouseArea.containsMouse
22:    color: root.active && root.useActiveColor ? root.activeColor : root.foreground
30:    Behavior on color {
40:    enabled: root.interactive
46:## Plugin manifest
48:Every plugin ships a `manifest.json` describing what it is and how the
96:Entry points may declare `omarchyPath`, `shell`, `manifest`, `pluginRegistry`, and `barWidgetRegistry` properties for host injection. Built-in plugins receive the trusted host objects. Third-party plugins receive capability-scoped facades: ordinary plugins can look up and control only their own service and lifecycle, built-in clones retain narrow source-specific configuration and UI compatibility, menu plugins receive an application-library facade, and plugins can read detached scalar bar state. A full-bar plugin additionally receives detached bar configuration and widget-catalog snapshots, narrow proxies for the non-authentication services used by built-in bar widgets, and lifecycle control over configured non-authentication UI plugins. Authentication capabilities are stamped from trusted first-party manifests, authentication services are retained outside the host's public service map and QML object tree, and changing a third-party registry or configuration snapshot cannot mutate host state. Facades do not isolate visual widgets from the parent hierarchy of the shared QML scene, so sensitive state must remain outside that reachable graph.
104:A plugin is a **git repo** with a `manifest.json` at its root. Adding one
106:manifest id); updating is a fast-forward pull of that checkout.
127:files, validates the manifest, and toggles enabled state over shell IPC. Since
135:1. Put it in `~/.config/omarchy/plugins/<plugin-id>/` with a `manifest.json`
261:   to use the built-in bar. Set it to another plugin id whose manifest declares
277:6. **Multiple instances** are allowed when a manifest sets
ls: cannot access '~/.config/omarchy/plugins': No such file or directory
/usr/bin/omarchy-plugin-validate
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 40,100p README.md; sed -n 125,300p README.md`

✓ 76 ms

```text
[exit 0, 67 ms]
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
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn -A6 "StdioCollector" plugins | head -30; grep -n "id\b\|idPattern\|RegExp\|test(" services/PluginRegistry.qml | head -20`

✓ 141 ms

```text
[exit 0, 133 ms]
plugins/agents/Main.qml:29:    stdout: StdioCollector {
plugins/agents/Main.qml-30-      waitForEnd: true
plugins/agents/Main.qml-31-      onStreamFinished: root.applyAgentListing(text)
plugins/agents/Main.qml-32-    }
plugins/agents/Main.qml-33-  }
plugins/agents/Main.qml-34-
plugins/agents/Main.qml-35-  function rescanAgents() {
--
plugins/agents/Main.qml:140:    stderr: StdioCollector {
plugins/agents/Main.qml-141-      waitForEnd: true
plugins/agents/Main.qml-142-      onStreamFinished: if (text.trim() !== "") console.warn("agents", text.trim())
plugins/agents/Main.qml-143-    }
plugins/agents/Main.qml-144-  }
plugins/agents/Main.qml-145-
plugins/agents/Main.qml-146-  function updateCommand(kind, agentIds) {
--
plugins/agents/Main.qml:337:    stdout: StdioCollector {
plugins/agents/Main.qml-338-      waitForEnd: true
plugins/agents/Main.qml-339-      onStreamFinished: root.parseSyncScanOutput(text)
plugins/agents/Main.qml-340-    }
plugins/agents/Main.qml-341-
plugins/agents/Main.qml:342:    stderr: StdioCollector {
plugins/agents/Main.qml-343-      waitForEnd: true
plugins/agents/Main.qml-344-      onStreamFinished: if (text.trim() !== "") console.warn("agents/sync", text.trim())
plugins/agents/Main.qml-345-    }
plugins/agents/Main.qml-346-  }
plugins/agents/Main.qml-347-
plugins/agents/Main.qml-348-  FileView {
--
plugins/background/Background.qml:126:    stdout: StdioCollector {
8:  id: registry
31:  signal pluginLoadFailed(string id, string error)
32:  signal localPluginChanged(string id)
52:    var required = ["id", "name", "version", "kinds", "entryPoints"]
59:    var id = String(manifest.id)
60:    if (!id || id.indexOf("/") !== -1 || id.indexOf("..") !== -1 || id.charAt(0) === "/") {
61:      console.warn("PluginRegistry: invalid plugin id '" + id + "' at " + sourcePath)
76:        console.warn("PluginRegistry: invalid barWidget.defaultSection at " + sourcePath)
135:  // Enabled = the plugin id is referenced somewhere in shell.json. That can
…
```

Now I'll write the plugin. I'm calling it `parker.disk-free`, following the username-prefix convention.

**⏺ bash** `mkdir -p .config/omarchy/plugins/parker.disk-free && cd .config/omarchy/plugins/parker.disk-free && cat > manifest.json <<'EOF'
{
  "schemaVersion": 1,
  "id": "parker.disk-free",
  "name": "Disk free",
  "version": "1.0.0",
  "author": "parker",
  "description": "Free space left on the root filesys`

✓ 2444 ms

```text
[exit 0, 2177 ms]
```

Fixing a stale comment, then adding the widget to the bar (backing up shell.json first).

**⏺ bash** `cd .config/omarchy && sed -i 's|// warnPercent (default 10%). Left click opens a disk usage view in btop.|// warnPercent (default 10%). Clicking refreshes immediately.|' plugins/parker.disk-free/BarWidget.qml && cp shell.json shell.json.bak.$(date +%s) && python3 - <<'EOF'
import json
p='shell.json'`

✓ 2915 ms

```text
[exit 0, 2900 ms]
57:          "id": "parker.disk-free",
```

**⏺ check** `build`

✓ 5167 ms

```text
[exit 0, 4870 ms]
plugin parker.disk-free  (~/.config/omarchy/plugins/parker.disk-free)
  barWidget: BarWidget.qml: loaded; drew: 116G free
    picture: ~/.h0-preview/parker.disk-free-barWidget.png
PREVIEW: ok
```

The plugin loads and draws text. A quick check of the numbers it's working from:

**⏺ bash** `df -B1 --output=avail,size / ; df -h /`

✓ 100 ms

```text
[exit 0, 95 ms]
       Avail     1B-blocks
124907438080 1022042832896
Filesystem        Size  Used Avail Use% Mounted on
/dev/mapper/root  952G  833G  117G  88% /
```

I built the plugin and added it to the right side of your bar, just left of the brightness/display widget. In the offscreen preview it showed **"116G free"** for your root drive.

**What it does**
- Every 60 seconds it runs `df` on `/` and shows the free space, like "116G free". When the bar is vertical it drops the word "free" to save room.
- When less than 10% is left, the text turns your theme's red color.
- Hovering shows a tooltip with the free space, total size and percentage. Clicking refreshes it straight away.
- In `shell.json` you can change which drive it watches (`path`), how often it updates in seconds (`interval`) and the red threshold (`warnPercent`).

**Files**
- New: `.config/omarchy/plugins/parker.disk-free/manifest.json` and `BarWidget.qml`.
- Edited: `.config/omarchy/shell.json`, where I added one entry to the right section of the bar. A backup was saved first as `shell.json.bak.<timestamp>`.

**Checks**
- The project's `build` check passed: the JSON is valid, Omarchy's plugin validator accepted it, and the plugin loaded in Quickshell and drew its text.
- I compared the number against `df`: 124,907,438,080 bytes free out of 952G, which is **116G**. `df -h` shows 117G only because it rounds up.

**Not checked**
- I didn't see the red text, because your drive isn't below 10%. It's **about 12% free**, so the text will turn red after roughly another 20G is used. To test it now, temporarily set `"warnPercent": 50` on the entry in `shell.json`.
- I couldn't check it on your running desktop from here. The shell should pick it up on its own; if the widget doesn't appear, run `omarchy-shell shell rescanPlugins`.

*harness: verify check `build` passed*

