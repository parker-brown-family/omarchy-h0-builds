import QtQuick
import qs.Commons
import qs.Ui

// Drawer button for the bar. Clicking it opens a panel holding the widgets
// listed in this entry's "widgets" setting in shell.json:
//
//   { "id": "parker.drawer", "widgets": ["omarchy.weather", "omarchy.bluetooth"] }
//
// Items are widget ids, or full entries with inline settings, exactly like
// bar.layout entries: { "id": "omarchy.clock", "format": "HH:mm" }.
// The widgets are built once per monitor and stay alive while the drawer is
// closed, so their state keeps updating.
BarWidget {
  id: root

  readonly property string pluginId: moduleName || "parker.drawer"

  // ------------------------------------------------------------ config

  // Rebuilt only when the list of widgets changes; settings-only edits update
  // the hosted widgets in place.
  property var hostedEntries: []
  property var hostedSettings: []
  property string hostedSignature: ""

  function normalizedEntries() {
    var list = setting("widgets", [])
    // Settings arrive through a `var` property, so the list may be a
    // QVariantList (array-like, but Array.isArray() is false). A JSON round trip
    // turns it and its entries into plain JS values.
    if (!list || typeof list === "string" || typeof list.length !== "number") return []
    try {
      list = JSON.parse(JSON.stringify(list))
    } catch (error) {
      return []
    }
    if (!Array.isArray(list)) list = Object.keys(list).map(function(key) { return list[key] })
    var out = []
    for (var i = 0; i < list.length; i++) {
      var item = list[i]
      var entry = typeof item === "string" ? { id: item }
        : (item && typeof item === "object" && !Array.isArray(item) ? item : null)
      if (!entry || !entry.id) continue
      entry.id = Util.canonicalWidgetId(String(entry.id))
      if (entry.id === root.pluginId) continue   // not inside itself
      out.push(entry)
    }
    return out
  }

  function entrySettings(entry) {
    var copy = {}
    for (var key in entry) if (key !== "id") copy[key] = entry[key]
    return copy
  }

  function syncEntries() {
    var entries = normalizedEntries()
    var signature = JSON.stringify(entries.map(function(entry) {
      return [entry.id, String(entry.type || ""), String(entry.exec || "")]
    }))
    var settingsList = entries.map(entrySettings)
    if (signature !== hostedSignature) {
      hostedSignature = signature
      hostedSettings = settingsList
      hostedEntries = entries
    } else if (JSON.stringify(settingsList) !== JSON.stringify(hostedSettings)) {
      hostedSettings = settingsList
    }
  }

  onSettingsChanged: syncEntries()
  Component.onCompleted: syncEntries()

  // ------------------------------------------------- widget catalogue

  // This plugin's service holds the host's widget catalogue (see
  // DrawerService.qml). Services load asynchronously, so look until it is up.
  property var service: null
  readonly property var registry: service ? service.barWidgetRegistry : null

  function lookupService() {
    if (service) return
    var shell = bar ? bar.shell : null
    if (shell && typeof shell.serviceFor === "function") service = shell.serviceFor(pluginId) || null
  }

  Timer {
    interval: 250
    repeat: true
    running: !root.service && !!root.bar
    triggeredOnStart: true
    onTriggered: root.lookupService()
  }

  HostBar {
    id: drawerHostBar
    target: root.bar
    host: root
  }

  // ------------------------------------------------------------ popout

  property bool drawerOpen: false
  readonly property bool opened: drawerOpen
  // The tucked widget whose own panel is currently open, if any.
  property var hostedOwner: null

  function open() {
    drawerOpen = true
    if (bar && !hostedOwner && bar.activePopout !== root) bar.requestPopout(root)
  }

  // Explicit close: the button, `omarchy-shell shell hide parker.drawer`.
  function dismiss() {
    closeHostedPanel()
    drawerOpen = false
    if (bar && bar.activePopout === root) bar.releasePopout(root)
  }

  function toggle() {
    if (drawerOpen) dismiss()
    else open()
  }

  // The bar calls these when another popout takes over; the panel calls close()
  // when its outside-click grab clears. A tucked widget opening its panel
  // triggers both, and must keep the drawer open as that panel's anchor, so
  // decide once the new owner has settled.
  function close() {
    Qt.callLater(settleClose)
  }

  function closeForPopoutSwitch() {
    Qt.callLater(settleClose)
  }

  function settleClose() {
    if (drawerOpen && !hostedOwner) dismiss()
  }

  function closeHostedPanel() {
    var owner = hostedOwner
    hostedOwner = null
    if (owner && typeof owner.close === "function") owner.close()
  }

  // From HostBar: a tucked widget opens or closes its own panel.
  function hostedRequestPopout(owner) {
    hostedOwner = owner
    if (bar) bar.requestPopout(owner)
  }

  function hostedReleasePopout(owner) {
    if (bar) bar.releasePopout(owner)
    if (hostedOwner !== owner) return
    hostedOwner = null
    // Take the popout slot back so opening another bar panel still folds the
    // drawer away.
    Qt.callLater(function() {
      if (root.drawerOpen && root.bar && !root.hostedOwner && root.bar.activePopout === null)
        root.bar.requestPopout(root)
    })
  }

  Connections {
    target: root.bar
    ignoreUnknownSignals: true

    // Another bar panel opened (it shows up as a foreign marker): fold away.
    function onActivePopoutChanged() {
      if (!root.drawerOpen) return
      var popout = root.bar.activePopout
      if (popout === null || popout === root || (root.hostedOwner && popout === root.hostedOwner)) return
      root.dismiss()
    }
  }

  // ------------------------------------------------------------ visuals

  readonly property string closedIcon: {
    if (position === "bottom") return "\uf077"   // chevron-up
    if (position === "left") return "\uf054"     // chevron-right
    if (position === "right") return "\uf053"    // chevron-left
    return "\uf078"                              // chevron-down
  }
  readonly property string openIcon: {
    if (position === "bottom") return "\uf078"
    if (position === "left") return "\uf053"
    if (position === "right") return "\uf054"
    return "\uf077"
  }
  readonly property string position: bar ? String(bar.position || "top") : "top"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.drawerOpen
      ? String(root.setting("openIcon", root.openIcon))
      : String(root.setting("icon", root.closedIcon))
    slotSize: Style.bar.statusSlot
    tooltipText: root.drawerOpen ? "" : String(root.setting("tooltip", "More"))

    onPressed: function(mouseButton) {
      if (mouseButton === Qt.LeftButton || mouseButton === Qt.MiddleButton) root.toggle()
    }
  }

  // PopupCard expects a bar to coordinate with; the drawer coordinates its own
  // popout above, so this stand-in only supplies placement.
  QtObject {
    id: cardBar
    readonly property string position: root.position
    readonly property var activePopout: null
    function requestPopout(owner) { }
    function releasePopout(owner) { }
  }

  PopupCard {
    id: card

    anchorItem: button
    bar: cardBar
    owner: root
    open: root.drawerOpen
    // Hand outside-click handling to a tucked widget's panel while it is up.
    triggerMode: root.hostedOwner ? "hover" : "click"
    contentWidth: Math.max(1, Math.ceil(drawerContent.implicitWidth)) + padding * 2
      + Border.left(borderSpec) + Border.right(borderSpec)
    contentHeight: Math.max(1, Math.ceil(drawerContent.implicitHeight)) + verticalContentInset

    Item {
      id: drawerContent

      readonly property bool anyVisible: (root.vertical ? grid.implicitHeight : grid.implicitWidth) > 0

      anchors.fill: parent
      implicitWidth: anyVisible ? grid.implicitWidth : emptyLabel.implicitWidth
      implicitHeight: anyVisible ? grid.implicitHeight : emptyLabel.implicitHeight

      Grid {
        id: grid
        anchors.centerIn: parent
        columns: root.vertical ? 1 : Math.max(1, slots.count)
        rows: root.vertical ? Math.max(1, slots.count) : 1
        spacing: 0
        verticalItemAlignment: Grid.AlignVCenter
        horizontalItemAlignment: Grid.AlignHCenter

        Repeater {
          id: slots
          model: root.hostedEntries

          HostedWidget {
            required property var modelData
            required property int index

            entry: modelData
            settingsValue: root.hostedSettings[index] !== undefined ? root.hostedSettings[index] : ({})
            registry: root.registry
            hostBar: drawerHostBar
          }
        }
      }

      Text {
        id: emptyLabel
        visible: !drawerContent.anyVisible
        anchors.centerIn: parent
        text: root.hostedEntries.length === 0
          ? "Add widgets to \"widgets\" in this entry of shell.json"
          : "Nothing to show right now"
        color: Color.foreground
        opacity: 0.6
        font.family: root.bar ? root.bar.fontFamily : ""
        font.pixelSize: Style.font.body
      }
    }
  }
}
