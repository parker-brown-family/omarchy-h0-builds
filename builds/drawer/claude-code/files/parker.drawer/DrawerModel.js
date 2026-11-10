// Pure helpers for the drawer widget. Kept free of QML so they can be
// exercised outside the shell.

function isPlainObject(value) {
  return value !== null && typeof value === "object" && !Array.isArray(value)
}

// Settings arrays can reach a widget as Qt sequences rather than JS arrays
// (Array.isArray is false for them), so accept anything array-like.
function itemList(settings) {
  var items = isPlainObject(settings) ? settings.items : null
  if (!items || typeof items === "string" || typeof items.length !== "number") return []
  var out = []
  for (var i = 0; i < items.length; i++) out.push(items[i])
  return out
}

function entryId(entry) {
  if (typeof entry === "string") return entry
  if (isPlainObject(entry) && entry.id !== undefined && entry.id !== null) return String(entry.id)
  return ""
}

// Ordered, de-duplicated widget ids from the drawer's `items` setting.
// Items are ids ("omarchy.audio") or entries ({ "id": "omarchy.clock", ... }).
function itemIds(settings, selfId) {
  var items = itemList(settings)
  var ids = []
  for (var i = 0; i < items.length; i++) {
    var id = entryId(items[i])
    if (id && id !== selfId && ids.indexOf(id) === -1) ids.push(id)
  }
  return ids
}

// Inline settings for one tucked widget: the extra fields on its object form
// in `items`, the same shape as a bar layout entry.
function itemSettings(settings, id) {
  var items = itemList(settings)
  for (var i = 0; i < items.length; i++) {
    if (!isPlainObject(items[i]) || entryId(items[i]) !== id) continue
    var copy = JSON.parse(JSON.stringify(items[i]))
    delete copy.id
    return copy
  }
  return {}
}

// Parse the catalogue scan: one JSON object per line, `{ id, file }`, where
// `file` is the widget's barWidget entry point. Later lines win, so user
// plugins override built-ins with the same id. Entry points that climb out
// of their plugin directory are dropped, as the shell's own registry does.
function parseCatalogue(text) {
  var out = {}
  var lines = String(text || "").split("\n")
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i].trim()
    if (!line) continue
    var row = null
    try { row = JSON.parse(line) } catch (e) { continue }
    if (!isPlainObject(row) || !row.id || !row.file) continue
    var file = String(row.file)
    if (file.charAt(0) !== "/" || file.split("/").indexOf("..") !== -1) continue
    out[String(row.id)] = file
  }
  return out
}

if (typeof module !== "undefined") {
  module.exports = {
    entryId: entryId,
    itemIds: itemIds,
    itemSettings: itemSettings,
    parseCatalogue: parseCatalogue
  }
}
