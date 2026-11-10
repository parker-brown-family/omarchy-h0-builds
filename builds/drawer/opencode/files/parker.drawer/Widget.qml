import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// Drawer button for the bar. Clicking it opens a card next to the bar that
// hosts the widgets listed in this entry's `items` setting in shell.json:
//
//   { "id": "parker.drawer", "items": ["omarchy.weather", { "id": "omarchy.clock", "format": "HH:mm" }] }
//
// The drawer surfaces (Drawer.qml) load the first time the drawer opens, so
// the button itself never creates a window. From then on hosted widgets stay
// mounted while the drawer is closed, keeping their state and timers.
BarWidget {
  id: root

  // Bar-shaped popup contract: lets `omarchy-shell shell toggle parker.drawer`
  // and the numbered panel hotkeys open the drawer, and lets the bar's
  // one-popup-at-a-time coordinator close it when another panel opens.
  readonly property bool opened: drawerOpen
  property bool drawerOpen: false

  property QtObject service: null
  readonly property var registry: service ? service.barWidgetRegistry : null

  readonly property var barWindow: root.QsWindow.window
  readonly property string screenName: barWindow && barWindow.screen ? String(barWindow.screen.name || "") : ""
  readonly property string position: bar ? String(bar.position || "top") : "top"
  readonly property real barThickness: barWindow
    ? (vertical ? barWindow.width : barWindow.height)
    : barSize
  readonly property int gap: Style.gapsOut
  readonly property int margin: Style.gapsOut

  readonly property var configuredItems: Array.isArray(settings.items) ? settings.items : []

  // Only the identity of the hosted list drives the Repeater: settings edits
  // (a clock format cycling, say) patch the live widgets instead of rebuilding
  // them, because an unchanged string property does not notify.
  readonly property string hostedKey: JSON.stringify(computeHostedEntries())
  readonly property var hostedEntries: JSON.parse(hostedKey)

  property var hostedSlots: []
  property var openAfterShow: null

  property var tooltipTarget: null
  property string tooltipText: ""
  property bool tooltipShown: false
  property bool focusPrimed: false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // ------------------------------------------------------------- lifecycle

  function open() {
    if (drawerOpen) return
    mountDrawer()
    drawerOpen = true
    if (bar) bar.requestPopout(root)
  }

  function close() {
    if (!drawerOpen) return
    drawerBar.closeActivePopout()
    clearTooltip()
    openAfterShow = null
    drawerOpen = false
    if (bar) bar.releasePopout(root)
  }

  function closeForPopoutSwitch() { close() }

  function toggle() { drawerOpen ? close() : open() }

  onDrawerOpenChanged: {
    focusPrimeTimer.stop()
    focusPrimed = false
    if (drawerOpen) {
      focusPrimeTimer.start()
    }
  }

  // ------------------------------------------------------- service lookup

  function lookupService() {
    if (service || !bar || !bar.shell || typeof bar.shell.serviceFor !== "function") return
    var found = bar.shell.serviceFor(root.moduleName)
    if (!found) return
    service = found
    if (typeof found.registerHost === "function") found.registerHost(root)
  }

  onBarChanged: lookupService()
  onModuleNameChanged: lookupService()
  Component.onCompleted: lookupService()
  Component.onDestruction: {
    if (service && typeof service.unregisterHost === "function") service.unregisterHost(root)
    if (bar) bar.releasePopout(root)
  }

  // The service is created alongside this widget and may land a moment later.
  Timer {
    interval: 250
    repeat: true
    running: !root.service && root.moduleName !== ""
    onTriggered: root.lookupService()
  }

  // --------------------------------------------------------- hosted items

  function entryId(entry) {
    if (typeof entry === "string") return entry
    if (Util.isPlainObject(entry) && entry.id !== undefined && entry.id !== null) return String(entry.id)
    return ""
  }

  function entrySettings(entry) {
    var copy = {}
    if (!Util.isPlainObject(entry)) return copy
    for (var key in entry) if (key !== "id") copy[key] = entry[key]
    return copy
  }

  function inBarLayout(id) {
    var layout = bar && bar.layoutConfig ? bar.layoutConfig : null
    if (!Util.isPlainObject(layout)) return false
    var sections = ["left", "center", "right"]
    for (var s = 0; s < sections.length; s++) {
      var entries = layout[sections[s]]
      if (!Array.isArray(entries)) continue
      for (var i = 0; i < entries.length; i++)
        if (Util.canonicalWidgetId(entryId(entries[i])) === id) return true
    }
    return false
  }

  function allowsMultiple(id) {
    var metadata = registry && typeof registry.metadataFor === "function" ? registry.metadataFor(id) : null
    return !!metadata && metadata.allowMultiple === true
  }

  function computeHostedEntries() {
    var out = []
    var seen = {}
    for (var i = 0; i < configuredItems.length; i++) {
      var id = Util.canonicalWidgetId(entryId(configuredItems[i]))
      if (!id || id === root.moduleName) continue
      var multiple = allowsMultiple(id)
      // A second live copy of a single-instance widget would register its IPC
      // target twice, so a widget still on the bar stays on the bar.
      if (!multiple && (seen[id] || inBarLayout(id))) continue
      seen[id] = true
      out.push({ id: id, index: i })
    }
    return out
  }

  function registerSlot(slot) {
    if (!slot || hostedSlots.indexOf(slot) !== -1) return
    var next = hostedSlots.slice()
    next.push(slot)
    hostedSlots = next
  }

  function unregisterSlot(slot) {
    hostedSlots = hostedSlots.filter(function(item) { return item !== slot })
  }

  function orderedSlots() {
    return hostedSlots.slice().sort(function(a, b) { return a.order - b.order })
  }

  function hostedItems(id) {
    var out = []
    for (var i = 0; i < hostedSlots.length; i++) {
      var slot = hostedSlots[i]
      if (slot && slot.activeItem && slot.moduleName === id) out.push(slot.activeItem)
    }
    return out
  }

  function allHostedItems(id) {
    return service && typeof service.hostedWidgets === "function" ? service.hostedWidgets(id) : hostedItems(id)
  }

  function isPanelItem(item) {
    return !!item && typeof item.open === "function" && typeof item.close === "function" && item.opened !== undefined
  }

  function switchHostedPanel(owner, direction) {
    var panels = orderedSlots().filter(function(slot) {
      return slot.activeItem && slot.activeItem.visible && slot.width > 0 && slot.height > 0 && root.isPanelItem(slot.activeItem)
    })
    if (panels.length < 2) return false
    var current = -1
    for (var i = 0; i < panels.length; i++) if (panels[i].activeItem === owner) current = i
    if (current < 0) return false
    var next = panels[(current + (direction < 0 ? -1 : 1) + panels.length) % panels.length]
    next.activeItem.open()
    return true
  }

  // Hotkey bridge: `omarchy-shell parker.drawer togglePanel omarchy.bluetooth`.
  function firstHostedPanel(key) {
    var items = hostedItems(key).filter(isPanelItem)
    return items.length > 0 ? items[0] : null
  }

  function toggleHostedPanel(id) {
    var key = Util.canonicalWidgetId(String(id || ""))
    var item = firstHostedPanel(key)
    if (drawerOpen && item) {
      if (item.opened === true) close()
      else item.open()
      return
    }
    if (drawerOpen) {
      console.warn("parker.drawer: no hosted panel widget for", key)
      return
    }
    open()
    // The drawer surface has to be mounted and mapped before a hosted panel
    // exists and can measure its position against it.
    openAfterShow = key
    openAfterShowTimer.restart()
  }

  Timer {
    id: openAfterShowTimer
    interval: 60
    onTriggered: {
      var key = root.openAfterShow
      root.openAfterShow = null
      if (!root.drawerOpen || !key) return
      var item = root.firstHostedPanel(key)
      if (item) item.open()
      else console.warn("parker.drawer: no hosted panel widget for", key)
    }
  }

  function updateHostedEntry(id, settings) {
    var key = Util.canonicalWidgetId(id)
    var items = configuredItems.slice()
    var index = -1
    for (var i = 0; i < items.length; i++) {
      if (Util.canonicalWidgetId(entryId(items[i])) === key) { index = i; break }
    }
    if (index < 0 || !bar || !bar.shell || typeof bar.shell.updateEntryInline !== "function") return false

    var entry = { id: key }
    for (var k in settings) if (k !== "id") entry[k] = settings[k]
    items[index] = entry

    var own = entrySettings(root.settings)
    own.items = items
    return bar.shell.updateEntryInline(root.moduleName, own)
  }

  // ---------------------------------------------------------------- tooltip

  function clearTooltip() {
    tooltipTimer.stop()
    tooltipTarget = null
    tooltipText = ""
    tooltipShown = false
  }

  function showTooltip(target, text) {
    clearTooltip()
    if (!target || !text) return
    tooltipTarget = target
    tooltipText = text
    tooltipTimer.restart()
  }

  function hideTooltip(target) {
    if (tooltipTarget === target) clearTooltip()
  }

  function tooltipHovered(target) {
    return !!target && target.visible !== false && target.opacity !== 0 && target.tooltipHovered === true
  }

  Timer {
    id: tooltipTimer
    interval: 400
    onTriggered: {
      if (root.tooltipHovered(root.tooltipTarget)) root.tooltipShown = true
      else root.clearTooltip()
    }
  }

  Timer {
    interval: 100
    repeat: true
    running: root.tooltipShown
    onTriggered: if (!root.tooltipHovered(root.tooltipTarget)) root.clearTooltip()
  }

  Timer {
    id: focusPrimeTimer
    interval: 75
    onTriggered: if (root.drawerOpen) root.focusPrimed = true
  }

  // ----------------------------------------------------------------- button

  DrawerBar {
    id: drawerBar
    host: root
    hostBar: root.bar
  }

  function defaultIcon() {
    // Material Design chevrons from the Nerd Font, pointing toward the drawer.
    if (position === "bottom") return String.fromCodePoint(0xF0143)
    if (position === "left") return String.fromCodePoint(0xF0142)
    if (position === "right") return String.fromCodePoint(0xF0141)
    return String.fromCodePoint(0xF0140)
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: String(root.setting("icon", "")) || root.defaultIcon()
    textRotation: root.drawerOpen && !String(root.setting("icon", "")) ? 180 : 0
    tooltipText: root.drawerOpen ? "" : "Drawer"

    onPressed: function(mouseButton) {
      if (mouseButton === Qt.LeftButton || mouseButton === Qt.MiddleButton) root.toggle()
    }
  }

  // ----------------------------------------------------------------- drawer

  function mountDrawer() {
    if (drawerLoader.status !== Loader.Null) return
    drawerLoader.setSource(Qt.resolvedUrl("Drawer.qml"), { host: root, api: drawerBar })
  }

  Loader {
    id: drawerLoader
    onStatusChanged: {
      if (status === Loader.Error) console.warn("parker.drawer: drawer surfaces failed to load")
    }
  }
}
