import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.Ui
import qs.Commons

// Window opacity control. Drives Hyprland's decoration.active_opacity and
// decoration.inactive_opacity live. Those multiply with Omarchy's default
// window-rule opacity, so 100% here = the stock Omarchy look.
//
// Settings persist in this widget's own shell.json bar entry:
//   { "id": "parker.window-opacity", "active": 100, "inactive": 90 }
// and are re-applied on shell start and after every Hyprland config reload
// (a reload resets decoration.* back to the Lua config values).
Panel {
  id: root
  moduleName: "parker.window-opacity"
  ipcTarget: "parker.window-opacity"

  readonly property int minPercent: 30
  readonly property int maxPercent: 100
  readonly property string glyph: "󰗋"

  // Live values (what the sliders show and Hyprland gets).
  property int activePercent: clampPercent(setting("active", 100))
  property int inactivePercent: clampPercent(setting("inactive", 100))

  // Keyboard cursor: 0 = focused slider, 1 = unfocused slider.
  property int cursorRow: 0
  property bool cursorActive: false
  property real wheelAccumulator: 0

  // Ignore the configreloaded our own eval may cause, so we never loop.
  property double lastApplyMs: 0
  property bool applyQueued: false

  function clampPercent(v) {
    var n = Math.round(Number(v))
    if (isNaN(n)) n = 100
    return Math.max(minPercent, Math.min(maxPercent, n))
  }

  function fraction(p) {
    return (clampPercent(p) / 100).toFixed(2)
  }

  // Push current values to Hyprland, coalescing while a call is in flight.
  function apply() {
    if (applyProc.running) {
      applyQueued = true
      return
    }
    applyQueued = false
    lastApplyMs = Date.now()
    applyProc.command = ["bash", "-c",
      "hyprctl eval \"hl.config({ decoration = { active_opacity = $1, inactive_opacity = $2 } })\" >/dev/null 2>&1 || " +
      "{ hyprctl keyword decoration:active_opacity \"$1\" && hyprctl keyword decoration:inactive_opacity \"$2\"; } >/dev/null 2>&1",
      "window-opacity", fraction(activePercent), fraction(inactivePercent)]
    applyProc.running = true
  }

  function setActive(v) { activePercent = clampPercent(v); apply() }
  function setInactive(v) { inactivePercent = clampPercent(v); apply() }

  // Write to shell.json. Debounced so drags and wheel spins write once.
  function persist() { persistDebounce.restart() }

  function writeSettings() {
    var entry = { id: root.moduleName }
    for (var key in root.settings) if (key !== "id") entry[key] = root.settings[key]
    entry.active = root.activePercent
    entry.inactive = root.inactivePercent
    root.settings = entry
    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
      root.bar.shell.updateEntryInline(root.moduleName, entry)
  }

  function adjustRow(row, delta) {
    if (row === 0) setActive(activePercent + delta)
    else setInactive(inactivePercent + delta)
    persist()
  }

  function reset() {
    activePercent = 100
    inactivePercent = 100
    apply()
    persist()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Component.onCompleted: apply()

  // shell.json edited by hand (or written back by us): follow it.
  onSettingsChanged: {
    var a = clampPercent(setting("active", 100))
    var i = clampPercent(setting("inactive", 100))
    if (a !== activePercent || i !== inactivePercent) {
      activePercent = a
      inactivePercent = i
      apply()
    }
  }

  onOpenedChanged: if (opened) { cursorRow = 0; cursorActive = false }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (!event || String(event.name) !== "configreloaded") return
      if (Date.now() - root.lastApplyMs < 1500) return
      reapplyDelay.restart()
    }
  }

  Timer {
    id: reapplyDelay
    interval: 250
    repeat: false
    onTriggered: root.apply()
  }

  Timer {
    id: persistDebounce
    interval: 600
    repeat: false
    onTriggered: root.writeSettings()
  }

  Process {
    id: applyProc
    stdout: StdioCollector { waitForEnd: true }
    onRunningChanged: if (!running && root.applyQueued) root.apply()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.glyph
    onPressed: function(b) { root.toggle() }
    // Scroll on the bar icon nudges focused-window opacity.
    onWheelMoved: function(delta) {
      var wheel = Util.wheelSteps(root.wheelAccumulator, delta)
      root.wheelAccumulator = wheel.remainder
      if (wheel.steps === 0) return
      root.adjustRow(0, wheel.steps * 5)
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
      onMoveRequested: function(dx, dy) {
        if (!root.cursorActive) { root.cursorActive = true; return }
        if (dy !== 0) root.cursorRow = Math.max(0, Math.min(1, root.cursorRow + dy))
        else if (dx !== 0) root.adjustRow(root.cursorRow, dx * 5)
      }
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: panelColumn
        width: parent.width
        spacing: Style.space(14)

        PanelHero {
          iconComponent: Text {
            textFormat: Text.PlainText
            text: root.glyph
            color: root.bar.foreground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.display
          }
          title: "Window Opacity"
          meta: "100% = OMARCHY DEFAULT"
          foreground: root.bar.foreground
          fontFamily: root.bar.fontFamily
          trailingControl: Button {
            text: "Reset"
            fontSize: Style.font.caption
            foreground: root.bar.foreground
            fontFamily: root.bar.fontFamily
            horizontalPadding: Style.spacing.sm
            verticalPadding: Style.spacing.controlPaddingY
            bordered: true
            onClicked: root.reset()
          }
        }

        PanelSeparator { foreground: root.bar.foreground }

        OpacityRow {
          label: "FOCUSED WINDOW"
          row: 0
          value: root.activePercent
        }

        OpacityRow {
          label: "UNFOCUSED WINDOWS"
          row: 1
          value: root.inactivePercent
        }

        Item { width: parent.width; height: Style.space(4) }
      }
    }
  }

  component OpacityRow: Column {
    id: optRow
    required property string label
    required property int row
    required property int value

    width: panelColumn.width
    spacing: Style.space(6)

    Item {
      width: parent.width
      implicitHeight: Math.max(rowHeader.implicitHeight, rowValue.implicitHeight)

      PanelSectionHeader {
        id: rowHeader
        text: optRow.label
        foreground: root.bar.foreground
        fontFamily: root.bar.fontFamily
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
      }

      Text {
        id: rowValue
        textFormat: Text.PlainText
        text: Math.round(slider.dragging ? slider.liveValue : optRow.value) + "%"
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
      hasCursor: root.cursorActive && root.cursorRow === optRow.row
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
        step: 5
        integer: true
        value: optRow.value
        // Live while dragging; saved once on release.
        onMoved: function(v) {
          if (optRow.row === 0) root.setActive(v)
          else root.setInactive(v)
        }
        onReleased: function(v) {
          if (optRow.row === 0) root.setActive(v)
          else root.setInactive(v)
          root.persist()
        }
      }

      HoverHandler {
        onHoveredChanged: if (hovered) {
          root.cursorActive = true
          root.cursorRow = optRow.row
        }
      }
    }
  }
}
