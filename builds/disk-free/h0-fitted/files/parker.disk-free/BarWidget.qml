import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Shows free space on a filesystem (default "/") as e.g. "182G free".
// Turns the theme's urgent (red) color when free space drops below
// warnPercent (default 10%). Clicking refreshes immediately.
BarWidget {
  id: root
  moduleName: "parker.disk-free"

  readonly property string mountPath: String(setting("path", "/"))
  readonly property int intervalSeconds: Math.max(5, Number(setting("interval", 60)) || 60)
  readonly property real warnPercent: Number(setting("warnPercent", 10))

  property real availBytes: -1
  property real sizeBytes: -1
  readonly property real freePercent: sizeBytes > 0 ? (availBytes / sizeBytes) * 100 : 100
  readonly property bool low: availBytes >= 0 && freePercent < warnPercent

  function humanSize(bytes) {
    var units = ["B", "K", "M", "G", "T", "P"]
    var value = bytes
    var i = 0
    while (value >= 1024 && i < units.length - 1) { value /= 1024; i++ }
    return (value < 10 && i > 0 ? value.toFixed(1) : Math.floor(value)) + units[i]
  }

  readonly property string displayText: availBytes < 0
    ? ""
    : (vertical ? humanSize(availBytes) : humanSize(availBytes) + " free")

  function refresh() {
    if (!dfProc.running) dfProc.running = true
  }

  function parse(text) {
    // `df -B1 --output=avail,size PATH` → header line, then "<avail> <size>"
    var lines = String(text).trim().split("\n")
    if (lines.length < 2) return
    var parts = lines[lines.length - 1].trim().split(/\s+/)
    var avail = Number(parts[0])
    var size = Number(parts[1])
    if (isNaN(avail) || isNaN(size)) return
    availBytes = avail
    sizeBytes = size
  }

  onMountPathChanged: refresh()

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: dfProc
    command: ["df", "-B1", "--output=avail,size", root.mountPath]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.parse(text)
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
    text: root.displayText
    active: root.low
    tooltipText: root.availBytes < 0 ? "" :
      root.mountPath + ": " + root.humanSize(root.availBytes) + " free of "
      + root.humanSize(root.sizeBytes) + " (" + root.freePercent.toFixed(1) + "%)"
    onPressed: function(b) { root.refresh() }
  }
}
