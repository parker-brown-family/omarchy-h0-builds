import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

// The drawer surfaces for one drawer button: the card that hosts the tucked
// widgets, its tooltip, and the outside-click catchers. Kept apart from the
// button so the bar widget itself never creates a window; Widget.qml loads
// this the first time the drawer opens.
Scope {
  id: drawer

  required property var host
  required property var api

  Connections {
    target: drawer.host
    function onDrawerOpenChanged() {
      if (drawer.host.drawerOpen)
        Qt.callLater(function() { if (drawer.host.drawerOpen) keyCatcher.forceActiveFocus() })
    }
  }

  Component.onCompleted: {
    if (host.drawerOpen) Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  PanelWindow {
    id: drawerWindow

    screen: host.barWindow ? host.barWindow.screen : null
    visible: host.drawerOpen || card.opacity > 0
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "parker-drawer"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: host.drawerOpen
      ? (host.focusPrimed ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.Exclusive)
      : WlrKeyboardFocus.None

    // Hug the same screen edge as the bar and span the bar, the gap, and the
    // card. Hosted panels place their popups past their window's far edge,
    // so this keeps them opening just beyond the drawer, as they would from
    // the bar. Only the card takes input; the rest is click-through.
    anchors {
      top: host.position === "top" || host.vertical
      bottom: host.position === "bottom" || host.vertical
      left: host.position === "left" || !host.vertical
      right: host.position === "right" || !host.vertical
    }

    implicitHeight: host.vertical ? 0 : Math.ceil(host.barThickness + host.gap + card.height)
    implicitWidth: host.vertical ? Math.ceil(host.barThickness + host.gap + card.width) : 0

    mask: Region { item: card }

    readonly property real spanW: screen ? screen.width : width
    readonly property real spanH: screen ? screen.height : height

    TransformWatcher {
      id: anchorWatcher
      a: host.barWindow ? host.barWindow.contentItem : null
      b: drawer.host
    }

    readonly property point anchorCenter: {
      anchorWatcher.transform
      if (!host.barWindow || !host.barWindow.contentItem) return Qt.point(spanW / 2, spanH / 2)
      return host.mapToItem(host.barWindow.contentItem, host.width / 2, host.height / 2)
    }

    BorderSurface {
      id: card

      readonly property real contentW: content.implicitWidth
      readonly property real contentH: content.implicitHeight

      x: {
        if (host.vertical) return host.position === "left" ? host.barThickness + host.gap : 0
        var desired = drawerWindow.anchorCenter.x - width / 2
        return Math.round(Util.clamp(desired, host.margin, Math.max(host.margin, drawerWindow.spanW - width - host.margin)))
      }
      y: {
        if (!host.vertical) return host.position === "bottom" ? 0 : host.barThickness + host.gap
        var desired = drawerWindow.anchorCenter.y - height / 2
        return Math.round(Util.clamp(desired, host.margin, Math.max(host.margin, drawerWindow.spanH - height - host.margin)))
      }
      width: Math.ceil(contentLeftInset + contentRightInset + contentW)
      height: Math.ceil(contentTopInset + contentBottomInset + contentH)

      color: Color.bar.background
      borderSpec: Border.surfaceSpec("popups", "border", Color.popups.border, Math.max(1, Style.space(2)))
      padding: Style.spacing.sm
      radius: Style.cornerRadius
      opacity: host.drawerOpen ? 1 : 0

      Behavior on opacity {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
      }

      // Swallow clicks that land between hosted widgets.
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
      }

      Item {
        id: keyCatcher
        focus: true
        Keys.onEscapePressed: host.close()
      }

      Item {
        id: content
        x: card.contentLeftInset
        y: card.contentTopInset

        readonly property bool empty: host.vertical ? slotGrid.implicitHeight < 1 : slotGrid.implicitWidth < 1

        implicitWidth: empty ? emptyLabel.implicitWidth + Style.space(16) : slotGrid.implicitWidth
        implicitHeight: empty ? host.barSize : slotGrid.implicitHeight

        Text {
          id: emptyLabel
          visible: content.empty
          anchors.centerIn: parent
          text: host.configuredItems.length === 0 ? "Drawer is empty" : "Nothing to show"
          color: api.foreground
          opacity: 0.6
          font.family: api.fontFamily
          font.pixelSize: Style.font.body
          rotation: host.vertical ? (host.position === "left" ? 90 : -90) : 0
        }

        Grid {
          id: slotGrid
          spacing: 0
          rows: host.vertical ? Math.max(1, host.hostedEntries.length) : 1
          columns: host.vertical ? 1 : Math.max(1, host.hostedEntries.length)

          Repeater {
            model: host.hostedEntries

            delegate: Item {
              id: slot

              required property var modelData
              required property int index

              readonly property string moduleName: modelData.id
              readonly property int order: index
              readonly property var itemSettings: host.entrySettings(host.configuredItems[modelData.index])
              readonly property var registryComponent: {
                var widgets = host.registry ? host.registry.widgets : null
                var entry = widgets ? widgets[moduleName] : null
                return entry ? entry.component : null
              }
              readonly property var activeItem: loader.item

              implicitWidth: activeItem && activeItem.visible ? (host.vertical ? host.barSize : activeItem.implicitWidth) : 0
              implicitHeight: activeItem && activeItem.visible ? activeItem.implicitHeight : 0
              width: implicitWidth
              height: implicitHeight

              function injectProps() {
                var target = activeItem
                // A deferred call can land after the Repeater rebuilt this slot.
                var surface = typeof drawer === "undefined" || !drawer ? null : drawer.api
                if (!target || !surface) return
                if ("bar" in target) target.bar = surface
                if ("moduleName" in target) target.moduleName = moduleName
                if ("settings" in target) target.settings = itemSettings
              }

              onItemSettingsChanged: injectProps()
              Component.onCompleted: host.registerSlot(slot)
              Component.onDestruction: host.unregisterSlot(slot)

              Timer {
                interval: 5000
                running: true
                onTriggered: {
                  if (!slot.registryComponent)
                    console.warn("parker.drawer: no enabled bar widget named '" + slot.moduleName + "'; check the id in shell.json")
                }
              }

              Loader {
                id: loader
                anchors.fill: parent
                active: slot.registryComponent !== null
                sourceComponent: slot.registryComponent
                onLoaded: {
                  slot.injectProps()
                  Qt.callLater(slot.injectProps)
                }
              }

              // Same open-panel mark the bar draws under a module whose
              // popup is showing, on the edge facing the popup.
              Rectangle {
                readonly property int inset: Style.space(2)
                readonly property real extent: Math.max(Style.space(10), Math.round((host.vertical ? slot.height : slot.width) * 0.55))

                visible: opacity > 0
                opacity: api.activePopout && api.activePopout === slot.activeItem ? 0.9 : 0
                color: Color.accent
                radius: Math.min(width, height) / 2
                width: host.vertical ? Style.space(2) : extent
                height: host.vertical ? extent : Style.space(2)
                x: host.vertical
                  ? (host.position === "left" ? slot.width - width - inset : inset)
                  : Math.round((slot.width - width) / 2)
                y: host.vertical
                  ? Math.round((slot.height - height) / 2)
                  : (host.position === "top" ? slot.height - height - inset : inset)
                z: 50

                Behavior on opacity {
                  NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                }
              }
            }
          }
        }
      }
    }

    PopupWindow {
      id: tooltipWindow

      visible: host.tooltipShown && host.tooltipTarget !== null && host.tooltipText !== ""
        && api.targetBelongsToWindow(host.tooltipTarget, drawerWindow)
      color: "transparent"
      implicitWidth: Math.ceil(tooltipBubble.implicitWidth)
      implicitHeight: Math.ceil(tooltipBubble.implicitHeight)

      anchor {
        id: tooltipAnchor
        window: drawerWindow
        adjustment: PopupAdjustment.Slide
        edges: Edges.Top | Edges.Left
        gravity: Edges.Bottom | Edges.Right
        rect.width: 1
        rect.height: 1

        onAnchoring: {
          var target = host.tooltipTarget
          if (!api.targetBelongsToWindow(target, drawerWindow)) return

          var popupWidth = tooltipWindow.implicitWidth
          var popupHeight = tooltipWindow.implicitHeight
          var localX = target.width / 2 - popupWidth / 2
          var localY = target.height + 6

          if (host.position === "bottom") {
            localY = -popupHeight - 6
          } else if (host.position === "left") {
            localX = target.width + 6
            localY = target.height / 2 - popupHeight / 2
          } else if (host.position === "right") {
            localX = -popupWidth - 6
            localY = target.height / 2 - popupHeight / 2
          }

          var point = drawerWindow.contentItem.mapFromItem(target, localX, localY)
          tooltipAnchor.rect.x = Math.round(point.x)
          tooltipAnchor.rect.y = Math.round(point.y)
        }
      }

      BorderSurface {
        id: tooltipBubble
        implicitWidth: tooltipLabel.implicitWidth + 20
        implicitHeight: tooltipLabel.implicitHeight + 14
        color: Color.tooltip.background
        borderSpec: Border.surfaceSpec("tooltip", "border", Color.tooltip.border, 1)
        radius: Style.cornerRadius

        Text {
          id: tooltipLabel
          textFormat: Text.PlainText
          anchors.centerIn: parent
          text: host.tooltipText
          color: Color.tooltip.text
          font.family: api.fontFamily
          font.pixelSize: Style.font.body
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }
    }
  }

  // Outside-click dismissal. Normal exclusion keeps these out of every bar's
  // reserved strip, so clicking another bar widget still reaches it (and the
  // bar's coordinator closes the drawer), while a click anywhere else on any
  // monitor closes the drawer. They sit on the Top layer, under the drawer
  // card and under any popup a hosted widget opens on the Overlay layer.
  Variants {
    model: host.drawerOpen ? Quickshell.screens : []

    delegate: Component {
      PanelWindow {
        required property var modelData

        screen: modelData
        color: "transparent"
        exclusionMode: ExclusionMode.Normal

        WlrLayershell.namespace: "parker-drawer-dismiss"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        anchors {
          top: true
          bottom: true
          left: true
          right: true
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.AllButtons
          onPressed: host.close()
        }
      }
    }
  }
}
