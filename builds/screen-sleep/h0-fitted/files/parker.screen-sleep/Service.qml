import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Screen sleep: DPMS off after `timeoutSeconds` of no input, DPMS on at the
// next input. This plugin only ever toggles display power. It never calls
// systemctl suspend/hibernate or anything else that sleeps the machine.
Item {
  id: root

  // Injected by omarchy-shell.
  property var shell: null

  // 10 minutes.
  readonly property int timeoutSeconds: 600

  // Same file the stock "Stay awake" indicator writes; when it exists we
  // leave the screens on.
  readonly property string stayAwakeFile: Quickshell.env("HOME") + "/.local/state/omarchy/indicators/stay-awake"

  property bool screensOff: false

  function run(process, command) {
    if (process.running) return
    process.command = ["bash", "-c", command]
    process.running = true
  }

  function screensOffNow() {
    console.log("screen-sleep: idle " + root.timeoutSeconds + "s, turning displays off")
    root.screensOff = true
    run(offProcess, "[[ -f \"" + root.stayAwakeFile + "\" ]] || omarchy-brightness-display off")
  }

  function screensOnNow() {
    if (!root.screensOff) return
    console.log("screen-sleep: activity, turning displays on")
    root.screensOff = false
    // Hyprland already wakes DPMS on key press / mouse move
    // (misc.key_press_enables_dpms / mouse_move_enables_dpms); this is a
    // backstop. `on` is a no-op when every display is already lit.
    run(onProcess, "omarchy-brightness-display on")
  }

  IdleMonitor {
    id: idleMonitor
    enabled: true
    timeout: root.timeoutSeconds
    // Honour idle inhibitors (video playback, etc.) like the stock idle service.
    respectInhibitors: true
    onIsIdleChanged: {
      if (isIdle) root.screensOffNow()
      else root.screensOnNow()
    }
  }

  Process { id: offProcess }
  Process { id: onProcess }

  IpcHandler {
    target: "screen-sleep"

    function status(): string {
      return JSON.stringify({
        timeout: root.timeoutSeconds,
        idle: idleMonitor.isIdle,
        screensOff: root.screensOff
      })
    }
  }
}
