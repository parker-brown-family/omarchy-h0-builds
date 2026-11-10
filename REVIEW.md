# Blind review

For each subject, the four builds went to a judge (Claude Opus 5.5) under letters A–D in a shuffled order, as their files plus pictures drawn offscreen from their own code. The judge scored each 1–5 on taste, implementation and execution against the rubric in [tools/judge.py](tools/judge.py), and ranked them. Each subject was judged twice with a different order. Below, the judge's letters are replaced with the harness names; the raw answers, with the mapping, are under [review/](review/).

Limits: one judge, the same model that wrote the builds; one build per harness per subject; a fraction of a point is noise.

## Disk Free

**Pass 1:** h0 plain > h0 + fitting > Claude Code > opencode.

h0 plain is the most robust and restrained, with good formatting at every size and safe df invocation. h0 + fitting is clean and does exactly what was asked, but lacks a hide-until-loaded guard. Claude Code is solid but adds a btop launch and lacks NaN guards. opencode floors near-empty disks to "0G" and changes the click behaviour unasked.

**Pass 2:** h0 plain > h0 + fitting > opencode > Claude Code.

h0 plain is the most careful and complete, with no unwanted extras. h0 + fitting is correct and restrained but less polished: an empty pill before the first reading and a loose schema. opencode and Claude Code both bolt on a btop launch nobody asked for. Claude Code is worst because it fires btop on every click and has the weakest input validation.

## Screen Sleep

**Pass 1:** Claude Code > h0 plain > h0 + fitting > opencode.

Claude Code does the whole job with the least code. It uses DPMS-only argv, honours stay-awake and inhibitors, and restores the screens on unload. h0 plain matches Claude Code's behaviour but buries it in an over-built JS model, a directory watcher and a mkdir side effect. h0 + fitting is lean and uses Omarchy's script, but it can drop wake commands, misreports state when stay-awake is on, and has no unload restore. opencode has the same gaps as h0 + fitting and adds a jq dependency plus process-killing in run().

**Pass 2:** Claude Code > opencode > h0 plain > h0 + fitting.

Claude Code is the simplest correct build: direct DPMS calls, live stay-awake handling and a destruction restore. opencode is straightforward and correct but lacks the reload restore and leans on bash and jq. h0 plain works but is over-built, with an untested JS model, a mkdir side effect and a dubious directory FileView. h0 + fitting rests on an unverified brightness script for the core off/on action.

## Opacity

**Pass 1:** Claude Code > opencode > h0 + fitting > h0 plain.

Claude Code and opencode both fully deliver live sliders and shell.json persistence with reload re-apply. Claude Code is leaner and more restrained. opencode adds smarter reconciliation but spawns many hyprctl processes during drags. h0 + fitting works but adds unrequested wheel scrolling and a Reset button, and forces 100% on every start. D's persistence depends on a Lua file it never creates, so settings do not survive a restart.

**Pass 2:** opencode > Claude Code > h0 + fitting > h0 plain.

opencode fully meets the request with native-looking UI and the most robust reload reconciliation. Claude Code is equally complete and simpler but less polished and starts its sliders at the wrong values. h0 + fitting works but adds unwanted extras and forces 100% opacity at startup. D's persistence relies on a Lua hook it never ships, so settings are lost on restart.

## Drawer

**Pass 1:** Claude Code > opencode > h0 + fitting > h0 plain.

Claude Code is a self-contained bar widget that does everything asked, with a fitting look and only modest reliance on internals. opencode is similarly complete with good polish, but carries far more machinery and a few surprises. h0 + fitting works but defaults to auto-close and loses tucked-widget tooltips. h0 plain forces a whole-bar replacement that couples to stock Bar.qml internals and can rewrite shell.json, which is invasive for a simple drawer.

**Pass 2:** Claude Code > opencode > h0 + fitting > h0 plain.

Claude Code is a clean, conventional popup that uses PluginBarApi properly, dismisses on an outside click, and exposes `items` in the settings UI. opencode is the most thorough and uses the registry through a service, but it carries heavy machinery: full-screen dismiss layers, focus timers and polling. h0 + fitting works, but its pointer-leave auto-close, missing outside-click dismissal and likely-broken tooltips make it weaker. h0 plain hijacks the whole bar, forges first-party trust, and edits shell.json on failure.

## Harbour Fog

**Pass 1:** opencode > h0 + fitting > Claude Code > h0 plain.

opencode pairs a solid palette with the most atmospheric, on-brief harbour wallpaper. h0 + fitting is nearly as good, with an elegant, restrained scene and a reproducible generator. Claude Code is competent but its wallpaper is sparse and has a corner artifact, and its border colour format is risky. B's smeared, muddy wallpaper undercuts an otherwise good palette and a nice gradient border.

**Pass 2:** h0 + fitting > opencode > Claude Code > h0 plain.

h0 + fitting pairs a disciplined low-contrast palette with the calmest, most liveable fog-harbour background. opencode is equally complete with an attractive but busier scene. Claude Code is calm but sparse and has a questionable border colour string. B's palette is fine, but its smeared background with a clashing brown railing and its light icon theme on a dark theme let it down.

## Paper Lantern

**Pass 1:** h0 + fitting > opencode > h0 plain > Claude Code.

h0 + fitting has the cleanest, most liveable paper-textured wallpaper and fully valid files, including a correctly ordered lighter_background. B's wallpaper is lovely but its btop file carries invalid gradient keys. h0 plain is busier, with a brownish wallpaper and no Chromium theme. D's monogram seal and fake glyph are gimmicky, and its keyboard format is questionable.

**Pass 2:** opencode > h0 + fitting > h0 plain > Claude Code.

opencode is complete, clean and has the most tasteful single-lantern wallpaper with an authentic glyph. h0 + fitting has the best paper texture but adds an unneeded generator script and a heavy glow. h0 plain is solid but has a muddier vignette and a dim keyboard red. Claude Code is let down by the PL stamp, the fake character and the '#'-prefixed keyboard.rgb.

