# h0, plain building Window Opacity

h0 with no fitting, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 42 | 2,197,458 | 24,207 | $1.33 | 5.3 | all pass |
| **all** | | **42** | | | **$1.33** | **5.3** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

42 model calls, $1.33, 318 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.window-opacity
- ✓ `validate`
- ✓ `loads`: plugin parker.window-opacity  (~/.config/omarchy/plugins/parker.window-opacity)
- ✓ `switched-on`: id parker.window-opacity
- ✓ `sets-opacity`: read from the code

<details><summary>The harness's reply</summary>

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

</details>

Every step: [SESSION.md](SESSION.md).
