import QtQuick
import qs.config

// PanelCloseButton
// ----------------
// Small hover-highlighted circular close (X) button, shared by full-panel
// overlays (ShortcutsWindow, WorkspaceOverlay) that aren't built on
// BarButtonBase — that widget's sizing/styling is bar-specific and has
// nothing to do with a full-screen panel's close affordance.
//
// Extracted from ShortcutsWindow's original inline version, which had a
// `Behavior on opacity` that never actually animated anything (nothing in
// that file bound to `opacity`) — fixed here to animate `color`, which is
// what actually changes on hover.
//
// Usage:
//   PanelCloseButton {
//       anchors.right: parent.right
//       anchors.verticalCenter: parent.verticalCenter
//       onClicked: root.close()
//   }

Item {
    id: root

    signal clicked

    width: 28
    height: 28

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: width / 2
        color: hoverArea.containsMouse ? Colors.md3.surface : Colors.md3.surface_container

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }

        Text {
            anchors.centerIn: parent
            text: "\u2715"
            color: Colors.md3.on_surface
            font.pixelSize: 14
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
