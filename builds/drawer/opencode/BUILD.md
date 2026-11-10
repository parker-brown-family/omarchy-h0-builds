# opencode building Bar Drawer

opencode 2.0.28 as shipped, with the Omarchy skill Omarchy installs, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 71 | 11,130,595 | 79,545 | $4.92 | 13.5 | failed: loads |
| 2 | follow-up | 20 | 4,890,256 | 12,517 | $1.31 | 2.1 | all pass |
| **all** | | **91** | | | **$6.23** | **15.6** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

71 model calls, $4.92, 808 s. Effort sent: None.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.drawer
- ✓ `validate`
- ✗ `loads`: plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
- ✓ `switched-on`: id parker.drawer
- ✓ `configurable`: read from the code and the preview

<details><summary>The harness's reply</summary>

I've built the drawer plugin and added it to your top bar. It hasn't been run inside your live shell yet. My test setup had no compositor, so I tested the plugin's logic using your real first-party widgets on a stand-in bar. That covered opening and closing, one popup at a time, settings being saved, and the hotkey command. The panels inside the drawer and exactly where the drawer lands on screen still need checking on your desktop. The shell picks up the changes when they're saved, and `omarchy-shell shell rescanPlugins` forces a reload if it doesn't.

**What it does**
- A chevron button sits in the right section of the bar, next to the tray. Clicking it opens a card just below the bar holding the widgets you've tucked away.
- Those widgets work the same as on the bar, including their popups and tooltips. They keep running while the drawer is closed.
- Escape, a click anywhere else, or opening another bar panel closes the drawer.
- `omarchy-shell shell toggle parker.drawer` opens it from a key.

**Choosing what goes in the drawer** (`~/.config/omarchy/shell.json`):
```json
{ "id": "parker.drawer", "items": ["omarchy.weather", "omarchy.keyboard-layout", "omarchy.agents"] }
```
I moved weather, keyboard-layout and agents in as a starting point. Edit the list however you like:
- Use the same ids as on the bar. An item can also be an object with its usual settings, e.g. `{ "id": "omarchy.clock", "format": "HH:mm" }`.
- Take a widget off the bar when you add it here. If it's still on the bar, the drawer skips it so you don't get two copies.
- An optional `"icon"` replaces the chevron.
- Settings a widget saves itself, like the clock format, are written back into `items`.

**Things to know**
- **Panel hotkeys:** keys like `SUPER+CTRL+B` (Bluetooth) and `SUPER+CTRL+D` (Display) only reach widgets on the bar. That's why I left Bluetooth and Monitor out of the starting list. If you move them in, rebind those keys to `omarchy-shell parker.drawer togglePanel omarchy.bluetooth` (or `omarchy.monitor`).
- **Some widgets can't go in the drawer.** Media, and the Do Not Disturb, Night Light and Stay Awake indicators, need access that only the built-in bar gives. Custom command and QML modules aren't supported either.
- **System updates:** I left the update indicator on the bar so you'll still see when updates are available.

The plugin is in `~/.config/omarchy/plugins/parker.drawer/`, with a short `README.md` covering the options above. Your previous config is saved as `~/.config/omarchy/shell.json.bak.1794284063`.

</details>

## Prompt 2

```text
It's not working yet: it doesn't load in the shell. The shell says:

plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
  barWidget: Widget.qml: errors; drew no text
    picture: ~/.h0-preview/parker.drawer-barWidget.png
    WARN scene: file://~/.config/omarchy/plugins/parker.drawer/Widget.qml[334:3]: No PanelWindow backend loaded.
    WARN qml: PREVIEW_LOAD_ERROR file://~/.config/omarchy/plugins/parker.drawer/Widget.qml
  service: Service.qml: loaded; drew no text
PREVIEW: FAILED
```

20 model calls, $1.31, 128 s. Effort sent: None.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.drawer
- ✓ `validate`
- ✓ `loads`: plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
- ✓ `switched-on`: id parker.drawer
- ✓ `configurable`: read from the code and the preview

<details><summary>The harness's reply</summary>

I fixed the load error, so the drawer button now loads without needing a window backend. It still hasn't been run inside your live shell.

**What was wrong:** the drawer's windows were built directly into `Widget.qml`, the button's own file. The preview has no way to create windows, so that one failure stopped the whole widget from loading, button included.

**The fix:** the windows now live in a separate file, `Drawer.qml`, which only loads the first time you open the drawer. The button itself never creates a window, so it loads anywhere.

**One change in behaviour:** the tucked-away widgets now start up the first time you open the drawer, not when the shell starts. After that they keep running while it's closed, as before. The same applies to the hotkey bridge (`omarchy-shell parker.drawer togglePanel <id>`): it opens the drawer first, then the panel.

While retesting I also found and fixed a bug from the split. Widgets inside the drawer weren't being connected to it, so only one popup at a time wasn't enforced and the clock couldn't save its format.

**Tests:**
- **Preview conditions:** loading `Widget.qml` alone with no window backend now gives no warnings, and the button draws at 27×26.
- **Behaviour:** I ran the plugin on a stand-in bar on a virtual screen (no Wayland), with the real clock and keyboard-layout widgets. Opening and closing, one popup at a time, the clock saving its format into `items`, widgets staying loaded after closing, the hotkey commands and cleanup all work.
- **Not covered:** the Wayland-specific parts (exact drawer placement and keyboard focus) can only be checked on your desktop. The Wayland-only lines were removed for these tests. Panels that open from widgets inside the drawer, like the clock's calendar, also didn't open there.

The plugin still passes `omarchy plugin validate`. To reload it, run `omarchy-shell shell rescanPlugins`.

</details>

Every step: [SESSION.md](SESSION.md).
