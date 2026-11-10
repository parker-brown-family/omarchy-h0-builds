# h0 + Omarchy fitting building Bar Drawer

h0 with its Omarchy fitting (omarchy-v4), on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 49 | 3,013,236 | 44,023 | $2.04 | 9.9 | all pass |
| **all** | | **49** | | | **$2.04** | **9.9** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

49 model calls, $2.04, 595 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.bar-drawer
- ✓ `validate`
- ✓ `loads`: plugin parker.bar-drawer  (~/.config/omarchy/plugins/parker.bar-drawer)
- ✓ `switched-on`: id parker.bar-drawer
- ✓ `configurable`: read from the code and the preview

<details><summary>The harness's reply</summary>

I built the drawer plugin and turned it on in your bar. It passes the project's checks and an offscreen test, but I couldn't run it on your real desktop, so nobody has clicked it yet.

**How it works:** a chevron button sits in the bar, next to the tray. Click it and a panel slides out under it showing your tucked-away widgets. Click any of those and its normal popup opens, with the drawer staying open behind it. The drawer closes when you:
- click the button again,
- open any other bar popup, or
- move the pointer away for about 0.9s, but only once it has been over the drawer.

It works with the bar on any edge.

**Choosing what goes in the drawer** — this is the drawer's entry in `.config/omarchy/shell.json`:
```json
{ "id": "parker.bar-drawer",
  "items": [ {"id":"omarchy.weather"}, {"id":"omarchy.keyboard-layout"},
             {"id":"omarchy.agents"}, {"id":"omarchy.bluetooth"}, {"id":"omarchy.monitor"} ],
  "autoClose": true, "autoCloseDelay": 900 }
```
I picked those five as a starting point and moved them out of `bar.layout`; change the list however you like. Each item can be just a widget id (`"omarchy.weather"`) or an object with the widget's usual settings (`{"id":"omarchy.clock","format":"HH:mm"}`). When you tuck a widget away, delete its entry from `bar.layout` so it doesn't show twice; the plugin logs a warning if you forget. It also warns about ids it doesn't recognise. Your bar now shows menu and workspaces on the left, indicators, clock and system-update in the middle, and tray, drawer, network, audio and power on the right. The file reloads on save, and your original is backed up as `shell.json.bak.<timestamp>`.

**Files** (in `.config/omarchy/plugins/parker.bar-drawer/`):
- `manifest.json`
- `Drawer.qml`: the button, open/close behaviour, and the lookup of installed widgets (built-in and your own plugins)
- `DrawerWindow.qml`: the panel
- `NestedBar.qml`: passes the bar connection through to the tucked widgets, and keeps the drawer open while one of them has its popup up

**Checks:**
- The `build`, `validate` and `json` checks all pass.
- I also ran a temporary offscreen test that opens the drawer. It found the tucked widgets and loaded them into the panel. Tucked widgets could find their own copies, and opening another popup closed the drawer. An unknown id produced a warning.
- What I couldn't check: the panel's actual position on screen, clicks reaching the bar underneath it, and tucked widgets' popups opening just beyond the drawer. That needs Hyprland, so please try it and tell me if anything is misplaced. If it doesn't appear, run `omarchy-shell shell rescanPlugins`.

**Limitations, because widgets in the drawer run through your plugin rather than the bar itself:**
- **No hover tooltips** for tucked widgets.
- **No volume/brightness pop-up display** (the on-screen display) when you scroll on tucked audio or monitor widgets. The shell's permissions block plugins from showing it.
- **Shortcuts that open a tucked widget's panel** (e.g. bluetooth or monitor) won't work until you've opened the drawer once per session. The tucked widgets only load on first open.
- **Your tucked widgets' popups:** the drawer stays open while one is up, but I haven't checked where they appear.
- **`"type": "command"` / `"type": "qml"` custom modules** aren't supported in the drawer yet.
- **Keyboard shortcut:** none yet, but I can add one, since the drawer responds to `omarchy-shell shell toggle parker.bar-drawer '{}'`.

</details>

Every step: [SESSION.md](SESSION.md).
