# opencode building Window Opacity

opencode 2.0.28 as shipped, with the Omarchy skill Omarchy installs, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 38 | 2,249,853 | 18,196 | $1.23 | 3.3 | all pass |
| **all** | | **38** | | | **$1.23** | **3.3** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

38 model calls, $1.23, 199 s. Effort sent: None.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.window-opacity
- ✓ `validate`
- ✓ `loads`: plugin parker.window-opacity  (~/.config/omarchy/plugins/parker.window-opacity)
- ✓ `switched-on`: id parker.window-opacity
- ✓ `sets-opacity`: read from the code

<details><summary>The harness's reply</summary>

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

</details>

Every step: [SESSION.md](SESSION.md).
