import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons
import "Model.js" as Model

// Bar icon + popup with two sliders that drive Hyprland's
// decoration.active_opacity / decoration.inactive_opacity live.
//
// Persistence: the values are written to ~/.config/hypr/window-opacity.lua,
// which hyprland.lua loads. That keeps them across shell restarts, Hyprland
// reloads, and logins (Hyprland applies them itself, before the shell starts).
// The same file is read back to seed the sliders.
Panel {
  id: root
  moduleName: "parker.window-opacity"

  property int activePercent: 100
  property int inactivePercent: 100
  property bool fileReady: false      // never write before the first read
  property bool applyQueued: false

  // Keyboard cursor: "active" | "inactive"; painted after hover/first key.
  property string focusRow: "active"
  property bool cursorActive: false

  readonly property string luaPath: Quickshell.env("HOME") + "/.config/hypr/window-opacity.lua"

  function setOpacity(row, value) {
    var percent = Model.clampPercent(value)
    if (row === "active") {
      if (percent === activePercent) return
      activePercent = percent
    } else {
      if (percent === inactivePercent) return
      inactivePercent = percent
    }
    apply()
    persistDebounce.restart()
  }

  // Live update. Coalesce while hyprctl is still running so a fast drag
  // never stacks processes; the last value always lands.
  function apply() {
    if (applyProc.running) {
      applyQueued = true
      return
    }
    applyQueued = false
    applyProc.command = ["hyprctl", "eval", Model.configCall(activePercent, inactivePercent)]
    applyProc.running = true
  }

  function persist() {
    if (!fileReady) return
    luaFile.setText(Model.luaFile(activePercent, inactivePercent))
  }

  function loadFrom(text) {
    // Don't let a file event yank the knob mid-drag or overwrite a pending save.
    if (persistDebounce.running || activeRow.slider.dragging || inactiveRow.slider.dragging) return
    var parsed = Model.parseLuaFile(text)
    activePercent = parsed.active
    inactivePercent = parsed.inactive
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onOpenedChanged: if (opened) { focusRow = "active"; cursorActive = false }

  FileView {
    id: luaFile
    path: root.luaPath
    watchChanges: true
    atomicWrites: true
    printErrors: false
    onLoaded: { root.loadFrom(text()); root.fileReady = true }
    onLoadFailed: root.fileReady = true   // no file yet: defaults (100/100)
    onFileChanged: reload()
  }

  Timer {
    id: persistDebounce
    interval: 400
    repeat: false
    onTriggered: root.persist()
  }

  Process {
    id: applyProc
    stdout: StdioCollector { id: applyOut; waitForEnd: true }
    onExited: function(exitCode) {
      if (exitCode !== 0) console.warn("window-opacity: hyprctl eval failed (" + exitCode + "): " + applyOut.text)
      if (root.applyQueued) root.apply()
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰗋"
    tooltipText: "Window opacity " + root.activePercent + "% / " + root.inactivePercent + "%"
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
    contentHeight: panel.fittedContentHeight(panelColumn.implicitHeight, Style.space(400))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onMoveRequested: function(dx, dy) {
        if (!root.cursorActive) { root.cursorActive = true; return }
        if (dy !== 0) root.focusRow = dy > 0 ? "inactive" : "active"
        else if (dx !== 0) {
          var current = root.focusRow === "active" ? root.activePercent : root.inactivePercent
          root.setOpacity(root.focusRow, current + dx * 5)
        }
      }
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: panelColumn
        width: parent.width
        spacing: Style.space(14)

        PanelHero {
          width: parent.width
          title: "Window opacity"
          meta: "APPLIES LIVE"
          foreground: root.bar.foreground
          fontFamily: root.bar.fontFamily
          iconComponent: Component {
            Text {
              text: "󰗋"
              color: root.bar.foreground
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.display
            }
          }
        }

        PanelSeparator { foreground: root.bar.foreground }

        OpacityRow {
          id: activeRow
          row: "active"
          label: "FOCUSED WINDOW"
          percent: root.activePercent
        }

        OpacityRow {
          id: inactiveRow
          row: "inactive"
          label: "UNFOCUSED WINDOWS"
          percent: root.inactivePercent
        }
      }
    }
  }

  component OpacityRow: Column {
    id: rowRoot
    required property string row
    required property string label
    required property int percent
    property alias slider: rowSlider

    width: parent ? parent.width : 0
    spacing: Style.space(6)

    Item {
      width: parent.width
      implicitHeight: Math.max(rowHeader.implicitHeight, rowValue.implicitHeight)

      PanelSectionHeader {
        id: rowHeader
        text: rowRoot.label
        foreground: root.bar.foreground
        fontFamily: root.bar.fontFamily
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
      }

      Text {
        id: rowValue
        textFormat: Text.PlainText
        text: Math.round(rowSlider.dragging ? rowSlider.liveValue : rowRoot.percent) + "%"
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
      height: rowSlider.implicitHeight + Style.spacing.controlGap
      hasCursor: root.cursorActive && root.focusRow === rowRoot.row
      foreground: root.bar.foreground
      outline: true

      PanelSlider {
        id: rowSlider
        bar: root.bar
        anchors.fill: parent
        anchors.leftMargin: Style.space(6)
        anchors.rightMargin: Style.space(6)
        minimum: Model.MIN_PERCENT
        maximum: Model.MAX_PERCENT
        step: 5
        integer: true
        value: rowRoot.percent
        onMoved: function(v) { root.setOpacity(rowRoot.row, v) }
        onReleased: function(v) { root.setOpacity(rowRoot.row, v) }
      }

      HoverHandler {
        onHoveredChanged: if (hovered) {
          root.cursorActive = true
          root.focusRow = rowRoot.row
        }
      }
    }
  }
}
