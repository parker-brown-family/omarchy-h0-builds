# Window Opacity

*plugin, moderate*

> Build me an Omarchy shell plugin that puts a window opacity control in my top bar. Clicking it should open a small panel with two sliders, one for the focused window and one for unfocused windows, that change Hyprland's opacity live. Keep my settings after a restart.

The idea comes from brownfamilysports.opacity, a cut of wicky14's Rounded Corner Blur; no harness saw that code.

| | result | prompts | model calls | cost | minutes | taste | implementation | execution | review rank |
|---|---|---|---|---|---|---|---|---|---|
| [h0 + Omarchy fitting](h0-fitted/BUILD.md) | pass | 1 | 22 | $0.68 | 3.3 | 3.0 | 3.0 | 4.0 | 3.0 |
| [h0, plain](h0-plain/BUILD.md) | pass | 1 | 42 | $1.33 | 5.3 | 3.0 | 2.0 | 2.0 | 4.0 |
| [Claude Code](claude-code/BUILD.md) | pass | 1 | 38 | $1.25 | 5.7 | 3.5 | 4.0 | 4.5 | 1.5 |
| [opencode](opencode/BUILD.md) | pass | 1 | 38 | $1.23 | 3.3 | 4.0 | 4.0 | 5.0 | 1.5 |

Review scores are 1–5 from a blind judge (Claude Opus 5.5), averaged over two passes with the builds shuffled; rank 1 is best. See [../../REVIEW.md](../../REVIEW.md) for the method and its limits.

### h0 + Omarchy fitting

![h0 + Omarchy fitting](h0-fitted/bar.png)

### h0, plain

![h0, plain](h0-plain/bar.png)

### Claude Code

![Claude Code](claude-code/bar.png)

### opencode

![opencode](opencode/bar.png)

## What the judge said

Pass 1: Claude Code > opencode > h0 + Omarchy fitting > h0, plain. A and C both fully deliver live sliders and shell.json persistence with reload re-apply. A is leaner and more restrained. C adds smarter reconciliation but spawns many hyprctl processes during drags. B works but adds unrequested wheel scrolling and a Reset button, and forces 100% on every start. D's persistence depends on a Lua file it never creates, so settings do not survive a restart.

Pass 2: opencode > Claude Code > h0 + Omarchy fitting > h0, plain. B fully meets the request with native-looking UI and the most robust reload reconciliation. A is equally complete and simpler but less polished and starts its sliders at the wrong values. C works but adds unwanted extras and forces 100% opacity at startup. D's persistence relies on a Lua hook it never ships, so settings are lost on restart.

Pictures are drawn by Quickshell offscreen from each build's own code, beside Omarchy's stock clock (plugins) or over the theme's own background (themes). Not desktop screenshots; popup panels cannot be drawn this way.

