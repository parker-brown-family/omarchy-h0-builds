# Screen Sleep

*plugin, simple*

> Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.

The idea comes from brownfamilysports.screen-sleep (Parker Brown); no harness saw that code.

| | result | prompts | model calls | cost | minutes | taste | implementation | execution | review rank |
|---|---|---|---|---|---|---|---|---|---|
| [h0 + Omarchy fitting](h0-fitted/BUILD.md) | pass | 1 | 18 | $0.39 | 1.3 | 3.0 | 2.5 | 3.0 | 3.5 |
| [h0, plain](h0-plain/BUILD.md) | pass | 2 | 44 | $1.15 | 5.1 | 3.0 | 2.5 | 4.5 | 2.5 |
| [Claude Code](claude-code/BUILD.md) | pass | 2 | 21 | $0.65 | 2.8 | 4.0 | 4.0 | 5.0 | 1.0 |
| [opencode](opencode/BUILD.md) | pass | 2 | 25 | $0.66 | 2.0 | 3.0 | 2.5 | 4.0 | 3.0 |

Review scores are 1–5 from a blind judge (Claude Opus 5.5), averaged over two passes with the builds shuffled; rank 1 is best. See [../../REVIEW.md](../../REVIEW.md) for the method and its limits.

## What the judge said

Pass 1: Claude Code > h0, plain > h0 + Omarchy fitting > opencode. A does the whole job with the least code. It uses DPMS-only argv, honours stay-awake and inhibitors, and restores the screens on unload. D matches A's behaviour but buries it in an over-built JS model, a directory watcher and a mkdir side effect. B is lean and uses Omarchy's script, but it can drop wake commands, misreports state when stay-awake is on, and has no unload restore. C has the same gaps as B and adds a jq dependency plus process-killing in run().

Pass 2: Claude Code > opencode > h0, plain > h0 + Omarchy fitting. C is the simplest correct build: direct DPMS calls, live stay-awake handling and a destruction restore. A is straightforward and correct but lacks the reload restore and leans on bash and jq. B works but is over-built, with an untested JS model, a mkdir side effect and a dubious directory FileView. D rests on an unverified brightness script for the core off/on action.

Pictures are drawn by Quickshell offscreen from each build's own code, beside Omarchy's stock clock (plugins) or over the theme's own background (themes). Not desktop screenshots; popup panels cannot be drawn this way.

