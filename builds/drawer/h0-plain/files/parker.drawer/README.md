# parker.drawer — bar drawer

A drawer button for the Omarchy top bar. Widgets you list in the drawer leave
the bar; clicking the button opens a panel holding them.

## Choosing what goes in the drawer

Everything is in `~/.config/omarchy/shell.json` (hot-reloads on save):

```json
"bar": {
  "id": "parker.drawer",
  "layout": {
    "right": [
      { "id": "omarchy.tray" },
      { "id": "parker.drawer", "items": ["omarchy.weather", "omarchy.bluetooth"] },
      { "id": "omarchy.bluetooth" },
      { "id": "omarchy.audio" }
    ]
  }
}
```

- `bar.id: "parker.drawer"` turns the drawer bar on. Set it back to
  `"omarchy.bar"` (or delete it) to return to the stock bar; tucked widgets
  then simply reappear on the bar.
- `items` lists widget ids in the order they appear in the drawer. Take one
  out of `items` and it goes back to its spot on the bar.
- **Leave each tucked widget's own entry in `bar.layout`.** It is hidden from
  the bar, but it still holds the widget's settings (clock format, etc.) and
  keeps third-party widgets enabled.
- Optional: `icon`, `iconOpen`, `tooltip` on the drawer entry. You can add
  more than one drawer entry, each with its own `items`.
- Hotkey: `omarchy-shell shell toggle parker.drawer`. Summoning a tucked
  widget (e.g. `omarchy-shell shell toggle omarchy.bluetooth`) opens the
  drawer and then that widget's panel.

## How it works

A plain bar widget never gets the widget catalogue, so it cannot host other
widgets. This plugin therefore is also a *bar option* (`kind: bar`):
`DrawerBar.qml` loads the stock `$OMARCHY_PATH/shell/plugins/bar/Bar.qml`
unmodified (so Omarchy bar updates still arrive), gives it the layout minus
tucked widgets, and registers `DrawerButton.qml` with it. The button renders the
tucked widgets in a popup, the same way the bar renders its own slots.
`DrawerModel.js` holds the pure layout logic.

## Limitations

- Couples to stock `Bar.qml` internals (`registerModuleSlot`,
  `pluginBarApiFor`, `barWidgetRegistry`). If an Omarchy update renames them,
  the drawer may break. If the stock bar fails to load at all, the plugin
  switches `bar.id` back to `omarchy.bar` and sends a notification.
- Hover tooltips don't show for widgets inside the drawer (the bar only draws
  tooltips for its own windows). Their click popups do work.
- Under any non-stock bar, third-party widgets get Omarchy's service-less
  facade. Built-in `omarchy.*` widgets are unaffected.
- Shell command modules (`"type": "command"` / `"qml"`) can't be tucked; only
  registered widgets can.
- Tucking an id tucks every instance of it.

## Test

```
QML_XHR_ALLOW_FILE_READ=1 QT_QPA_PLATFORM=offscreen QT_FORCE_STDERR_LOGGING=1 qml6 test/ModelTest.qml
```
