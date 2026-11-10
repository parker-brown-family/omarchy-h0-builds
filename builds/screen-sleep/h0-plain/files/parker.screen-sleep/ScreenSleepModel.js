.pragma library

// Pure decision logic for the screen-sleep service, kept free of QML so it
// can be unit tested with plain node (see test.mjs).

// Ten minutes without keyboard/mouse input.
var DEFAULT_IDLE_SECONDS = 600

// The only commands this plugin ever runs, as argv arrays executed directly
// (no shell, no wrapper scripts). Both are Hyprland's own DPMS dispatcher:
// they power the displays down/up and nothing else. Nothing here talks to
// systemd/logind, so the machine itself never sleeps.
var SCREENS_OFF_ARGV = ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "disable" })']
var SCREENS_ON_ARGV = ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "enable" })']

// Decide what to do after the idle monitor or stay-awake state changes.
// Returns "off", "on", or "" (nothing to do).
//   idle       - the compositor reports no input for the idle timeout
//   stayAwake  - Omarchy's "stay awake" toggle is on
//   screensOff - this plugin currently has the screens turned off
function nextAction(idle, stayAwake, screensOff) {
  var wantOff = !!idle && !stayAwake
  if (wantOff && !screensOff) return "off"
  if (!wantOff && screensOff) return "on"
  return ""
}

function argvFor(action) {
  if (action === "off") return SCREENS_OFF_ARGV.slice()
  if (action === "on") return SCREENS_ON_ARGV.slice()
  return []
}
