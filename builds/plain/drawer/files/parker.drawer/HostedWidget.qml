import QtQuick
import qs.Commons

// One widget inside the drawer: the same component the bar would use, from the
// host's widget catalogue, injected with `bar` / `moduleName` / `settings` the
// way the bar injects them.
Item {
  id: slot

  required property var entry
  property var settingsValue: ({})
  property var registry: null      // detached widget catalogue
  property QtObject hostBar: null  // HostBar proxy

  readonly property string moduleName: entry ? Util.canonicalWidgetId(entry.id) : ""
  readonly property bool commandModule: !!entry && String(entry.type || "") === "command"
  readonly property var registryComponent: {
    var widgets = registry ? registry.widgets : null
    if (!widgets || commandModule || !widgets[moduleName]) return null
    return widgets[moduleName].component || null
  }
  // The catalogue has loaded but holds no widget with this id.
  readonly property bool missing: !!registry && !commandModule && registryComponent === null
  readonly property var activeItem: commandModule ? commandLoader.item : widgetLoader.item
  readonly property bool vertical: hostBar ? hostBar.vertical === true : false

  implicitWidth: {
    if (missing) return missingLabel.implicitWidth + 16
    if (!activeItem || !activeItem.visible) return 0
    return vertical && hostBar ? hostBar.barSize : activeItem.implicitWidth
  }
  implicitHeight: {
    if (missing) return missingLabel.implicitHeight + 12
    if (!activeItem || !activeItem.visible) return 0
    return activeItem.implicitHeight
  }
  width: implicitWidth
  height: implicitHeight

  function injectProps() {
    var item = activeItem
    if (!item) return
    if ("bar" in item) item.bar = hostBar
    if ("moduleName" in item) item.moduleName = moduleName
    if ("settings" in item) item.settings = settingsValue
  }

  onActiveItemChanged: injectProps()
  onSettingsValueChanged: injectProps()
  onHostBarChanged: injectProps()

  Loader {
    id: widgetLoader
    anchors.fill: parent
    active: slot.registryComponent !== null
    sourceComponent: slot.registryComponent
    onLoaded: slot.injectProps()
  }

  Loader {
    id: commandLoader
    anchors.fill: parent
    active: slot.commandModule
    sourceComponent: CommandModule { }
    onLoaded: slot.injectProps()
  }

  // Shown for an id the catalogue does not know (typo, or a third-party widget
  // that is not installed and enabled).
  Text {
    id: missingLabel
    visible: slot.missing
    anchors.centerIn: parent
    text: slot.moduleName + "?"
    color: Color.foreground
    opacity: 0.5
    font.family: slot.hostBar ? slot.hostBar.fontFamily : ""
    font.pixelSize: Style.font.body
  }
}
