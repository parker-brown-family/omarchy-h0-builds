import QtQuick

// The `bar` handed to widgets living in the drawer. Mirrors the bar facade
// the drawer itself received (same members widgets use: colours, font, size,
// tooltips, run, popouts) and forwards to it, with three differences:
//  - Popout requests go through the drawer first, so a tucked widget opening
//    its own panel does not fold away the drawer that panel is anchored to.
//  - Click targets are not registered with the bar. The bar dispatches clicks
//    on its own slots by mapping into registered targets regardless of which
//    window they live in, so a target in the drawer could catch a click meant
//    for the bar. Tucked widgets handle their own clicks.
//  - Tab-to-next-panel does not apply inside the drawer.
QtObject {
  id: proxy

  // The drawer widget's own bar facade, and the drawer widget.
  property var target: null
  property var host: null

  readonly property var shell: target ? target.shell : null
  readonly property color foreground: target ? target.foreground : "transparent"
  readonly property color barForeground: target ? target.barForeground : "transparent"
  readonly property color background: target ? target.background : "transparent"
  readonly property color urgent: target ? target.urgent : "transparent"
  readonly property string fontFamily: target ? String(target.fontFamily || "") : ""
  readonly property string position: target ? String(target.position || "top") : "top"
  readonly property bool vertical: target ? target.vertical === true : false
  readonly property int barSize: target ? target.barSize : 0
  readonly property bool transparent: target ? target.transparent === true : false
  readonly property bool foregroundAnimationEnabled: target ? target.foregroundAnimationEnabled !== false : true
  readonly property bool centerSectionRevealHeld: target ? target.centerSectionRevealHeld === true : false
  readonly property bool centerHoverRevealSuppressed: target ? target.centerHoverRevealSuppressed === true : false
  readonly property var activePopout: target ? target.activePopout : null
  readonly property var clickTargets: []
  readonly property var layoutConfig: target ? target.layoutConfig : ({})
  readonly property var foreignPopoutMarker: target ? target.foreignPopoutMarker : ({ foreign: true })

  function setCenterHoverRevealSuppressed(value) { }

  function showTooltip(item, text) {
    if (target) target.showTooltip(item, text)
  }

  function hideTooltip(item) {
    if (target) target.hideTooltip(item)
  }

  function registerClickTarget(item) { }
  function unregisterClickTarget(item) { }

  function requestPopout(owner) {
    if (host) host.hostedRequestPopout(owner)
  }

  function releasePopout(owner) {
    if (host) host.hostedReleasePopout(owner)
  }

  function switchPanelFrom(owner, direction) {
    return false
  }

  function targetBelongsToWindow(item, window) {
    return target ? target.targetBelongsToWindow(item, window) : false
  }

  function moduleWidgets(id) {
    return []
  }

  function run(command) {
    if (target) target.run(command)
  }
}
