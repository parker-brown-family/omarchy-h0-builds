import QtQuick
import qs.Commons

// The `bar` handed to widgets hosted inside the drawer. It mirrors the bar
// surface widgets expect (colors, geometry, tooltips, popout coordination,
// click targets) but scopes everything to this drawer, and its `shell` only
// forwards to the drawer plugin's own scoped shell — hosting a widget here
// never grants it more than the drawer itself was given.
QtObject {
  id: api

  // The drawer button (Widget.qml) that owns this surface.
  property var host: null
  // The bar facade the host bar injected into the drawer button.
  property var hostBar: null

  readonly property var hostShell: hostBar ? hostBar.shell : null

  // Hosted widgets sit on an opaque card, so they always use the theme's bar
  // text color rather than the wallpaper-derived transparent-bar color.
  readonly property color foreground: hostBar ? hostBar.foreground : Color.bar.text
  readonly property color barForeground: foreground
  readonly property color background: Color.bar.background
  readonly property color urgent: hostBar ? hostBar.urgent : Color.bar.active
  readonly property string fontFamily: hostBar && hostBar.fontFamily ? hostBar.fontFamily : Style.font.family
  readonly property string position: hostBar ? String(hostBar.position || "top") : "top"
  readonly property bool vertical: position === "left" || position === "right"
  readonly property int barSize: hostBar && hostBar.barSize > 0
    ? hostBar.barSize : (vertical ? Style.bar.sizeVertical : Style.bar.sizeHorizontal)
  readonly property bool transparent: false
  readonly property bool foregroundAnimationEnabled: hostBar ? hostBar.foregroundAnimationEnabled !== false : true
  readonly property bool barHidden: false
  // Indicators reveal their inactive items while the bar's center is hovered;
  // inside an open drawer they should simply be shown.
  readonly property bool centerSectionRevealHeld: true
  property bool centerHoverRevealSuppressed: false
  readonly property var layoutConfig: hostBar && hostBar.layoutConfig ? hostBar.layoutConfig : ({})

  property var activePopout: null
  property var clickTargets: []

  function run(command) {
    if (hostBar && command) hostBar.run(String(command))
  }

  function shellQuote(value) {
    return Util.shellQuote(value)
  }

  function showTooltip(target, text) {
    if (host) host.showTooltip(target, String(text || ""))
  }

  function hideTooltip(target) {
    if (host) host.hideTooltip(target)
  }

  function registerClickTarget(target) {
    if (!target || clickTargets.indexOf(target) !== -1) return
    var next = clickTargets.slice()
    next.push(target)
    clickTargets = next
  }

  function unregisterClickTarget(target) {
    clickTargets = clickTargets.filter(function(item) { return item !== target })
  }

  // One hosted popup at a time, mirroring the bar's coordinator.
  function requestPopout(owner) {
    if (activePopout === owner) return
    var previous = activePopout
    activePopout = owner
    if (previous) {
      if ("closeForPopoutSwitch" in previous) previous.closeForPopoutSwitch()
      else if ("close" in previous) previous.close()
    }
  }

  function releasePopout(owner) {
    if (activePopout === owner) activePopout = null
  }

  function closeActivePopout() {
    var owner = activePopout
    if (owner && "close" in owner) owner.close()
    activePopout = null
  }

  function switchPanelFrom(owner, direction) {
    return host ? host.switchHostedPanel(owner, direction) : false
  }

  function targetWindow(target) {
    return target && target.QsWindow ? target.QsWindow.window : null
  }

  function targetBelongsToWindow(target, window) {
    return !!target && !!window && targetWindow(target) === window
  }

  function moduleWidgets(id) {
    return host ? host.allHostedItems(String(id || "")) : []
  }

  function setCenterHoverRevealSuppressed(value) {
    centerHoverRevealSuppressed = !!value
  }

  readonly property QtObject shell: QtObject {
    readonly property var bar: api.hostShell ? api.hostShell.bar : null
    readonly property var barConfig: api.hostShell ? api.hostShell.barConfig : ({})

    function serviceFor(id) {
      return null
    }

    function firstPartyServiceFor(id) {
      return api.hostShell && typeof api.hostShell.firstPartyServiceFor === "function"
        ? api.hostShell.firstPartyServiceFor(String(id || "")) : null
    }

    function summon(id, payloadJson) {
      return api.hostShell ? api.hostShell.summon(id, payloadJson) : false
    }

    function hide(id) {
      return api.hostShell ? api.hostShell.hide(id) : false
    }

    function toggle(id, payloadJson) {
      return api.hostShell ? api.hostShell.toggle(id, payloadJson) : false
    }

    function isPluginOpen(id) {
      return api.hostShell ? api.hostShell.isPluginOpen(id) : false
    }

    // Hosted widgets persist their own state (clock format, power percentage,
    // ...) here; the drawer writes it back into its own `items` entry.
    function updateEntryInline(id, settings) {
      return api.host ? api.host.updateHostedEntry(String(id || ""), settings) : false
    }

    function mutateShellConfig(mutator) {
      return false
    }
  }
}
