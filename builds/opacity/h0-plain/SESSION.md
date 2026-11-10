# h0, plain building Window Opacity

Rendered from the session's recorded trace (`trace.jsonl`), not from a screen capture. Workspace paths are shown as `~`; tool output is cut to its first 40 lines.

Model `claude-opus-5-5` · fitting `none` · tools read, edit, write, grep, glob, bash

---

### › You

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

I'll start by looking at what's in the project and how Omarchy shell plugins are structured.

**⏺ bash** `ls -la; find . -maxdepth 4 -not -path './.git*' | head -100`

✓ 336 ms

```text
[exit 0, 329 ms]
total 0
drwxr-xr-x 1 parker parker  68 Nov  9 16:45 .
drwx------ 3 parker parker  60 Nov  9 16:45 ..
drwxr-xr-x 1 parker parker  12 Nov  9 16:45 .agents
drwxr-xr-x 1 parker parker  12 Nov  9 16:45 .claude
drwxr-xr-x 1 parker parker  12 Nov  9 16:45 .codex
drwxr-xr-x 1 parker parker  72 Nov  8 22:07 .config
drwxr-xr-x 1 parker parker 160 Nov  9 16:45 .git
drwxr-xr-x 1 parker parker  10 Nov  9 16:45 .pi
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

**⏺ bash** `find .agents .claude .codex .pi -type f -o -type l | head; cat .config/omarchy/shell.json; cat .config/hypr/looknfeel.lua .config/hypr/hyprland.lua`

✓ 70 ms

```text
[exit 0, 65 ms]
.agents/skills/omarchy
.agents/skills/diagnose-crash
.claude/skills/omarchy
.claude/skills/diagnose-crash
.codex/skills/omarchy
.pi/agent/skills/omarchy
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
…
```

The skills are symlinks; let me see where they point and read the Omarchy skill.

**⏺ bash** `ls -la .agents/skills/ .claude/skills/; readlink -f .agents/skills/omarchy; ls -la "$(readlink -f .agents/skills/omarchy)" 2>&1; echo $OMARCHY_PATH; ls /usr/share/omarchy 2>&1 | head`

✓ 72 ms

```text
[exit 0, 67 ms]
.agents/skills/:
total 8
drwxr-xr-x 1 parker parker 42 Nov  9 16:45 .
drwxr-xr-x 1 parker parker 12 Nov  9 16:45 ..
lrwxrwxrwx 1 parker parker 55 Nov  9 16:45 diagnose-crash -> /usr/share/omarchy/default/agents/skills/diagnose-crash
lrwxrwxrwx 1 parker parker 48 Nov  9 16:45 omarchy -> /usr/share/omarchy/default/agents/skills/omarchy

.claude/skills/:
total 8
drwxr-xr-x 1 parker parker 42 Nov  9 16:45 .
drwxr-xr-x 1 parker parker 12 Nov  9 16:45 ..
lrwxrwxrwx 1 parker parker 55 Nov  9 16:45 diagnose-crash -> /usr/share/omarchy/default/agents/skills/diagnose-crash
lrwxrwxrwx 1 parker parker 48 Nov  9 16:45 omarchy -> /usr/share/omarchy/default/agents/skills/omarchy
/usr/share/omarchy/default/agents/skills/omarchy
total 40
drwxr-xr-x 1 nobody nobody   144 Oct 13 11:12 .
drwxr-xr-x 1 nobody nobody    42 Aug 30 11:54 ..
-rw-r--r-- 1 nobody nobody 13248 Sep 15 14:04 SKILL.md
-rw-r--r-- 1 nobody nobody  2217 Sep 15 14:04 capture.md
-rw-r--r-- 1 nobody nobody  2385 Sep 15 14:04 contributing.md
-rw-r--r-- 1 nobody nobody  1063 Sep 15 14:04 hooks.md
-rw-r--r-- 1 nobody nobody  3376 Sep 15 14:04 hyprland.md
-rw-r--r-- 1 nobody nobody  1820 Sep 15 14:04 plugins.md
-rw-r--r-- 1 nobody nobody  3245 Sep 15 14:04 theming.md

applications
bin
config
default
etc-overrides
icon.png
icon.txt
install
logo.svg
logo.txt
```

**⏺ bash** `cd /usr/share/omarchy/default/agents/skills/omarchy; cat SKILL.md plugins.md hyprland.md`

✓ 74 ms

```text
[exit 0, 67 ms]
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
- User-facing `omarchy` commands (`omarchy theme ...`, `omarchy refresh ...`, `omarchy restart ...`, etc.)
- Screenshots, screen recording, reminders, night light, idle behavior, lock screen

**If you're about to edit a config file in ~/.config/ on this system, STOP and use this skill first.**

**Do NOT use this skill for Omarchy development tasks** (editing the Omarchy source tree, creating migrations, or running `omarchy dev ...` workflows).

## Topic Guides
…
```

Now let me look at how built-in shell plugins are written, especially ones with a bar widget and a popup panel.

**⏺ bash** `cd /usr/share/omarchy/shell; ls; ls plugins; find plugins -maxdepth 2 | head -80; ls ~/.. 2>/dev/null; ls /usr/share/omarchy/shell/plugins/*/ | head -60`

✓ 111 ms

```text
[exit 0, 93 ms]
Commons
README.md
Ui
plugins
services
shell.qml
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
plugins
plugins/agents
plugins/agents/assets
plugins/agents/Agent.qml
plugins/agents/Main.qml
plugins/agents/Panel.qml
plugins/agents/README.md
plugins/agents/manifest.json
plugins/background
plugins/background/Background.qml
plugins/background/manifest.json
plugins/bar
plugins/bar/indicators
plugins/bar/widgets
plugins/bar/Bar.qml
plugins/bar/BarModel.js
plugins/bar/README.md
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; cat README.md plugins/README.md`

✓ 93 ms

```text
[exit 0, 70 ms]
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

Let me study a built-in bar widget that opens a popup with a slider (audio is the closest match), plus the bar README.

**⏺ bash** `cd /usr/share/omarchy/shell/plugins; ls -R panels/audio panels/monitor panels/power; cat panels/audio/manifest.json; cat bar/README.md | head -150`

✓ 83 ms

```text
[exit 0, 71 ms]
panels/audio:
Model.js
Panel.qml
manifest.json

panels/monitor:
Model.js
Panel.qml
manifest.json

panels/power:
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
# Omarchy bar

This is the Quickshell implementation of the Omarchy status bar. It is
shipped as a first-party plugin of [`omarchy-shell`](../../README.md), the
long-running shell host. The bar is mounted at startup and lives inside
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/plugins/panels; cat monitor/manifest.json; wc -l monitor/* audio/*; cat monitor/Panel.qml`

✓ 113 ms

```text
[exit 0, 94 ms]
{
  "schemaVersion": 1,
  "id": "omarchy.monitor",
  "name": "Display",
  "version": "1.0.0",
  "author": "Omarchy",
  "description": "Brightness slider and laptop display controls",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Panel.qml"
  },
  "barWidget": {
    "displayName": "Display",
    "description": "Brightness slider and laptop display controls",
    "category": "System",
    "allowMultiple": false
  }
}
  124 monitor/Model.js
  929 monitor/Panel.qml
   20 monitor/manifest.json
  262 audio/Model.js
 1248 audio/Panel.qml
   20 audio/manifest.json
 2603 total
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons
import "Model.js" as Model

Panel {
  id: root
  moduleName: "omarchy.monitor"
  ipcTarget: "omarchy.monitor"
…
```

The output got cut off in the middle where the brightness slider is. Let me read that section and the shared `Panel` UI component.

**⏺ bash** `cd /usr/share/omarchy/shell; ls Ui Commons; grep -n "Slider\|bar\.\|panelContent\|contentComponent\|PanelSlider\|icon\b\|iconText\|tooltip" plugins/panels/monitor/Panel.qml | head -80`

✓ 51 ms

```text
[exit 0, 46 ms]
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
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 330,560p plugins/panels/monitor/Panel.qml`

✓ 55 ms

```text
[exit 0, 48 ms]
  // (which may be an off-notch value set from the CLI).
  function displayedTextPx() {
    return textSizePreviewIndex >= 0 ? textSizeStops[textSizePreviewIndex] : Style.font.baseSize
  }

  function setTextSize(px) {
    textScaleProc.command = ["omarchy-display-text-size", String(px)]
    if (!textScaleProc.running) textScaleProc.running = true
  }

  function adjustTextSize(deltaSteps) {
    var idx = currentTextIndex() + deltaSteps
    if (idx < 0) idx = 0
    if (idx > textSizeStops.length - 1) idx = textSizeStops.length - 1
    markReflowing()
    textSizePreviewIndex = idx
    setTextSize(textSizeStops[idx])
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Component.onCompleted: refresh()

  // KeyboardPanel primes focus at open-time, so SUPER-bound IPC summons land
  // with j/k ready to navigate. Keep a default landing point, but don't paint
  // the cursor until hover or the first navigation key.
  onOpenedChanged: {
    if (opened) {
      refresh()
      if (brightnessAvailable) {
        focusSection = "brightness"
        selectedIndex = -1
      } else {
        focusSection = "scale"
        selectedIndex = 0
      }
      cursorActive = false
    }
…
```

**⏺ bash** `cd /usr/share/omarchy/shell; sed -n 560,660p plugins/panels/monitor/Panel.qml; echo ------; cat Ui/PanelSlider.qml; echo -----; cat Ui/Panel.qml`

✓ 73 ms

```text
[exit 0, 66 ms]

              Text {
                id: heroLabel
                textFormat: Text.PlainText
                text: {
                  if (root.brightnessAvailable) {
                    return root.brightnessName(brightnessSlider.dragging ? brightnessSlider.liveValue : root.brightnessPercent).toUpperCase()
                  }
                  return "FIXED BRIGHTNESS"
                }
                color: Qt.darker(root.bar.foreground, 1.4)
                font.family: root.bar.fontFamily
                font.pixelSize: Style.font.caption
                font.bold: true
                font.letterSpacing: 1.2
                elide: Text.ElideRight
                width: parent.width
              }
            }
          }

          // ---------- Brightness ----------
          PanelSeparator {
            visible: root.brightnessAvailable
            foreground: root.bar.foreground
          }

          Column {
            visible: root.brightnessAvailable
            width: parent.width
            spacing: Style.space(6)

            Item {
              width: parent.width
              implicitHeight: Math.max(brightnessHeader.implicitHeight, brightnessPercent.implicitHeight)

              PanelSectionHeader {
                id: brightnessHeader
                text: "BRIGHTNESS"
…
```

Next I'll check how plugins persist settings, how Omarchy applies runtime Hyprland changes (toggles), and whether `hyprctl` is reachable from here.

**⏺ bash** `cd /usr/share/omarchy; cat default/hypr/toggles.lua; ls default/hypr; grep -rn "opacity" default/hypr | head -20`

✓ 126 ms

```text
[exit 0, 105 ms]
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
…
```

**⏺ bash** `which hyprctl Hyprland quickshell omarchy-shell 2>&1; hyprctl version 2>&1 | head -5; echo "HIS=$HYPRLAND_INSTANCE_SIGNATURE"; ls /usr/share/omarchy/bin | grep -i -E "toggle|opacity|transparen" `

✓ 100 ms

```text
[exit 0, 93 ms]
/usr/bin/hyprctl
/usr/bin/Hyprland
/usr/bin/quickshell
/usr/bin/omarchy-shell
HYPRLAND_INSTANCE_SIGNATURE not set! (is hyprland running?)

HIS=
omarchy-hyprland-toggle
omarchy-hyprland-toggle-disabled
omarchy-hyprland-toggle-enabled
omarchy-hyprland-window-gaps-toggle
omarchy-hyprland-window-single-square-aspect-toggle
omarchy-hyprland-window-tiled-fullscreen-toggle
omarchy-hyprland-window-transparency-toggle
omarchy-hyprland-workspace-layout-toggle
omarchy-toggle
omarchy-toggle-bar
omarchy-toggle-crash-capture
omarchy-toggle-enabled
omarchy-toggle-hybrid-gpu
omarchy-toggle-idle
omarchy-toggle-input-device
omarchy-toggle-nightlight
omarchy-toggle-notification-silencing
omarchy-toggle-screensaver
omarchy-toggle-suspend
omarchy-toggle-touchpad
omarchy-toggle-touchscreen
```

No Hyprland is running in this sandbox, so I can't test live changes here. Let me see how Omarchy's existing transparency toggle and default-opacity rule work, so the plugin cooperates with them.

**⏺ bash** `cd /usr/share/omarchy; cat bin/omarchy-hyprland-window-transparency-toggle bin/omarchy-hyprland-toggle; cat default/hypr/windows.lua; ls default/hypr/toggles; grep -n "opacity\|decoration" -A3 default/hypr/looknfeel.lua | head -40`

✓ 181 ms

```text
[exit 0, 96 ms]
#!/bin/bash

# omarchy:summary=Toggles transparency for the currently focused window.

addr=$(hyprctl activewindow -j | jq -r '.address')
hyprctl dispatch "hl.dsp.window.set_prop({ window = \"address:$addr\", prop = \"opaque\", value = \"toggle\" })" >/dev/null 2>&1 || \
  hyprctl dispatch setprop "address:$addr" opaque toggle
#!/bin/bash

# omarchy:summary=Toggle permanent Hyprland flags by copying them into a directory that's sourced entirely.
# omarchy:args=<flag-name> [on|off|toggle]

usage() {
  echo "Usage: omarchy-hyprland-toggle <flag-name> [on|off|toggle]" >&2
}

if (($# < 1)); then
  usage
  exit 1
fi

FLAG_NAME="$1"
ACTION="${2:-toggle}"
FLAG_FILE="$HOME/.local/state/omarchy/toggles/hypr/$FLAG_NAME.lua"
FLAG_SOURCE="$OMARCHY_PATH/default/hypr/toggles/$FLAG_NAME.lua"

on() {
  if [[ -f $FLAG_SOURCE ]]; then
    mkdir -p "$(dirname "$FLAG_FILE")"
    cp "$FLAG_SOURCE" "$FLAG_FILE"
  else
    echo "Flag not found: $FLAG_NAME" >&2
    exit 1
  fi
}

off() {
  rm -f "$FLAG_FILE"
}
…
```

**⏺ bash** `hyprctl --help 2>&1 | head -60; grep -rln "hyprctl.*\(keyword\|eval\|hl\.config\)" /usr/share/omarchy/bin | head; `

✓ 70 ms

```text
[exit 0, 65 ms]
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
…
```

**⏺ bash** `grep -rn "hyprctl eval\|hyprctl keyword\|hl.config" /usr/share/omarchy/bin /usr/share/omarchy/shell 2>/dev/null | head -20`

✓ 346 ms

```text
[exit 0, 320 ms]
```

**⏺ bash** `grep -rn "hyprctl" /usr/share/omarchy/bin | grep -v "dispatch\|activewindow\|clients\|monitors\|reload\|-j" | head -20; grep -rln "eval" /usr/share/omarchy/bin | xargs grep -n "hyprctl" | head`

✓ 109 ms

```text
[exit 0, 99 ms]
```

**⏺ bash** `grep -rhoE "hyprctl [a-z]+[^|;)]{0,80}" /usr/share/omarchy/bin /usr/share/omarchy/shell | sort | uniq -c | sort -rn | head -40`

✓ 131 ms

```text
[exit 0, 126 ms]
      2 hyprctl missing / Hyprland not running — leave the previous value.
      1 hyprctl switchxkblayout " + Util.shellQuote(root.keyboardName
      1 hyprctl reports as the active keymap:
      1 hyprctl reflects
      1 hyprctl hyprsunset temperature " + Number(temp
      1 hyprctl gives the old value. 200ms is
      1 hyprctl gets to speak for the seat.
      1 hyprctl getoption` on startup and
      1 hyprctl forever for an answer that cannot change.
      1 hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" }
      1 hyprctl command rather than a dispatcher, so it has to
```

Very few Omarchy scripts call `hyprctl` for config changes. Let me check how the shell itself talks to Hyprland (`getoption`, Quickshell's `Hyprland` module).

**⏺ bash** `cd /usr/share/omarchy/shell; grep -rn "getoption\|Hyprland\.dispatch\|import Quickshell.Hyprland\|\"hyprctl\"" . | head -20`

✓ 251 ms

```text
[exit 0, 246 ms]
./Commons/Style.qml:16:// shell picks them up by re-running `hyprctl getoption` on startup and
./Commons/Style.qml:444:    command: ["hyprctl", "-j", "getoption", "decoration:rounding"]
./Commons/Style.qml:453:    command: ["hyprctl", "-j", "getoption", "general:gaps_out"]
./Ui/PopupCard.qml:3:import Quickshell.Hyprland
./plugins/bar/widgets/KeyboardLayout.qml:3:import Quickshell.Hyprland
./plugins/bar/widgets/KeyboardLayout.qml:106:    command: ["hyprctl", "-j", "devices"]
./plugins/bar/widgets/Workspaces.qml:3:import Quickshell.Hyprland
./plugins/bar/Bar.qml:2:import Quickshell.Hyprland
./plugins/panels/monitor/Panel.qml:303:    actionProc.command = ["hyprctl", "keyword", "monitor", name + (enabled ? ",disable" : ",preferred,auto,auto")]
./plugins/services/idle/Service.qml:3:import Quickshell.Hyprland
./plugins/services/nightlight/Service.qml:57:    command: ["hyprctl", "hyprsunset", "temperature"]
```

**⏺ bash** `cd /usr/share/omarchy/default/hypr; cat bootstrap.lua require_all.lua paths.lua; sed -n 1,40p looknfeel.lua`

✓ 88 ms

```text
[exit 0, 49 ms]
-- Hyprland bootstrap for Omarchy's Lua module path.

local home = os.getenv("HOME")
local reload_prefixes = {
  "default.hypr",
  "hypr",
  "omarchy.current.theme",
}

local function should_reload_module(module)
  for _, prefix in ipairs(reload_prefixes) do
    if module == prefix or module:sub(1, #prefix + 1) == prefix .. "." then
      return true
    end
  end

  return false
end

local modules_to_reload = {}
for module in pairs(package.loaded) do
  if should_reload_module(module) then
    table.insert(modules_to_reload, module)
  end
end

for _, module in ipairs(modules_to_reload) do
  package.loaded[module] = nil
end

-- Load generated state from ~/.local/state, user modules from ~/.config, and
-- Omarchy defaults from $OMARCHY_PATH.
package.path = home
  .. "/.local/state/?.lua;"
  .. home
  .. "/.config/?.lua;"
  .. (os.getenv("OMARCHY_PATH") or "/usr/share/omarchy")
  .. "/?.lua;"
  .. package.path
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/services; ls; wc -l *.qml; grep -n "schemaVersion\|required\|kinds\|entryPoints\|isValidId\|idPattern\|RegExp\|userPluginDir\|plugins/" PluginRegistry.qml | head -60`

✓ 116 ms

```text
[exit 0, 110 ms]
AppLibrary.qml
AppSearch.js
AuthServiceStore.js
BarWidgetRegistry.qml
PluginAppLibraryApi.qml
PluginBarStateApi.qml
PluginBarWidgetRegistryApi.qml
PluginFirstPartyServiceApi.qml
PluginRegistry.qml
PluginRegistryApi.qml
PluginShellApi.qml
hidden-entries.sh
  268 AppLibrary.qml
   49 BarWidgetRegistry.qml
   46 PluginAppLibraryApi.qml
   12 PluginBarStateApi.qml
   24 PluginBarWidgetRegistryApi.qml
   46 PluginFirstPartyServiceApi.qml
  743 PluginRegistry.qml
   32 PluginRegistryApi.qml
   70 PluginShellApi.qml
 1290 total
48:    if (manifest.schemaVersion !== 1) {
49:      console.warn("PluginRegistry: unsupported schemaVersion at " + sourcePath)
52:    var required = ["id", "name", "version", "kinds", "entryPoints"]
53:    for (var i = 0; i < required.length; i++) {
54:      if (manifest[required[i]] === undefined) {
55:        console.warn("PluginRegistry: missing required field '" + required[i] + "' at " + sourcePath)
64:    if (!Array.isArray(manifest.kinds) || manifest.kinds.length === 0) {
65:      console.warn("PluginRegistry: kinds must be a non-empty array at " + sourcePath)
68:    if (!Util.isPlainObject(manifest.entryPoints)) {
69:      console.warn("PluginRegistry: entryPoints must be an object at " + sourcePath)
82:    for (var key in manifest.entryPoints) {
83:      if (!isSafeEntryPoint(manifest.entryPoints[key])) {
85:          + manifest.entryPoints[key] + "' at " + sourcePath)
120:    var ep = manifest.entryPoints ? manifest.entryPoints[kind] : null
153:      if (Array.isArray(manifest.kinds) && manifest.kinds.indexOf("bar") !== -1) {
432:      if (Array.isArray(candidateManifest.kinds) && candidateManifest.kinds.indexOf("bar") !== -1) {
443:    var isBarOption = cloneManifest && Array.isArray(cloneManifest.kinds)
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/services; sed -n 40,160p PluginRegistry.qml; grep -n "userPlugin\|\.config/omarchy/plugins\|pluginRoots\|scanDir\|validId\|function isValid" PluginRegistry.qml ../shell.qml | head`

✓ 52 ms

```text
[exit 0, 47 ms]
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
      console.warn("PluginRegistry: entryPoints must be an object at " + sourcePath)
      return null
    }
    if (manifest.barWidget !== undefined && Util.isPlainObject(manifest.barWidget)
        && manifest.barWidget.defaultSection !== undefined) {
      var defaultSection = String(manifest.barWidget.defaultSection)
      if (["left", "center", "right"].indexOf(defaultSection) === -1) {
        console.warn("PluginRegistry: invalid barWidget.defaultSection at " + sourcePath)
        return null
      }
…
```

**⏺ bash** `cd /usr/share/omarchy/shell/services; sed -n 680,743p PluginRegistry.qml; cat PluginShellApi.qml`

✓ 81 ms

```text
[exit 0, 74 ms]
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
    var script = ""
      + "emit_manifest() { local kind=\"$1\"; local manifest=\"$2\"; local sub; "
      + "  if [[ ${manifest##*/} == \"manifest.json\" ]]; then sub=\"${manifest%/manifest.json}\"; else sub=\"$(dirname -- \"$manifest\")\"; fi; "
      + "  printf '===%s::%s===\\n' \"$kind\" \"$sub\"; "
      + "  cat \"$manifest\"; "
      + "  printf '\\n=== EOM ===\\n'; "
      + "}; "
      + "scan_firstparty() { local dir=\"$1\"; "
      + "  [[ -d \"$dir\" ]] || return 0; "
      + "  while IFS= read -r manifest; do emit_manifest firstparty \"$manifest\"; done < <(find \"$dir\" -mindepth 2 -maxdepth 3 -type f \\( -name manifest.json -o -name '*.manifest.json' \\) | sort); "
      + "}; "
      + "scan_thirdparty() { local dir=\"$1\"; "
      + "  [[ -d \"$dir\" ]] || return 0; "
      + "  for sub in \"$dir\"/*/; do "
      + "    [[ -f \"$sub/manifest.json\" ]] || continue; "
      + "    emit_manifest thirdparty \"$sub/manifest.json\"; "
      + "  done; "
      + "}; "
      + "scan_firstparty \"$0\"; "
      + "scan_thirdparty \"$1\""
…
```

Let me confirm third-party plugins outside the shell tree can `import qs.Ui`. The clone command copies built-in panels as-is, so I'll check whether it rewrites imports.

**⏺ bash** `ls /usr/share/omarchy/bin | grep plugin; grep -n "qs\.\|sed\|import" /usr/share/omarchy/bin/omarchy-plugin-clone | head -20`

✓ 72 ms

```text
[exit 0, 67 ms]
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
42:        sed -i "s|$source_pattern|$target|g" "$file"
```

**⏺ bash** `sed -n 1,80p /usr/share/omarchy/bin/omarchy-plugin-clone; echo ----; cat /usr/share/omarchy/bin/omarchy-plugin-validate`

✓ 112 ms

```text
[exit 0, 106 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/BarIconButton.qml; grep -n "property\|signal" Ui/KeyboardPanel.qml Ui/PanelKeyCatcher.qml | head -60`

✓ 55 ms

```text
[exit 0, 48 ms]
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

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "moduleName\|\"settings\"\|settings:\|\.bar = \|bar:\|setProperty\|createObject\|pluginShell\|shell:" plugins/bar/Bar.qml | head -40`

✓ 52 ms

```text
[exit 0, 46 ms]
22:  // `bar:` subtree: position, centerAnchor, layout. The host owns file IO;
28:  property var shell: null
229:  function pluginBarApiFor(pluginId, moduleName, registered) {
233:    var pluginShell = null
234:    if (registered && root.shell && typeof root.shell.pluginShellForId === "function") {
237:      pluginShell = root.shell.pluginShellForId(moduleName)
238:    } else if (root.shell && typeof root.shell.pluginShellForBarEntry === "function") {
242:      pluginShell = root.shell.pluginShellForBarEntry(key, moduleName)
246:      pluginBarApis[key].shell = pluginShell
250:    var api = pluginBarApiComponent.createObject(null, {
252:      moduleName: String(moduleName || ""),
253:      shell: pluginShell,
263:        return String(requestedId || "") === String(moduleName || "")
264:          ? root.moduleWidgets(moduleName) : []
365:        id: slot.moduleName,
521:        if (!Util.isPlainObject(config.bar)) config.bar = {}
609:        if (!slot || slot.region !== change.region || slot.moduleName !== entryId(change.entry)) continue
611:        if (item && "settings" in item) item.settings = settings
634:        if (!slot || slot.region !== region || slot.moduleName !== id) continue
658:    return slot ? String(slot.moduleName || "") : ""
702:      if (!slot || !slot.activeItem || slot.moduleName !== id) continue
733:      if (slot.moduleName !== id) continue
851:        if (!Util.isPlainObject(config.bar)) config.bar = {}
860:    if (!Util.isPlainObject(config.bar)) config.bar = {}
902:    if (!source || !source.region || !source.moduleName || !toRegion) return false
903:    if (source.region === toRegion && source.moduleName === beforeName) return false
908:      changed = moveModuleInConfig(config, source.region, source.moduleName, toRegion, beforeName)
950:      if (!slot || slot === sourceSlot || slot.region !== region || slot.moduleName !== name ||
978:    var beforeName = afterTarget ? nextVisibleModuleName(targetSlot.region, targetSlot.moduleName, sourceSlot) : targetSlot.moduleName
1778:    readonly property string moduleName: root.entryId(entry)
1781:    readonly property var registryMetadata: root.barWidgetRegistry.metadataFor(root.canonicalWidgetId(moduleName))
1783:    readonly property string pluginApiId: registered ? root.canonicalWidgetId(moduleName) : "bar-entry:" + moduleName
1790:      var registryName = root.canonicalWidgetId(moduleName)
2002:      if ("bar" in target) target.bar = firstParty
2003:        ? root : root.pluginBarApiFor(pluginApiId, moduleName, registered)
2004:      if ("moduleName" in target) target.moduleName = moduleName
2005:      if ("settings" in target) target.settings = moduleSettings
2018:    readonly property string moduleName: root.entryId(entry)
2019:    readonly property var settings: root.entrySettings(entry)
…
```

Third-party widgets receive a `PluginBarApi` facade as `bar`, not the real bar. I need to confirm that facade has what `KeyboardPanel` / `BarIconButton` / `PanelSlider` read from it.

**⏺ bash** `cd /usr/share/omarchy/shell; cat Ui/PluginBarApi.qml; grep -on "bar\.[a-zA-Z]*" Ui/KeyboardPanel.qml Ui/WidgetButton.qml Ui/PanelSlider.qml Ui/CursorSurface.qml Ui/PanelSectionHeader.qml Ui/PanelSeparator.qml Ui/PopupCard.qml | awk -F: '{print $1":"$3}' | sort -u`

✓ 78 ms

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

The facade covers everything those components read. Let me check `WidgetButton`'s tooltip/click/scroll API and the `Style` tokens I'll use.

**⏺ bash** `cd /usr/share/omarchy/shell; grep -n "property\|signal\|sizeHorizontal" Ui/WidgetButton.qml | head -50; grep -n "wheelSteps" -A12 Commons/Util.qml | head -20; grep -n "readonly property var font\|display:\|title:\|caption:\|body:\|function space" Commons/Style.qml | head`

✓ 95 ms

```text
[exit 0, 89 ms]
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
20:  function wheelSteps(accumulator, delta) {
21-    // Some mouse/compositor combinations scale a single notch well beyond
22-    // Qt's conventional 120 units. Keep one event to one step while still
23-    // accumulating the smaller deltas emitted by touchpads.
24-    delta = Math.max(-120, Math.min(120, delta))
25-    if (accumulator * delta < 0) accumulator = 0
26-    var total = accumulator + delta
…
```

Everything the widget needs is on the facade. Before writing the code I'll check two details: hyprctl's batch flag, and the codepoint for an "opacity" icon in the installed Nerd Font.

**⏺ bash** `hyprctl --help 2>&1 | sed -n 60,90p; fc-list | grep -i "nerd" | head -3; python3 -c "import fontTools; print('fonttools ok')" 2>&1; which jq qmllint qmllint6 /usr/lib/qt6/bin/qmllint 2>&1 | grep -v "no "`

✓ 359 ms

```text
[exit 0, 327 ms]

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
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Italic.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Italic
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Bold.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Bold
/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf: JetBrainsMono Nerd Font,JetBrainsMono NF:style=Regular
Traceback (most recent call last):
  File "<string>", line 1, in <module>
    import fontTools; print('fonttools ok')
    ^^^^^^^^^^^^^^^^
ModuleNotFoundError: No module named 'fontTools'
/usr/bin/jq
~/.local/bin/qmllint
/usr/lib/qt6/bin/qmllint
```

**⏺ bash** `for cp in f05c8 f1853; do echo "$cp: $(fc-list ":charset=$cp" family | grep -ci nerd)"; done; python3 - <<'EOF'
# Read glyph names from the post table (format 2) to confirm what U+F05C8 is.
import struct
f=open('/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf','rb').read()
n=struct.unpack('>H`

✓ 3227 ms

```text
[exit 0, 3217 ms]
f05c8: 1
f1853: 1
0xf05c8 md-format_line_style
0xf1853 md-circle_opacity
```

**⏺ bash** `git status --short; git log --oneline | head -3; grep -n "function fittedContent" /usr/share/omarchy/shell/Ui/KeyboardPanel.qml; grep -n "property" /usr/share/omarchy/shell/Ui/CursorSurface.qml | head; grep -n "pressed(" /usr/share/omarchy/shell/Ui/WidgetButton.qml`

✓ 387 ms

```text
[exit 0, 376 ms]
 D .config/omarchy/themes/ember/README.md
 D .config/omarchy/themes/ember/colors.toml
 D .config/omarchy/themes/ember/hyprland.lua
 D .config/omarchy/themes/ember/icons.theme
 D .config/omarchy/themes/ember/install.sh
 D .config/omarchy/themes/ember/neovim.lua
?? .agents/
?? .claude/
?? .codex/
?? .pi/
133a829 h0: task baseline
161:  function fittedContentWidth(width, cap) {
168:  function fittedContentHeight(implicitHeight, cap) {
17:  property bool hasCursor: false
18:  property bool current: false
19:  property bool outline: false
20:  property bool bordered: false
22:  property color foreground: Color.foreground
23:  property color accent: Color.accent
24:  property color fill: Style.hoverFillFor(foreground, accent)
25:  property color currentFill: Style.selectedFillFor(foreground, accent)
32:  signal pressed(int button)
37:    root.pressed(button)
```

The deleted `ember` theme files were already like that before I started; I'll leave them alone. Writing the plugin now: manifest first, then the widget and panel.

**⏺ write** `.config/omarchy/plugins/parker.window-opacity/manifest.json`

```
{
  "schemaVersion": 1,
  "id": "parker.window-opacity",
  "name": "Window opacity",
  "version": "1.0.0",
  "author": "parker",
  "description": "Live sliders for Hyprland's focused and unfocused window opacity",
  "kinds": [
    "bar-widget"
  ],
  "entryPoints": {
    "barWidget": "Panel.qml"
  },
  "barWidget": {
    "displayName": "Window opacity",
    "description": "Focused and unfocused window opacity sliders",
    "category": "System",
    "allowMultiple": false,
    "defaultSection": "right"
  }
}
```

✓ 2 ms

```text
wrote 513 bytes to .config/omarchy/plugins/parker.window-opacity/manifest.json
```

**⏺ write** `.config/omarchy/plugins/parker.window-opacity/Panel.qml`

```
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons

// Window opacity bar widget.
//
// Two sliders drive Hyprland's decoration:active_opacity (focused window) and
// decoration:inactive_opacity (unfocused windows). Changes are applied live
// with `hyprctl keyword`, then saved as two plain numbers to
// $XDG_STATE_HOME/window-opacity/values. ~/.config/hypr/window-opacity.lua reads
// that file so the values survive Hyprland reloads and restarts.
//
// Omarchy's default window rule (opacity 0.985 0.96) multiplies with these
// values, so 100% here means "Omarchy's normal look".
Panel {
  id: root
  moduleName: "parker.window-opacity"
  ipcTarget: "parker.window-opacity"

  // Below this, windows become hard to find again; keep a usable floor.
  readonly property int minPercent: 20
  readonly property int maxPercent: 100
  readonly property int stepPercent: 5

  property int activePercent: 100
  property int inactivePercent: 100
  property bool applyQueued: false
  property real wheelAccumulator: 0

  // Keyboard cursor: "active" or "inactive" slider row.
  property string focusSection: "active"
  property bool cursorActive: false

  readonly property string icon: String.fromCodePoint(0xF1853)  // md-circle_opacity
  readonly property string stateHome: {
    var xdg = Quickshell.env("XDG_STATE_HOME")
    return xdg ? String(xdg) : String(Quickshell.env("HOME")) + "/.local/state"
  }
  readonly property string stateFile: stateHome + "/window-opacity/values"

  function clampPercent(value) {
    var n = Math.round(Number(value))
    if (isNaN(n)) return maxPercent
    return Math.max(minPercent, Math.min(maxPercent, n))
  }

  function fraction(percent) {
    return (clampPercent(percent) / 100).toFixed(2)
  }

  // Parse a Hyprland float ("0.9") into a percent, or -1 when unusable.
  function parsePercent(text) {
    var v = parseFloat(String(text || "").trim())
    if (isNaN(v) || v <= 0) return -1
    return clampPercent(v * 100)
  }

  function setOpacity(which, value) {
… (292 more lines in the repository)
```

✓ 89 ms

```text
wrote 10414 bytes to .config/omarchy/plugins/parker.window-opacity/Panel.qml
```

Inline components may not reliably see ids declared deeper in the file. The built-in panel only touches `root` from inside them, so I'll avoid referencing `panelColumn` there.

**⏺ edit** `.config/omarchy/plugins/parker.window-opacity/Panel.qml`

```
    width: parent ? parent.width : 0
    spacing: Style.space(6)
```

✓ 4278 ms

```text
edited .config/omarchy/plugins/parker.window-opacity/Panel.qml at line 292
```

**⏺ write** `.config/hypr/window-opacity.lua`

```
-- Window opacity chosen in the bar's Window opacity panel
-- (~/.config/omarchy/plugins/parker.window-opacity).
--
-- The panel saves two plain numbers, "<focused> <unfocused>", to
-- $XDG_STATE_HOME/window-opacity/values. They are parsed as numbers, never run
-- as code, and clamped to 0.2-1.0. Delete that file to go back to the defaults.

local paths = require("default.hypr.paths")

local file = io.open(paths.state_home .. "/window-opacity/values", "r")
if not file then
  return
end

local active, inactive = file:read("n", "n")
file:close()

local function clamp(value)
  if type(value) ~= "number" or value ~= value then
    return nil
  end
  return math.max(0.2, math.min(1.0, value))
end

local decoration = {
  active_opacity = clamp(active),
  inactive_opacity = clamp(inactive),
}

if decoration.active_opacity or decoration.inactive_opacity then
  hl.config({ decoration = decoration })
end
```

✓ 693 ms

```text
wrote 908 bytes to .config/hypr/window-opacity.lua
```

**⏺ edit** `.config/hypr/hyprland.lua`

```
require("hypr.looknfeel")
require("hypr.window-opacity")
```

✓ 110 ms

```text
edited .config/hypr/hyprland.lua at line 22
```

`file:read("n")` needs Lua 5.3+, but `"*n"` works in every Lua version, so I'll switch to that since I don't know which one Hyprland embeds. Then I'll add the widget to the bar layout.

**⏺ edit** `.config/hypr/window-opacity.lua`

```
file:read("*n", "*n")
```

✓ 405 ms

```text
edited .config/hypr/window-opacity.lua at line 15
```

**⏺ edit** `.config/omarchy/shell.json`

```
        {
          "id": "parker.window-opacity"
        },
        {
          "id": "omarchy.monitor"
        },
```

✓ 10 ms

```text
edited .config/omarchy/shell.json at line 56
```

Now verification: the Omarchy manifest validator, JSON validity, and a Lua check of the Hyprland module against a stub `hl`.

**⏺ bash** `omarchy-plugin-validate .config/omarchy/plugins/parker.window-opacity && echo VALID; jq -e '.bar.layout.right[] | select(.id=="parker.window-opacity")' .config/omarchy/shell.json; which lua lua5.4 lua5.1 luajit 2>/dev/null`

✓ 1354 ms

```text
[exit 0, 825 ms]
VALID
{
  "id": "parker.window-opacity"
}
/usr/bin/lua
/usr/bin/lua5.4
/usr/bin/lua5.1
/usr/bin/luajit
```

**⏺ bash** `cat > /tmp/test.lua <<'EOF'
package.path = (os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/?.lua;" .. os.getenv("PWD") .. "/.config/?.lua;" .. package.path
local got
hl = { config = function(t) got = t end }
package.loaded["hypr.window-opacity"] = nil
require("hypr.window-opacity")
if got t`

✓ 546 ms

```text
[exit 0, 532 ms]
[__missing__] lua5.4   no config call
[__missing__] lua5.1   no config call
[__missing__] luajit   no config call
[0.90 0.75]  lua5.4   0.9	0.75
[0.90 0.75]  lua5.1   0.9	0.75
[0.90 0.75]  luajit   0.9	0.75
[0.05 7]     lua5.4   0.2	1.0
[0.05 7]     lua5.1   0.2	1
[0.05 7]     luajit   0.2	1
[garbage]    lua5.4   no config call
[garbage]    lua5.1   no config call
[garbage]    luajit   no config call
[0.8]        lua5.4   0.8	nil
[0.8]        lua5.1   0.8	nil
[0.8]        luajit   0.8	nil
```

**⏺ bash** `S=$(mktemp -d); F="$S/window-opacity/values"
bash -c "mkdir -p \"\$(dirname \"\$0\")\" && printf '%s %s\\n' \"\$1\" \"\$2\" > \"\$0.tmp\" && mv -f \"\$0.tmp\" \"\$0\"" "$F" 0.85 0.70
echo "saved: $(cat "$F")"; ls "$S/window-opacity"
echo "--- read output:"
bash -c "for o in active inactive; do v=\$(`

✓ 118 ms

```text
[exit 0, 111 ms]
Referenced but unset environment variable evaluates to an empty string: o
saved: 0.85 0.70
values
--- read output:
$
$
0.85 0.70$
```

Save and fallback-read both work: the lines are empty, empty, then saved values, which is what the parser expects. I want to know where that "unset variable" warning came from, though.

**⏺ bash** `echo "BASH_ENV=$BASH_ENV SHELLOPTS=$SHELLOPTS"; S=$(mktemp -d); env -i PATH=$PATH bash -c 'for o in active inactive; do v=$(hyprctl -j getoption decoration:${o}_opacity 2>/dev/null | jq -r ".float // empty" 2>/dev/null); printf "%s\n" "$v"; done; cat "$0" 2>/dev/null; echo rc=$?' "$S/none"`

✓ 251 ms

```text
[exit 0, 241 ms]
Referenced but unset environment variable evaluates to an empty string: o
BASH_ENV= SHELLOPTS=braceexpand:hashall:interactive-comments


rc=1
```

**⏺ bash** `sed -n 440,475p /usr/share/omarchy/shell/Commons/Style.qml`

✓ 99 ms

```text
[exit 0, 89 ms]
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
        if (name.length > 0) root.resolvedFontFamily = name
      }
```

**⏺ bash** `grep -n "function applyRoundingJson" -A14 /usr/share/omarchy/shell/Commons/Style.qml`

✓ 96 ms

```text
[exit 0, 90 ms]
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
372-      var css = String(json.css || "")
373-      var parts = css.match(/-?\d+(?:\.\d+)?/g) || []
```

**⏺ bash** `cd .config/omarchy/plugins/parker.window-opacity; /usr/lib/qt6/bin/qmllint Panel.qml 2>&1 | grep -v "^$" | grep -iE "error|syntax|expected|unexpected" | head -20; echo "---"; /usr/lib/qt6/bin/qmllint Panel.qml 2>&1 | head -12`

✓ 503 ms

```text
[exit 0, 496 ms]
---
Warning: Panel.qml:4:1: Warnings occurred while importing module "qs.Ui": [import]
import qs.Ui
^^^^^^
---
Warning: 4:1: Failed to import qs.Ui. Are your import paths set up properly? [import]
---

Warning: Panel.qml:5:1: Warnings occurred while importing module "qs.Commons": [import]
import qs.Commons
^^^^^^
---
Warning: 5:1: Failed to import qs.Commons. Are your import paths set up properly? [import]
```

No syntax errors, just the expected unresolved `qs.*` imports. Last, I'll review the full diff.

**⏺ bash** `git diff -- .config/hypr/hyprland.lua .config/omarchy/shell.json; git status --short .config`

✓ 96 ms

```text
[exit 0, 89 ms]
diff --git a/.config/hypr/hyprland.lua b/.config/hypr/hyprland.lua
index 45c9b66..a0f30ed 100644
--- a/.config/hypr/hyprland.lua
+++ b/.config/hypr/hyprland.lua
@@ -20,6 +20,7 @@ require("hypr.monitors")
 require("hypr.input")
 require("hypr.bindings")
 require("hypr.looknfeel")
+require("hypr.window-opacity")
 require("hypr.autostart")
 
 -- Toggle config flags dynamically.
diff --git a/.config/omarchy/shell.json b/.config/omarchy/shell.json
index e6202da..5ddb226 100644
--- a/.config/omarchy/shell.json
+++ b/.config/omarchy/shell.json
@@ -53,6 +53,9 @@
         {
           "id": "omarchy.audio"
         },
+        {
+          "id": "parker.window-opacity"
+        },
         {
           "id": "omarchy.monitor"
         },
 M .config/hypr/hyprland.lua
 M .config/omarchy/shell.json
 D .config/omarchy/themes/ember/README.md
 D .config/omarchy/themes/ember/colors.toml
 D .config/omarchy/themes/ember/hyprland.lua
 D .config/omarchy/themes/ember/icons.theme
 D .config/omarchy/themes/ember/install.sh
 D .config/omarchy/themes/ember/neovim.lua
?? .config/hypr/window-opacity.lua
?? .config/omarchy/plugins/
```

I've built the plugin and added it to your top bar, but I haven't seen it running. Hyprland and the shell aren't running in this sandbox, so the panel, the live opacity change and the restart behaviour are all untested.

**What it does**
- A new icon sits in the right side of your bar, between Audio and Display. Clicking it opens a small panel with two sliders, **Focused window** and **Unfocused windows**, each running from 20% to 100%.
- Moving a slider changes Hyprland's opacity straight away.
- Extras I added: scrolling on the bar icon changes the focused-window opacity in 5% steps. In the panel, `j`/`k` switch slider, `h`/`l` adjust by 5%, and `Esc` closes. The hover tooltip shows both current values.

**How settings are kept**
- When you change a value, the plugin saves the two numbers to `~/.local/state/window-opacity/values`.
- A new file, `~/.config/hypr/window-opacity.lua`, reads them back whenever Hyprland starts or reloads. Without it, any config reload (Omarchy's toggles trigger one) would reset the opacity.
- The values are read as plain numbers, never run as code, and limited to 0.2–1.0. Delete that state file to go back to the defaults.

**Files**
- New: `~/.config/omarchy/plugins/parker.window-opacity/` (`manifest.json` and `Panel.qml`)
- New: `~/.config/hypr/window-opacity.lua`
- Edited: `hyprland.lua`, one `require("hypr.window-opacity")` line after looknfeel
- Edited: `shell.json`, the widget added to the bar layout

**What I checked**
- `omarchy plugin validate` passes, and `shell.json` is still valid JSON.
- I ran the Hyprland module against a stand-in for Hyprland on Lua 5.1, 5.4 and LuaJIT. Missing, valid, out-of-range, garbage and half-written files are all handled.
- The plugin's save and read commands work, including falling back to the saved file when Hyprland can't answer.
- `qmllint` found no syntax errors. It couldn't resolve Omarchy's own UI imports outside the running shell, so it couldn't fully check the QML.

**Please run these on your desktop**
1. `hyprctl reload && hyprctl configerrors` should report no errors.
2. If the icon doesn't appear, run `omarchy-shell shell rescanPlugins`.
3. Click the icon, drag both sliders, then run `hyprctl reload` and check the opacity stays put.

**Good to know**
- These sliders scale Omarchy's normal window transparency rather than replacing it, so 100% looks the same as before.
- They also scale apps Omarchy normally keeps fully solid, like video players, PiP and Steam. Windows you've made opaque with the transparency toggle stay solid.
- The icon is the Nerd Font "circle opacity" glyph; I confirmed it's in your installed JetBrainsMono Nerd Font.
- Your worktree already showed the `ember` theme files as deleted before I started. I didn't touch them.

