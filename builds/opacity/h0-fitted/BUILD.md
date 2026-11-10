# h0 + Omarchy fitting building Window Opacity

h0 with its Omarchy fitting (omarchy-v4), on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 22 | 798,188 | 12,280 | $0.68 | 3.3 | all pass |
| **all** | | **22** | | | **$0.68** | **3.3** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.
```

22 model calls, $0.68, 198 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.window-opacity
- ✓ `validate`
- ✓ `loads`: plugin parker.window-opacity  (~/.config/omarchy/plugins/parker.window-opacity)
- ✓ `switched-on`: id parker.window-opacity
- ✓ `sets-opacity`: read from the code

<details><summary>The harness's reply</summary>

I built the plugin and put it in your top bar. It passes the build check and the bar icon draws in the offscreen preview. I couldn't test it live: the sandbox has no Hyprland, and the preview can't draw popups, so the panel and the actual opacity change are untested.

**Files**
- `.config/omarchy/plugins/parker.window-opacity/manifest.json`: declares the bar widget.
- `.config/omarchy/plugins/parker.window-opacity/Panel.qml`: an opacity icon (󰗋) for the bar. Clicking it opens a small panel with:
  - **Focused window** slider, 30–100%
  - **Unfocused windows** slider, 30–100%
  - a **Reset** button that puts both back to 100%
- `.config/omarchy/shell.json`: added `{ "id": "parker.window-opacity", "active": 100, "inactive": 100 }` to the right side of the bar, just before the display widget. A backup is saved as `shell.json.bak.<timestamp>`.

**How it works**
- **Live changes:** dragging a slider changes Hyprland's focused and unfocused window opacity settings straight away. It uses the same command pattern as Omarchy's own scripts, with an older-style command as a fallback.
- **100% means Omarchy's normal look, not fully solid.** Hyprland multiplies your setting with Omarchy's default window opacity (98.5% focused, 96% unfocused). Apps Omarchy keeps solid, like video players, Steam and VMs, stay solid.
- **Keeping your settings:** when you let go of a slider, the values are saved into your widget's entry in `shell.json`. You can also edit them there by hand.
- **After a restart or reload:** the values are applied again when the shell starts and after every Hyprland config reload, since a reload (for example a theme change) resets them.
- **Extras:**
  - Scrolling on the bar icon changes focused-window opacity in 5% steps.
  - In the panel, `j`/`k` picks a slider, `h`/`l` adjusts it, `Esc` closes it.

**What I couldn't confirm**
- Whether `hyprctl eval` with `hl.config` changes opacity on your Hyprland version. The fallback should cover it if not.
- Whether that command itself triggers a config-reload event. If it does, the plugin ignores reload events for 1.5 seconds after its own change, so it can't loop.
- There's a short delay after login before your saved values apply, because the shell has to start first.

**Please test:** the shell hot-reloads, so the icon should appear on its own. If it doesn't, run `omarchy-shell shell rescanPlugins`. Then drag the sliders, run `hyprctl reload`, and check that the opacity stays where you set it.

</details>

Every step: [SESSION.md](SESSION.md).
