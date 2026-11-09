// Pure helpers for the window-opacity widget. No QML dependencies so they can
// be exercised with plain node (see test.js).
.pragma library

var MIN_PERCENT = 10
var MAX_PERCENT = 100

function clampPercent(value) {
  var n = Math.round(Number(value))
  if (!isFinite(n)) return MAX_PERCENT
  return Math.max(MIN_PERCENT, Math.min(MAX_PERCENT, n))
}

// 90 -> "0.90". Fixed precision keeps the Lua file and hyprctl input stable.
function toFraction(percent) {
  return (clampPercent(percent) / 100).toFixed(2)
}

// The Lua table both `hyprctl eval` and the persisted file apply.
function configCall(active, inactive) {
  return "hl.config({ decoration = { active_opacity = " + toFraction(active)
    + ", inactive_opacity = " + toFraction(inactive) + " } })"
}

function luaFile(active, inactive) {
  return "-- Managed by the parker.window-opacity bar widget\n"
    + "-- (~/.config/omarchy/plugins/parker.window-opacity). Moving its sliders\n"
    + "-- rewrites this file; delete it to fall back to your other settings.\n"
    + "hl.config({\n"
    + "  decoration = {\n"
    + "    active_opacity = " + toFraction(active) + ",\n"
    + "    inactive_opacity = " + toFraction(inactive) + ",\n"
    + "  },\n"
    + "})\n"
}

function readOption(text, name) {
  // Anchor on a non-identifier char so "active_opacity" never matches inside
  // "inactive_opacity".
  var re = new RegExp("(^|[^A-Za-z0-9_])" + name + "\\s*=\\s*([0-9]*\\.?[0-9]+)")
  var m = re.exec(String(text || ""))
  if (!m) return MAX_PERCENT
  return clampPercent(parseFloat(m[2]) * 100)
}

// Parse a previously written file. Missing file/values mean Hyprland's
// default of fully opaque.
function parseLuaFile(text) {
  return {
    active: readOption(text, "active_opacity"),
    inactive: readOption(text, "inactive_opacity")
  }
}
