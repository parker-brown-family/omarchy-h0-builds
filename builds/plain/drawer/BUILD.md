# How h0 built Bar Drawer

h0 (a coding-agent harness) running Claude Opus 5.5 (claude-opus-5-5), fitting `none`, in a sandbox holding a copy of an Omarchy 4 home directory. It was sent the idea below, then, after each reply, the same automatic checks ran; when one failed, the next prompt was written from a fixed template from what the check printed, the way a person pastes back an error. Nobody edited its files. The protocol is in the omarchy-h0-builds repository.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 48 | 4,622,210 | 64,892 | $2.99 | 13.0 | failed: configurable |
| 2 | follow-up | 34 | 3,299,468 | 33,728 | $1.92 | 7.1 | all pass |
| **all** | | **82** | | | **$4.91** | **20.1** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that tidies my top bar: a drawer button that, when I click it, opens a panel holding the bar widgets I've chosen to tuck away, so the bar only shows the essentials. I want to choose which widgets go in the drawer in shell.json.
```

48 turns, $2.99, 779 s. Stop: `end_turn`.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.drawer
- ✓ `validate`
- ✓ `loads`: plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
- ✓ `switched-on`: id parker.drawer
- ✗ `configurable`: read from the code and the preview

<details><summary>h0's reply</summary>

I've built the drawer as an Omarchy shell plugin, `parker.drawer`, and turned it on in your shell.json. I couldn't see or click it, though: there's no display in this sandbox, so I tested it by running the real Omarchy shell without drawing anything.

**How you use it:** add `"drawer": true` to any widget's entry in `bar.layout` and it moves off the bar into the drawer. Delete the flag and it comes back. The file reloads when you save, no restart needed.

**What it is:** a bar plugin that runs the normal Omarchy bar unchanged and adds a drawer button next to the tray. A plain widget plugin can't do this, because only a whole-bar plugin is allowed to display other widgets.
- Tucked widgets are the real widgets. Clicking one inside the drawer opens its usual panel.
- Tucked widgets stay in their place in shell.json. They keep their settings, and if you switch back to the built-in bar they all reappear.
- You place the button with a `{ "id": "parker.drawer" }` entry in the layout. Without one it goes at the start of the right section, and it hides itself when nothing is tucked.
- Panel hotkeys still work for tucked widgets: summoning, say, Bluetooth opens the drawer and then its panel.
- For a keybind: `omarchy-shell parker.drawer toggle` (also `open` / `close`).

**Your shell.json now** selects this bar, puts the button right after the tray, and tucks a starting set: keyboard layout, weather, system update, agents, Bluetooth and monitor. Edit those flags to whatever you prefer.

The plugin lives in `~/.config/omarchy/plugins/parker.drawer/` (the code plus a README with the config reference).

**How I tested it:**
- The manifest passes `omarchy plugin validate`, all QML files parse, and shell.json is valid JSON.
- I couldn't start Hyprland or Xvfb here, so I ran the actual Omarchy shell without a screen, using a throwaway copy in /tmp. Its only change was swapping the bar's three window types for ones that work without a display.
- In that run the shell found and enabled the plugin. The bar showed only the untucked widgets plus the button, and the tucked ones were placed in the drawer.
- Removing `weather`'s flag while it ran moved weather back onto the bar. Switching back to the built-in bar brought every tucked widget back. My files logged no warnings or errors, and the toggle commands answered.

**Not checked:**
- How the panel looks, mouse clicks, and opening a tucked widget's panel from inside the drawer. Agents, Bluetooth, monitor, audio, network and power couldn't load at all in that test setup, so they weren't exercised. Worth a quick look on your desktop: switch bars with `omarchy restart shell` if needed, click the chevron, then open a tucked widget's panel.
- `omarchy-toggle-bar`'s refresh signal: the run showed a startup clash on the bar's own IPC command. I added a re-register step after load, and the command now answers, but I couldn't prove the right copy of the bar receives it. If hiding the bar ever lags, this is the place to look.

**Known limits:**
- Hover tooltips don't show for widgets inside the drawer.
- Tucked widgets keep the bar's text colour on the panel background.
- The plugin relies on a few internal parts of Omarchy's bar code (`moduleSlots`, `pluginBarApiFor`, `clickTargets`), so a big Omarchy bar rewrite could need a small fix here.

</details>

## Prompt 2

```text
It's not working yet: I don't see a drawer button in the bar, or a way to pick the drawer's widgets from its shell.json entry.

read from the code and the preview
```

34 turns, $1.92, 427 s. Stop: `end_turn`.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.drawer
- ✓ `validate`
- ✓ `loads`: plugin parker.drawer  (~/.config/omarchy/plugins/parker.drawer)
- ✓ `switched-on`: id parker.drawer
- ✓ `configurable`: read from the code and the preview

<details><summary>h0's reply</summary>

You were right: the drawer button couldn't appear in your bar. I'd built the plugin as a full replacement bar, which only shows up if you switch your whole bar to it. That's why your `{ "id": "parker.drawer" }` entry showed nothing. The widget choice was also spread across the layout as `"drawer": true` flags instead of living on the drawer's own entry. The `.h0-preview` folder was empty, so I worked from the code.

**What I changed:** the plugin is now an ordinary button in your normal bar, and you list the drawer's widgets on its own entry:

```json
{ "id": "parker.drawer",
  "widgets": ["omarchy.keyboard-layout", "omarchy.weather", "omarchy.system-update",
              "omarchy.agents", "omarchy.bluetooth", "omarchy.monitor"] }
```

- **Your shell.json:** the switch to the replacement bar and the `drawer` flags are gone. Those six widgets moved out of the bar into the drawer's list, and the button sits right after the tray.
- **List items:** each can be a widget id or a full entry with its own settings, like `{ "id": "omarchy.clock", "format": "HH:mm" }`. Edits apply when you save.
- **Why it now works:** a plain bar widget isn't given access to other widgets, so the plugin also includes a small background service, which is. The drawer gets the real widgets from it, the same ones your bar uses. Clicking a widget in the drawer opens its usual panel, and the drawer stays open underneath it.
- **A bug I fixed on the way:** the `widgets` list arrives in a form my first version didn't recognise as a list, so the drawer saw it as empty.

**How I checked it:** there's no screen in this sandbox, so I ran the real Omarchy shell without drawing anything. My only change to that copy was letting the bar's windows open without a display.
- With your normal bar, the drawer button showed up in the right section, visible and 21px wide.
- The drawer created all six widgets. keyboard-layout, weather and system-update fully started inside it. The other three can't start at all in that test setup, for reasons unrelated to the plugin.
- `omarchy-shell shell toggle parker.drawer '{}'` opened and closed it.
- Changing `widgets` while the shell was running rebuilt the drawer, including the clock's format setting.
- My files logged no warnings, and the plugin passes Omarchy's plugin validator.

**Not checked:** how the panel looks, real mouse clicks, and opening a widget's panel from inside the drawer. Please click the chevron next to the tray to confirm. If the button doesn't appear straight away, run `omarchy restart shell` once, since the plugin's file layout changed.

**Known limits:**
- Hotkeys that open one specific widget, like weather, don't reach widgets inside the drawer.
- Hover tooltips don't show for widgets in the drawer.
- Settings a widget saves itself, like the clock's click-to-switch format, aren't saved from inside the drawer.
- Third-party widgets only work in the drawer if they're also enabled, which means having an entry in the bar layout.

The README in `~/.config/omarchy/plugins/parker.drawer/` covers the details.

</details>

Every tool call and its result: [SESSION.md](SESSION.md). The hash-chained trace: [session/trace.jsonl](session/trace.jsonl).
