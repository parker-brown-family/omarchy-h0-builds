.pragma library

// Pure layout helpers for the drawer. No QML types here so the logic can be
// exercised outside the shell (see test/model.test.js).

var SECTIONS = ["left", "center", "right"]

function isPlainObject(value) {
  return value !== null && typeof value === "object" && !Array.isArray(value)
}

function entryId(entry) {
  if (typeof entry === "string") return entry
  if (isPlainObject(entry) && entry.id !== undefined && entry.id !== null) return String(entry.id)
  return ""
}

function entrySettings(entry) {
  var out = {}
  if (!isPlainObject(entry)) return out
  for (var key in entry) if (key !== "id") out[key] = entry[key]
  return out
}

// `items` on a drawer entry may be a list of ids or a single id string.
function itemList(entry, drawerId) {
  var raw = isPlainObject(entry) ? entry.items : null
  if (typeof raw === "string") raw = [raw]
  if (!Array.isArray(raw)) return []
  var out = []
  for (var i = 0; i < raw.length; i++) {
    var id = entryId(raw[i]).trim()
    if (!id || id === drawerId || out.indexOf(id) !== -1) continue
    out.push(id)
  }
  return out
}

// Every widget id tucked by any drawer entry in the layout.
function tuckedIds(layout, drawerId) {
  var out = []
  if (!isPlainObject(layout)) return out
  for (var s = 0; s < SECTIONS.length; s++) {
    var entries = layout[SECTIONS[s]]
    if (!Array.isArray(entries)) continue
    for (var i = 0; i < entries.length; i++) {
      if (entryId(entries[i]) !== drawerId) continue
      var items = itemList(entries[i], drawerId)
      for (var j = 0; j < items.length; j++) if (out.indexOf(items[j]) === -1) out.push(items[j])
    }
  }
  return out
}

// Copy of the bar config with tucked widgets removed from the visible layout.
// Their entries stay in shell.json, so their settings keep persisting.
function filteredBarConfig(barConfig, drawerId) {
  var config = isPlainObject(barConfig) ? JSON.parse(JSON.stringify(barConfig)) : {}
  var layout = isPlainObject(config.layout) ? config.layout : null
  if (!layout) return config
  var tucked = tuckedIds(layout, drawerId)
  if (tucked.length === 0) return config
  for (var s = 0; s < SECTIONS.length; s++) {
    var entries = layout[SECTIONS[s]]
    if (!Array.isArray(entries)) continue
    layout[SECTIONS[s]] = entries.filter(function(entry) {
      return tucked.indexOf(entryId(entry)) === -1
    })
  }
  return config
}

// The widgets one drawer should host, in the order listed in `items`. Each
// widget's settings come from its own entry in bar.layout; a widget listed in
// `items` but absent from the layout gets empty settings.
function drawerItems(layout, drawerEntry, drawerId) {
  var items = itemList(drawerEntry, drawerId)
  var out = []
  for (var i = 0; i < items.length; i++) {
    var found = null
    if (isPlainObject(layout)) {
      for (var s = 0; s < SECTIONS.length && !found; s++) {
        var entries = layout[SECTIONS[s]]
        if (!Array.isArray(entries)) continue
        for (var j = 0; j < entries.length; j++) {
          if (entryId(entries[j]) === items[i]) {
            found = { id: items[i], region: SECTIONS[s], settings: entrySettings(entries[j]), inLayout: true }
            break
          }
        }
      }
    }
    out.push(found || { id: items[i], region: "drawer", settings: {}, inLayout: false })
  }
  return out
}

// The drawer entry for a given button's settings. The bar injects settings
// without the id, so rebuild the entry shape the helpers expect.
function entryFromSettings(drawerId, settings) {
  var entry = { id: drawerId }
  if (isPlainObject(settings)) for (var key in settings) entry[key] = settings[key]
  return entry
}
