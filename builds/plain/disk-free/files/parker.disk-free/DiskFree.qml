import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

// Shows free space on the main drive, e.g. "182G free". Turns the theme's red
// when less than `warnPercent` (default 10%) of the drive is left.
// Left click refreshes immediately.
BarWidget {
  id: root
  moduleName: "parker.disk-free"

  readonly property string path: String(setting("path", "/"))
  readonly property int intervalSeconds: Math.max(5, Number(setting("interval", 60)) || 60)
  readonly property real warnPercent: Number(setting("warnPercent", 10))

  property var info: null
  readonly property bool low: Model.isLow(info, warnPercent)
  readonly property string freeText: info ? Model.formatBytes(info.avail) : ""

  function refresh() {
    if (!dfProc.running) dfProc.running = true
  }

  onPathChanged: refresh()

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: dfProc
    command: ["df", "-B1", "--output=size,avail,target", "--", root.path]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.info = Model.parseDf(text)
    }
    onExited: function(exitCode) {
      if (exitCode !== 0) root.info = null
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
    // Vertical bars are only 28px wide, so drop the word there.
    text: root.info ? (root.vertical ? root.freeText : root.freeText + " free") : "?"
    fontSize: root.vertical ? Style.font.caption : Style.font.body
    active: root.low
    activeColor: Color.urgent
    tooltipText: root.info
      ? Model.formatBytes(root.info.avail) + " free of " + Model.formatBytes(root.info.size)
        + " (" + Model.percentFree(root.info).toFixed(1) + "%) on " + (root.info.mount || root.path)
      : "Could not read free space for " + root.path
    onPressed: root.refresh()
  }
}
