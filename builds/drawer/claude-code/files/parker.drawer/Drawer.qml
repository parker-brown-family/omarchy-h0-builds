import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Ui
import "DrawerModel.js" as DrawerModel

// Drawer button plus the panel holding the tucked widgets.
//
// Configured inline on its bar layout entry:
//   { "id": "parker.drawer", "items": ["omarchy.bluetooth", "omarchy.monitor"] }
//
// Each item is built from the widget's own manifest entry point, found by
// scanning the built-in and user plugin directories, and receives a bar
// facade that forwards to this widget's facade. Tucked widgets therefore get
// the same bar surface a third-party widget gets on the bar itself.
//
// The panel is a plain popup rather than a bar popout: tucked widgets open
// their own popouts on top of it, and taking the bar's single popout slot
// would make the first one close the drawer underneath it.
Panel {
  id: root

  readonly property string selfId: moduleName || "parker.drawer"
  readonly property bool vertical: bar ? bar.vertical : false
  readonly property int barSize: bar ? bar.barSize : Style.bar.sizeHorizontal
  readonly property var barWindow: button.QsWindow.window

  // Ids only change when `items` does. Keeping the model a joined string means
  // unrelated shell.json writes do not rebuild every tucked widget.
  readonly property string itemsKey: DrawerModel.itemIds(settings, selfId).join("\n")
  readonly property var itemIds: itemsKey ? itemsKey.split("\n") : []

  // Widget id -> absolute path of its barWidget QML entry point.
  property var catalogue: ({})

  readonly property bool hostedPopoutOpen: bar ? isHosted(bar.activePopout) : false
  property var pendingItem: null

  property var tooltipTarget: null
  property string tooltipText: ""
  property bool tooltipShown: false

  function holders() {
    var out = []
    for (var i = 0; i < repeater.count; i++) {
      var holder = repeater.itemAt(i)
      if (holder) out.push(holder)
    }
    return out
  }

  function hostedItems(id) {
    var out = []
    var list = holders()
    for (var i = 0; i < list.length; i++)
      if (list[i].moduleName === id && list[i].activeItem) out.push(list[i].activeItem)
    return out
  }

  function inPanelWindow(target) {
    try {
      return !!target && !!target.QsWindow && target.QsWindow.window === panel
    } catch (e) {
      return false
    }
  }

  // A popout belongs to the drawer when its owner is a tucked widget, or when
  // it is a popup anchored to something inside the drawer panel.
  function isHosted(target) {
    if (!target || target.foreign === true) return false
    var list = holders()
    for (var i = 0; i < list.length; i++) if (list[i].activeItem === target) return true
    return inPanelWindow(target) || inPanelWindow(target.anchorItem)
  }

  function canPopOut(item) {
    return !!item && typeof item.open === "function" && typeof item.close === "function"
      && item.opened !== undefined
  }

  function closeHostedPopouts() {
    var list = holders()
    for (var i = 0; i < list.length; i++) {
      var item = list[i].activeItem
      if (canPopOut(item) && item.opened) item.close()
    }
  }

  // Open the drawer and then a tucked widget's own panel. The widget's popup
  // anchors to the drawer surface, so it waits for the drawer to map first.
  function openHosted(item) {
    if (!opened) open()
    pendingItem = item
    pendingOpen.restart()
  }

  function showTooltip(target, text) {
    tooltipShown = false
    tooltipTarget = text ? target : null
    tooltipText = String(text || "")
    if (tooltipTarget) tooltipDelay.restart()
  }

  function hideTooltip(target) {
    if (tooltipTarget !== target) return
    tooltipDelay.stop()
    tooltipShown = false
    tooltipTarget = null
    tooltipText = ""
  }

  function rescan() {
    catalogueScan.running = true
  }

  onItemsKeyChanged: rescan()

  onOpenedChanged: {
    if (opened) {
      // Claim and release the bar's popout slot: whatever bar panel was
      // showing closes, and the slot stays free for the tucked widgets.
      if (bar) {
        bar.requestPopout(root)
        bar.releasePopout(root)
      }
    } else {
      pendingOpen.stop()
      pendingItem = null
      hideTooltip(tooltipTarget)
      closeHostedPopouts()
    }
  }

  Process {
    id: catalogueScan

    running: true
    command: ["bash", "-c",
      "find -L \"$1\" \"$2\" \\( -name manifest.json -o -name '*.manifest.json' \\) -print0 2>/dev/null"
      + " | xargs -0 -r jq -c 'select((.kinds // []) | index(\"bar-widget\")) | select(.entryPoints.barWidget)"
      + " | {id, file: ((input_filename | sub(\"/[^/]*$\"; \"\")) + \"/\" + .entryPoints.barWidget)}' 2>/dev/null",
      "drawer-scan",
      Quickshell.env("OMARCHY_PATH") + "/shell/plugins",
      Quickshell.env("HOME") + "/.config/omarchy/plugins"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.catalogue = DrawerModel.parseCatalogue(text)
    }
  }

  Timer {
    id: pendingOpen
    interval: 60
    onTriggered: {
      var item = root.pendingItem
      root.pendingItem = null
      if (root.opened && item) item.open()
    }
  }

  Timer {
    id: tooltipDelay
    interval: 400
    onTriggered: root.tooltipShown = !!root.tooltipTarget && root.tooltipTarget.tooltipHovered === true
  }

  Timer {
    interval: 100
    running: root.tooltipShown
    repeat: true
    onTriggered: if (!root.tooltipTarget || root.tooltipTarget.tooltipHovered !== true) root.hideTooltip(root.tooltipTarget)
  }

  Connections {
    target: root.bar

    function onActivePopoutChanged() {
      var current = root.bar.activePopout
      if (!current || current === root) return
      if (!root.isHosted(current)) {
        if (root.opened) root.close()
        return
      }
      // A tucked widget opened by its own IPC target while the drawer was
      // shut: reopen it once the drawer surface is there to anchor to.
      if (!root.opened && root.canPopOut(current)) {
        current.close()
        root.openHosted(current)
      }
    }
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: String(root.setting("icon", "") || "\uf141")
    active: root.opened
    tooltipText: root.opened ? "" : String(root.setting("tooltip", "") || "Drawer")
    onPressed: function(mouseButton) {
      if (mouseButton === Qt.LeftButton) root.toggle()
    }
  }

  PopupWindow {
    id: panel

    readonly property int margin: Style.gapsOut
    readonly property int padding: Style.space(3)

    visible: root.opened || card.opacity > 0
    color: "transparent"
    implicitWidth: Math.max(1, Math.ceil(card.implicitWidth))
    implicitHeight: Math.max(1, Math.ceil(card.implicitHeight))

    anchor {
      id: panelAnchor
      window: root.barWindow
      adjustment: PopupAdjustment.Slide
      edges: Edges.Top | Edges.Left
      gravity: Edges.Bottom | Edges.Right
      rect.width: 1
      rect.height: 1

      // Hang the panel off the button on the side facing the desktop, the
      // same placement PopupCard gives the bar's own popouts.
      onAnchoring: {
        var window = root.barWindow
        if (!window || !root.bar) return

        var width = panel.implicitWidth
        var height = panel.implicitHeight
        var localX = button.width / 2 - width / 2
        var localY = button.height + panel.margin

        if (root.bar.position === "bottom") {
          localY = -height - panel.margin
        } else if (root.bar.position === "left") {
          localX = button.width + panel.margin
          localY = button.height / 2 - height / 2
        } else if (root.bar.position === "right") {
          localX = -width - panel.margin
          localY = button.height / 2 - height / 2
        }

        var point = window.contentItem.mapFromItem(button, localX, localY)
        if (root.vertical)
          point.y = Math.max(panel.margin, Math.min(point.y, window.height - height - panel.margin))
        else
          point.x = Math.max(panel.margin, Math.min(point.x, window.width - width - panel.margin))

        panelAnchor.rect.x = Math.round(point.x)
        panelAnchor.rect.y = Math.round(point.y)
      }
    }

    // Outside clicks dismiss the drawer. The bar is part of the grab so the
    // drawer button toggles cleanly, and the grab steps aside while a tucked
    // widget's own popout (which runs its own grab) is open.
    HyprlandFocusGrab {
      active: root.opened && panel.visible && !root.hostedPopoutOpen
      windows: root.barWindow ? [panel, root.barWindow] : [panel]
      onCleared: if (!root.hostedPopoutOpen) root.close()
    }

    BorderSurface {
      id: card

      anchors.fill: parent
      implicitWidth: (empty.visible ? empty.implicitWidth : strip.implicitWidth) + contentLeftInset + contentRightInset
      implicitHeight: (empty.visible ? empty.implicitHeight : strip.implicitHeight) + contentTopInset + contentBottomInset
      color: root.bar ? root.bar.background : Color.bar.background
      borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, Math.max(1, Style.space(2)))
      padding: panel.padding
      radius: Style.cornerRadius
      opacity: root.opened ? 1 : 0

      Behavior on opacity {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
      }

      Grid {
        id: strip

        x: card.contentLeftInset
        y: card.contentTopInset
        columns: root.vertical ? 1 : Math.max(1, repeater.count)
        spacing: 0

        Repeater {
          id: repeater
          model: root.itemIds

          delegate: HostedSlot { }
        }
      }

      Text {
        id: empty

        x: card.contentLeftInset
        y: card.contentTopInset
        visible: strip.childrenRect.width <= 0 || strip.childrenRect.height <= 0
        textFormat: Text.PlainText
        text: root.itemIds.length > 0 ? "Nothing to show" : "Drawer is empty"
        color: root.bar ? root.bar.barForeground : Color.bar.text
        opacity: 0.6
        font.family: root.bar ? root.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.body
        padding: Style.space(6)
      }
    }
  }

  // The bar only draws tooltips for its own surface, so the drawer draws the
  // ones raised by tucked widgets.
  PopupWindow {
    id: tooltip

    readonly property var target: root.tooltipTarget

    visible: panel.visible && root.tooltipShown && root.inPanelWindow(target) && root.tooltipText !== ""
    color: "transparent"
    implicitWidth: Math.ceil(tooltipBubble.implicitWidth)
    implicitHeight: Math.ceil(tooltipBubble.implicitHeight)

    anchor {
      id: tooltipAnchor
      window: panel
      adjustment: PopupAdjustment.Slide
      edges: Edges.Top | Edges.Left
      gravity: Edges.Bottom | Edges.Right
      rect.width: 1
      rect.height: 1

      onAnchoring: {
        var target = tooltip.target
        if (!root.inPanelWindow(target) || !root.bar) return

        var width = tooltip.implicitWidth
        var height = tooltip.implicitHeight
        var localX = target.width / 2 - width / 2
        var localY = target.height + 6

        if (root.bar.position === "bottom") {
          localY = -height - 6
        } else if (root.bar.position === "left") {
          localX = target.width + 6
          localY = target.height / 2 - height / 2
        } else if (root.bar.position === "right") {
          localX = -width - 6
          localY = target.height / 2 - height / 2
        }

        var point = panel.contentItem.mapFromItem(target, localX, localY)
        tooltipAnchor.rect.x = Math.round(point.x)
        tooltipAnchor.rect.y = Math.round(point.y)
      }
    }

    BorderSurface {
      id: tooltipBubble
      implicitWidth: tooltipLabel.implicitWidth + 20
      implicitHeight: tooltipLabel.implicitHeight + 14
      color: Color.tooltip.background
      borderSpec: Border.surfaceSpec("tooltip", "border", Color.tooltip.border, 1)
      radius: Style.cornerRadius

      Text {
        id: tooltipLabel
        textFormat: Text.PlainText
        anchors.centerIn: parent
        text: root.tooltipText
        color: Color.tooltip.text
        font.family: root.bar ? root.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.body
      }
    }
  }

  // One tucked widget: load its entry point, then inject bar, moduleName and
  // settings the way the bar's module slots do.
  component HostedSlot: Item {
    id: slot

    required property string modelData
    readonly property string moduleName: modelData
    readonly property string source: root.catalogue[moduleName] ? Util.fileUrl(root.catalogue[moduleName]) : ""
    readonly property var activeItem: loader.item
    // Compared as text so a shell.json write that leaves this widget's
    // settings alone does not push a fresh object into it.
    readonly property string settingsJson: JSON.stringify(DrawerModel.itemSettings(root.settings, moduleName))

    implicitWidth: activeItem && activeItem.visible ? (root.vertical ? root.barSize : activeItem.implicitWidth) : 0
    implicitHeight: activeItem && activeItem.visible ? (root.vertical ? activeItem.implicitHeight : root.barSize) : 0
    width: implicitWidth
    height: implicitHeight

    function injectProps() {
      var target = activeItem
      if (!target) return
      if ("bar" in target) target.bar = slotBar
      if ("moduleName" in target) target.moduleName = moduleName
      if ("settings" in target) target.settings = JSON.parse(settingsJson)
    }

    onSettingsJsonChanged: {
      var target = activeItem
      if (target && "settings" in target) target.settings = JSON.parse(settingsJson)
    }

    // Forwards to the drawer's own bar facade, except for what has to stay
    // inside the drawer: tooltips, and broadcasts to this widget's instances.
    PluginBarApi {
      id: slotBar

      pluginId: root.bar ? root.bar.pluginId : root.selfId
      moduleName: slot.moduleName
      shell: root.bar ? root.bar.shell : null
      foreground: root.bar ? root.bar.foreground : Color.bar.text
      barForeground: root.bar ? root.bar.barForeground : Color.bar.text
      background: root.bar ? root.bar.background : Color.bar.background
      urgent: root.bar ? root.bar.urgent : Color.bar.active
      fontFamily: root.bar ? root.bar.fontFamily : Style.font.family
      position: root.bar ? root.bar.position : "top"
      vertical: root.vertical
      barSize: root.barSize
      transparent: root.bar ? root.bar.transparent : false
      foregroundAnimationEnabled: root.bar ? root.bar.foregroundAnimationEnabled : true
      centerSectionRevealHeld: root.bar ? root.bar.centerSectionRevealHeld : false
      _centerHoverRevealSuppressed: root.bar ? root.bar.centerHoverRevealSuppressed : false
      activePopout: root.bar ? root.bar.activePopout : null
      clickTargets: root.bar ? root.bar.clickTargets : []
      layoutConfig: root.bar ? root.bar.layoutConfig : ({})

      _showTooltip: function(target, text) { root.showTooltip(target, text) }
      _hideTooltip: function(target) { root.hideTooltip(target) }
      _requestPopout: function(owner) { if (root.bar) root.bar.requestPopout(owner) }
      _releasePopout: function(owner) { if (root.bar) root.bar.releasePopout(owner) }
      _targetBelongsToWindow: function(target, window) {
        return root.bar ? root.bar.targetBelongsToWindow(target, window) : false
      }
      _moduleWidgets: function(id) { return root.hostedItems(id) }
      _run: function(command) { if (root.bar) root.bar.run(command) }
      _setCenterHoverRevealSuppressed: function(value) {
        if (root.bar) root.bar.setCenterHoverRevealSuppressed(value)
      }
    }

    Loader {
      id: loader
      anchors.fill: parent
      source: slot.source
      onLoaded: {
        slot.injectProps()
        Qt.callLater(slot.injectProps)
      }
    }
  }
}
