import QtQuick

import qs.config
import qs.widgets
import "reminders"

// RemindersSection
// -----------------
// Fills whatever fixed-height space ControlPanel gives it (the "bottom
// part, using a fixed size" requirement) — ReminderList scrolls
// internally within that space, ReminderFooter stays pinned to the
// bottom below it. NewReminderPopup opens on top when the footer's +
// button is clicked; this is the last piece, so the whole reminders
// feature is complete as of this file.

Item {
    id: root

    property bool creatingReminder: false

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface_container
        radius: 16
    }

    ReminderList {
        id: list
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footer.top
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 8
    }

    ReminderFooter {
        id: footer
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.bottom: parent.bottom

        onAddRequested: root.creatingReminder = true
    }

    NewReminderPopup {
        id: newReminderPopup
        open: root.creatingReminder
        onDismissRequested: root.creatingReminder = false
    }
}
