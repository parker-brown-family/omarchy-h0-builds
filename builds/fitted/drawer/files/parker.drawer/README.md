# parker.drawer

A bar button (󰅀) that opens a small strip under it holding bar widgets you
have tucked away, so the bar itself shows only the essentials.

## Choosing what goes in the drawer

Edit the drawer's entry in `~/.config/omarchy/shell.json` (hot-reloads):

```json
{ "id": "parker.drawer",
  "items": [
    "omarchy.weather",
    "omarchy.agents",
    { "id": "omarchy.clock", "format": "HH:mm" }
  ] }
```

- An item is a widget id, or a full layout entry with its inline settings.
  To tuck a widget away, move its entry from `bar.layout` into `items`, and
  don't leave it in both places.
- Ids are any bar widget: stock `omarchy.*`, your clones (`parker.*`), or
  installed plugins. List them with `omarchy plugin list`.
- An unknown id shows up in the drawer as `? the-id`.
- Optional settings are `icon`, `iconOpen`, and `tooltip`.
- `"allowMultiple": true` lets you add several drawers, each with its own items.
- `omarchy-shell shell toggle parker.drawer '{}'` opens and closes it, so you
  can bind it to a key.

## Behaviour

- Click the button, press Esc, or click elsewhere to close the drawer.
  Opening another bar panel closes it too.
- Hosted widgets open their own panels from the drawer. While one is open,
  the first outside click closes that panel and the next one closes the drawer.
- Settings a hosted widget saves (e.g. the clock's right-click format cycle)
  are written back into its `items` entry.
- The drawer window is built the first time you open it and is kept after
  that, so hosted widgets start running on first open.

## Limitations

Hosted widgets talk to this plugin's scoped bar interface, not directly to
the bar, so a few things that need the built-in bar don't work inside the
drawer:

- keyboard shortcuts that summon a specific widget's panel (they look for it
  in the bar);
- the volume/brightness OSD on scroll;
- the media section of the audio panel.

Widgets that work best in the drawer are the ones that sit outside the bar's
own layout logic. The tray and indicators already reveal on hover, so keep
those in the bar.
