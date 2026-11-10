import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "parker.disk-free"

  readonly property string mountPath: String(setting("path", "/"))
  readonly property int intervalSeconds: Math.max(5, Number(setting("interval", 60)))
  readonly property real lowPercent: Number(setting("lowPercent", 10))

  property real availBytes: -1
  property real sizeBytes: -1
  readonly property real freePercent: sizeBytes > 0 ? availBytes / sizeBytes * 100 : 100
  readonly property bool low: sizeBytes > 0 && freePercent < lowPercent

  // Same units and rounding df -h uses: powers of 1024, rounded up, one decimal below 10.
  function humanSize(bytes) {
    var units = ["B", "K", "M", "G", "T", "P"]
    var i = 0
    while (bytes >= 1024 && i < units.length - 1) {
      bytes /= 1024
      i++
    }
    return (bytes < 10 && i > 0 ? (Math.ceil(bytes * 10) / 10).toFixed(1) : Math.ceil(bytes)) + units[i]
  }

  function refresh() {
    if (!dfProc.running) dfProc.running = true
  }

  visible: availBytes >= 0
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onMountPathChanged: refresh()

  Process {
    id: dfProc
    command: ["df", "--block-size=1", "--output=avail,size", root.mountPath]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        // Header line, then "<avail> <size>".
        var lines = (text || "").trim().split("\n")
        var fields = lines.length > 1 ? lines[lines.length - 1].trim().split(/\s+/) : []
        if (fields.length < 2) return
        root.availBytes = Number(fields[0])
        root.sizeBytes = Number(fields[1])
      }
    }
  }

  Timer {
    interval: root.intervalSeconds * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.vertical ? root.humanSize(root.availBytes) : root.humanSize(root.availBytes) + " free"
    fontSize: Style.font.caption
    horizontalMargin: 6
    active: root.low
    tooltipText: root.humanSize(root.availBytes) + " of " + root.humanSize(root.sizeBytes)
      + " free on " + root.mountPath + " (" + Math.round(root.freePercent) + "%)"
    onPressed: function() {
      root.refresh()
      if (root.bar) root.bar.run("omarchy-launch-or-focus-tui btop")
    }
  }
}
