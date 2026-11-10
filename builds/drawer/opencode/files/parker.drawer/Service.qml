import QtQuick
import Quickshell.Hyprland
import Quickshell.Io

// Shared state for every drawer button (one per monitor's bar).
//
// Bar widgets are not handed the widget catalogue, but a plugin's own service
// is: the host injects a read-only barWidgetRegistry snapshot here, and each
// drawer button looks this service up through bar.shell.serviceFor(<own id>).
QtObject {
  id: service

  property var shell: null
  property var manifest: null
  property var barWidgetRegistry: null

  readonly property string pluginId: manifest && manifest.id ? String(manifest.id) : "parker.drawer"

  // Live drawer buttons, one per bar surface.
  property var hosts: []

  function registerHost(host) {
    if (!host || hosts.indexOf(host) !== -1) return
    var next = hosts.slice()
    next.push(host)
    hosts = next
  }

  function unregisterHost(host) {
    hosts = hosts.filter(function(item) { return item && item !== host })
  }

  // Every hosted instance of a widget id across all monitors, so a hosted
  // widget's broadcast() still reaches its peers the way it does on the bar.
  function hostedWidgets(id) {
    var out = []
    for (var i = 0; i < hosts.length; i++) {
      var host = hosts[i]
      if (host && typeof host.hostedItems === "function") out = out.concat(host.hostedItems(id))
    }
    return out
  }

  // The drawer on the focused monitor, falling back to any live drawer.
  function focusedHost() {
    var monitor = Hyprland.focusedMonitor
    var name = monitor ? String(monitor.name || "") : ""
    for (var i = 0; i < hosts.length; i++) {
      if (hosts[i] && name && hosts[i].screenName === name) return hosts[i]
    }
    return hosts.length > 0 ? hosts[0] : null
  }

  // Panel hotkeys such as `omarchy-shell shell toggle omarchy.bluetooth` only
  // reach widgets mounted directly on the bar. For a widget tucked into the
  // drawer, bind the key to `omarchy-shell parker.drawer togglePanel <id>`.
  property IpcHandler ipc: IpcHandler {
    target: service.pluginId

    function toggle(): void {
      var host = service.focusedHost()
      if (host) host.toggle()
    }

    function togglePanel(id: string): void {
      var host = service.focusedHost()
      if (host) host.toggleHostedPanel(id)
    }
  }
}
