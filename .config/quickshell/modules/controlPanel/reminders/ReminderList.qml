import QtQuick

import qs.config
import qs.services
import qs.widgets

// ReminderList
// ------------
// Scrollable list of reminders, soonest-due first (Reminders.qml
// already sorts — this just renders what it's given). Deliberately has
// NO implicitHeight of its own, unlike VolumeSlider/BrightnessSlider/
// etc. — this is designed to fill whatever fixed-height container
// RemindersSection gives it (anchors.fill: parent when embedded), not
// to auto-size to content the way the other slices do. That's the
// actual point of the "fixed size, fills remaining space" requirement:
// the container is fixed, the list scrolls within it.
//
// Empty state included now rather than deferred to the polish pass —
// without it, zero reminders would just render as blank space inside
// the fixed container, which reads as broken rather than empty.

Item {
    id: root

    readonly property var reminders: Reminders.sortedReminders

    Item {
        visible: root.reminders.length === 0
        anchors.fill: parent

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Colors.md3.on_surface_variant
                name: "common/reminder"
                size: 48
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No reminders yet"
                color: Colors.md3.on_surface_variant
                font.pixelSize: 13
            }
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        visible: root.reminders.length > 0
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        spacing: 4
        model: root.reminders

        delegate: ReminderRow {
            id: delegateRoot
            required property var modelData
            width: listView.width
            reminder: modelData
        }
    }
}
