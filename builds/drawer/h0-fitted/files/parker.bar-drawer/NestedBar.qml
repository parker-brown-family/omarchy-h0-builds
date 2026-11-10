import QtQuick
import qs.Commons

// The `bar` object handed to a widget that lives inside the drawer. It mirrors
// the bar facade the drawer itself received and forwards every call to it, with
// two changes:
//   - requestPopout() tells the drawer that the request comes from one of its
//     own widgets, so the drawer stays open while that widget's panel is up;
//   - moduleWidgets() returns the drawer's live instances of the widget (the
//     host only knows widgets that sit directly in the bar).
QtObject {
  id: proxy

  property var host: null
  property var drawer: null
  property var drawerWindow: null
  property string moduleId: ""

  property color foreground: host ? host.foreground : Color.bar.text
  property color barForeground: host ? host.barForeground : Color.bar.text
  property color background: host ? host.background : Color.bar.background
  property color urgent: host ? host.urgent : Color.urgent
  property string fontFamily: host ? host.fontFamily : Style.font.family
  property string position: host ? host.position : "top"
  property bool vertical: host ? host.vertical : false
  property int barSize: host ? host.barSize : Style.bar.sizeHorizontal
  property bool transparent: false
  property bool foregroundAnimationEnabled: host ? host.foregroundAnimationEnabled !== false : true
  property bool centerSectionRevealHeld: false
  property bool centerHoverRevealSuppressed: host ? host.centerHoverRevealSuppressed === true : false
  property var shell: host ? host.shell : null
  property var activePopout: host ? host.activePopout : null
  property var clickTargets: host && host.clickTargets ? host.clickTargets : []
  property var layoutConfig: host && host.layoutConfig ? host.layoutConfig : ({})
  property var foreignPopoutMarker: host ? host.foreignPopoutMarker : null

  function run(command) { if (host) host.run(command) }
  function shellQuote(value) { return Util.shellQuote(value) }
  function showTooltip(target, text) { if (host) host.showTooltip(target, text) }
  function hideTooltip(target) { if (host) host.hideTooltip(target) }
  function registerClickTarget(target) { if (host && host.registerClickTarget) host.registerClickTarget(target) }
  function unregisterClickTarget(target) { if (host && host.unregisterClickTarget) host.unregisterClickTarget(target) }

  function requestPopout(owner) {
    if (!host) return
    if (drawer) drawer.beginNestedPopout(owner)
    host.requestPopout(owner)
    if (drawer) drawer.endNestedPopout()
  }

  function releasePopout(owner) { if (host) host.releasePopout(owner) }
  function switchPanelFrom(owner, direction) { return false }

  function targetBelongsToWindow(target, window) {
    return host && host.targetBelongsToWindow ? host.targetBelongsToWindow(target, window) : false
  }

  function moduleWidgets(id) {
    if (String(id || "") !== moduleId || !drawerWindow) return []
    return drawerWindow.widgetsFor(moduleId)
  }

  function setCenterHoverRevealSuppressed(value) {
    if (host && host.setCenterHoverRevealSuppressed) host.setCenterHoverRevealSuppressed(value)
  }
}
