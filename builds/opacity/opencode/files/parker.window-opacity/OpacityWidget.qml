import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui
import qs.Commons

// Bar button + popup with two sliders driving Hyprland's
// decoration:active_opacity and decoration:inactive_opacity live.
//
// The chosen values are stored inline on this widget's shell.json entry
// (activeOpacity / inactiveOpacity). Runtime changes made with `hyprctl eval`
// are lost when Hyprland restarts or reloads its config, so the widget
// re-applies the saved values whenever it loads and after every
// `configreloaded` event.
Panel {
  id: root
  moduleName: "parker.window-opacity"
  ipcTarget: "parker.window-opacity"

  readonly property real minOpacity: 0.2
  readonly property real step: 0.05

  property real activeOpacity: 1.0
  property real inactiveOpacity: 1.0
  // True once there is a saved preference to enforce. Until then the sliders
  // just mirror whatever Hyprland is currently configured with.
  property bool hasSaved: false

  // Keyboard cursor: 0 = focused slider, 1 = unfocused slider.
  property int selectedIndex: 0
  property bool cursorActive: false

  readonly property bool dragging: activeSlider.dragging || inactiveSlider.dragging

  function clamp(v) {
    return Math.round(Math.max(minOpacity, Math.min(1, v)) * 100) / 100
  }

  function savedValue(name) {
    var raw = setting(name, null)
    if (raw === null || raw === "") return NaN
    var v = Number(raw)
    return isFinite(v) ? clamp(v) : NaN
  }

  function loadSettings() {
    if (dragging) return
    var a = savedValue("activeOpacity")
    var i = savedValue("inactiveOpacity")
    if (isFinite(a) || isFinite(i)) {
      if (isFinite(a)) activeOpacity = a
      if (isFinite(i)) inactiveOpacity = i
      hasSaved = true
      applyNow()
    } else if (!hasSaved) {
      readCurrent()
    }
  }

  function readCurrent() {
    if (!readActiveProc.running) readActiveProc.running = true
    if (!readInactiveProc.running) readInactiveProc.running = true
  }

  function parseOption(raw) {
    try {
      var v = Number(JSON.parse(raw || "{}").float)
      return isFinite(v) ? v : NaN
    } catch (e) {
      return NaN
    }
  }

  // Before a preference is saved, adopt Hyprland's value. Afterwards, only
  // re-apply when Hyprland disagrees, which keeps a reload from looping.
  function reconcile(current, desired, adopt) {
    if (!isFinite(current)) return
    if (!hasSaved) adopt(clamp(current))
    else if (Math.abs(current - desired) > 0.005) applyTimer.start()
  }

  function applyNow() {
    Quickshell.execDetached([
      "hyprctl", "eval",
      "hl.config({ decoration = { active_opacity = " + activeOpacity.toFixed(2)
        + ", inactive_opacity = " + inactiveOpacity.toFixed(2) + " } })"
    ])
  }

  // Coalesce slider drags into at most one hyprctl call per tick.
  function scheduleApply() {
    if (!applyTimer.running) applyTimer.start()
  }

  function setActive(v) {
    activeOpacity = clamp(v)
    scheduleApply()
  }

  function setInactive(v) {
    inactiveOpacity = clamp(v)
    scheduleApply()
  }

  function persist() {
    persistTimer.stop()
    hasSaved = true
    var entry = { id: root.moduleName }
    for (var key in root.settings) if (key !== "id") entry[key] = root.settings[key]
    entry.activeOpacity = activeOpacity
    entry.inactiveOpacity = inactiveOpacity
    root.settings = entry
    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
      root.bar.shell.updateEntryInline(root.moduleName, entry)
  }

  function adjustSelected(delta) {
    if (selectedIndex === 0) setActive(activeOpacity + delta)
    else setInactive(inactiveOpacity + delta)
    persistTimer.restart()
  }

  onSettingsChanged: loadSettings()
  Component.onCompleted: loadSettings()

  onOpenedChanged: {
    if (opened) {
      selectedIndex = 0
      cursorActive = false
    } else if (persistTimer.running) {
      persist()
    }
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Timer {
    id: applyTimer
    interval: 30
    onTriggered: root.applyNow()
  }

  Timer {
    id: persistTimer
    interval: 500
    onTriggered: root.persist()
  }

  Timer {
    id: reloadTimer
    interval: 200
    onTriggered: root.readCurrent()
  }

  Process {
    id: readActiveProc
    command: ["hyprctl", "-j", "getoption", "decoration:active_opacity"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.reconcile(root.parseOption(text), root.activeOpacity,
        function(v) { root.activeOpacity = v })
    }
  }

  Process {
    id: readInactiveProc
    command: ["hyprctl", "-j", "getoption", "decoration:inactive_opacity"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.reconcile(root.parseOption(text), root.inactiveOpacity,
        function(v) { root.inactiveOpacity = v })
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event && String(event.name) === "configreloaded") reloadTimer.restart()
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰗉"
    tooltipText: "Window opacity " + Math.round(root.activeOpacity * 100) + "% / "
      + Math.round(root.inactiveOpacity * 100) + "%"
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
        if (dy !== 0) root.selectedIndex = Math.max(0, Math.min(1, root.selectedIndex + dy))
        else if (dx !== 0) root.adjustSelected(dx * root.step)
      }
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: panelColumn
        width: parent.width
        spacing: Style.space(14)

        Row {
          spacing: Style.space(14)

          Text {
            textFormat: Text.PlainText
            text: "󰗉"
            color: root.bar.foreground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.display
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            text: "Window Opacity"
            color: root.bar.foreground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.title
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
          }
        }

        PanelSeparator {
          foreground: root.bar.foreground
        }

        OpacityRow {
          label: "FOCUSED"
          rowIndex: 0
          slider: activeSlider

          PanelSlider {
            id: activeSlider
            bar: root.bar
            anchors.fill: parent
            minimum: root.minOpacity
            maximum: 1
            step: root.step
            value: root.activeOpacity
            onMoved: function(v) { root.setActive(v) }
            onReleased: function(v) { root.setActive(v); persistTimer.restart() }
          }
        }

        OpacityRow {
          label: "UNFOCUSED"
          rowIndex: 1
          slider: inactiveSlider

          PanelSlider {
            id: inactiveSlider
            bar: root.bar
            anchors.fill: parent
            minimum: root.minOpacity
            maximum: 1
            step: root.step
            value: root.inactiveOpacity
            onMoved: function(v) { root.setInactive(v) }
            onReleased: function(v) { root.setInactive(v); persistTimer.restart() }
          }
        }
      }
    }
  }

  // Section header with a live percentage, above a cursor-highlightable slider.
  component OpacityRow: Column {
    id: row
    required property string label
    required property int rowIndex
    required property Item slider
    default property alias content: sliderHolder.children

    width: panelColumn.width
    spacing: Style.space(6)

    Item {
      width: parent.width
      implicitHeight: Math.max(header.implicitHeight, percent.implicitHeight)

      PanelSectionHeader {
        id: header
        text: row.label
        foreground: root.bar.foreground
        fontFamily: root.bar.fontFamily
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
      }

      Text {
        id: percent
        textFormat: Text.PlainText
        text: Math.round(row.slider.liveValue * 100) + "%"
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
      height: row.slider.implicitHeight + Style.spacing.controlGap
      hasCursor: root.cursorActive && root.selectedIndex === row.rowIndex
      foreground: root.bar.foreground
      outline: true

      Item {
        id: sliderHolder
        anchors.fill: parent
        anchors.leftMargin: Style.space(6)
        anchors.rightMargin: Style.space(6)
      }

      HoverHandler {
        onHoveredChanged: if (hovered) {
          root.cursorActive = true
          root.selectedIndex = row.rowIndex
        }
      }
    }
  }
}
