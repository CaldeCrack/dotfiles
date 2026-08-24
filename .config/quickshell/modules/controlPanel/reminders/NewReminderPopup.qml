import QtQuick

import qs.config
import qs.services
import qs.widgets

// NewReminderPopup
// -----------------
// The reminder creation form: title, optional description, urgency
// (Dropdown, defaults "low"), and hours/minutes/seconds until the
// notification fires. Wraps DismissablePopup the same way
// SystemStatsButton's stats popup does — click-outside/Escape handled
// for free, this just owns the form content.
//
// Same one-way `open` contract as everywhere else: caller sets `open`,
// this only ever emits dismissRequested(), never writes `open` itself.

Item {
    id: root

    property bool open: false
    signal dismissRequested

    function reset() {
        titleField.text = "";
        descriptionField.text = "";
        hoursField.text = "";
        minutesField.text = "";
        secondsField.text = "";
        urgencyDropdown.value = "low";
        urgencyDropdown.expanded = false;
    }

    readonly property int hoursValue: parseInt(hoursField.text) || 0
    readonly property int minutesValue: parseInt(minutesField.text) || 0
    readonly property int secondsValue: parseInt(secondsField.text) || 0
    readonly property int totalDelayMs: (hoursValue * 3600 + minutesValue * 60 + secondsValue) * 1000

    readonly property bool valid: titleField.text.trim().length > 0 && totalDelayMs > 0

    function submit() {
        if (!root.valid)
            return;
        Reminders.addReminder(titleField.text.trim(), descriptionField.text.trim(), urgencyDropdown.value, root.totalDelayMs);
        root.reset();
        root.dismissRequested();
    }

    // Small labeled single-line text field — used for both title and
    // description. A real multi-line editor for description would need
    // TextEdit + its own scroll handling; single-line covers the
    // "optional description" case without that extra machinery for now.
    component LabeledField: Column {
        id: fieldRoot
        required property string label
        property string placeholder: ""
        property alias text: input.text

        spacing: 4
        width: parent.width

        Text {
            text: fieldRoot.label
            font.pixelSize: 12
            color: Colors.md3.on_surface_variant
        }

        Rectangle {
            width: parent.width
            height: 34
            radius: 8
            color: Colors.md3.surface_container_high
            border.color: input.activeFocus ? Colors.md3.primary : Colors.md3.outline_variant
            border.width: 1

            TextInput {
                id: input
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                verticalAlignment: TextInput.AlignVCenter
                color: Colors.md3.on_surface
                font.pixelSize: 12
                clip: true

                HoverHandler {
                    cursorShape: Qt.IBeamCursor
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: input.text.length === 0
                    text: fieldRoot.placeholder
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 12
                }
            }
        }
    }

    // One of the three duration boxes (h/m/s) — digits only, clamped by
    // validator rather than by rejecting keystrokes outright.
    component DurationField: Column {
        id: durationRoot
        required property string label
        property int maxValue: 99
        property alias text: durationInput.text

        spacing: 2

        Rectangle {
            width: 52
            height: 34
            radius: 8
            color: Colors.md3.surface_container_high
            border.color: durationInput.activeFocus ? Colors.md3.primary : Colors.md3.outline_variant
            border.width: 1

            TextInput {
                id: durationInput
                anchors.fill: parent
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                color: Colors.md3.on_surface
                font.pixelSize: 12

                validator: IntValidator {
                    bottom: 0
                    top: durationRoot.maxValue
                }

                HoverHandler {
                    cursorShape: Qt.IBeamCursor
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: durationInput.text.length === 0
                    text: "0"
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 12
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: durationRoot.label
            font.pixelSize: 12
            color: Colors.md3.on_surface_variant
        }
    }

    DismissablePopup {
        id: popup

        open: root.open
        onDismissRequested: root.dismissRequested()

        // Centered on screen — this window already spans the whole
        // screen for click-outside detection (see DismissablePopup's
        // own doc note), so there's no natural "edge" to anchor to for
        // a form this size. Anchor to the + button instead if you'd
        // rather it feel more like a contextual popup than a modal.
        contentX: Math.round((width - panel.implicitWidth) / 2)
        contentY: Math.round((height - panel.implicitHeight) / 2)

        Column {
            width: 280
            spacing: 14

            Text {
                text: "New Reminder"
                font.bold: true
                font.pixelSize: 16
                color: Colors.md3.on_surface
                anchors.horizontalCenter: parent.horizontalCenter
            }

            LabeledField {
                id: titleField
                label: "Title"
                placeholder: "e.g., Watch anime"
            }

            LabeledField {
                id: descriptionField
                label: "Description (optional)"
                placeholder: "e.g., Bocchi the Rock!"
            }

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: "Urgency"
                    font.pixelSize: 12
                    color: Colors.md3.on_surface_variant
                }

                Dropdown {
                    id: urgencyDropdown
                    width: parent.width
                    value: "low"
                    options: [
                        {
                            value: "low",
                            label: "Low"
                        },
                        {
                            value: "normal",
                            label: "Normal"
                        },
                        {
                            value: "critical",
                            label: "Critical"
                        }
                    ]
                }
            }

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: "Notify in"
                    font.pixelSize: 12
                    color: Colors.md3.on_surface_variant
                }

                Row {
                    spacing: 8

                    DurationField {
                        id: hoursField
                        label: "hours"
                        maxValue: 99
                    }

                    DurationField {
                        id: minutesField
                        label: "min"
                        maxValue: 59
                    }

                    DurationField {
                        id: secondsField
                        label: "sec"
                        maxValue: 59
                    }
                }
            }

            Row {
                anchors.right: parent.right
                spacing: 8

                Rectangle {
                    width: 70
                    height: 32
                    radius: 16
                    color: cancelMouse.containsMouse ? Colors.md3.surface_container_high : "transparent"
                    border.color: Colors.md3.outline_variant
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: Colors.md3.on_surface
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: cancelMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.reset();
                            root.dismissRequested();
                        }
                    }
                }

                Rectangle {
                    width: 100
                    height: 32
                    radius: 16
                    color: Colors.md3.primary
                    opacity: root.valid ? 1 : 0.7

                    Text {
                        anchors.centerIn: parent
                        text: "Add reminder"
                        color: Colors.md3.on_primary
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: root.valid ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: root.submit()
                    }
                }
            }
        }
    }
}
