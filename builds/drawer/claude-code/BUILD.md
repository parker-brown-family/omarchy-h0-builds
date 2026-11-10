# Claude Code building Bar Drawer

Claude Code 2.1.296 as shipped, with the Omarchy skill Omarchy installs, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 47 | 5,927,004 | 61,816 | $3.30 | 12.3 | failed: configurable |
| 2 | follow-up | 28 | 5,890,938 | 31,711 | $2.04 | 9.0 | all pass |
| **all** | | **75** | | | **$5.34** | **21.3** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

47 model calls, $3.30, 738 s. Effort sent: medium.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.drawer
- ✓ `validate`
- ✓ `loads`: plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
- ✓ `switched-on`: id parker.drawer
- ✗ `configurable`: read from the code and the preview

<details><summary>The harness's reply</summary>

I've built the drawer plugin and switched your bar to use it. I couldn't see it on screen, though: there's no running desktop session here and `omarchy-shell` isn't running. So check it the first time the shell starts. The logic and the QML did pass tests in Quickshell itself (details below).

**How you choose what's tucked away** (`~/.config/omarchy/shell.json`, reloads when you save):

```json
"bar": {
  "id": "parker.drawer",
  "layout": {
    "right": [
      { "id": "omarchy.tray" },
      { "id": "parker.drawer", "items": ["omarchy.agents", "omarchy.bluetooth", "omarchy.monitor", "omarchy.weather", "omarchy.keyboard-layout"] },
      ...
```

- **The button:** the `parker.drawer` entry is the drawer button. Move it to wherever you want it on the bar.
- **The contents:** `items` lists the widgets in the drawer, in the order they appear in the panel. Add an id to tuck a widget away; remove it to put it back on the bar.
- **The rest of the layout:** tucked widgets keep their normal entry in the bar layout, so their settings and enabled state don't change.
- **Starter set:** I picked the five widgets above as a starting point. Change them to whatever you like.

**How it behaves:**
- Clicking the button opens a small bar-style panel under it.
- Tucked widgets work as they do on the bar, including opening their own panels from inside the drawer.
- Clicking outside the drawer, or opening another bar panel, closes it.
- Panel shortcuts for tucked widgets still work: they open the drawer, then the widget's panel.
- Optional `icon` and `tooltip` settings change the button.

**How it's built:** the plugin is in `~/.config/omarchy/plugins/parker.drawer/`. It loads Omarchy's own bar from `$OMARCHY_PATH` instead of copying it, so you keep getting Omarchy's bar updates. It only removes the tucked widgets from the bar and adds the drawer button. There's a README in that folder.

**Testing:**
- Both QML files load cleanly in Quickshell against Omarchy's real UI modules.
- 25 checks on the drawer passed, covering hosting widgets, passing in settings, opening and closing panels, and shortcuts.
- 12 checks on the wrapper passed, using a stand-in for the stock bar.
- On your actual `shell.json`, the bar keeps menu, workspaces, indicators, clock, update, tray, the drawer button, network, audio and power; the five starter widgets go in the drawer.

**Limitations:**
- Tucking works by widget id, so if you have two of the same widget (two clocks, say), both get tucked.
- Custom `command`/`qml` modules can't be tucked.

**To try it:** run `omarchy restart shell`. If anything looks wrong, delete the `"id": "parker.drawer"` line under `bar` to go back to the stock bar. Your original config is backed up at `~/.config/omarchy/shell.json.bak.1794269529`.

</details>

## Prompt 2

```text
It's not working yet: I don't see a drawer button in the bar, or a way to pick the drawer's widgets from its shell.json entry.

read from the code and the preview
```

28 model calls, $2.04, 543 s. Effort sent: medium.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.drawer
- ✓ `validate`
- ✓ `loads`: plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
- ✓ `switched-on`: id parker.drawer
- ✓ `configurable`: read from the code and the preview

<details><summary>The harness's reply</summary>

The drawer should now show up as a button on your normal bar, and you choose its widgets with the `items` list on its entry in `shell.json`. I still couldn't see it on screen: there's no running desktop session here, and I found no preview file anywhere in the workspace. So I went by the code and checked it with offscreen tests inside Quickshell.

**What was wrong:**
1. **The drawer wasn't a normal bar widget.** I'd built it as a replacement for the whole bar, so `omarchy.bar` treated the `parker.drawer` entry as unknown and drew nothing. Its manifest also had no settings schema, so `items` wasn't a setting the shell knew about.
2. **`items` was being ignored.** When the shell hands settings to a widget, `items` can arrive as a Qt list type rather than a plain array. My code only accepted plain arrays, so the drawer always ended up empty. Omarchy's own Indicators widget handles `items` the same tolerant way my fix now does.

**What I changed:**
- **Plugin type:** `parker.drawer` is now an ordinary `bar-widget` plugin that runs inside the stock bar. The bar-replacement file is deleted.
- **Picker:** the manifest declares `items` as a multiselect of all the built-in widgets, the same way `omarchy.indicators` declares its `items`, plus optional `icon` and `tooltip` settings.
- **`shell.json`:** I removed the `bar.id` override. The drawer entry sits after the tray, and its five widgets (agents, bluetooth, display, weather, keyboard layout) are now listed only in its `items`:
  ```json
  { "id": "parker.drawer", "items": ["omarchy.agents", "omarchy.bluetooth", "omarchy.monitor", "omarchy.weather", "omarchy.keyboard-layout"] }
  ```
  To tuck a widget away, move its id from the bar layout into `items`; to bring it back, move it back. If an id is in both places, it shows in both.

**Testing:**
- Omarchy's own plugin registry finds `parker.drawer`, accepts it as a third-party bar widget, counts it as enabled from your `shell.json`, and reads its three settings.
- 14 checks on the drawer passed using your real `shell.json`. They cover the button showing, reading `items`, building the tucked widgets, and opening and closing panels.
- Agents, bluetooth and display couldn't be built offscreen because their panels need a real display. The stock bar fails on them the same way in that environment, so it's not a drawer bug, but I couldn't confirm those three load.

**Limitations:**
- Tucked widgets get the same limited bar access as any third-party widget, so a few extras (for example the audio panel's media controls) may not work inside the drawer.
- `omarchy-shell shell toggle omarchy.audio` won't reach a tucked widget. The widget's own target (`omarchy-shell omarchy.audio toggle`) does, and the drawer opens around it.

Run `omarchy restart shell` to load it. If the button still doesn't appear, the output of `omarchy-shell shell listPlugins` and the shell log would show me what's going on.

</details>

Every step: [SESSION.md](SESSION.md).
