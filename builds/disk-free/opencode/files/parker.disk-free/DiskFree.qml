import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "parker.disk-free"

  readonly property string mountPath: String(setting("path", "/"))
  readonly property int intervalSec: Math.max(5, Number(setting("intervalSec", 60)))
  readonly property real warnPercent: Number(setting("warnPercent", 10))

  property real totalBytes: 0
  property real freeBytes: 0
  readonly property real freePercent: totalBytes > 0 ? freeBytes / totalBytes * 100 : 100
  readonly property bool low: totalBytes > 0 && freePercent < warnPercent

  function formatSize(bytes) {
    var gib = bytes / 1073741824
    if (gib >= 1024) return (gib / 1024).toFixed(1) + "T"
    return Math.floor(gib) + "G"
  }

  function refresh() {
    if (!dfProc.running) dfProc.running = true
  }

  onMountPathChanged: refresh()

  Process {
    id: dfProc
    command: ["df", "-B1", "--output=size,avail", root.mountPath]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var lines = String(text || "").trim().split("\n")
        if (lines.length < 2) return
        var fields = lines[lines.length - 1].trim().split(/\s+/)
        var size = Number(fields[0])
        var avail = Number(fields[1])
        if (!isFinite(size) || !isFinite(avail) || size <= 0) return
        root.totalBytes = size
        root.freeBytes = avail
      }
    }
  }

  Timer {
    interval: root.intervalSec * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  visible: totalBytes > 0
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.vertical ? root.formatSize(root.freeBytes) : root.formatSize(root.freeBytes) + " free"
    fontSize: Style.font.caption
    horizontalMargin: 6
    active: root.low
    tooltipText: root.mountPath + ": " + root.formatSize(root.freeBytes) + " of "
      + root.formatSize(root.totalBytes) + " free (" + Math.round(root.freePercent) + "%)"
    onPressed: function(b) {
      if (b === Qt.MiddleButton) root.refresh()
      else if (root.bar) root.bar.run("omarchy-launch-or-focus-tui btop")
    }
  }
}
