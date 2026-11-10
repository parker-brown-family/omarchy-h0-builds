# Protocol

## Question

Can h0 build real Omarchy plugins and themes from a plain request plus the kind of follow-ups
a person sends when something doesn't work, and does the Omarchy fitting help? The answer is
published as working repositories: the code h0 wrote, every prompt verbatim, and the turns,
tokens, dollars and minutes each prompt took.

## Subjects (written before any run)

Ideas from real plugins in the Omarchy catalog. The agent never sees their code: the originals
live in the person's home, which the sandbox hides, and the network is off.

| id | kind | inspired by | size of the original |
|---|---|---|---|
| disk-free | simple plugin (bar widget) | brownfamilysports.disk-hud | 154 lines |
| screen-sleep | simple plugin (service) | brownfamilysports.screen-sleep | 75 lines |
| opacity | moderate plugin (bar widget + popup) | brownfamilysports.opacity, a cut of wicky14's Rounded Corner Blur | 470 lines |
| drawer | moderate plugin (bar widget) | io.github.huey-holdings-llc.omarchy-drawer-redux (Corey Tyhurst) | 1,844 lines |
| harbour-fog | simple theme (dark) | — | — |
| paper-lantern | moderate theme (light, plus btop and keyboard) | — | — |

The first prompt for each is in `prompts.json`, written as a person would type it.

## Arms

- **plain**: h0 with no fitting.
- **fitted**: h0 with `omarchy-v4`, which is v3 minus the line that told agents not to inspect
  plugin internals, plus two checks it can run itself: `validate` (Omarchy's own
  `omarchy-plugin-validate` on every plugin) and `preview` (loads every plugin entry point in
  Quickshell offscreen, inside the sandbox, and prints the QML errors and the text it drew).

Same model for both: Claude Opus 5.5, default effort. One session per subject per arm.

## The normal workflow

1. Send the idea prompt.
2. When the agent finishes, the operator script runs the acceptance checks below, the same
   checks for both arms.
3. If one fails, send a follow-up written from a fixed template: "It's not working yet: <the
   first failing check, in plain words>" followed by at most 20 lines of what the check printed.
   That is what a person who ran the thing would paste back.
4. Stop when every check passes, or after three follow-ups (four prompts in all).

No polish prompts, no hints the checks did not produce, no hand edits to the agent's files.

## Acceptance (the same for both arms)

Plugins:
1. One new plugin folder with a `manifest.json` under `~/.config/omarchy/plugins/`.
2. `omarchy-plugin-validate` passes on it.
3. Every entry point loads in Quickshell offscreen, inside the sandbox, with no QML errors from
   the plugin's own files.
4. It is switched on: its id is in `shell.json` (`plugins` or the bar layout).
5. A subject check. disk-free: the widget draws a size with a unit. screen-sleep: the code turns
   displays off through Hyprland's DPMS and never calls suspend. opacity: the code sets Hyprland's
   active and inactive opacity. drawer: the widget draws something, and the code reads a list of
   widgets to hide. All but disk-free's are read from the code, not watched; the repos say so.

Themes:
1. A folder under `~/.config/omarchy/themes/<slug>/` with a `colors.toml` carrying every key a
   stock theme has, each a valid colour, and the asked-for mode (dark or light).
2. At least one background image of at least 640 pixels wide.
3. Bar widgets render under the theme offscreen with no errors.
4. paper-lantern only: `btop.theme` and `keyboard.rgb` exist.

## Published

- One repository per subject whose fitted build passes: installable with
  `omarchy plugin add` or `omarchy theme install`, with BUILD.md (prompts verbatim, per-prompt
  turns, tokens, dollars, minutes, check results), an offscreen screenshot labelled as one, and
  the session rendered as an image from its recorded output.
- `omarchy-h0-builds`: the protocol, both arms' results, every transcript, the builds that
  failed included.

Home paths are scrubbed to `~` before anything is published; the keyring key never enters a
workspace.

## Known limits, said up front

- Popup panels need a layer-shell compositor, which the offscreen preview does not have, so a
  panel's contents are checked by loading its code, not by a picture.
- Nothing is run on Parker's live desktop.
- One session per arm per subject is an example, not a measurement of a rate.

## Amendment 1 (2026-11-09, before the run that counts)

The pilot run (`runs/builds-1`) found two faults in the operator, not in the builds:

- The preview loaded each widget with no bar host, so a widget reading `bar.foreground`, which
  the real shell always provides, failed the "loads" check. Plain's opacity build was sent a
  follow-up for exactly that. The preview now hands every widget a stand-in bar carrying the
  members stock widgets use, in the theme's colours; its `run()` records the command and never
  executes it.
- The switched-on check crashed when `shell.json`'s `plugins` list held objects, which killed both
  screen-sleep sessions before they were scored (their traces are kept in `runs/builds-1-crashed`).

So every subject runs again, both arms, from scratch, into `runs/builds-2`, with these fixes and
nothing else changed. The pilot's results are reported beside it, not replaced: disk-free passed
first time in both arms (fitted 15 turns, $0.35; plain 25 turns, $0.53), opacity passed first time
fitted (30 turns, $0.96) and second time plain (62 turns, $2.05, the follow-up caused by the fault
above).

## Amendment 2 (2026-11-09, before builds-3): four harnesses, a clean home, one meter

Parker asked whether Claude Code (and opencode) would do the same work better, in taste,
implementation and execution, and whether h0 is worth using at all. So every subject runs again
in four arms, into `runs/builds-3`:

- **h0-fitted** and **h0-plain**: as before.
- **claude-code**: Claude Code 2.1.296, headless (`-p`), `--dangerously-skip-permissions`, web tools
  disallowed, as shipped otherwise (its own system prompt, tools and built-in skills).
- **opencode**: opencode 2.0.28, `run --auto`, as shipped otherwise.

All on `claude-opus-5-5`, each at its own default effort (Claude Code sends `medium`; h0 and
opencode send none, so the API's default applies). Every arm starts from the same home: the
Omarchy fixture without the planted malicious theme, plus the agent-skill links Omarchy's own
installer makes (`~/.claude/skills/omarchy`, `~/.agents/skills/omarchy`, …). Nothing from
Parker's machine: no CLAUDE.md, hooks, plugins, MCP servers or personal skills.

Every arm runs in h0's bubblewrap sandbox with the network off. Claude Code and opencode reach the
API through a host proxy on a Unix socket in their workspace (bridged to 127.0.0.1 inside the
sandbox); the proxy holds the key, so the harness and its shell never see it (checked: zero
`sk-ant` strings in either harness's shell environment, and no route to the internet). The proxy
records every request's model, effort and token usage, and all four arms are priced with the same
table.

Turns are model calls. Follow-ups use the same template; the external harnesses continue their own
session (`--resume`, `--session`).

After the builds, a blind review of taste, implementation and execution compares the four builds
of each subject (method written before it runs).

## Amendment 3 (2026-11-10, after builds-3, before the review): three of my checks were wrong

Reported as found, with both the as-run and the corrected numbers published:

- **screen-sleep, "dpms-never-suspend"** looked for the word `dpms` in the plugin's own code. Three
  first builds (Claude Code, h0 plain, opencode) called `omarchy-brightness-display off`, which is
  Omarchy's own command and dispatches Hyprland's DPMS two scripts down. They were correct and were
  sent a follow-up anyway; each rewrote the call to `hyprctl dispatch` DPMS.
- **themes, "colors"** required every value in `colors.toml` to be `#rrggbb`. Stock themes set
  `hyprland_active_border` and `hyprland_inactive_border` to `rgba(...)` gradients, so two first
  builds of Harbour Fog (Claude Code, h0 plain) were valid and were sent a follow-up anyway.
- (builds-2) **screen-sleep** passed a build on the word `DPMS` in its manifest description.

The two real first-prompt misses: Claude Code's drawer replaced the whole bar instead of adding a
widget, and opencode's drawer did not load (QML errors). Corrected, the first-prompt passes are
h0-fitted 6/6, h0-plain 6/6, Claude Code 5/6, opencode 5/6; the corrected cost counts only the
prompts up to the first correct build.

Also seen in builds-3: the starting home's removed malicious theme shows as an uncommitted deletion
in `git status` (removed after the workspace's first commit), the same for every arm.
