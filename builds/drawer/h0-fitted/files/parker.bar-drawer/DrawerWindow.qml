import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

// The drawer panel. A transparent layer-shell strip anchored to the same screen
// edge as the bar, spanning the bar plus the card below it. Only the card takes
// input (see `mask`), so the bar underneath stays clickable. Covering the bar's
// strip matters for the tucked widgets' own panels: they place themselves just
// past the edge of the window their button lives in, so with this geometry they
// open beyond the drawer instead of on top of it.
PanelWindow {
  id: win

  property var drawer: null
  property Item anchorItem: null
  property var entries: []

  readonly property var hostBar: drawer ? drawer.bar : null
  readonly property bool open: drawer ? drawer.opened === true : false
  readonly property string barPos: hostBar ? String(hostBar.position || "top") : "top"
  readonly property bool vertical: barPos === "left" || barPos === "right"
  readonly property int slotSize: hostBar && hostBar.barSize ? hostBar.barSize : Style.bar.sizeHorizontal
  readonly property var anchorWindow: anchorItem ? anchorItem.QsWindow.window : null
  readonly property real barThickness: anchorWindow
    ? (vertical ? anchorWindow.width : anchorWindow.height) : slotSize
  readonly property int gap: Style.gapsOut
  readonly property int edgeMargin: Style.gapsOut
  readonly property bool hovered: cardHover.hovered
  readonly property Item contentRoot: card
  readonly property bool empty: vertical ? widgetGrid.implicitHeight <= 0 : widgetGrid.implicitWidth <= 0

  function widgetsFor(id) {
    var out = []
    for (var i = 0; i < repeater.count; i++) {
      var slot = repeater.itemAt(i)
      if (slot && slot.widget && slot.entryId === id) out.push(slot.widget)
    }
    return out
  }

  function allWidgets() {
    var out = []
    for (var i = 0; i < repeater.count; i++) {
      var slot = repeater.itemAt(i)
      if (slot && slot.widget) out.push(slot.widget)
    }
    return out
  }

  screen: anchorWindow ? anchorWindow.screen : null
  visible: open || card.opacity > 0
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.namespace: "parker-bar-drawer"
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  anchors {
    top: win.barPos !== "bottom"
    bottom: win.barPos !== "top"
    left: win.barPos !== "right"
    right: win.barPos !== "left"
  }

  implicitWidth: vertical ? Math.ceil(barThickness + gap + card.width) : 0
  implicitHeight: vertical ? 0 : Math.ceil(barThickness + gap + card.height)

  mask: Region { item: card }

  TransformWatcher {
    id: anchorWatcher
    a: win.anchorWindow ? win.anchorWindow.contentItem : null
    b: win.anchorItem
  }

  readonly property point anchorPos: {
    anchorWatcher.transform
    if (!anchorItem || !anchorWindow || !anchorWindow.contentItem) return Qt.point(0, 0)
    return anchorItem.mapToItem(anchorWindow.contentItem, 0, 0)
  }

  BorderSurface {
    id: card

    readonly property real wantX: win.anchorPos.x + (win.anchorItem ? win.anchorItem.width : 0) / 2 - width / 2
    readonly property real wantY: win.anchorPos.y + (win.anchorItem ? win.anchorItem.height : 0) / 2 - height / 2

    x: win.vertical
      ? (win.barPos === "left" ? win.barThickness + win.gap : 0)
      : Math.round(Math.max(win.edgeMargin, Math.min(wantX, win.width - width - win.edgeMargin)))
    y: win.vertical
      ? Math.round(Math.max(win.edgeMargin, Math.min(wantY, win.height - height - win.edgeMargin)))
      : (win.barPos === "top" ? win.barThickness + win.gap : 0)
    width: Math.ceil((win.empty ? emptyLabel.implicitWidth : widgetGrid.implicitWidth) + contentLeftInset + contentRightInset)
    height: Math.ceil((win.empty ? emptyLabel.implicitHeight : widgetGrid.implicitHeight) + contentTopInset + contentBottomInset)

    color: Color.popups.background
    borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, Math.max(1, Style.space(2)))
    padding: Style.space(4)
    radius: Style.cornerRadius
    opacity: win.open ? 1.0 : 0

    Behavior on opacity {
      NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }

    HoverHandler { id: cardHover }

    Text {
      id: emptyLabel
      visible: win.empty
      x: card.contentLeftInset
      y: card.contentTopInset
      leftPadding: Style.space(8)
      rightPadding: Style.space(8)
      height: win.slotSize
      verticalAlignment: Text.AlignVCenter
      text: win.entries.length > 0 ? "Nothing to show right now" : "Drawer is empty"
      color: Color.muted
      font.family: win.hostBar ? win.hostBar.fontFamily : Style.font.family
      font.pixelSize: Style.font.body
    }

    Grid {
      id: widgetGrid
      x: card.contentLeftInset
      y: card.contentTopInset
      spacing: 0
      columns: win.vertical ? 1 : Math.max(1, repeater.count)

      Repeater {
        id: repeater
        model: win.entries

        Item {
          id: slot

          required property var modelData
          readonly property string entryId: String(modelData.id)
          readonly property Item widget: loader.item

          // Same rule as the bar's own slots: a widget that hides itself
          // (no updates pending, no weather yet, ...) takes no room.
          readonly property bool shown: widget !== null && widget.visible
          width: !shown ? 0 : (win.vertical ? win.slotSize : widget.implicitWidth)
          height: !shown ? 0 : (win.vertical ? widget.implicitHeight : win.slotSize)

          NestedBar {
            id: proxy
            host: win.hostBar
            drawer: win.drawer
            drawerWindow: win
            moduleId: slot.entryId
          }

          function inject() {
            var target = loader.item
            if (!target) return
            if ("bar" in target) target.bar = proxy
            if ("moduleName" in target) target.moduleName = slot.entryId
            if ("settings" in target) target.settings = slot.modelData.settings || ({})
          }

          onModelDataChanged: inject()

          Loader {
            id: loader
            anchors.fill: parent
            source: slot.modelData.url
            onLoaded: {
              slot.inject()
              Qt.callLater(slot.inject)
            }
            onStatusChanged: {
              if (status === Loader.Error)
                console.warn("parker.bar-drawer: could not load " + slot.entryId + " from " + source)
            }
          }
        }
      }
    }
  }
}
