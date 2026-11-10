import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "ScreenSleepModel.js" as Model

// Headless service: turn every display off after 10 minutes without keyboard
// or mouse input, and back on at the next input.
//
// Screens go off/on via Hyprland DPMS only:
//   hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'   (after idle)
//   hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'    (on input)
// (argv in ScreenSleepModel.js, executed directly without a shell). It never
// suspends the machine, so agents/builds keep running while screens are dark.
//
// Respects Omarchy's "stay awake" toggle and Wayland idle inhibitors (e.g. a
// fullscreen video), the same way the built-in omarchy.idle service does.
Item {
  id: root

  // Injected by omarchy-shell; unused but declared so injection is harmless.
  property var shell: null
  property var manifest: null

  readonly property int idleSeconds: Model.DEFAULT_IDLE_SECONDS

  readonly property string home: Quickshell.env("HOME")
  readonly property string stayAwakeStateDir: home + "/.local/state/omarchy/indicators"

  property bool stayAwake: false
  property bool screensOff: false
  property string pendingAction: ""

  function log(message) {
    console.log("parker.screen-sleep " + new Date().toISOString() + " " + message)
  }

  function evaluate(reason) {
    var action = Model.nextAction(idleMonitor.isIdle, root.stayAwake, root.screensOff)
    if (!action) return
    log(reason + " -> screens " + action)
    root.screensOff = action === "off"
    run(action)
  }

  function run(action) {
    // Never overlap DPMS commands; replay only the latest wanted state.
    if (displayProcess.running) {
      root.pendingAction = action
      return
    }
    displayProcess.command = Model.argvFor(action)
    displayProcess.running = true
  }

  IdleMonitor {
    id: idleMonitor
    enabled: true
    timeout: root.idleSeconds
    respectInhibitors: true
    onIsIdleChanged: root.evaluate(isIdle ? "idle" : "input")
  }

  Process {
    id: displayProcess
    onExited: function(exitCode) {
      if (exitCode !== 0) root.log("display command exited " + exitCode)
      if (root.pendingAction) {
        var next = root.pendingAction
        root.pendingAction = ""
        root.run(next)
      }
    }
  }

  // Omarchy's stay-awake toggle is a marker file; watch its directory so
  // toggling it on while the screens are off wakes them immediately.
  // The directory must exist for the watcher below, so create it first.
  Process {
    id: stayAwakeDirMaker
    command: ["mkdir", "-p", root.stayAwakeStateDir]
    onExited: stayAwakeProbe.running = true
  }

  Process {
    id: stayAwakeProbe
    command: ["test", "-f", root.stayAwakeStateDir + "/stay-awake"]
    onExited: function(exitCode) {
      stayAwakeWatcher.reload()
      var value = exitCode === 0
      if (value === root.stayAwake) return
      root.stayAwake = value
      root.evaluate(value ? "stay-awake on" : "stay-awake off")
    }
  }

  FileView {
    id: stayAwakeWatcher
    path: root.stayAwakeStateDir
    watchChanges: true
    printErrors: false
    onFileChanged: if (!stayAwakeProbe.running) stayAwakeProbe.running = true
  }

  Component.onCompleted: {
    log("ready, screens off after " + root.idleSeconds + "s idle (display power only)")
    stayAwakeDirMaker.running = true
  }

  // If the plugin is disabled or reloaded while the screens are dark, light
  // them back up rather than leaving them off with nothing to wake them.
  Component.onDestruction: {
    if (root.screensOff) Quickshell.execDetached(Model.argvFor("on"))
  }

  IpcHandler {
    target: "screen-sleep"

    function status(): string {
      return JSON.stringify({
        idleSeconds: root.idleSeconds,
        idle: idleMonitor.isIdle,
        stayAwake: root.stayAwake,
        screensOff: root.screensOff
      })
    }
  }
}
