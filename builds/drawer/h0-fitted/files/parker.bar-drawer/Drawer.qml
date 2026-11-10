import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Bar drawer: a button that opens a panel holding the widgets listed in this
// entry's `items` in ~/.config/omarchy/shell.json, e.g.
//
//   { "id": "parker.bar-drawer",
//     "items": [ "omarchy.weather", { "id": "omarchy.clock", "format": "HH:mm" } ] }
//
// Each item is a widget id, or an object with an id plus that widget's usual
// settings. Move a widget's entry out of bar.layout when you tuck it away, so
// it is not shown twice.
BarWidget {
  id: root

  readonly property string pluginId: "parker.bar-drawer"

  property bool opened: false
  property bool everOpened: false
  property bool engaged: false
  property bool nestedRequestPending: false
  property var nestedOwner: null

  // id -> entry-point URL for every bar widget installed (built-in and user).
  property var catalog: ({})
  property bool catalogReady: false
  property var warned: ({})

  readonly property string barPos: bar ? String(bar.position || "top") : "top"
  readonly property bool autoClose: setting("autoClose", true) !== false
  readonly property int autoCloseDelay: Math.max(200, Number(setting("autoCloseDelay", 900)) || 900)

  // `items` normalised to [{ id, settings }], first occurrence of an id wins.
  readonly property var itemEntries: {
    var raw = setting("items", [])
    var list = Array.isArray(raw) ? raw : []
    var seen = ({})
    var out = []
    for (var i = 0; i < list.length; i++) {
      var item = list[i]
      var id = typeof item === "string" ? item : (Util.isPlainObject(item) ? String(item.id || "") : "")
      if (!id || seen[id]) continue
      if (id === root.pluginId || id === root.moduleName) continue  // no drawer inside a drawer
      seen[id] = true
      var settings = ({})
      if (Util.isPlainObject(item)) {
        for (var key in item) if (key !== "id") settings[key] = item[key]
      }
      out.push({ id: id, settings: settings })
    }
    return out
  }

  readonly property var resolvedEntries: {
    var out = []
    if (!catalogReady) return out
    for (var i = 0; i < itemEntries.length; i++) {
      var url = catalog[itemEntries[i].id]
      if (url) out.push({ id: itemEntries[i].id, settings: itemEntries[i].settings, url: url })
    }
    return out
  }

  readonly property bool pointerInside: buttonHover.hovered
    || (windowLoader.item !== null && windowLoader.item.hovered === true)

  readonly property bool nestedActive: {
    if (!bar || !opened) return false
    var active = bar.activePopout
    return !!active && active !== root && ownsPopout(active)
  }

  function chevron() {
    var custom = String(setting("icon", "") || "")
    if (custom) return custom
    if (barPos === "bottom") return opened ? "\uf078" : "\uf077"
    if (barPos === "left") return opened ? "\uf053" : "\uf054"
    if (barPos === "right") return opened ? "\uf054" : "\uf053"
    return opened ? "\uf077" : "\uf078"
  }

  // ---- open / close, and the bar's one-popup-at-a-time coordinator --------

  function open() {
    if (opened) return
    everOpened = true
    engaged = pointerInside
    opened = true
    if (bar) bar.requestPopout(root)
  }

  function close() {
    if (!opened) return
    opened = false
    engaged = false
    var widgets = windowLoader.item ? windowLoader.item.allWidgets() : []
    for (var i = 0; i < widgets.length; i++) {
      var w = widgets[i]
      if (w && w.opened === true && typeof w.close === "function") w.close()
    }
    nestedOwner = null
    if (bar && bar.activePopout === root) bar.releasePopout(root)
  }

  function toggle() { opened ? close() : open() }

  // Called by the bar when another popup takes over. A tucked widget opening
  // its own panel is not "another popup": keep the drawer up underneath it.
  function closeForPopoutSwitch() {
    if (nestedRequestPending) return
    close()
  }

  function beginNestedPopout(owner) {
    nestedRequestPending = true
    nestedOwner = owner
  }

  function endNestedPopout() {
    nestedRequestPending = false
  }

  // True for this drawer, and for popups that belong to one of its widgets.
  function ownsPopout(target) {
    if (!target) return false
    if (target === root || target === nestedOwner) return true
    var content = windowLoader.item ? windowLoader.item.contentRoot : null
    if (!content) return false
    var node = target
    for (var depth = 0; node && depth < 64; depth++) {
      if (node === content) return true
      node = (node.anchorItem !== undefined && node.anchorItem) ? node.anchorItem
        : (node.parent !== undefined ? node.parent : null)
    }
    return false
  }

  Connections {
    target: root.bar
    ignoreUnknownSignals: true

    function onActivePopoutChanged() {
      if (!root.opened || !root.bar) return
      var active = root.bar.activePopout
      if (!active) {
        // A tucked widget closed its panel: take the coordinator back so the
        // bar keeps showing the drawer as the open popup.
        Qt.callLater(function() {
          if (root.opened && root.bar && !root.bar.activePopout) root.bar.requestPopout(root)
        })
      } else if (!root.nestedRequestPending && !root.ownsPopout(active)) {
        root.close()
      }
    }
  }

  onPointerInsideChanged: if (pointerInside && opened) engaged = true

  // Close after the pointer has been in the drawer and left it, unless one of
  // the tucked widgets has its own panel open. A drawer opened by keyboard or
  // IPC stays until toggled.
  Timer {
    interval: root.autoCloseDelay
    running: root.opened && root.autoClose && root.engaged && !root.pointerInside && !root.nestedActive
    onTriggered: root.close()
  }

  // ---- widget catalogue ----------------------------------------------------

  readonly property string omarchyPath: Quickshell.env("OMARCHY_PATH") || "/usr/share/omarchy"
  readonly property string configHome: Quickshell.env("XDG_CONFIG_HOME") || ((Quickshell.env("HOME") || "") + "/.config")

  function parseCatalog(text) {
    var next = ({})
    var records = String(text || "").split("\x1e")
    for (var i = 0; i < records.length; i++) {
      var sep = records[i].indexOf("\x1f")
      if (sep <= 0) continue
      var path = records[i].slice(0, sep)
      var manifest = null
      try { manifest = JSON.parse(records[i].slice(sep + 1)) } catch (e) { continue }
      if (!Util.isPlainObject(manifest) || !manifest.id) continue
      if (!Array.isArray(manifest.kinds) || manifest.kinds.indexOf("bar-widget") === -1) continue
      var ep = manifest.entryPoints ? manifest.entryPoints.barWidget : ""
      if (typeof ep !== "string" || !ep || ep.charAt(0) === "/" || ep.indexOf("..") !== -1) continue
      var dir = path.slice(0, path.lastIndexOf("/"))
      next[String(manifest.id)] = Util.fileUrl(dir + "/" + ep)
    }
    delete next[root.pluginId]
    catalog = next
    catalogReady = true
    reportProblems()
  }

  function reportProblems() {
    if (!catalogReady) return
    var onBar = ({})
    var layout = bar && bar.layoutConfig ? bar.layoutConfig : ({})
    var sections = ["left", "center", "right"]
    for (var s = 0; s < sections.length; s++) {
      var list = Array.isArray(layout[sections[s]]) ? layout[sections[s]] : []
      for (var j = 0; j < list.length; j++) {
        var id = typeof list[j] === "string" ? list[j] : (list[j] && list[j].id)
        if (id) onBar[id] = true
      }
    }
    var nextWarned = Object.assign({}, warned)
    for (var i = 0; i < itemEntries.length; i++) {
      var itemId = itemEntries[i].id
      var problem = !catalog[itemId] ? "unknown widget id"
        : (onBar[itemId] ? "also placed in bar.layout, so it shows twice" : "")
      var key = itemId + ":" + problem
      if (problem && !nextWarned[key]) {
        console.warn("parker.bar-drawer: " + itemId + ": " + problem)
        nextWarned[key] = true
      }
    }
    warned = nextWarned
  }

  function rescan() {
    if (scanProcess.running) return
    scanProcess.command = ["bash", "-c",
      "emit() { printf '\\036%s\\037' \"$1\"; cat -- \"$1\" 2>/dev/null; }; " +
      "[ -d \"$1\" ] && find \"$1\" -mindepth 2 -maxdepth 3 -type f \\( -name manifest.json -o -name '*.manifest.json' \\) | sort | while IFS= read -r m; do emit \"$m\"; done; " +
      "[ -d \"$2\" ] && find \"$2\" -mindepth 2 -maxdepth 2 -type f -name manifest.json | sort | while IFS= read -r m; do emit \"$m\"; done; " +
      "exit 0",
      "bar-drawer-scan", omarchyPath + "/shell/plugins", configHome + "/omarchy/plugins"]
    scanProcess.running = true
  }

  Process {
    id: scanProcess
    stdout: StdioCollector {
      onStreamFinished: root.parseCatalog(text)
    }
  }

  Component.onCompleted: rescan()

  // A newly installed widget id: look again rather than wait for a reload.
  onItemEntriesChanged: {
    for (var i = 0; i < itemEntries.length; i++) {
      if (catalogReady && !catalog[itemEntries[i].id]) { rescan(); return }
    }
    reportProblems()
  }

  // ---- bar button ------------------------------------------------------------

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.chevron()
    active: root.opened
    useActiveColor: false
    tooltipText: root.opened ? "" : (root.itemEntries.length + " tucked away")

    onPressed: function(b) {
      if (b === Qt.LeftButton) root.toggle()
    }
  }

  HoverHandler { id: buttonHover }

  Loader {
    id: windowLoader
    // Loaded by URL on first open, so the layer-shell window is only compiled
    // and created once it is needed.
    active: root.everOpened
    source: root.everOpened ? Qt.resolvedUrl("DrawerWindow.qml") : ""
    onLoaded: {
      item.drawer = root
      item.anchorItem = button
      item.entries = Qt.binding(function() { return root.resolvedEntries })
    }
    onStatusChanged: if (status === Loader.Error) console.warn("parker.bar-drawer: could not load DrawerWindow.qml")
  }
}
