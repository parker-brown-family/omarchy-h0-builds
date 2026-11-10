import QtQuick
import Quickshell
import Quickshell.Hyprland
import "DrawerModel.js" as DrawerModel

// Full-bar plugin that wraps the stock Omarchy bar instead of copying it.
//
// The stock Bar.qml is loaded unmodified from $OMARCHY_PATH, so bar updates
// keep flowing in. This wrapper only:
//   - hides widgets listed in a drawer's `items` from the visible layout,
//   - registers the drawer button (DrawerButton.qml) with the bar so it is
//     handed the live bar object and the widget catalogue, which a plain
//     third-party bar widget never receives,
//   - routes shell IPC (summon/hide/toggle) for tucked widgets into the drawer.
Item {
  id: root

  // Injected by the omarchy-shell host (see shell.qml configureBar()).
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null
  property var barWidgetRegistry: null
  property var pluginRegistry: null
  property var barConfig: ({})

  readonly property string drawerId: manifest && manifest.id ? String(manifest.id) : "parker.drawer"
  readonly property string upstreamBarUrl: "file://" + (omarchyPath || "/usr/share/omarchy") + "/shell/plugins/bar/Bar.qml"
  readonly property var innerBar: barLoader.item

  // Unfiltered layout, read by drawer buttons to find tucked entries' settings.
  readonly property var fullLayout: barConfig && barConfig.layout ? barConfig.layout : ({})
  readonly property var tucked: DrawerModel.tuckedIds(fullLayout, drawerId)
  readonly property var innerBarConfig: DrawerModel.filteredBarConfig(barConfig, drawerId)

  // Scalar state the host reads straight off shell.bar.
  readonly property bool barHidden: innerBar ? innerBar.barHidden === true : false
  readonly property int barSize: innerBar ? innerBar.barSize : 0
  readonly property string fontFamily: innerBar ? String(innerBar.fontFamily || "") : ""
  readonly property string position: innerBar ? String(innerBar.position || "top") : "top"

  // Live drawer buttons (one per monitor), registered by DrawerButton.qml.
  property var drawers: []

  function registerDrawer(drawer) {
    if (!drawer || drawers.indexOf(drawer) !== -1) return
    var next = drawers.slice()
    next.push(drawer)
    drawers = next
  }

  function unregisterDrawer(drawer) {
    drawers = drawers.filter(function(d) { return d !== drawer })
  }

  // Widget catalogue handed to the stock bar: the host snapshot plus the
  // drawer button, flagged first-party so the bar injects itself as `bar`.
  QtObject {
    id: drawerRegistry

    readonly property var drawerHost: root
    readonly property int revision: root.barWidgetRegistry ? root.barWidgetRegistry.revision : 0
    readonly property var widgets: {
      var source = root.barWidgetRegistry ? root.barWidgetRegistry.widgets : null
      var next = ({})
      if (source) for (var id in source) next[id] = source[id]
      var base = next[root.drawerId] && next[root.drawerId].metadata ? next[root.drawerId].metadata : ({})
      var meta = ({})
      for (var key in base) meta[key] = base[key]
      meta.firstParty = true
      meta.displayName = meta.displayName || "Drawer"
      next[root.drawerId] = { component: drawerButtonComponent, metadata: meta }
      return next
    }

    function metadataFor(id) {
      var entry = widgets[String(id || "")]
      return entry ? entry.metadata : null
    }

    function availableIds() { return Object.keys(widgets) }
    function has(id) { return widgets[String(id || "")] !== undefined }
  }

  Component {
    id: drawerButtonComponent
    DrawerButton { }
  }

  Loader {
    id: barLoader
    source: root.upstreamBarUrl

    onLoaded: {
      item.omarchyPath = Qt.binding(function() { return root.omarchyPath })
      item.manifest = Qt.binding(function() { return root.manifest })
      item.pluginRegistry = Qt.binding(function() { return root.pluginRegistry })
      item.shell = Qt.binding(function() { return root.shell })
      item.barWidgetRegistry = drawerRegistry
      item.barConfig = Qt.binding(function() { return root.innerBarConfig })
    }

    onStatusChanged: {
      if (status !== Loader.Error) return
      // Without the stock bar there is no bar at all. Hand control back to
      // the built-in bar rather than leave the user with an empty screen.
      console.warn("parker.drawer: could not load " + root.upstreamBarUrl + "; switching back to omarchy.bar")
      if (root.shell && typeof root.shell.mutateShellConfig === "function") {
        root.shell.mutateShellConfig(function(config) {
          if (config.bar && typeof config.bar === "object") config.bar.id = "omarchy.bar"
        })
      }
      Quickshell.execDetached(["notify-send", "Bar drawer",
        "Could not load the stock bar, switched back to omarchy.bar. See the shell log."])
    }
  }

  // ---------------------------------------------------------- host surface

  function isTucked(id) {
    return root.tucked.indexOf(String(id || "")) !== -1
  }

  function focusedDrawerFor(id) {
    var monitor = Hyprland.focusedMonitor
    var screenName = monitor ? String(monitor.name || "") : ""
    var fallback = null
    for (var i = 0; i < drawers.length; i++) {
      var drawer = drawers[i]
      if (!drawer || !drawer.hostsWidget(id)) continue
      if (!fallback) fallback = drawer
      if (screenName && drawer.screenName() === screenName) return drawer
    }
    return fallback
  }

  function summonBarWidget(id) {
    if (isTucked(id)) {
      var drawer = focusedDrawerFor(id)
      return drawer ? drawer.summonWidget(String(id)) : false
    }
    return innerBar ? innerBar.summonBarWidget(id) : false
  }

  function hideBarWidget(id) {
    if (isTucked(id)) {
      var hidden = false
      for (var i = 0; i < drawers.length; i++) if (drawers[i].hideWidget(String(id))) hidden = true
      return hidden
    }
    return innerBar ? innerBar.hideBarWidget(id) : false
  }

  function isBarWidgetOpen(id) {
    if (isTucked(id)) {
      for (var i = 0; i < drawers.length; i++) if (drawers[i].widgetOpen(String(id))) return true
      return false
    }
    return innerBar ? innerBar.isBarWidgetOpen(id) : false
  }

  function panelWidgetIdAt(section, index) {
    return innerBar ? innerBar.panelWidgetIdAt(section, index) : ""
  }

  function toggleTransparency() {
    if (innerBar) innerBar.toggleTransparency()
  }

  function debugBarGeometry() {
    return innerBar ? innerBar.debugBarGeometry() : []
  }
}
