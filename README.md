# Omarchy, built by h0

Four Omarchy shell plugins and two themes, each written by [h0](https://github.com/parker-brown-family/fitting-room), a
coding-agent harness, from the kind of request a person would type. Every prompt, every tool call, and the turns,
tokens, dollars and minutes each build took are published here, failures included.

![Harbour Fog, with its generated background and the bar in its colours](builds/fitted/harbour-fog/files/harbour-fog/backgrounds/1-harbour-fog.jpg)

*The background h0 drew for the Harbour Fog theme. It had no network, so it made the picture itself.*

## The builds

| | what it is | install |
|---|---|---|
| [Disk Free](https://github.com/parker-brown-family/omarchy-h0-disk-free) | free space on your main drive in the bar, red under 10% | `omarchy plugin add https://github.com/parker-brown-family/omarchy-h0-disk-free.git --enable` |
| [Screen Sleep](https://github.com/parker-brown-family/omarchy-h0-screen-sleep) | screens off after 10 idle minutes, never suspends | `omarchy plugin add https://github.com/parker-brown-family/omarchy-h0-screen-sleep.git --enable` |
| [Window Opacity](https://github.com/parker-brown-family/omarchy-h0-opacity) | focused and unfocused window opacity from the bar | `omarchy plugin add https://github.com/parker-brown-family/omarchy-h0-opacity.git --enable` |
| [Bar Drawer](https://github.com/parker-brown-family/omarchy-h0-drawer) | tuck chosen bar widgets behind one button | `omarchy plugin add https://github.com/parker-brown-family/omarchy-h0-drawer.git --enable` |
| [Harbour Fog](https://github.com/parker-brown-family/omarchy-h0-harbour-fog) | a low-contrast night theme with a teal accent | `omarchy theme install https://github.com/parker-brown-family/omarchy-h0-harbour-fog.git` |
| [Paper Lantern](https://github.com/parker-brown-family/omarchy-h0-paper-lantern) | a warm light theme with a red accent, btop and keyboard included | `omarchy theme install https://github.com/parker-brown-family/omarchy-h0-paper-lantern.git` |

Each repository has the code at its root, the request verbatim, a BUILD.md with every prompt and its cost, and
SESSION.md with every step h0 took.

## How they were made

Each subject was built twice: once by plain h0, and once by h0 with its Omarchy fitting, a short map of where Omarchy
keeps things plus two checks the agent can run itself (Omarchy's own `omarchy-plugin-validate`, and an offscreen
preview that loads the plugin in Quickshell and reports what broke). Both ran Claude Opus 5.5 in a sandbox holding a
copy of an Omarchy 4 home directory, with the network off.

The first prompt was the idea. After each reply the same automatic checks ran for both arms. When one failed, the next
prompt was written from a fixed template out of what the check printed, the way you would paste an error back:
"It's not working yet: …". At most three of those. Nobody edited h0's files. The protocol was committed before the
run; it is in [PROTOCOL.md](PROTOCOL.md), and the six first prompts are in [prompts.json](prompts.json).

## What happened

| subject | fitted | plain |
|---|---|---|
| Disk Free (simple plugin) | first prompt · 15 turns · $0.33 | first prompt · 26 turns · $0.63 |
| Screen Sleep (simple plugin) | first prompt · 16 turns · $0.39 | first prompt · 24 turns · $0.58 |
| Window Opacity (moderate plugin) | first prompt · 25 turns · $0.83 | first prompt · 48 turns · $1.58 |
| Bar Drawer (moderate plugin) | first prompt · 54 turns · $2.82 | second prompt · 82 turns · $4.91 |
| Harbour Fog (simple theme) | first prompt · 27 turns · $0.79 | first prompt · 11 turns · $0.30 |
| Paper Lantern (moderate theme) | first prompt · 20 turns · $0.30 | refused by the API (below) |
| **all six** | **6 of 6 · 157 turns · $5.46 · 31 min** | **5 of 6 · 201 turns · $8.17 · 32 min** |

On the four plugins, the fitted builds took 33–48% fewer turns and cost $4.37 against $7.70. On the themes it went the
other way for Harbour Fog: the fitted build spent 13 minutes drawing the harbour scene above, where the plain one made
a simpler picture in two.

The plain Paper Lantern session ended with the API's own refusal on its first turn, and on each follow-up. The starting
home directory still held a deliberately malicious theme that the security tests plant, and the agent printed it while
looking around. That is a fault in the starting directory, not in either arm; it is reported as it happened rather than
re-run.

One session per subject per arm is an example, not a rate. Full per-prompt numbers are in [RESULTS.md](RESULTS.md).

## What "passed" means, and what it doesn't

Plugins passed when Omarchy's validator accepted them, every entry point loaded in Quickshell with no QML errors from
the plugin's own files, the plugin was switched on in `shell.json`, and a check for what was asked held. Themes passed
when `colors.toml` carried every key a stock theme has with the asked-for mode, there was a background of at least 640
pixels, and the bar drew in its colours.

- Everything was drawn offscreen, not on a live desktop. Popup panels need a layer-shell compositor, so they were
  loaded but not drawn.
- Some subject checks read the code rather than watching it run. Screen Sleep's check passed the fitted build on a word
  in its manifest; reading the code confirms it turns screens off with `omarchy-brightness-display`, which dispatches
  Hyprland's DPMS, and never suspends.
- Nobody has run these on their own desktop yet. Issues are welcome.

## The preview tool

[`tools/preview`](tools/preview) loads any Omarchy shell plugin in Quickshell offscreen, prints the QML errors from the
plugin's files and the text each bar widget drew, and saves a picture. Popup types are swapped for stand-ins with the
same properties, and the bar the widget is given records commands instead of running them. Run it on plugin code you
didn't write inside a sandbox: QML can start processes.

```bash
python3 tools/preview/preview.py ~/.config/omarchy/plugins/<id>
python3 tools/preview/preview.py --theme ~/.config/omarchy/themes/<slug>
```

It found one thing about Omarchy along the way: the stock bar clock updates once a minute, so putting `ss` in its
format shows seconds that never move (it drew `14:58:00` twice, 3.2 seconds apart). A copy of the widget set to
`precision: SystemClock.Seconds` ticks.

## A pilot run first

A first run found two faults in the checks rather than the builds: the preview gave widgets no bar, so reading
`bar.foreground` failed, and the switched-on check crashed on one shape of `shell.json`. Both were fixed and all twelve
sessions ran again from scratch. The pilot's results agreed with these.

## Credit

The plugin ideas come from plugins in the Omarchy catalog: Disk HUD, Screen Sleep and Opacity (Parker Brown; Opacity is
a cut of wicky14's Rounded Corner Blur), and Omarchy Drawer Redux by Corey Tyhurst. h0 never saw their code. Omarchy is
by DHH and its contributors; the plugin system, Quickshell shell and theme format are theirs.

MIT licence.
