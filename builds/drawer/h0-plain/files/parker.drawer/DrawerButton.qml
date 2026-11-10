import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui
import "DrawerModel.js" as DrawerModel

// The drawer button. Clicking it opens a panel holding the widgets listed in
// this entry's `items`. Only works under the parker.drawer bar, which hands
// this widget the live bar object plus the drawer host; on any other bar it
// renders nothing.
BarWidget {
  id: root

  // `bar` is the stock Bar instance (we are flagged first-party by the
  // drawer bar's registry), so its widget catalogue is the drawer registry.
  readonly property var registry: bar && bar.barWidgetRegistry ? bar.barWidgetRegistry : null
  readonly property var host: registry && registry.drawerHost ? registry.drawerHost : null
  readonly property string drawerId: host ? host.drawerId : moduleName
  readonly property var items: host
    ? DrawerModel.drawerItems(host.fullLayout, DrawerModel.entryFromSettings(drawerId, settings), drawerId)
    : []
  // Repeater model keyed by a string so unrelated shell.json writes (which
  // rebuild `items`) do not tear down and recreate every tucked widget.
  readonly property string itemKey: JSON.stringify(items.map(function(item) { return item.id }))
  readonly property var itemIds: JSON.parse(itemKey)

  function itemFor(id) {
    for (var i = 0; i < items.length; i++) if (items[i].id === id) return items[i]
    return { id: id, region: "drawer", settings: ({}), inLayout: false }
  }

  property bool drawerOpen: false
  // open/close/opened make `omarchy-shell shell toggle parker.drawer` work
  // through the bar's normal panel routing (usable from a Hyprland bind).
  readonly property bool opened: drawerOpen
  property var slotItems: []

  visible: host !== null
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onHostChanged: if (host) host.registerDrawer(root)
  Component.onCompleted: if (host) host.registerDrawer(root)
  Component.onDestruction: {
    if (host) host.unregisterDrawer(root)
    if (bar) for (var i = 0; i < slotItems.length; i++) bar.unregisterModuleSlot(slotItems[i])
  }

  // ------------------------------------------------------------ lifecycle

  function open() {
    if (drawerOpen) return
    // One popup at a time: opening the drawer closes any other bar panel.
    var other = bar ? bar.activePopout : null
    if (other && !ownsObject(other) && typeof other.close === "function") other.close()
    drawerOpen = true
  }

  function close() {
    if (!drawerOpen) return
    // A tucked widget's popup is anchored to the drawer; close it first.
    var active = bar ? bar.activePopout : null
    if (active && ownsObject(active) && typeof active.close === "function") active.close()
    drawerOpen = false
  }

  function toggle() { drawerOpen ? close() : open() }

  function screenName() {
    var window = root.QsWindow ? root.QsWindow.window : null
    return window && window.screen ? String(window.screen.name || "") : ""
  }

  // --------------------------------------------- IPC routing (via the host)

  function slotFor(id) {
    for (var i = 0; i < slotItems.length; i++)
      if (slotItems[i].moduleName === id && slotItems[i].activeItem) return slotItems[i]
    return null
  }

  function hostsWidget(id) { return slotFor(id) !== null }

  function panelCapable(item) {
    return item && typeof item.open === "function" && typeof item.close === "function" && item.opened !== undefined
  }

  function summonWidget(id) {
    var slot = slotFor(id)
    if (!slot || !panelCapable(slot.activeItem)) return false
    open()
    pendingSummon = id
    summonTimer.restart()
    return true
  }

  function hideWidget(id) {
    var slot = slotFor(id)
    if (!slot || !panelCapable(slot.activeItem) || slot.activeItem.opened !== true) return false
    slot.activeItem.close()
    return true
  }

  function widgetOpen(id) {
    var slot = slotFor(id)
    return !!slot && panelCapable(slot.activeItem) && slot.activeItem.opened === true
  }

  property string pendingSummon: ""

  // The tucked widget's popup anchors to the drawer window, which has to be
  // mapped first.
  Timer {
    id: summonTimer
    interval: 80
    onTriggered: {
      var slot = root.slotFor(root.pendingSummon)
      root.pendingSummon = ""
      if (slot && root.panelCapable(slot.activeItem)) slot.activeItem.open()
    }
  }

  // ------------------------------------------------- popout coordination

  // True when `target` lives inside the drawer (a tucked widget, its panel,
  // or a popup anchored to the drawer window).
  function ownsObject(target) {
    if (!target) return false
    var node = target
    for (var depth = 0; node && depth < 64; depth++) {
      if (node === content) return true
      node = node.parent
    }
    if (target.anchorItem && ownsObject(target.anchorItem)) return true
    if (target.anchor && target.anchor.window === drawerWindow) return true
    return false
  }

  readonly property bool childPopoutOpen: drawerOpen && bar !== null && bar.activePopout !== null
    && ownsObject(bar.activePopout)

  Connections {
    target: root.bar
    ignoreUnknownSignals: true
    function onActivePopoutChanged() {
      // Another bar widget opened its panel: get out of the way.
      var active = root.bar.activePopout
      if (root.drawerOpen && active && !root.ownsObject(active)) root.drawerOpen = false
    }
  }

  // ---------------------------------------------------------------- button

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.drawerOpen ? String(root.setting("iconOpen", "\uf077")) : String(root.setting("icon", "\uf078"))
    tooltipText: root.drawerOpen ? "" : String(root.setting("tooltip", "More widgets"))
    onPressed: function(b) { if (b === Qt.LeftButton) root.toggle() }
  }

  Rectangle {
    // Same open-panel mark the bar draws under a widget whose panel is open.
    readonly property int inset: Style.space(2)
    visible: root.drawerOpen
    color: Color.accent
    opacity: 0.9
    radius: Math.min(width, height) / 2
    width: root.vertical ? Style.space(2) : Math.max(Style.space(10), Math.round(root.width * 0.55))
    height: root.vertical ? Math.max(Style.space(10), Math.round(root.height * 0.55)) : Style.space(2)
    x: root.vertical
      ? (root.bar && root.bar.position === "left" ? root.width - width - inset : inset)
      : Math.round((root.width - width) / 2)
    y: root.vertical
      ? Math.round((root.height - height) / 2)
      : (root.bar && root.bar.position === "top" ? root.height - height - inset : inset)
  }

  // ----------------------------------------------------------------- panel

  // Tucked widgets stay alive while the drawer is closed, so their timers,
  // IPC handlers and refreshes keep running exactly as they would on the bar.
  PopupWindow {
    id: drawerWindow

    readonly property int margin: Style.gapsOut
    readonly property int pad: Style.space(4)
    readonly property string barPosition: root.bar ? root.bar.position : "top"

    visible: root.drawerOpen && root.host !== null
    color: "transparent"
    implicitWidth: Math.max(Style.space(40), Math.ceil(content.implicitWidth + pad * 2 + 2))
    implicitHeight: Math.max(root.barSize, Math.ceil(content.implicitHeight + pad * 2 + 2))

    anchor {
      id: drawerAnchor
      window: root.QsWindow ? root.QsWindow.window : null
      adjustment: PopupAdjustment.Slide
      edges: Edges.Top | Edges.Left
      gravity: Edges.Bottom | Edges.Right
      rect.width: 1
      rect.height: 1

      onAnchoring: {
        var window = root.QsWindow ? root.QsWindow.window : null
        if (!window) return
        var w = drawerWindow.implicitWidth
        var h = drawerWindow.implicitHeight
        var m = drawerWindow.margin
        var localX = root.width / 2 - w / 2
        var localY = root.height + m
        if (drawerWindow.barPosition === "bottom") localY = -h - m
        else if (drawerWindow.barPosition === "left") { localX = root.width + m; localY = root.height / 2 - h / 2 }
        else if (drawerWindow.barPosition === "right") { localX = -w - m; localY = root.height / 2 - h / 2 }
        var point = window.contentItem.mapFromItem(root, localX, localY)
        drawerAnchor.rect.x = Math.round(point.x)
        drawerAnchor.rect.y = Math.round(point.y)
      }
    }

    // Click outside the drawer (and the bar) closes it. While a tucked
    // widget's own popup is open, that popup holds the grab instead.
    HyprlandFocusGrab {
      active: drawerWindow.visible && !root.childPopoutOpen
      windows: drawerAnchor.window ? [drawerWindow, drawerAnchor.window] : [drawerWindow]
      onCleared: Qt.callLater(function() { if (!root.childPopoutOpen) root.close() })
    }

    BorderSurface {
      anchors.fill: parent
      color: Color.bar.background
      borderSpec: Border.localOrSurfaceSpec("popups", "border", Color.popups.border, Color.popups.border, Math.max(1, Style.space(2)))
      radius: Style.cornerRadius
    }

    Text {
      anchors.centerIn: parent
      visible: content.implicitWidth <= 0 || content.implicitHeight <= 0
      text: root.items.length === 0 ? "No widgets in drawer" : "Nothing to show"
      color: Color.bar.text
      opacity: 0.6
      font.family: root.bar ? root.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.body
    }

    Grid {
      id: content
      x: drawerWindow.pad + 1
      y: drawerWindow.pad + 1
      flow: root.vertical ? Grid.TopToBottom : Grid.LeftToRight
      rows: root.vertical ? -1 : 1
      columns: root.vertical ? 1 : -1
      spacing: 0

      Repeater {
        model: root.itemIds

        DrawerSlot {
          required property var modelData
          moduleName: modelData
        }
      }
    }
  }

  // One tucked widget. Mirrors how the stock bar's ModuleSlot loads and
  // injects a widget, and registers a zero-size proxy with the bar so
  // broadcast(), hotkeys and third-party facade bookkeeping see it.
  component DrawerSlot: Item {
    id: slot

    required property string moduleName
    readonly property var entry: root.itemFor(moduleName)
    // String-compared so settings are re-injected only when they really change.
    readonly property string settingsKey: JSON.stringify(entry.settings)
    readonly property var metadata: root.registry ? root.registry.metadataFor(moduleName) : null
    readonly property bool firstParty: !!metadata && metadata.firstParty === true
    readonly property var component: {
      var w = root.registry ? root.registry.widgets : null
      return w && w[moduleName] && moduleName !== root.drawerId ? w[moduleName].component : null
    }
    readonly property var activeItem: loader.item

    implicitWidth: activeItem && activeItem.visible ? (root.vertical ? root.barSize : activeItem.implicitWidth) : 0
    implicitHeight: activeItem && activeItem.visible ? activeItem.implicitHeight : 0
    width: implicitWidth
    height: implicitHeight

    Loader {
      id: loader
      anchors.fill: parent
      active: slot.component !== null
      sourceComponent: slot.component
      onLoaded: {
        slot.injectProps()
        Qt.callLater(slot.injectProps)
      }
    }

    onSettingsKeyChanged: injectProps()

    function injectProps() {
      var target = loader.item
      if (!target || !root.bar) return
      if ("bar" in target) target.bar = slot.firstParty
        ? root.bar : root.bar.pluginBarApiFor(slot.moduleName, slot.moduleName, true)
      if ("moduleName" in target) target.moduleName = slot.moduleName
      if ("settings" in target) target.settings = JSON.parse(slot.settingsKey)
    }

    // Invisible, zero-size stand-in registered in the bar's slot list. Zero
    // size keeps it out of drag-and-drop targeting; `region` is the widget's
    // real layout section so nothing ever writes a bogus section.
    Item {
      id: proxy
      visible: false
      width: 0
      height: 0
      readonly property string moduleName: slot.moduleName
      readonly property string region: slot.entry.region
      readonly property var entry: ({ id: slot.moduleName })
      readonly property var activeItem: slot.activeItem
      readonly property string pluginApiId: slot.moduleName
      readonly property bool hovered: false
      readonly property bool dragSource: false
      readonly property bool panelOpen: false

      Component.onCompleted: root.addSlot(proxy)
      Component.onDestruction: root.removeSlot(proxy)
    }
  }

  function addSlot(proxy) {
    if (!bar || slotItems.indexOf(proxy) !== -1) return
    var next = slotItems.slice()
    next.push(proxy)
    slotItems = next
    bar.registerModuleSlot(proxy)
  }

  function removeSlot(proxy) {
    slotItems = slotItems.filter(function(s) { return s !== proxy })
    if (bar) bar.unregisterModuleSlot(proxy)
  }
}
