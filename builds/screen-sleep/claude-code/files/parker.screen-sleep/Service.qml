import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Display-only idle handling: Hyprland DPMS off after `timeoutSeconds` without
// input, DPMS on at the next input. This plugin never suspends, hibernates, or
// locks: the only command it runs is `hyprctl dispatch` with the DPMS
// dispatcher below (plus `test -e` to read the Stay Awake flag).
Item {
  id: root

  // Injected by omarchy-shell.
  property var shell: null

  readonly property int timeoutSeconds: 600
  readonly property string stayAwakePath: Quickshell.env("HOME") + "/.local/state/omarchy/indicators/stay-awake"

  property bool stayAwake: false
  property bool screensOff: false

  // Hyprland DPMS: "disable" powers every monitor's signal off, "enable"
  // powers them back on. The session, apps, and agents keep running.
  function dpms(action) {
    Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.dpms({ action = \"" + action + "\" })"])
  }

  function setScreens(on) {
    if (on === !root.screensOff) return
    root.screensOff = !on
    console.log("screen-sleep: dpms " + (on ? "enable" : "disable"))
    dpms(on ? "enable" : "disable")
  }

  // Respects Wayland idle inhibitors (e.g. fullscreen video) and Omarchy's
  // Stay Awake toggle.
  IdleMonitor {
    id: idleMonitor
    enabled: !root.stayAwake
    timeout: root.timeoutSeconds
    respectInhibitors: true
    onIsIdleChanged: root.setScreens(!isIdle)
  }

  onStayAwakeChanged: if (stayAwake) setScreens(true)

  Process {
    id: stayAwakeProbe
    command: ["test", "-e", root.stayAwakePath]
    onExited: function(exitCode) { root.stayAwake = exitCode === 0 }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!stayAwakeProbe.running) stayAwakeProbe.running = true
  }

  // Never leave the screens dark if the plugin is reloaded or disabled.
  Component.onDestruction: if (root.screensOff) dpms("enable")

  IpcHandler {
    target: "screen-sleep"

    function status(): string {
      return JSON.stringify({
        timeout: root.timeoutSeconds,
        idle: idleMonitor.isIdle,
        screensOff: root.screensOff,
        stayAwake: root.stayAwake
      })
    }
  }
}
