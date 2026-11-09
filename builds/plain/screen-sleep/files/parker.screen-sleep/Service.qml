import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Screen sleep: DPMS-off the displays after a period with no input, DPMS-on
// again at the next input.
//
// This plugin ONLY toggles display power. It never calls systemctl suspend,
// hibernate, or anything else that sleeps the machine, so long-running jobs
// (overnight agents, builds) keep running while the screens are dark.
Item {
  id: root

  // Injected by omarchy-shell.
  property string omarchyPath: Quickshell.env("OMARCHY_PATH") || "/usr/share/omarchy"
  property var shell: null
  property var manifest: null

  // Seconds without keyboard/mouse input before the screens go dark.
  readonly property int timeoutSeconds: 600

  // Honour Omarchy's "stay awake" toggle, same file the built-in idle uses.
  readonly property string stayAwakePath: Quickshell.env("HOME") + "/.local/state/omarchy/indicators/stay-awake"
  readonly property string brightnessCmd: omarchyPath + "/bin/omarchy-brightness-display"

  property bool screensOff: false
  property string lastEvent: "starting"

  function log(event) {
    root.lastEvent = new Date().toISOString() + " " + event
    console.log("screen-sleep " + root.lastEvent)
  }

  function run(proc, args) {
    // If a previous toggle is still in flight, stop it so the newest state wins.
    if (proc.running) proc.running = false
    proc.command = args
    proc.running = true
  }

  function screensOffNow(force) {
    log((force ? "manual" : "idle " + root.timeoutSeconds + "s") + ": displays off")
    if (onProcess.running) onProcess.running = false
    root.screensOff = true
    // Idle path skips when Omarchy's stay-awake is on. DPMS only; no suspend.
    run(offProcess, ["bash", "-c",
      "[[ $1 != force && -f $2 ]] && exit 0; exec \"$3\" off",
      "screen-sleep", force ? "force" : "idle", root.stayAwakePath, root.brightnessCmd])
  }

  function screensOnNow() {
    log("input: displays on")
    if (offProcess.running) offProcess.running = false
    root.screensOff = false
    run(onProcess, [root.brightnessCmd, "on"])
  }

  // ext-idle-notify: fires after timeoutSeconds of no keyboard/mouse/touch
  // input, and flips back the moment input arrives. respectInhibitors keeps
  // the screens on while video playback or similar holds an idle inhibitor.
  IdleMonitor {
    id: idleMonitor
    enabled: true
    timeout: root.timeoutSeconds
    respectInhibitors: true
    onIsIdleChanged: {
      if (idleMonitor.isIdle) root.screensOffNow()
      else if (root.screensOff) root.screensOnNow()
    }
  }

  Process {
    id: offProcess
    onExited: function(exitCode) { if (exitCode !== 0) root.log("display off failed: exit " + exitCode) }
  }

  Process {
    id: onProcess
    onExited: function(exitCode) { if (exitCode !== 0) root.log("display on failed: exit " + exitCode) }
  }

  Component.onCompleted: log("ready, timeout=" + root.timeoutSeconds + "s")

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

    function off(): string {
      root.screensOffNow(true)
      return "ok"
    }

    function on(): string {
      root.screensOnNow()
      return "ok"
    }
  }
}
