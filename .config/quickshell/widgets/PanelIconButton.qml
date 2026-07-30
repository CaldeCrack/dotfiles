import QtQuick
import qs.config
import qs.widgets as Widgets

// Shared hover/press/checked chrome for icon-only buttons living inside
// panel content (InfoPanel tabs, ControlPanel sliders, etc.) — NOT the bar.
// BarButtonBase already owns that styling contract for the bar itself;
// this is the panel-content equivalent, circular rather than the bar's
// pill shape, and with no tooltip/BarButtonBase-specific concerns.
//
// Usage:
//   Widgets.PanelIconButton {
//       iconName: "media-play"
//       checked: someToggleState
//       onClicked: doSomething()
//   }
Item {
    id: root

    property string iconName: ""
    property real iconSize: 18
    property real padding: 8
    property bool checked: false
    property bool enabled: true

    signal clicked()

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed

    implicitWidth: root.iconSize + root.padding * 2
    implicitHeight: implicitWidth // circular — width drives height

    opacity: root.enabled ? 1.0 : 0.4

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: root.checked
            ? Colors.md3.primary_container
            : (root.hovered ? Colors.md3.surface_container_high : "transparent")

        Behavior on color { ColorAnimation { duration: 120 } }
    }

    Widgets.Icon {
        anchors.centerIn: parent
        name: root.iconName
        size: root.iconSize
        color: root.checked ? Colors.md3.on_primary_container : Colors.md3.on_surface
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
