import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons

// Window opacity bar widget.
//
// Two sliders drive Hyprland's decoration:active_opacity (focused window) and
// decoration:inactive_opacity (unfocused windows). Changes are applied live
// with `hyprctl keyword`, then saved as two plain numbers to
// $XDG_STATE_HOME/window-opacity/values. ~/.config/hypr/window-opacity.lua reads
// that file so the values survive Hyprland reloads and restarts.
//
// Omarchy's default window rule (opacity 0.985 0.96) multiplies with these
// values, so 100% here means "Omarchy's normal look".
Panel {
  id: root
  moduleName: "parker.window-opacity"
  ipcTarget: "parker.window-opacity"

  // Below this, windows become hard to find again; keep a usable floor.
  readonly property int minPercent: 20
  readonly property int maxPercent: 100
  readonly property int stepPercent: 5

  property int activePercent: 100
  property int inactivePercent: 100
  property bool applyQueued: false
  property real wheelAccumulator: 0

  // Keyboard cursor: "active" or "inactive" slider row.
  property string focusSection: "active"
  property bool cursorActive: false

  readonly property string icon: String.fromCodePoint(0xF1853)  // md-circle_opacity
  readonly property string stateHome: {
    var xdg = Quickshell.env("XDG_STATE_HOME")
    return xdg ? String(xdg) : String(Quickshell.env("HOME")) + "/.local/state"
  }
  readonly property string stateFile: stateHome + "/window-opacity/values"

  function clampPercent(value) {
    var n = Math.round(Number(value))
    if (isNaN(n)) return maxPercent
    return Math.max(minPercent, Math.min(maxPercent, n))
  }

  function fraction(percent) {
    return (clampPercent(percent) / 100).toFixed(2)
  }

  // Parse a Hyprland float ("0.9") into a percent, or -1 when unusable.
  function parsePercent(text) {
    var v = parseFloat(String(text || "").trim())
    if (isNaN(v) || v <= 0) return -1
    return clampPercent(v * 100)
  }

  function setOpacity(which, value) {
    var pct = clampPercent(value)
    if (which === "active") {
      if (pct === activePercent) return
      activePercent = pct
    } else {
      if (pct === inactivePercent) return
      inactivePercent = pct
    }
    applyNow()
    persistDebounce.restart()
  }

  function applyNow() {
    if (applyProc.running) {
      applyQueued = true
      return
    }
    applyQueued = false
    applyProc.command = [
      "hyprctl", "--batch",
      "keyword decoration:active_opacity " + fraction(activePercent)
        + " ; keyword decoration:inactive_opacity " + fraction(inactivePercent)
    ]
    applyProc.running = true
  }

  function persistNow() {
    if (persistProc.running) {
      persistDebounce.restart()
      return
    }
    persistProc.command = [
      "bash", "-c",
      "mkdir -p \"$(dirname \"$0\")\" && printf '%s %s\\n' \"$1\" \"$2\" > \"$0.tmp\" && mv -f \"$0.tmp\" \"$0\"",
      stateFile, fraction(activePercent), fraction(inactivePercent)
    ]
    persistProc.running = true
  }

  // Read Hyprland's live values; fall back to the saved file when hyprctl
  // can't answer. Skipped while our own change is still in flight so the
  // sliders don't jump back mid-drag.
  function refresh() {
    if (readProc.running || applyProc.running || persistDebounce.running) return
    readProc.running = true
  }

  function adjustFocused(deltaSteps) {
    var which = focusSection
    var current = which === "active" ? activePercent : inactivePercent
    setOpacity(which, current + deltaSteps * stepPercent)
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Component.onCompleted: refresh()

  onOpenedChanged: {
    if (opened) {
      refresh()
      focusSection = "active"
      cursorActive = false
    } else if (persistDebounce.running) {
      persistDebounce.stop()
      persistNow()
    }
  }

  Process {
    id: readProc
    command: [
      "bash", "-c",
      "for o in active inactive; do "
        + "v=$(hyprctl -j getoption decoration:${o}_opacity 2>/dev/null | jq -r '.float // empty' 2>/dev/null); "
        + "printf '%s\\n' \"$v\"; done; "
        + "cat \"$0\" 2>/dev/null",
      root.stateFile
    ]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var lines = String(text || "").split("\n")
        var saved = String(lines[2] || "").trim().split(/\s+/)
        var a = root.parsePercent(lines[0])
        var i = root.parsePercent(lines[1])
        if (a < 0) a = root.parsePercent(saved[0])
        if (i < 0) i = root.parsePercent(saved[1])
        if (a >= 0) root.activePercent = a
        if (i >= 0) root.inactivePercent = i
      }
    }
  }

  Process {
    id: applyProc
    stdout: StdioCollector { waitForEnd: true }
    onRunningChanged: if (!running && root.applyQueued) root.applyNow()
  }

  Process {
    id: persistProc
    stdout: StdioCollector { waitForEnd: true }
  }

  Timer {
    id: persistDebounce
    interval: 400
    repeat: false
    onTriggered: root.persistNow()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.icon
    tooltipText: "Window opacity · " + root.activePercent + "% / " + root.inactivePercent + "%"
    onPressed: function(b) { root.toggle() }
    // Scroll on the bar icon nudges the focused-window opacity.
    onWheelMoved: function(delta) {
      var wheel = Util.wheelSteps(root.wheelAccumulator, delta)
      root.wheelAccumulator = wheel.remainder
      if (wheel.steps === 0) return
      root.setOpacity("active", root.activePercent + wheel.steps * root.stepPercent)
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(320))
    contentHeight: panel.fittedContentHeight(panelColumn.implicitHeight, Style.space(400))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      // j/k (or arrows) switch slider, h/l adjust by 5%, Esc closes.
      onMoveRequested: function(dx, dy) {
        if (!root.cursorActive) { root.cursorActive = true; return }
        if (dy !== 0) root.focusSection = dy > 0 ? "inactive" : "active"
        else if (dx !== 0) root.adjustFocused(dx)
      }
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: panelColumn
        width: parent.width
        spacing: Style.space(14)

        // ---------- Hero ----------
        Item {
          width: parent.width
          implicitHeight: Math.max(heroIcon.implicitHeight, heroLabels.implicitHeight)

          Text {
            id: heroIcon
            textFormat: Text.PlainText
            text: root.icon
            color: root.bar.foreground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.display
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
          }

          Column {
            id: heroLabels
            anchors.left: heroIcon.right
            anchors.leftMargin: Style.space(14)
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Style.space(2)

            Text {
              text: "Window opacity"
              color: root.bar.foreground
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.title
              font.bold: true
              elide: Text.ElideRight
              width: parent.width
            }

            Text {
              textFormat: Text.PlainText
              text: "APPLIED LIVE · SAVED"
              color: Qt.darker(root.bar.foreground, 1.4)
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.caption
              font.bold: true
              font.letterSpacing: 1.2
              elide: Text.ElideRight
              width: parent.width
            }
          }
        }

        PanelSeparator { foreground: root.bar.foreground }

        OpacityRow {
          section: "active"
          label: "FOCUSED WINDOW"
          percent: root.activePercent
        }

        OpacityRow {
          section: "inactive"
          label: "UNFOCUSED WINDOWS"
          percent: root.inactivePercent
        }

        Item {
          width: parent.width
          height: Style.space(4)
        }
      }
    }
  }

  component OpacityRow: Column {
    id: row
    required property string section
    required property string label
    required property int percent

    width: parent ? parent.width : 0
    spacing: Style.space(6)

    Item {
      width: parent.width
      implicitHeight: Math.max(header.implicitHeight, valueText.implicitHeight)

      PanelSectionHeader {
        id: header
        text: row.label
        foreground: root.bar.foreground
        fontFamily: root.bar.fontFamily
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
      }

      Text {
        id: valueText
        textFormat: Text.PlainText
        text: Math.round(slider.dragging ? slider.liveValue : row.percent) + "%"
        color: Qt.darker(root.bar.foreground, 1.4)
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.caption
        font.bold: true
        anchors.right: parent.right
        anchors.rightMargin: Style.space(6)
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    CursorSurface {
      width: parent.width
      height: slider.implicitHeight + Style.spacing.controlGap
      hasCursor: root.cursorActive && root.focusSection === row.section
      foreground: root.bar.foreground
      outline: true

      PanelSlider {
        id: slider
        bar: root.bar
        anchors.fill: parent
        anchors.leftMargin: Style.space(6)
        anchors.rightMargin: Style.space(6)
        minimum: root.minPercent
        maximum: root.maxPercent
        step: root.stepPercent
        integer: true
        value: row.percent
        onMoved: function(v) { root.setOpacity(row.section, v) }
        onReleased: function(v) { root.setOpacity(row.section, v) }
      }

      HoverHandler {
        onHoveredChanged: if (hovered) {
          root.cursorActive = true
          root.focusSection = row.section
        }
      }
    }
  }
}
