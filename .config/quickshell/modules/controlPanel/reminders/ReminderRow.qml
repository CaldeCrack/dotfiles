import QtQuick

import qs.config
import qs.services
import qs.widgets

// ReminderRow
// -----------
// One reminder, two lines:
//   - top: urgency dot + countdown ("23m", "45s" once under a minute,
//     "Overdue" once fired) on the left, tick/x on the right.
//   - bottom: title, swapped for the description on hover (if any).
//
// Tick and x occupy the exact same slot but are never both live at
// once — which one exists is driven entirely by `reminder.fired`, not
// by hovering one to reveal the other. Fired -> tick (confirm/dismiss).
// Not yet fired -> x (delete outright). The service itself doesn't
// enforce this pairing; it's a UI decision made here.
//
// Standalone component — takes a `reminder` object directly rather
// than reaching into Reminders itself, so it can be used both as
// ReminderList's delegate (reminder: modelData) and, right now, tested
// in isolation before that list exists. To smoke-test this visually
// before step 3: call Reminders.addReminder("Test", "desc", "low",
// 65000) from anywhere temporarily — it persists immediately.

Item {
    id: root

    required property var reminder

    property real rowHeight: 44
    property real iconButtonSize: 22

    implicitHeight: rowHeight

    readonly property bool fired: reminder.fired
    readonly property bool hasDescription: reminder.description && reminder.description.length > 0

    readonly property color urgencyColor: {
        switch (reminder.urgency) {
        case "critical":
            return Colors.md3.error;
        case "normal":
            return Colors.md3.primary;
        default:
            return Colors.md3.secondary;
        }
    }

    // Minute precision normally, second precision once under a minute
    // — a display decision, deliberately not something Reminders.qml
    // itself bakes in (same split SystemStatsButton's popup uses for
    // its own unit formatting).
    function formatRemaining(ms) {
        if (ms <= 0)
            return "Overdue";
        const totalSeconds = Math.floor(ms / 1000);
        if (totalSeconds < 60)
            return totalSeconds + "s";
        const totalMinutes = Math.floor(totalSeconds / 60);
        const hours = Math.floor(totalMinutes / 60);
        const minutes = totalMinutes % 60;
        return hours > 0 ? `${hours}h ${minutes}m` : `${minutes}m`;
    }

    readonly property string countdownText: root.fired ? "Overdue" : formatRemaining(Reminders.remainingMs(reminder))

    HoverHandler {
        id: rowHover
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: Colors.md3.on_surface
        opacity: rowHover.hovered ? 0.06 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }
    }

    // --- top line: urgency dot + countdown  |  tick/x (shared slot) -------
    Item {
        id: topLine
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        height: 18

        Rectangle {
            id: urgencyDot
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 6
            height: 6
            radius: 3
            color: root.urgencyColor
        }

        Text {
            anchors.left: urgencyDot.right
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: root.fired ? Colors.md3.error : Colors.md3.on_surface_variant
            text: root.countdownText
        }

        Item {
            id: actionSlot
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: root.iconButtonSize
            height: root.iconButtonSize
            implicitWidth: width
            implicitHeight: height
            property bool hovered: actionMouse.containsMouse

            Rectangle {
                anchors.fill: parent
                radius: 16
                color: Colors.md3.on_surface
                opacity: actionMouse.containsMouse ? 0.12 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }

            Icon {
                anchors.centerIn: parent
                name: root.fired ? "actions/check" : "actions/x"
                size: 14
                color: root.fired ? Colors.md3.primary : Colors.md3.on_surface_variant
            }

            MouseArea {
                id: actionMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.fired ? Reminders.dismissReminder(root.reminder.id) : Reminders.deleteReminder(root.reminder.id)
            }
        }

        Tooltip {
            target: actionSlot
            text: root.fired ? "Mark as done" : "Delete reminder"
        }
    }

    // --- bottom line: title, swaps to description (or a placeholder) on hover
    Text {
        anchors.top: topLine.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        elide: Text.ElideRight
        font.pixelSize: 13
        // Placeholder ("No description") reads as italic/muted so it's
        // visually distinct from actually-hovering real content.
        font.italic: rowHover.hovered && !root.hasDescription
        color: (rowHover.hovered && !root.hasDescription) ? Colors.md3.on_surface_variant : Colors.md3.on_surface
        text: {
            if (!rowHover.hovered)
                return root.reminder.title;
            return root.hasDescription ? root.reminder.description : "No description";
        }
    }
}
