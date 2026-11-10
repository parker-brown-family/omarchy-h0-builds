# Drawer

A bar button that opens a drawer holding the bar widgets you tucked away.

## Choosing what goes in the drawer

Add the drawer to the bar in `~/.config/omarchy/shell.json` and list the
widgets it should hold under `items`. Take those widgets out of the bar
layout itself; a widget that is still on the bar stays on the bar.

```json
{
  "id": "parker.drawer",
  "items": [
    "omarchy.weather",
    { "id": "omarchy.clock", "format": "HH:mm" },
    "omarchy.agents"
  ]
}
```

- Items use the same ids as the bar (`omarchy plugin list`). An item can be a
  plain id or an object with the same inline settings the widget takes on the
  bar.
- Widgets appear in the drawer in the order listed. Settings a widget saves
  itself (cycling the clock format, for example) are written back into
  `items`.
- `icon` (optional) replaces the default chevron with any glyph.
- `shell.json` hot-reloads, so edits apply on save.

## Using it

- Click the button (or `omarchy-shell shell toggle parker.drawer`) to open or
  close the drawer. Press Escape or click anywhere else to close it.
- Hosted widgets work as they do on the bar, including their popups and
  tooltips. They load the first time the drawer opens and then stay mounted
  while it is closed.
- Panel hotkeys such as `omarchy-shell shell toggle omarchy.bluetooth` only
  reach widgets on the bar. To open a drawer widget's panel from a key, bind
  `omarchy-shell parker.drawer togglePanel omarchy.bluetooth` instead.

## Limits

- Widgets that need a shell service only the built-in bar grants
  (`omarchy.media` and the Do Not Disturb, Night Light, and Stay Awake
  indicators) cannot work from the drawer.
- Custom `"type": "command"` and `"type": "qml"` bar modules are not supported
  in the drawer.
- A third-party widget is only loaded while it is enabled. If it lives only in
  the drawer, also list `{ "id": "<its id>" }` under the top-level `plugins`
  array so it stays enabled.
