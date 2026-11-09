.pragma library

// Parse the output of `df -B1 --output=size,avail,target <path>`:
//
//   1B-blocks        Avail Mounted on
//   999653638144 195421257728 /
//
// Returns { size, avail, mount } in bytes, or null if it can't be read.
function parseDf(output) {
  var lines = String(output || "").trim().split("\n")
  if (lines.length < 2) return null
  var fields = lines[lines.length - 1].trim().split(/\s+/)
  if (fields.length < 2) return null
  var size = Number(fields[0])
  var avail = Number(fields[1])
  if (!isFinite(size) || !isFinite(avail) || size <= 0 || avail < 0) return null
  return { size: size, avail: avail, mount: fields.slice(2).join(" ") }
}

// Human-readable size in powers of 1024, matching `df -h`: one decimal
// below 10 ("9.4G"), whole numbers above ("182G").
function formatBytes(bytes) {
  var units = ["B", "K", "M", "G", "T", "P", "E"]
  var value = Math.max(0, Number(bytes) || 0)
  var i = 0
  while (value >= 1024 && i < units.length - 1) {
    value /= 1024
    i++
  }
  var shown = value < 10 && i > 0 ? (Math.round(value * 10) / 10).toFixed(1) : String(Math.round(value))
  // Rounding can carry into the next unit (1023.6M -> "1024M"); step up instead.
  if (Number(shown) >= 1024 && i < units.length - 1) return "1.0" + units[i + 1]
  return shown + units[i]
}

function percentFree(info) {
  return info ? (info.avail / info.size) * 100 : 0
}

function isLow(info, warnPercent) {
  return !!info && percentFree(info) < warnPercent
}
