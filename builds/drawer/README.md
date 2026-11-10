# Bar Drawer

*plugin, moderate*

> Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.

The idea comes from io.github.huey-holdings-llc.omarchy-drawer-redux (Corey Tyhurst); no harness saw that code.

| | result | prompts | model calls | cost | minutes | taste | implementation | execution | review rank |
|---|---|---|---|---|---|---|---|---|---|
| [h0 + Omarchy fitting](h0-fitted/BUILD.md) | pass | 1 | 49 | $2.04 | 9.9 | 3.0 | 3.0 | 4.0 | 3.0 |
| [h0, plain](h0-plain/BUILD.md) | pass | 1 | 60 | $2.80 | 10.0 | 2.0 | 2.0 | 3.0 | 4.0 |
| [Claude Code](claude-code/BUILD.md) | pass | 2 | 75 | $5.34 | 21.3 | 4.0 | 4.0 | 4.5 | 1.0 |
| [opencode](opencode/BUILD.md) | pass | 2 | 91 | $6.23 | 15.6 | 4.0 | 3.0 | 4.0 | 2.0 |

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

Pass 1: Claude Code > opencode > h0 + Omarchy fitting > h0, plain. A is a self-contained bar widget that does everything asked, with a fitting look and only modest reliance on internals. D is similarly complete with good polish, but carries far more machinery and a few surprises. C works but defaults to auto-close and loses tucked-widget tooltips. B forces a whole-bar replacement that couples to stock Bar.qml internals and can rewrite shell.json, which is invasive for a simple drawer.

Pass 2: Claude Code > opencode > h0 + Omarchy fitting > h0, plain. B is a clean, conventional popup that uses PluginBarApi properly, dismisses on an outside click, and exposes `items` in the settings UI. C is the most thorough and uses the registry through a service, but it carries heavy machinery: full-screen dismiss layers, focus timers and polling. A works, but its pointer-leave auto-close, missing outside-click dismissal and likely-broken tooltips make it weaker. D hijacks the whole bar, forges first-party trust, and edits shell.json on failure.

Pictures are drawn by Quickshell offscreen from each build's own code, beside Omarchy's stock clock (plugins) or over the theme's own background (themes). Not desktop screenshots; popup panels cannot be drawn this way.

