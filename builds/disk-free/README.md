# Disk Free

*plugin, simple*

> Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.

The idea comes from brownfamilysports.disk-hud (Parker Brown); no harness saw that code.

| | result | prompts | model calls | cost | minutes | taste | implementation | execution | review rank |
|---|---|---|---|---|---|---|---|---|---|
| [h0 + Omarchy fitting](h0-fitted/BUILD.md) | pass | 1 | 11 | $0.27 | 1.1 | 3.0 | 3.5 | 4.5 | 2.0 |
| [h0, plain](h0-plain/BUILD.md) | pass | 1 | 30 | $0.67 | 3.6 | 4.0 | 4.0 | 4.5 | 1.0 |
| [Claude Code](claude-code/BUILD.md) | pass | 1 | 15 | $0.43 | 1.9 | 2.5 | 2.5 | 3.5 | 3.5 |
| [opencode](opencode/BUILD.md) | pass | 1 | 20 | $0.45 | 1.2 | 2.0 | 3.0 | 3.0 | 3.5 |

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

Pass 1: h0, plain > h0 + Omarchy fitting > Claude Code > opencode. C is the most robust and restrained, with good formatting at every size and safe df invocation. B is clean and does exactly what was asked, but lacks a hide-until-loaded guard. A is solid but adds a btop launch and lacks NaN guards. D floors near-empty disks to "0G" and changes the click behaviour unasked.

Pass 2: h0, plain > h0 + Omarchy fitting > opencode > Claude Code. A is the most careful and complete, with no unwanted extras. B is correct and restrained but less polished: an empty pill before the first reading and a loose schema. C and D both bolt on a btop launch nobody asked for. D is worst because it fires btop on every click and has the weakest input validation.

Pictures are drawn by Quickshell offscreen from each build's own code, beside Omarchy's stock clock (plugins) or over the theme's own background (themes). Not desktop screenshots; popup panels cannot be drawn this way.

