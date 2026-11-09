# How h0 built Window Opacity

h0 (a coding-agent harness) running Claude Opus 5.5 (claude-opus-5-5), fitting `none`, in a sandbox holding a copy of an Omarchy 4 home directory. It was sent the idea below, then, after each reply, the same automatic checks ran; when one failed, the next prompt was written from a fixed template from what the check printed, the way a person pastes back an error. Nobody edited its files. The protocol is in the omarchy-h0-builds repository.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 48 | 2,839,445 | 27,461 | $1.58 | 4.8 | all pass |
| **all** | | **48** | | | **$1.58** | **4.8** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

48 turns, $1.58, 289 s. Stop: `end_turn`.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.window-opacity
- ✓ `validate`
- ✓ `loads`: plugin parker.window-opacity  (~/.config/omarchy/plugins/parker.window-opacity)
- ✓ `switched-on`: id parker.window-opacity
- ✓ `sets-opacity`: read from the code

<details><summary>h0's reply</summary>

I've built the opacity plugin and added it to the right side of your top bar, next to the Display icon. I tested it in Quickshell with a fake `hyprctl`, but there's no running Hyprland in my sandbox, so I haven't seen it change real windows yet.

**How it works**
- **The bar icon:** a droplet icon whose tooltip shows both values. Clicking it opens a small panel with two sliders: "Focused window" and "Unfocused windows", from 10% to 100%.
- **Live changes:** moving a slider changes Hyprland's opacity settings for focused and unfocused windows right away. You can also use the keyboard: j/k to switch sliders, h/l to change by 5%, Esc to close.
- **Keeping your settings:** after you stop moving a slider, the values are saved to `~/.config/hypr/window-opacity.lua`. I added one line to `hyprland.lua` that loads this file, so Hyprland applies your values itself at login and on every config reload, even before the bar starts. If the file is missing, nothing happens. Delete it to go back to normal.

**Files**
- `~/.config/omarchy/plugins/parker.window-opacity/`: `manifest.json`, `Widget.qml` and `Model.js` (the value and file logic)
- `~/.config/omarchy/shell.json`: added the widget to the bar
- `~/.config/hypr/hyprland.lua`: the one loading line

**How I checked it**
- Omarchy's plugin validator passes and `shell.json` is valid.
- I tested the value logic: it limits values to 10–100 and reads the saved file back correctly.
- I ran your Hyprland config's loading code on the saved file: the values are found and applied, and a missing file causes no error.
- In Quickshell, with only the popup window swapped for a placeholder, the widget read the saved values and sent the right commands to `hyprctl`. When I moved both sliders quickly, the last values were the ones applied. A slider set to 3% was raised to 10%, and the save happened. On a simulated restart it read the values back and didn't reapply or rewrite anything.

**Please check on your machine**
- The bar should pick up the new widget by itself; if it doesn't, run `omarchy-shell shell rescanPlugins`. Then move a slider and run `hyprctl configerrors` to confirm there are no errors.
- **How the numbers combine:** Omarchy already gives most windows 98.5% opacity when focused and 96% when unfocused. Hyprland multiplies that by your slider, so 90% shows as about 89%.
- **What it affects:** these sliders change all windows, including ones Omarchy normally keeps fully opaque (video, games, picture-in-picture). Fullscreen windows aren't affected.
- **Brief reload:** saving the file may make Hyprland reload its config automatically when you let go of a slider. Your values stay the same; it's just a reload.

</details>

Every tool call and its result: [SESSION.md](SESSION.md). The hash-chained trace: [session/trace.jsonl](session/trace.jsonl).
