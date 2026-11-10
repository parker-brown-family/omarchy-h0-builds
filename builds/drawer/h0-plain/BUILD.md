# h0, plain building Bar Drawer

h0 with no fitting, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 60 | 5,246,424 | 51,435 | $2.80 | 10.0 | all pass |
| **all** | | **60** | | | **$2.80** | **10.0** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

60 model calls, $2.80, 598 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.drawer
- ✓ `validate`
- ✓ `loads`: plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
- ✓ `switched-on`: id parker.drawer
- ✓ `configurable`: read from the code and the preview

<details><summary>The harness's reply</summary>

I've built the drawer plugin and switched your bar to it. I couldn't run it in the live shell (there's no display in my sandbox), so it's untested on screen. Please check it on your desktop; the things to look at are listed at the end.

**How you choose drawer widgets.** In `~/.config/omarchy/shell.json`, the drawer button's entry has an `items` list of widget ids. Anything listed there leaves the bar and shows up in the drawer, in that order. Leave each tucked widget's own entry in `bar.layout`: it stays hidden from the bar but still holds the widget's settings (like clock format).

**What's in your config now.** The drawer button sits next to the tray, with this starting selection, which is my pick, so edit it freely:
- weather
- system update
- keyboard layout
- agents
- bluetooth
- monitor

The bar now shows: menu and workspaces · indicators and clock · tray, drawer, network, audio, power. The file reloads on save, and the original is backed up as `shell.json.bak.1794268850`.

**Why it also replaces the bar.** Omarchy doesn't let an ordinary bar widget display other widgets; only a full bar plugin can. So the plugin `parker.drawer` (in `~/.config/omarchy/plugins/parker.drawer/`) does both jobs:
- It loads Omarchy's own bar unchanged rather than copying it, so bar updates still reach you. It just hands the bar a layout without the tucked widgets, plus the drawer button.
- Clicking the button opens a panel under it holding the tucked widgets. They keep running while the drawer is closed, and their own popups open from inside it.
- `omarchy-shell shell toggle parker.drawer` works as a hotkey. Summoning a tucked widget, e.g. `omarchy-shell shell toggle omarchy.bluetooth`, should open the drawer and then that widget's popup.
- To undo everything, set `bar.id` back to `"omarchy.bar"`; tucked widgets just reappear on the bar.

**How I checked it:**
- `omarchy plugin validate` passes and shell.json is valid JSON.
- The layout logic is tested by `test/ModelTest.qml`, run against your real shell.json. All checks pass, and a deliberately broken check fails as it should.
- Both QML files parse. `qmllint`'s only warning is one that Omarchy's own popup code also triggers.

**Limitations:**
- **Depends on bar internals.** It relies on internal parts of Omarchy's bar code. An Omarchy update that renames them could break the drawer. If the bar fails to load at all, the plugin sets `bar.id` back to `omarchy.bar` and sends a notification.
- **No hover tooltips** for widgets inside the drawer (clicks still work).
- **Command or custom QML modules can't be tucked**, only registered widgets.
- **Tucking an id moves every copy** of that widget.

**On your desktop, please check:**
- The panel's position under the button.
- Opening a tucked widget's popup from inside the drawer (e.g. bluetooth), then clicking outside to close things.
- Dragging bar widgets to reorder them.

If the drawer doesn't appear, run `omarchy-shell shell rescanPlugins`.

Separately, git shows your `themes/ember` files as deleted. They were already missing when I started; I didn't touch them or restore them.

</details>

Every step: [SESSION.md](SESSION.md).
