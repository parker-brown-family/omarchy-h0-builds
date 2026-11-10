import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

// Shows free space on the main drive ("182G free") and turns the label the
// theme's urgent (red) color once less than `lowPercent` of the drive is free.
BarWidget {
  id: root
  moduleName: "parker.disk-free"

  readonly property string mountPath: String(root.setting("path", "/"))
  readonly property int intervalSec: Math.max(10, Number(root.setting("intervalSec", 60)) || 60)
  readonly property real lowPercent: Number(root.setting("lowPercent", 10)) || 10

  property real availBytes: -1
  property real sizeBytes: -1

  readonly property bool hasData: availBytes >= 0 && sizeBytes > 0
  readonly property real freePercent: hasData ? (availBytes / sizeBytes) * 100 : 100
  readonly property bool low: hasData && freePercent < lowPercent

  function humanSize(bytes) {
    var gib = bytes / 1073741824
    if (gib >= 1024) return (gib / 1024).toFixed(1) + "T"
    if (gib >= 10) return Math.floor(gib) + "G"
    if (gib >= 1) return gib.toFixed(1) + "G"
    return Math.floor(bytes / 1048576) + "M"
  }

  function refresh() {
    if (!dfProc.running) dfProc.running = true
  }

  onMountPathChanged: refresh()

  // POSIX output, byte units: second line is
  // "<fs> <size> <used> <avail> <capacity> <mount>".
  Process {
    id: dfProc
    command: ["df", "-P", "-B1", "--", root.mountPath]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var lines = String(text || "").trim().split("\n")
        if (lines.length < 2) return
        var cols = lines[lines.length - 1].trim().split(/\s+/)
        if (cols.length < 6) return
        var size = Number(cols[1])
        var avail = Number(cols[3])
        if (!isFinite(size) || !isFinite(avail) || size <= 0) return
        root.sizeBytes = size
        root.availBytes = avail
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

  visible: hasData
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.hasData
      ? (root.vertical ? root.humanSize(root.availBytes) : root.humanSize(root.availBytes) + " free")
      : ""
    fontSize: Style.font.caption
    horizontalMargin: 6
    active: root.low
    tooltipText: root.hasData
      ? root.mountPath + ": " + root.humanSize(root.availBytes) + " free of "
        + root.humanSize(root.sizeBytes) + " (" + Math.round(root.freePercent) + "% free)"
      : ""
    onPressed: function() { root.refresh() }
  }
}
