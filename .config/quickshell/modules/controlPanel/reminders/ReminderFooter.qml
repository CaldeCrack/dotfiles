import QtQuick
import Quickshell

import qs.config
import qs.services
import qs.widgets

// ReminderFooter
// ---------------
// Bottom bar for the reminders section: live count on the left, a
// button to create a new reminder on the right. Reads Reminders.count
// directly rather than taking it as a prop — same reasoning
// WifiSection/BluetoothSection read their services directly instead of
// having state handed down to them.
//
// addRequested() is emitted but not yet connected to anything real —
// the creation popup is step 5. RemindersSection just needs to route
// this signal to it once that exists.

Item {
    id: root

    implicitHeight: 32

    signal addRequested

    readonly property int count: Reminders.count

    Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: Colors.md3.on_surface_variant
        font.pixelSize: 12
        text: root.count === 1 ? "1 reminder" : `${root.count} reminders`
    }

    Item {
        id: addButton
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 28
        height: 28
        implicitWidth: width
        implicitHeight: height
        property bool hovered: addMouse.containsMouse

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Colors.md3.on_surface
            opacity: addMouse.containsMouse ? 0.12 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 120
                }
            }
        }

        Icon {
            anchors.centerIn: parent
            name: "actions/circle-plus"
            size: 16
            color: Colors.md3.on_surface
        }

        MouseArea {
            id: addMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.addRequested()
        }
    }

    Tooltip {
        target: addButton
        text: "New reminder"
        edge: Edges.Top
    }
}
