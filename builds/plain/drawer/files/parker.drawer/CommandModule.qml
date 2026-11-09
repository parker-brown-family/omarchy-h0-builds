import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

// A `"type": "command"` bar module tucked into the drawer. Mirrors the stock
// bar's CustomCommandModule (exec / interval / onClick / Waybar-style JSON).
WidgetButton {
  id: root

  property var settings: ({})
  property string outputText: ""
  property string outputTooltip: ""
  property bool outputActive: false

  function setting(name, fallback) {
    var value = settings ? settings[name] : undefined
    return value === undefined || value === null ? fallback : value
  }

  function update(raw) {
    var data = Util.parseModuleJson(raw)
    var klass = data.class || data.alt || ""
    outputText = data.text || String(raw || "").trim()
    outputTooltip = data.tooltip || String(setting("tooltip", ""))
    outputActive = klass === "active" || (Array.isArray(klass) && klass.indexOf("active") !== -1)
  }

  text: outputText || String(setting("text", ""))
  tooltipText: outputTooltip || String(setting("tooltip", ""))
  active: outputActive
  keepSpace: setting("keepSpace", false) === true
  horizontalMargin: Number(setting("horizontalMargin", 7.5))
  verticalPadding: Number(setting("verticalPadding", 6))
  fontSize: Number(setting("fontSize", 12))

  onPressed: function(button) {
    var command = ""
    if (button === Qt.RightButton) command = String(setting("onRightClick", ""))
    else if (button === Qt.MiddleButton) command = String(setting("onMiddleClick", ""))
    else command = String(setting("onClick", ""))
    if (command && bar) bar.run(command)
  }

  Process {
    id: proc
    command: ["bash", "-lc", String(root.setting("exec", ""))]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.update(text)
    }
  }

  Timer {
    interval: Math.max(1, Number(root.setting("interval", 5))) * 1000
    running: String(root.setting("exec", "")) !== ""
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!proc.running) proc.running = true
  }
}
