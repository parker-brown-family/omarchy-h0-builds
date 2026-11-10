# Claude Code building Window Opacity

Claude Code 2.1.296 as shipped, with the Omarchy skill Omarchy installs, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 38 | 2,426,425 | 20,964 | $1.25 | 5.7 | all pass |
| **all** | | **38** | | | **$1.25** | **5.7** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

38 model calls, $1.25, 344 s. Effort sent: medium.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.window-opacity
- ✓ `validate`
- ✓ `loads`: plugin parker.window-opacity  (~/.config/omarchy/plugins/parker.window-opacity)
- ✓ `switched-on`: id parker.window-opacity
- ✓ `sets-opacity`: read from the code

<details><summary>The harness's reply</summary>

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

</details>

Every step: [SESSION.md](SESSION.md).
