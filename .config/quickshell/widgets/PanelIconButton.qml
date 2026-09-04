import QtQuick
import qs.config
import qs.widgets

// Shared hover/press/checked chrome for icon-only buttons living inside
// panel content (InfoPanel tabs, ControlPanel sliders, etc.) — NOT the bar.
// BarButtonBase already owns that styling contract for the bar itself;
// this is the panel-content equivalent, circular rather than the bar's
// pill shape, and with no tooltip/BarButtonBase-specific concerns.
//
// Usage:
//   PanelIconButton {
//       iconName: "media-play"
//       checked: someToggleState
//       onClicked: doSomething()
//   }
Item {
    id: root

    property string iconName: ""       // bundled icon (assets/icons/<name>.svg), tinted per checked/hover state
    property string systemIconName: "" // real app/system icon via Icon.qml's systemIcon mode — never tinted (own branding colors). Takes priority over iconName when non-empty; iconName acts as the fallback.
    property string appId: ""
    property real iconSize: 18
    property real padding: 8
    property bool checked: false
    property bool enabled: true

    property string color: Colors.md3.on_surface
    property string backgroundColor: "transparent"
    property string hoveredColor: Colors.md3.on_surface
    property string hoveredBackgroundColor: Colors.md3.surface_container_highest

    signal clicked

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed

    implicitWidth: root.iconSize + root.padding * 2
    implicitHeight: implicitWidth // circular — width drives height

    opacity: root.enabled ? 1.0 : 0.4

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: root.checked ? Colors.md3.primary_container : (root.hovered ? root.hoveredBackgroundColor : root.backgroundColor)

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    // Real app/system icon, shown only when the caller actually resolved
    // one (e.g. via Services.Media.resolveIconName). Never tinted — an
    // app's real branding colors are the point.
    Icon {
        anchors.centerIn: parent
        visible: root.systemIconName.length > 0
        systemIcon: root.systemIconName
        size: root.iconSize
    }

    // Bundled icon, tinted per checked/hover state — the original/default
    // mode, and the fallback whenever systemIconName is empty.
    Icon {
        anchors.centerIn: parent
        visible: root.iconName.length > 0
        name: root.iconName
        size: root.iconSize
        color: root.checked ? Colors.md3.on_primary_container : (root.hovered ? root.hoveredColor : root.color)
    }

    Icon {
        anchors.centerIn: parent
        visible: root.appId.length > 0
        appId: root.appId
        size: root.iconSize
        color: root.checked ? Colors.md3.on_primary_container : (root.hovered ? root.hoveredColor : root.color)
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
