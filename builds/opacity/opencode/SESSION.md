# opencode building Window Opacity

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools opencode

---

### › You

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

**⏺ skill** `{"id": "omarchy"}`

✓ 252 ms

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

✓ 559 ms

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

**⏺ read** `~/.agents/skills/omarchy/hyprland.md`

✓ 544 ms

```text
Read file ~/.agents/skills/omarchy/hyprland.md, lines 1-78
1: # Hyprland Configuration
2: 
3: Read this before changing keybindings, monitors, window rules, or any other
4: Hyprland (window manager) configuration.
5: 
6: Omarchy configures Hyprland in Lua. User files are loaded after Omarchy's
7: defaults, so overrides go here:
8: 
9: ```
10: ~/.config/hypr/
11: ├── hyprland.lua       # Main config (loads Omarchy defaults, then user files)
12: ├── bindings.lua       # Keybindings
13: ├── monitors.lua       # Display configuration
14: ├── input.lua          # Keyboard/mouse settings
15: ├── looknfeel.lua      # Appearance (gaps, borders, animations)
16: ├── autostart.lua      # Startup applications
17: ├── hyprsunset.conf    # Night light / blue light filter
18: └── xdph.conf          # Screen sharing / desktop portal
19: ```
20: 
21: **Key behaviors (the `.lua` files):**
22: - Hyprland auto-reloads on config save (no restart needed for most changes)
23: - Use `hyprctl reload` to force reload
24: - After ANY Hyprland Lua config change, validate with `hyprctl reload` followed by `hyprctl configerrors`
25: - If `hyprctl configerrors` reports errors, address them and rerun validation until clean or until a real blocker is identified
26: - Use `omarchy refresh hyprland` to reset the Lua config files to defaults
27: 
28: The two `.conf` files are read by separate processes, so `hyprctl` neither
29: applies nor validates them:
30: - `hyprsunset.conf` (night light): apply changes with `omarchy restart hyprsunset`; reset with `omarchy refresh hyprsunset`
31: - `xdph.conf` (screen-sharing portal): applies when the portal restarts, e.g. on next login
32: 
33: ## Keybindings
34: 
35: Edit `~/.config/hypr/bindings.lua`. Format:
36: ```lua
37: o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")
38: o.bind("SUPER + B", "Browser", { launch = "chromium" })  -- launch wraps with uwsm-app
39: ```
…
```

Now let me look at the actual system: plugin structure, existing plugins, and current opacity config.

**⏺ shell** `{"command": "echo $OMARCHY_PATH; ls /usr/share/omarchy/shell/ /usr/share/omarchy/shell/plugins/ ~/.config/omarchy/ ~/.config/omarchy/plugins/ 2>&1; cat ~/.config/omarchy/shell.json; omarchy plugin --h`

✓ 1214 ms

```text
/usr/share/omarchy
ls: cannot access '~/.config/omarchy/plugins/': No such file or directory
~/.config/omarchy/:
extensions
hooks
shell.json
themed
themes

/usr/share/omarchy/shell/:
Commons
README.md
Ui
plugins
services
shell.qml

/usr/share/omarchy/shell/plugins/:
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
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  },
…
```

**⏺ shell** `{"command": "echo $HOME; cat /usr/share/omarchy/shell/plugins/README.md; cat /usr/share/omarchy/shell/README.md | head -150"}`

✓ 538 ms

```text
~
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

**⏺ shell** `{"command": "sed -n 150,400p /usr/share/omarchy/shell/README.md; ls -R /usr/share/omarchy/shell/plugins/panels/ /usr/share/omarchy/shell/plugins/bar | head -80"}`

✓ 750 ms

```text
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
| `toggle <id> <payloadJson>`              | —       | summon if closed, hide if open                        |
| `call <id> <method> <arg>`               | string  | call a method on an already-loaded plugin             |
| `rescanPlugins`                          | —       | re-walk plugin dirs and hot-reload plugin code        |
| `reloadConfig`                           | `ok`    | reload `~/.config/omarchy/shell.json`                 |
| `setPluginEnabled <id> <enabled>`        | `ok` / `unknown` | flip the persisted enabled bit (see note)    |
…
```

The audio panel has sliders, so it's the closest model. Let me read it.

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins/panels/audio; cat manifest.json; wc -l Panel.qml Model.js; cat Panel.qml"}`

✓ 560 ms

```text
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
 1248 Panel.qml
  262 Model.js
 1510 total
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import qs.Ui
import qs.Commons
import "Model.js" as Model

Panel {
  id: root
  moduleName: "omarchy.audio"
  ipcTarget: "omarchy.audio"

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var source: Pipewire.defaultAudioSource
…
```

Let me look at the shared UI base components (`Panel`, `PanelSlider`) and how plugin settings are persisted.

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; ls Ui Commons services; cat Ui/Panel.qml; cat Ui/PanelSlider.qml"}`

✓ 612 ms

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

Now how do plugins persist their own settings? Let me check the facade API and how widgets get loaded.

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -rn \"function \" services/PluginShellApi.qml Ui/PluginBarApi.qml | head -60; grep -rn -i \"setSetting\\|updateSetting\\|saveSetting\\|persistSetting\\|s`

✓ 984 ms

```text
services/PluginShellApi.qml:30:  function serviceFor(id) {
services/PluginShellApi.qml:36:  function firstPartyServiceFor(id) {
services/PluginShellApi.qml:41:  function pluginShellForBarEntry(ownerId, moduleName) {
services/PluginShellApi.qml:46:  function summon(id, payloadJson) {
services/PluginShellApi.qml:50:  function hide(id) {
services/PluginShellApi.qml:54:  function toggle(id, payloadJson) {
services/PluginShellApi.qml:58:  function isPluginOpen(id) {
services/PluginShellApi.qml:62:  function updateEntryInline(id, settings) {
services/PluginShellApi.qml:66:  function mutateShellConfig(mutator) {
Ui/PluginBarApi.qml:44:  function setCenterHoverRevealSuppressed(value) {
Ui/PluginBarApi.qml:48:  function showTooltip(target, text) {
Ui/PluginBarApi.qml:52:  function hideTooltip(target) {
Ui/PluginBarApi.qml:56:  function registerClickTarget(target) {
Ui/PluginBarApi.qml:60:  function unregisterClickTarget(target) {
Ui/PluginBarApi.qml:64:  function requestPopout(owner) {
Ui/PluginBarApi.qml:68:  function releasePopout(owner) {
Ui/PluginBarApi.qml:72:  function switchPanelFrom(owner, direction) {
Ui/PluginBarApi.qml:76:  function targetBelongsToWindow(target, window) {
Ui/PluginBarApi.qml:80:  function moduleWidgets(id) {
Ui/PluginBarApi.qml:84:  function run(command) {
./plugins/panels/clock/Panel.qml:154:  function persistSettings(values) {
./plugins/panels/clock/Panel.qml:168:    persistSettings({ weekStartDay: Model.weekStartSettingName(next) })
./plugins/panels/clock/Panel.qml:207:    persistSettings({ birthYear: 0 })
./plugins/panels/clock/Panel.qml:214:      persistSettings({ birthYear: born, lifeExpectancy: span })
./services/PluginShellApi.qml:27:  property var _updateSettings: null
./services/PluginShellApi.qml:63:    return _updateSettings ? _updateSettings(String(id || ""), settings) : false
./shell.qml:648:      _updateSettings: function(requestedId, settings) {
./shell.qml:726:      _updateSettings: function(requestedId, settings) {
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; cat services/PluginShellApi.qml; sed -n 140,165p plugins/panels/clock/Panel.qml; sed -n 620,760p shell.qml; cat Ui/PluginBarApi.qml | head -45"}`

✓ 897 ms

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

Persistence works via `bar.shell.updateEntryInline()` into `shell.json`. Now let me check Hyprland's current opacity setup and whether `hyprctl keyword` works with the Lua config.

**⏺ shell** `{"command": "hyprctl version | head -3; hyprctl getoption decoration:active_opacity; hyprctl getoption decoration:inactive_opacity; grep -rn -i \"opacity\" /usr/share/omarchy/default/hypr/ ~/.config/h`

✓ 851 ms

```text
HYPRLAND_INSTANCE_SIGNATURE not set! (is hyprland running?)

HYPRLAND_INSTANCE_SIGNATURE not set! (is hyprland running?)

HYPRLAND_INSTANCE_SIGNATURE not set! (is hyprland running?)

/usr/share/omarchy/default/hypr/apps/browser.lua:4:o.window({ tag = "chromium-based-browser" }, { tag = "-default-opacity", tile = true, opacity = "1.0 0.985" })
/usr/share/omarchy/default/hypr/apps/browser.lua:5:o.window({ tag = "firefox-based-browser" }, { tag = "-default-opacity", opacity = "1.0 0.985" })
/usr/share/omarchy/default/hypr/apps/browser.lua:7:-- Video apps: remove chromium browser tag so they don't get opacity applied.
/usr/share/omarchy/default/hypr/apps/browser.lua:9:o.window("(^.+-youtube\\.com__.*$|^.+-app\\.zoom\\.us__wc_home.*$)", { tag = "-default-opacity" })
/usr/share/omarchy/default/hypr/apps/davinci-resolve.lua:6:  tag = "-default-opacity",
/usr/share/omarchy/default/hypr/apps/davinci-resolve.lua:7:  opacity = "1 1",
/usr/share/omarchy/default/hypr/apps/hermes.lua:3:  tag = "-default-opacity",
/usr/share/omarchy/default/hypr/apps/hermes.lua:6:  opacity = "1 1",
/usr/share/omarchy/default/hypr/apps/omarchy-shell.lua:9:-- QML opacity transition for normal open/close, and skip it for panel handoff.
/usr/share/omarchy/default/hypr/apps/pip.lua:4:  tag = "-default-opacity",
/usr/share/omarchy/default/hypr/apps/pip.lua:10:  opacity = "1 1",
/usr/share/omarchy/default/hypr/apps/pip.lua:16:  tag = "-default-opacity",
/usr/share/omarchy/default/hypr/apps/pip.lua:22:  opacity = "1 1",
/usr/share/omarchy/default/hypr/apps/qemu.lua:1:o.window("qemu", { tag = "-default-opacity", opacity = "1 1" })
/usr/share/omarchy/default/hypr/apps/retroarch.lua:3:  tag = "-default-opacity",
/usr/share/omarchy/default/hypr/apps/retroarch.lua:4:  opacity = "1 1",
/usr/share/omarchy/default/hypr/apps/steam.lua:3:o.window("steam.*", { tag = "-default-opacity", opacity = "1 1" })
/usr/share/omarchy/default/hypr/apps/system.lua:43:    tag = "-default-opacity",
/usr/share/omarchy/default/hypr/apps/system.lua:49:    opacity = "1 1",
/usr/share/omarchy/default/hypr/apps/webcam-overlay.lua:19:  tag = "-default-opacity",
/usr/share/omarchy/default/hypr/apps/webcam-overlay.lua:24:  opacity = "1 1",
/usr/share/omarchy/default/hypr/windows.lua:5:-- Tag all windows for default opacity (apps can override with -default-opacity tag).
/usr/share/omarchy/default/hypr/windows.lua:6:o.window(".*", { tag = "+default-opacity" })
/usr/share/omarchy/default/hypr/windows.lua:21:-- App-specific tweaks (may remove default-opacity tag).
/usr/share/omarchy/default/hypr/windows.lua:24:-- Apply default opacity after apps have had a chance to opt out.
/usr/share/omarchy/default/hypr/windows.lua:25:o.window({ tag = "default-opacity" }, { opacity = "0.985 0.96" })
```

Hyprland isn't running in this environment, so I can't test live. Let me see how existing Omarchy code changes Hyprland settings at runtime (since the config is Lua, `hyprctl keyword` may differ).

**⏺ shell** `{"command": "cd /usr/share/omarchy; grep -rn \"hyprctl keyword\\|hyprctl eval\\|hl\\.config\\|hyprctl --batch\\|getoption\" bin/ shell/ default/hypr/*.lua 2>/dev/null | head -30; ls default/hypr/"}`

✓ 956 ms

```text
shell/Commons/Style.qml:16:// shell picks them up by re-running `hyprctl getoption` on startup and
shell/Commons/Style.qml:444:    command: ["hyprctl", "-j", "getoption", "decoration:rounding"]
shell/Commons/Style.qml:453:    command: ["hyprctl", "-j", "getoption", "general:gaps_out"]
default/hypr/envs.lua:41:hl.config({
default/hypr/input.lua:50:hl.config({
default/hypr/looknfeel.lua:6:hl.config({
default/hypr/looknfeel.lua:91:hl.config({
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
looknfeel.lua
nvidia.lua
omarchy.lua
paths.lua
require_all.lua
require_optional.lua
toggles
toggles.lua
windows.lua
workspace-layouts.lua
```

**⏺ shell** `{"command": "cd /usr/share/omarchy; ls default/hypr/toggles; cat default/hypr/toggles.lua | head -60; grep -rln \"hyprctl\" bin/ | head -40"}`

✓ 690 ms

```text
flags.lua
single-window-aspect-ratio.lua
window-no-gaps.lua
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
```

**⏺ shell** `{"command": "cd /usr/share/omarchy; grep -rl \"hyprctl\" bin/ | head -40; cat default/hypr/toggles/window-no-gaps.lua"}`

✓ 603 ms

```text
-- Remove all window gaps and borders.
hl.config({
  general = {
    gaps_out = 0,
    gaps_in = 0,
    border_size = 0,
  },

  decoration = {
    rounding = 0,
  },
})
```

**⏺ shell** `{"command": "cd /usr/share/omarchy; ls bin | head -5; ls bin | wc -l; grep -l \"hyprctl\" bin/* 2>/dev/null | head; grep -rn \"hyprctl\" bin/omarchy-toggle* 2>/dev/null | head -20; which hyprctl"}`

✓ 1120 ms

```text
omarchy
omarchy-agent
omarchy-agent-crash
omarchy-agent-prompt
omarchy-agent-usage-claude
441
bin/omarchy-bar-text-color
bin/omarchy-brightness-display
bin/omarchy-capture-region
bin/omarchy-capture-screenrecording
bin/omarchy-capture-screenshot
bin/omarchy-capture-webcam-resize
bin/omarchy-cmd-terminal-cwd
bin/omarchy-hw-touchpad
bin/omarchy-hw-touchscreen
bin/omarchy-hyprland-focus-app
bin/omarchy-toggle-input-device:48:  hyprctl eval "hl.device({ name = \"$quoted\", enabled = $enabled })" >/dev/null
bin/omarchy-toggle-nightlight:14:  output=$(hyprctl hyprsunset temperature 2>/dev/null) || return
bin/omarchy-toggle-nightlight:54:  hyprctl hyprsunset temperature $TARGET_TEMP >/dev/null 2>&1
/usr/bin/hyprctl
```

Omarchy uses `hyprctl eval "hl.config(...)"` for runtime changes. Let me confirm with more examples.

**⏺ shell** `{"command": "cd /usr/share/omarchy; grep -rn \"hyprctl eval\\|hyprctl keyword\" bin/ shell/ | head -20; hyprctl --help 2>&1 | grep -i -E \"eval|keyword|getoption|batch\""}`

✓ 657 ms

```text
    eval <code>         → Issue a Lua string to execute
    getoption <option>  → Gets the config option status (values)
    keyword <name> <value> → Issue a keyword to call a config keyword
    --batch             → Execute a batch of commands, separated by ';'
```

**⏺ shell** `{"command": "cd /usr/share/omarchy; sed -n 30,60p bin/omarchy-toggle-input-device; grep -rn \"rawEvent\\|configreloaded\" shell/ | head -10; cat /usr/share/omarchy/default/hypr/looknfeel.lua | sed -n `

✓ 793 ms

```text
device="$("omarchy-hw-$KIND")"

require_device() {
  if [[ -z $device ]]; then
    echo "No $KIND device found" >&2
    exit 1
  fi

  if [[ $device == *[[:cntrl:]]* ]]; then
    echo "Invalid $KIND device name" >&2
    exit 1
  fi
}

apply_device() {
  local enabled=$1
  local quoted=${device//\\/\\\\}
  quoted=${quoted//\"/\\\"}
  hyprctl eval "hl.device({ name = \"$quoted\", enabled = $enabled })" >/dev/null
}

enable() {
  # Clear the persisted state before requiring a usable device, so a device
  # that stops reporting a valid name can never wedge the disable in place.
  rm -f "$NAME_FILE"
  require_device
  apply_device true
  omarchy-osd -i "$ICON" -m "$LABEL enabled"
}

disable() {
shell/plugins/bar/widgets/KeyboardLayout.qml:100:      if (name.indexOf("activelayout") !== -1 || name === "configreloaded") root.refresh()
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

local active_border_color = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 }
local inactive_border_color = "rgba(595959aa)"

hl.config({
  general = {
    gaps_in = 5,
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; sed -n 1,130p plugins/bar/widgets/KeyboardLayout.qml; cat plugins/bar/widgets/KeyboardLayout.manifest.json"}`

✓ 749 ms

```text
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui
import qs.Commons
import "KeyboardLayoutModel.js" as KeyboardLayoutModel

BarWidget {
  id: root
  moduleName: "omarchy.keyboard-layout"


  property string layoutFull: ""
  // The keyboard the last reading spoke for, which is the one a click switches,
  // and separately the one activelayout named as being typed on. A reading
  // confirms the first is really there, so the click has a keyboard to reach
  // from the first reading onwards rather than only after a switch, and stops
  // naming one that has been unplugged.
  property string keyboardName: ""
  property string typedKeyboardName: ""
  // Keyboards on the seat, buttons and virtual ones excluded, and whether the
  // last reading left that shape in doubt.
  property int keyboardCount: 0
  property bool keyboardUnresolved: false
  // Nothing to read or switch on the single-layout install most people run, so
  // the widget ships on the bar and stays out of the way until there are two.
  // An older Hyprland that doesn't report the list keeps showing the label.
  property bool multipleLayouts: true
  // Short language code per layout description ("English (US)": "en"), read from
  // xkb's own table rather than maintained by hand.
  property var layoutBriefs: ({})
  readonly property string layoutLabel: KeyboardLayoutModel.shortLabel(layoutFull, layoutBriefs)

  // A query already in flight was started before this event, so it may read the
  // layout the switch replaced. Remember the request and re-run once it lands
  // rather than dropping it; nothing else would correct the label afterwards.
  property bool refreshPending: false

  function refresh() {
…
```

Let me check how the bar instantiates third-party widgets (which properties get injected), plus `KeyboardPanel`.

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n \"settings\\|moduleName\\|createObject\\|setSource\\|pluginBarApi\\|PluginBarApi\" plugins/bar/Bar.qml | head -50"}`

✓ 901 ms

```text
27:  // settings and persisting inline widget state.
112:  property var pluginBarApis: ({})
116:    id: pluginBarApiComponent
117:    PluginBarApi { }
124:  function bindPluginBarApi(api) {
138:    root.syncPluginBarApiObjects(api)
141:  function syncPluginBarApiObjects(api) {
203:  function syncAllPluginBarApiObjects() {
204:    for (var id in pluginBarApis) root.syncPluginBarApiObjects(pluginBarApis[id])
229:  function pluginBarApiFor(pluginId, moduleName, registered) {
237:      pluginShell = root.shell.pluginShellForId(moduleName)
242:      pluginShell = root.shell.pluginShellForBarEntry(key, moduleName)
245:    if (pluginBarApis[key]) {
246:      pluginBarApis[key].shell = pluginShell
247:      return pluginBarApis[key]
250:    var api = pluginBarApiComponent.createObject(null, {
252:      moduleName: String(moduleName || ""),
263:        return String(requestedId || "") === String(moduleName || "")
264:          ? root.moduleWidgets(moduleName) : []
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
365:        id: slot.moduleName,
591:    // settings, patch the live layout and running widgets in place instead.
606:      var settings = entrySettings(change.entry)
609:        if (!slot || slot.region !== change.region || slot.moduleName !== entryId(change.entry)) continue
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; sed -n 225,280p plugins/bar/Bar.qml; grep -n \"loader\\|Loader\\|\\.setSource\\|initialProps\\|bar:\\s*\\|settings:\" plugins/bar/Bar.qml | sed -n 1,40p"}`

✓ 1246 ms

```text
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
          ? root.moduleWidgets(moduleName) : []
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; cat Ui/BarIconButton.qml | head -60; sed -n 1,80p Ui/KeyboardPanel.qml"}`

✓ 626 ms

```text
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

Let me find a small panel to model the structure on, plus `PanelKeyCatcher`'s signals.

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; wc -l plugins/panels/*/Panel.qml; grep -n \"signal\" Ui/PanelKeyCatcher.qml Ui/CursorSurface.qml; grep -n \"property\" Ui/CursorSurface.qml Ui/PanelSectionHea`

✓ 960 ms

```text
  1248 plugins/panels/audio/Panel.qml
  1045 plugins/panels/bluetooth/Panel.qml
   762 plugins/panels/clock/Panel.qml
   151 plugins/panels/disk-speedtest/Panel.qml
   547 plugins/panels/dropbox/Panel.qml
   929 plugins/panels/monitor/Panel.qml
  1970 plugins/panels/network/Panel.qml
   536 plugins/panels/power/Panel.qml
   202 plugins/panels/speedtest/Panel.qml
  1273 plugins/panels/tailscale/Panel.qml
   881 plugins/panels/weather/Panel.qml
   369 plugins/panels/wifiqr/Panel.qml
  9913 total
Ui/PanelKeyCatcher.qml:4:// and emits semantic signals so each panel keeps its own state machine
Ui/PanelKeyCatcher.qml:32:// triggering signals.
Ui/PanelKeyCatcher.qml:38:  signal moveRequested(int dx, int dy)
Ui/PanelKeyCatcher.qml:39:  signal activateRequested()
Ui/PanelKeyCatcher.qml:40:  signal returnRequested()
Ui/PanelKeyCatcher.qml:41:  signal closeRequested()
Ui/PanelKeyCatcher.qml:42:  signal deleteRequested()
Ui/PanelKeyCatcher.qml:43:  signal tabRequested(int direction)
Ui/PanelKeyCatcher.qml:44:  signal textKey(string text)
Ui/CursorSurface.qml:17:  property bool hasCursor: false
Ui/CursorSurface.qml:18:  property bool current: false
Ui/CursorSurface.qml:19:  property bool outline: false
Ui/CursorSurface.qml:20:  property bool bordered: false
Ui/CursorSurface.qml:22:  property color foreground: Color.foreground
Ui/CursorSurface.qml:23:  property color accent: Color.accent
Ui/CursorSurface.qml:24:  property color fill: Style.hoverFillFor(foreground, accent)
Ui/CursorSurface.qml:25:  property color currentFill: Style.selectedFillFor(foreground, accent)
Ui/PanelSectionHeader.qml:10:  property color foreground: Color.foreground
Ui/PanelSectionHeader.qml:11:  property string fontFamily: Style.font.family
Ui/PanelSectionHeader.qml:12:  property real fontSize: Style.font.caption
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell/plugins/panels; cat speedtest/manifest.json; cat speedtest/Panel.qml | head -120; grep -rn \"rescanPlugins\\|validate\" /usr/share/omarchy/bin/omarchy-plugin-v`

✓ 1281 ms

```text
{
  "schemaVersion": 1,
  "id": "omarchy.speedtest",
  "name": "Speed Test",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Internet speed test with download and upload dials",
  "kinds": [
    "panel"
  ],
  "entryPoints": {
    "panel": "Panel.qml"
  }
}
import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

// The shared gauge-cluster overlay (SpeedTestOverlay) dressed for the
// internet speed test: download and upload dials in Mbps, titled with the
// connection under test.
//
// Standalone panel plugin: summoning it starts a fresh run, dismissing it
// stops the traffic, so the download workers never keep saturating the link
// behind a closed overlay. The payload may carry the connection's display
// name -- {"connection": "MyWifi"} -- and the panel looks it up itself via
// omarchy-network-status when the caller doesn't know it.
Item {
  id: root

  property var shell: null
  property var manifest: null

  property bool opened: false
  property string connectionName: ""

  property bool running: false
  property bool expectedStop: false
  property bool pendingRun: false
…
```

Let me check how `getoption -j` output is parsed in Style.qml, the manifest schema for bar widgets, and my username for the plugin id.

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; whoami; sed -n 435,480p Commons/Style.qml; grep -n \"barWidget\\.\\|defaultSection\\|\\\"schema\\\"\\|icon\" services/PluginRegistry.qml | head -30"}`

✓ 940 ms

```text
parker
    fontOverrides = fontOut
    barOverrides = barOut
    barScaleWithFont = nextBarScaleWithFont
    spacingOverrides = spacingOut
    styleOverrides = styleOut
  }

  property Process hyprctlProc: Process {
    id: hyprctlProc
    command: ["hyprctl", "-j", "getoption", "decoration:rounding"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.applyRoundingJson(text)
    }
  }

  property Process gapsOutProc: Process {
    id: gapsOutProc
    command: ["hyprctl", "-j", "getoption", "general:gaps_out"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.applyGapsOutJson(text)
    }
  }

  // Resolve the fontconfig alias to a concrete family name. `omarchy font
  // set <name>` rewrites ~/.config/fontconfig/fonts.conf and restarts the
  // shell, but rerun on file change anyway so manual edits propagate too.
  function resolveFontFamily() {
    fcMatchProc.running = true
  }

  property Process fcMatchProc: Process {
    id: fcMatchProc
    command: ["fc-match", "-f", "%{family[0]}", "monospace"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var name = String(text || "").trim()
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n \"applyRoundingJson\" -A12 Commons/Style.qml | head -20; sed -n 1,80p Ui/BarWidget.qml | grep -n \"property\\|function\""}`

✓ 748 ms

```text
359:  function applyRoundingJson(raw) {
360-    try {
361-      var json = JSON.parse(raw || "{}")
362-      var n = Number(json.int)
363-      if (isFinite(n) && n >= 0) cornerRadius = n
364-    } catch (e) {
365-      // hyprctl missing / Hyprland not running — leave the previous value.
366-    }
367-  }
368-
369-  function applyGapsOutJson(raw) {
370-    try {
371-      var json = JSON.parse(raw || "{}")
--
447:      onStreamFinished: root.applyRoundingJson(text)
448-    }
449-  }
450-
451-  property Process gapsOutProc: Process {
452-    id: gapsOutProc
15:  property QtObject bar: null
16:  property string moduleName: ""
17:  property var settings: ({})
22:  readonly property bool vertical: bar ? bar.vertical : false
23:  readonly property int barSize: bar ? bar.barSize : Style.bar.sizeHorizontal
29:  function broadcast(method) {
30:    var items = bar && typeof bar.moduleWidgets === "function"
33:      if (items[i] && typeof items[i][method] === "function") items[i][method]()
41:  function setting(name, fallback) {
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; sed -n 1838,1900p plugins/bar/Bar.qml"}`

✓ 509 ms

```text
    Loader {
      id: componentLoader
      active: !slot.qmlCustom && !slot.registered
      sourceComponent: slot.commandCustom ? customCommandModuleComponent : emptyModuleComponent
      anchors.fill: parent
      opacity: slot.dragSource ? 0.22 : 1.0
      onLoaded: {
        slot.injectProps()
        Qt.callLater(slot.injectProps)
      }
    }

    Loader {
      id: registryLoader
      active: slot.registered
      sourceComponent: slot.registered ? slot.registryComponent : null
      anchors.fill: parent
      opacity: slot.dragSource ? 0.22 : 1.0
      onLoaded: {
        slot.injectProps()
        Qt.callLater(slot.injectProps)
      }
    }

    Loader {
      id: qmlLoader
      active: slot.qmlCustom
      source: slot.qmlCustom ? root.customModuleSource(slot.entry) : ""
      anchors.fill: parent
      opacity: slot.dragSource ? 0.22 : 1.0
      onLoaded: {
        slot.injectProps()
        Qt.callLater(slot.injectProps)
      }
    }

    Rectangle {
      id: openPanelIndicator

      readonly property int inset: Style.space(2)
…
```

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n \"function injectProps\" -A30 plugins/bar/Bar.qml"}`

✓ 597 ms

```text
1999:    function injectProps() {
2000-      var target = activeItem
2001-      if (!target) return
2002-      if ("bar" in target) target.bar = firstParty
2003-        ? root : root.pluginBarApiFor(pluginApiId, moduleName, registered)
2004-      if ("moduleName" in target) target.moduleName = moduleName
2005-      if ("settings" in target) target.settings = moduleSettings
2006-    }
2007-
2008-    Component {
2009-      id: customCommandModuleComponent
2010-      CustomCommandModule { entry: slot.entry }
2011-    }
2012-  }
2013-
2014-  component CustomCommandModule: WidgetButton {
2015-    id: customRoot
2016-
2017-    required property var entry
2018-    readonly property string moduleName: root.entryId(entry)
2019-    readonly property var settings: root.entrySettings(entry)
2020-    property string outputText: ""
2021-    property string outputTooltip: ""
2022-    property bool outputActive: false
2023-
2024-    function setting(name, fallback) {
2025-      var value = settings ? settings[name] : undefined
2026-      return value === undefined || value === null ? fallback : value
2027-    }
2028-
2029-    function update(raw) {
```

I have enough context on the plugin API. One last check on `WidgetButton` (tooltip/pressed API) before writing.

**⏺ shell** `{"command": "cd /usr/share/omarchy/shell; grep -n \"property\\|signal\" Ui/WidgetButton.qml | head -40; grep -n \"function fitted\" Ui/KeyboardPanel.qml; grep -n \"property\\|signal\" Ui/ToggleSwitch.`

✓ 884 ms

```text
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
161:  function fittedContentWidth(width, cap) {
168:  function fittedContentHeight(implicitHeight, cap) {
30:  property bool checked: false
31:  property bool busy: false
34:  property bool interactive: true
38:  property bool hasCursor: false
40:  property bool cursorRing: interactive
41:  property int cursorPad: Style.space(6)
…
```

Now writing the plugin. Settings are stored in your bar entry in `shell.json`, and the widget re-applies them to Hyprland when the shell starts and after any Hyprland config reload.

**⏺ write** `~/.config/omarchy/plugins/parker.window-opacity/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.window-opacity",
  "name": "Window opacity",
  "version": "1.0.0",
  "author": "parker",
  "description": "Live sliders for Hyprland focused and unfocused window opacity",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Panel.qml"
  },
  "barWidget": {
    "displayName": "Window opacity",
    "description": "Live sliders for Hyprland focused and unfocused window opacity",
    "category": "Compositor",
    "allowMultiple": false,
    "defaultSection": "right"
  }
}
```

✓ 2297 ms

```text
Created file successfully: .config/omarchy/plugins/parker.window-opacity/manifest.json
```

**⏺ write** `~/.config/omarchy/plugins/parker.window-opacity/Panel.qml`

```
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui
import qs.Commons

// Bar button + popup with two sliders driving Hyprland's
// decoration:active_opacity and decoration:inactive_opacity live.
//
// The chosen values are stored inline on this widget's shell.json entry
// (activeOpacity / inactiveOpacity). Runtime changes made with `hyprctl eval`
// are lost when Hyprland restarts or reloads its config, so the widget
// re-applies the saved values whenever it loads and after every
// `configreloaded` event.
Panel {
  id: root
  moduleName: "parker.window-opacity"
  ipcTarget: "parker.window-opacity"

  readonly property real minOpacity: 0.2
  readonly property real step: 0.05

  property real activeOpacity: 1.0
  property real inactiveOpacity: 1.0
  // True once there is a saved preference to enforce. Until then the sliders
  // just mirror whatever Hyprland is currently configured with.
  property bool hasSaved: false

  // Keyboard cursor: 0 = focused slider, 1 = unfocused slider.
  property int selectedIndex: 0
  property bool cursorActive: false

  readonly property bool dragging: activeSlider.dragging || inactiveSlider.dragging

  function clamp(v) {
    return Math.round(Math.max(minOpacity, Math.min(1, v)) * 100) / 100
  }

  function savedValue(name) {
    var raw = setting(name, null)
    if (raw === null || raw === "") return NaN
    var v = Number(raw)
    return isFinite(v) ? clamp(v) : NaN
  }

  function loadSettings() {
    if (dragging) return
    var a = savedValue("activeOpacity")
    var i = savedValue("inactiveOpacity")
    if (isFinite(a) || isFinite(i)) {
      if (isFinite(a)) activeOpacity = a
      if (isFinite(i)) inactiveOpacity = i
      hasSaved = true
      applyNow()
    } else if (!hasSaved) {
      readCurrent()
    }
  }

… (285 more lines in the repository)
```

✓ 27260 ms

```text
Created file successfully: .config/omarchy/plugins/parker.window-opacity/Panel.qml
```

Small fix: make the sliders fill their holder (they'd otherwise sit at the top), and debounce saves so mouse-wheel scrolling doesn't rewrite `shell.json` on every tick.

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.window-opacity && python3 - <<'EOF'\np='Panel.qml'\ns=open(p).read()\ns=s.replace(\"\"\"            bar: root.bar\n            width: parent.width\n   `

✓ 2002 ms

```text
121:    persistTimer.restart()
186:    anchors.fill: parent
206:      anchors.fill: parent
254:            anchors.fill: parent
260:            onReleased: function(v) { root.setActive(v); persistTimer.restart() }
272:            anchors.fill: parent
278:            onReleased: function(v) { root.setInactive(v); persistTimer.restart() }
332:        anchors.fill: parent
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.window-opacity; omarchy plugin validate . ; echo \"exit=$?\"; which qmllint qmllint6 /usr/lib/qt6/bin/qmllint 2>/dev/null"}`

✓ 832 ms

```text
exit=0
~/.local/bin/qmllint
/usr/lib/qt6/bin/qmllint
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.window-opacity; /usr/lib/qt6/bin/qmllint -I /usr/share/omarchy/shell Panel.qml 2>&1 | grep -v -i \"unqualified\\|import\\|warning: .*not found\\|Info\"`

✓ 1262 ms

```text
^^^^^^
---
---

^^^^^^
---
---

  BarIconButton {
  ^^^^^^^^^^^^^
        PanelSeparator {
        ^^^^^^^^^^^^^^
          PanelSlider {
          ^^^^^^^^^^^
          PanelSlider {
          ^^^^^^^^^^^
      PanelSectionHeader {
      ^^^^^^^^^^^^^^^^^^
    CursorSurface {
    ^^^^^^^^^^^^^
  KeyboardPanel {
  ^^^^^^^^^^^^^
    PanelKeyCatcher {
    ^^^^^^^^^^^^^^^
Warning: Panel.qml:16:1: Panel is part of an inheritance cycle: Panel -> Panel [inheritance-cycle]
Panel {
^^^^^
    anchors.fill: parent
    ^^^^^^^
      anchors.fill: parent
      ^^^^^^^
            anchors.fill: parent
            ^^^^^^^
            anchors.fill: parent
            ^^^^^^^
        anchors.left: parent.left
        ^^^^^^^
Warning: Panel.qml:16:1: Type Panel is used but it is not resolved [unresolved-type]
Panel {
^^^^^
```

**⏺ shell** `{"command": "cd ~/.config/omarchy/plugins/parker.window-opacity; mv Panel.qml OpacityWidget.qml; sed -i 's/\"barWidget\": \"Panel.qml\"/\"barWidget\": \"OpacityWidget.qml\"/' manifest.json; grep barWi`

✓ 1787 ms

```text
    "barWidget": "OpacityWidget.qml"
  "barWidget": {
valid
Warning: OpacityWidget.qml:186:5: unknown grouped property scope anchors. [unqualified]
Warning: OpacityWidget.qml:206:7: unknown grouped property scope anchors. [unqualified]
Warning: OpacityWidget.qml:254:13: unknown grouped property scope anchors. [unqualified]
Warning: OpacityWidget.qml:272:13: unknown grouped property scope anchors. [unqualified]
Warning: OpacityWidget.qml:305:9: unknown grouped property scope anchors. [unqualified]
Warning: OpacityWidget.qml:249:19: Cannot assign binding of type PanelSlider to QQuickItem [incompatible-type]
Warning: OpacityWidget.qml:267:19: Cannot assign binding of type PanelSlider to QQuickItem [incompatible-type]
Warning: OpacityWidget.qml:312:37: Member "liveValue" not found on type "QQuickItem" [missing-property]
```

The remaining warnings all come from qmllint not being able to see the shell's `qs.Ui` types (`PanelSlider` etc.). The manifest validates. Now let me enable it in the bar.

**⏺ shell** `{"command": "omarchy-shell shell ping 2>&1 | tail -2; omarchy plugin enable parker.window-opacity 2>&1 | tail -5"}`

✓ 667 ms

```text
omarchy-shell is not running
omarchy-shell is not running
```

The shell isn't running in this session, so I'll add the widget to the bar layout in `shell.json` directly. For third-party plugins, being listed there is what enables them.

**⏺ shell** `{"command": "cp ~/.config/omarchy/shell.json ~/.config/omarchy/shell.json.bak.$(date +%s); omarchy bar put parker.window-opacity --after omarchy.audio 2>&1 | tail -3; python3 -c \"import json,os;print`

✓ 5192 ms

```text
omarchy-shell is not running; parker.window-opacity was not put on the bar
[{'id': 'omarchy.tray'}, {'id': 'omarchy.agents'}, {'id': 'omarchy.bluetooth'}, {'id': 'omarchy.network'}, {'id': 'omarchy.audio'}, {'id': 'omarchy.monitor'}, {'id': 'omarchy.power'}]
```

**⏺ edit** `~/.config/omarchy/shell.json`

```
        {
          "id": "omarchy.audio"
        },
        {
          "id": "parker.window-opacity"
        },
```

✓ 1318 ms

```text
Edited .config/omarchy/shell.json (1 replacement)
```

**⏺ shell** `{"command": "python3 -m json.tool ~/.config/omarchy/shell.json >/dev/null && echo json-ok; ls ~/.config/omarchy/plugins/parker.window-opacity"}`

✓ 798 ms

```text
json-ok
OpacityWidget.qml
manifest.json
```

I've built the plugin and added it to your bar, but I couldn't try it live: neither Hyprland nor the Omarchy shell is running in this session. The manifest passes `omarchy plugin validate`. The rest is untested, and the first real test will be when the shell loads it.

**What I created**
- `~/.config/omarchy/plugins/parker.window-opacity/manifest.json`: the plugin description.
- `~/.config/omarchy/plugins/parker.window-opacity/OpacityWidget.qml`: the bar icon and the panel.
- `~/.config/omarchy/shell.json`: added `parker.window-opacity` to the right side of the bar, just after the audio icon. I saved a backup as `shell.json.bak.<timestamp>`.

**How it works**
- **Bar icon:** click it to open the panel. Hovering shows both current values.
- **Panel:** one slider for the focused window and one for unfocused windows, each showing a percentage. Both go from 20% to 100% in 5% steps. The lower limit stops a window from becoming invisible.
- **Live changes:** moving a slider changes Hyprland's opacity settings straight away.
- **Keyboard:** the arrow keys move between the sliders and adjust them, matching the audio panel.
- **Saving:** your values are saved to the widget's entry in `shell.json` shortly after you release a slider or stop pressing keys.
- **After a restart:** when the shell starts, the plugin applies your saved values again. It also does this after Hyprland reloads its config (for example, when you save a Hypr file or change theme), since a reload would otherwise reset them.
- **Before you save anything:** the sliders show Hyprland's current values.

**Good to know**
- **The sliders multiply with Omarchy's built-in transparency.** Omarchy already makes most windows slightly see-through (98.5% focused, 96% unfocused), so the result is your slider value times that. Browsers and media apps like video, games and VMs have their own built-in settings; some of these stay fully solid.

**To check it**
Next time you log in, or after `omarchy restart shell`, the icon should appear next to the audio icon. If it doesn't, run `omarchy-shell shell rescanPlugins`.

