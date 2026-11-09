# parker.drawer: bar drawer

A button for the normal Omarchy bar. Clicking it opens a panel holding the bar
widgets listed in its `widgets` setting, so the bar itself only shows the
essentials.

## Configure (`~/.config/omarchy/shell.json`, hot-reloads on save)

Put the drawer in the bar layout wherever you want the button, and list the
widgets to tuck away on that entry:

```jsonc
"right": [
  { "id": "omarchy.tray" },
  {
    "id": "parker.drawer",
    "widgets": [
      "omarchy.weather",
      "omarchy.bluetooth",
      { "id": "omarchy.clock", "format": "HH:mm" }   // full entries take inline settings
    ]
  },
  { "id": "omarchy.network" }
]
```

- `widgets` items are widget ids, or full entries in the same shape as
  `bar.layout` entries (inline settings, `"type": "command"` modules).
- Listed widgets appear in the drawer in that order. Remove them from the rest
  of the layout so they don't show up twice.
- Optional settings on the drawer entry: `icon`, `openIcon`, `tooltip`.
- An id the shell doesn't know shows as `id?` in the drawer.

## Keyboard / IPC

```bash
omarchy-shell shell toggle parker.drawer '{}'   # also: summon, hide
```

## How it works

Bar widgets are only given `bar`, `moduleName` and `settings`, so the plugin also
declares a `service` (DrawerService.qml). The shell gives services the bar-widget
catalogue, and the drawer widget reads it through
`bar.shell.serviceFor("parker.drawer")` to build the listed widgets from the
same components the bar uses. Each tucked widget gets a small proxy of the
drawer's bar facade (HostBar.qml). Through it, opening a tucked widget's own
panel keeps the drawer open, and clicks are never routed through the bar.

## Known limits

- Third-party widgets can only go in the drawer if they are installed and
  enabled. A third-party plugin counts as enabled when it has an entry in the
  bar layout.
- Hotkeys that summon a specific widget (e.g. `shell summon omarchy.weather`)
  only reach widgets on the bar, not ones in the drawer. Open the drawer and
  click the widget instead.
- Hover tooltips of tucked widgets don't show (the bar's tooltip only renders
  over the bar), and widget settings written back from inside the drawer (like
  the clock's click-to-switch format) aren't saved.
