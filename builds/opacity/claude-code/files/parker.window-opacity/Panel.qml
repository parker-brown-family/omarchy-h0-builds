import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Ui

// Bar button + popup with two sliders driving Hyprland's
// decoration:active_opacity and decoration:inactive_opacity live.
//
// Values persist as inline settings on this widget's shell.json entry
// ({ "id": "parker.window-opacity", "active": 0.9, "inactive": 0.8 }) and are
// re-applied whenever the shell starts or Hyprland reloads its config, so the
// Hyprland Lua files are never touched. Until a slider is first moved, nothing
// is applied and Hyprland's own config stays in charge.
Panel {
  id: root
  moduleName: "parker.window-opacity"
  ipcTarget: "parker.window-opacity"

  readonly property real minimumOpacity: 0.2
  readonly property bool hasSaved: setting("active", null) !== null || setting("inactive", null) !== null
  readonly property real savedActive: clamp(setting("active", 1.0))
  readonly property real savedInactive: clamp(setting("inactive", 1.0))

  // What the sliders show; follows saved values except mid-drag.
  property real liveActive: savedActive
  property real liveInactive: savedInactive
  property bool dragging: false
  property int selectedRow: 0
  property bool cursorActive: false

  // Pending values for the single hyprctl process; drags coalesce into
  // whatever is newest when the previous call exits.
  property var pending: null

  // Runs on startup and whenever shell.json changes (including hand edits).
  // Reads settings directly: inside onSettingsChanged the saved* bindings
  // may not have re-evaluated yet.
  function syncFromSettings() {
    if (dragging) return
    liveActive = clamp(setting("active", 1.0))
    liveInactive = clamp(setting("inactive", 1.0))
    if (setting("active", null) !== null || setting("inactive", null) !== null) apply(liveActive, liveInactive)
  }

  onSettingsChanged: syncFromSettings()
  Component.onCompleted: syncFromSettings()

  function clamp(v) {
    var n = Number(v)
    if (!isFinite(n)) n = 1.0
    return Math.round(Math.max(minimumOpacity, Math.min(1.0, n)) * 100) / 100
  }

  function apply(active, inactive) {
    pending = { active: clamp(active), inactive: clamp(inactive) }
    // Our own eval may echo back as a configreloaded event; ignore those.
    echoGuard.restart()
    if (!applyProc.running) flush()
  }

  function flush() {
    if (!pending) return
    var lua = "hl.config({ decoration = { active_opacity = " + pending.active.toFixed(2)
      + ", inactive_opacity = " + pending.inactive.toFixed(2) + " } })"
    pending = null
    applyProc.command = ["hyprctl", "-q", "eval", lua]
    applyProc.running = true
  }

  function preview(active, inactive) {
    liveActive = clamp(active)
    liveInactive = clamp(inactive)
    apply(liveActive, liveInactive)
  }

  function save() {
    dragging = false
    var next = Object.assign({}, root.settings, { active: liveActive, inactive: liveInactive })
    root.settings = next
    if (root.bar && root.bar.shell) root.bar.shell.updateEntryInline(root.moduleName, next)
  }

  function nudge(row, delta) {
    if (row === 0) preview(liveActive + delta, liveInactive)
    else preview(liveActive, liveInactive + delta)
    save()
  }

  Process {
    id: applyProc
    onExited: root.flush()
  }

  Timer {
    id: echoGuard
    interval: 1000
  }

  // `hyprctl reload` or saving a Hyprland config file resets decoration
  // options to the Lua config, so put the saved values back afterwards.
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (!event || String(event.name) !== "configreloaded") return
      if (!root.hasSaved || root.dragging || echoGuard.running) return
      root.apply(root.savedActive, root.savedInactive)
    }
  }

  onOpenedChanged: if (opened) cursorActive = false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰗋"
    tooltipText: "Window opacity"
    onPressed: function(b) { root.toggle() }
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(320))
    contentHeight: panel.fittedContentHeight(column.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onMoveRequested: function(dx, dy) {
        if (!root.cursorActive) { root.cursorActive = true; return }
        if (dy !== 0) root.selectedRow = dy > 0 ? 1 : 0
        else if (dx !== 0) root.nudge(root.selectedRow, dx * 0.05)
      }
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Style.space(14)

        PanelSectionHeader {
          text: "WINDOW OPACITY"
          foreground: root.bar.foreground
          fontFamily: root.bar.fontFamily
        }

        OpacityRow {
          label: "Focused"
          row: 0
          value: root.liveActive
          onMovedTo: function(v) { root.preview(v, root.liveInactive) }
        }

        OpacityRow {
          label: "Unfocused"
          row: 1
          value: root.liveInactive
          onMovedTo: function(v) { root.preview(root.liveActive, v) }
        }
      }
    }
  }

  component OpacityRow: Column {
    id: opacityRow
    property string label: ""
    property int row: 0
    property real value: 1.0
    signal movedTo(real value)

    readonly property bool selected: root.cursorActive && root.selectedRow === row

    width: parent.width
    spacing: Style.space(6)

    Item {
      width: parent.width
      implicitHeight: rowLabel.implicitHeight

      Text {
        id: rowLabel
        textFormat: Text.PlainText
        text: (opacityRow.selected ? "› " : "") + opacityRow.label
        color: root.bar.foreground
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.bodySmall
        font.bold: opacityRow.selected
      }

      Text {
        anchors.right: parent.right
        textFormat: Text.PlainText
        text: Math.round(opacityRow.value * 100) + "%"
        color: root.bar.foreground
        opacity: 0.7
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.bodySmall
      }
    }

    PanelSlider {
      bar: root.bar
      width: parent.width
      minimum: root.minimumOpacity
      maximum: 1.0
      step: 0.05
      value: opacityRow.value

      onMoved: function(v) {
        root.dragging = true
        opacityRow.movedTo(v)
      }
      onReleased: function(v) {
        opacityRow.movedTo(v)
        root.save()
      }
    }

    HoverHandler {
      onHoveredChanged: if (hovered) {
        root.cursorActive = true
        root.selectedRow = opacityRow.row
      }
    }
  }
}
