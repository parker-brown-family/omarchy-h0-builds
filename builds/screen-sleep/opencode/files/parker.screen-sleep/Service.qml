import QtQuick
import Quickshell.Io
import Quickshell.Wayland

// Blanks displays (DPMS off) after a period without input and lights them
// again on the next keypress or mouse movement. This plugin only ever toggles
// DPMS; it never suspends, hibernates, or locks the machine.
Item {
  id: root

  property var shell: null

  readonly property int timeoutSeconds: 600

  property bool screensOff: false
  property string lastEvent: "starting"

  function logEvent(event) {
    root.lastEvent = new Date().toISOString() + " " + event
    console.log("screen-sleep " + root.lastEvent)
  }

  function run(process, command) {
    if (process.running) process.running = false
    process.command = ["bash", "-c", command]
    process.running = true
  }

  function screensOffNow() {
    logEvent("idle " + root.timeoutSeconds + "s, displays off")
    root.screensOff = true
    // Honor Omarchy's "stay awake" toggle, which keeps the displays lit.
    run(offProcess, "[[ -f \"$HOME/.local/state/omarchy/indicators/stay-awake\" ]] || hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'")
  }

  function screensOnNow() {
    if (!root.screensOff) return
    logEvent("input, displays on")
    root.screensOff = false
    // Skip when every display is already lit; a redundant enable forces a modeset flicker.
    run(onProcess, "hyprctl monitors -j | jq -e '[.[] | select(.disabled == false)] | length > 0 and all(.dpmsStatus)' >/dev/null || hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'")
  }

  IdleMonitor {
    id: idleMonitor
    enabled: true
    timeout: root.timeoutSeconds
    // Apps holding an idle inhibitor (e.g. fullscreen video) keep screens on.
    respectInhibitors: true
    onIsIdleChanged: {
      if (isIdle) root.screensOffNow()
      else root.screensOnNow()
    }
  }

  Process { id: offProcess }
  Process { id: onProcess }

  Component.onCompleted: logEvent("ready, timeout=" + root.timeoutSeconds + "s")

  IpcHandler {
    target: "screen-sleep"

    function status(): string {
      return JSON.stringify({
        timeout: root.timeoutSeconds,
        idle: idleMonitor.isIdle,
        screensOff: root.screensOff,
        lastEvent: root.lastEvent
      })
    }
  }
}
