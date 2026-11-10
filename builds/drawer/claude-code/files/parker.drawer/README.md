# Drawer (`parker.drawer`)

A bar widget for the stock Omarchy bar: a button that opens a panel holding
the widgets you have tucked away, so the bar itself shows only the essentials.

## Choosing what goes in the drawer

Add a drawer entry to `bar.layout` in `~/.config/omarchy/shell.json` and list
the widgets it holds in `items`. The file hot-reloads on save.

```json
"right": [
  { "id": "omarchy.tray" },
  { "id": "parker.drawer", "items": ["omarchy.bluetooth", "omarchy.monitor", "omarchy.weather"] },
  { "id": "omarchy.network" },
  { "id": "omarchy.audio" },
  { "id": "omarchy.power" }
]
```

- The `parker.drawer` entry is the button; put it wherever you want it.
- `items` is the panel's contents, in order. To tuck a widget away, move its
  id from the bar layout into `items`; to bring it back, move it back. A widget
  listed in both places shows in both.
- A tucked widget's settings go on its object form in `items`, the same fields
  its bar entry would take: `{ "id": "omarchy.clock", "format": "HH:mm" }`.
- Several drawers are fine: add more `parker.drawer` entries, each with its own
  `items`.

| Key       | Default            | Meaning                         |
|-----------|--------------------|---------------------------------|
| `items`   | `[]`               | Widget ids (or entries) to hold |
| `icon`    | `""` (falls back to `\uf141`, an ellipsis) | Nerd Font glyph for the button |
| `tooltip` | `"Drawer"`         | Button tooltip                  |

The same keys are declared in `manifest.json`, so the shell's widget settings
offer `items` as a multiselect of the built-in widgets.

## Behaviour

- Left-click the button to open or close the drawer. Clicking outside it, or
  opening another bar panel, closes it.
- Tucked widgets work as they do on the bar, and their own panels open from
  inside the drawer.
- `omarchy-shell shell toggle parker.drawer` toggles the drawer.

## Limits

- A tucked widget gets the same plugin-scoped bar access a third-party widget
  gets. A few built-in extras that need the trusted bar are unavailable inside
  the drawer, such as the audio panel's media controls and on-screen display.
- `omarchy-shell shell toggle <widget>` reaches widgets on the bar, not tucked
  ones. Use the widget's own IPC target instead, e.g.
  `omarchy-shell omarchy.audio toggle`; the drawer opens around it.
- Only catalogue widgets (built-in and installed plugins) can be tucked, not
  custom `command`/`qml` modules.

## Files

- `Drawer.qml`: the button, the panel, and hosting of tucked widgets. Widgets
  are found by scanning plugin manifests in `$OMARCHY_PATH/shell/plugins` and
  `~/.config/omarchy/plugins` for their `barWidget` entry point.
- `DrawerModel.js`: pure helpers for reading `items` and the scan output.
