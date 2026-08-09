import QtQuick
import qs.config
import qs.widgets

// One column of the power overlay: big icon, label below.
// Kept local to modules/powerMenu since PowerOverlay is currently its only
// consumer — see widgets/ vs module-local convention in Widgets_reference.md.
//
// `focused` is exposed as an external property rather than derived
// internally, because the overlay drives it from keyboard nav (arrow keys
// moving a currentIndex) as well as mouse hover — same "hovered vs checked
// are independent, caller can react to either" shape BarButtonBase uses.
Item {
    id: root

    required property string iconName
    required property string label

    // Driven by the overlay's currentIndex when navigating with arrow keys.
    property bool focused: false

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool highlighted: hovered || focused

    signal clicked()

    implicitWidth: 160
    implicitHeight: 160

    Rectangle {
        id: highlightBg
        anchors.fill: parent
        radius: 12
        color: Colors.md3.primary
        opacity: root.highlighted ? 0.12 : 0

        Behavior on opacity {
            NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Icon {
            id: icon
            anchors.horizontalCenter: parent.horizontalCenter
            name: root.iconName
            size: 64
            color: root.highlighted ? Colors.md3.primary : Colors.md3.on_surface

            Behavior on color {
                ColorAnimation { duration: 120 }
            }

            scale: root.highlighted ? 1.08 : 1.0
            Behavior on scale {
                NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            font.pixelSize: 14
            color: root.highlighted ? Colors.md3.primary : Colors.md3.on_surface

            Behavior on color {
                ColorAnimation { duration: 120 }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
