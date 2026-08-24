import QtQuick

import qs.config
import qs.services
import qs.widgets

// NewReminderPopup
// -----------------
// The reminder creation form: title, optional description (real
// multi-line text area), urgency (Dropdown, defaults "low"), and
// hours/minutes/seconds until the notification fires.
//
// Escape and Tab are handled locally on each field rather than relying
// on DismissablePopup's own bubbled handling — a focused TextInput/
// TextEdit doesn't reliably let Escape bubble back up through the
// NavStack/Loader layer, same issue ClipboardOptions.qml's search field
// already worked around. Each field forwards explicitly to
// root.requestClose() instead.
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

    // Both the outside-click/Escape path (DismissablePopup's own
    // handling, for whenever nothing has focus) and every field's own
    // explicit Escape forward land here — one place that both resets
    // and closes, so neither path can do one without the other.
    function requestClose() {
        root.reset();
        root.dismissRequested();
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

    // Single-line labeled field — used for title only now that
    // description has its own multi-line component below.
    component LabeledField: Column {
        id: fieldRoot
        required property string label
        property string placeholder: ""
        property alias text: input.text
        property alias focusTarget: input
        property Item nextTabTarget: null
        property Item prevTabTarget: null

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

                KeyNavigation.tab: fieldRoot.nextTabTarget
                KeyNavigation.backtab: fieldRoot.prevTabTarget
                Keys.onEscapePressed: root.requestClose()
                Keys.onReturnPressed: root.submit()
                Keys.onEnterPressed: root.submit()

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

    // Multi-line description. Built around the TextEdit pattern you
    // supplied: emptyGuard MouseArea covers the whole box and handles
    // click-to-focus while empty; once there's real text, it steps
    // aside (enabled: false) and TextEdit's own native click/drag
    // (selectByMouse) takes over for actual cursor positioning. No
    // scroll handling — content just clips past the fixed box height,
    // same simplification the single-line version already had.
    component TextAreaField: Column {
        id: fieldRoot
        required property string label
        property string placeholder: ""
        property alias text: textArea.text
        property alias focusTarget: textArea
        property Item nextTabTarget: null
        property Item prevTabTarget: null

        spacing: 4
        width: parent.width

        Text {
            text: fieldRoot.label
            font.pixelSize: 12
            color: Colors.md3.on_surface_variant
        }

        Rectangle {
            width: parent.width
            height: 64
            radius: 8
            clip: true
            color: Colors.md3.surface_container_high
            border.color: textArea.activeFocus ? Colors.md3.primary : Colors.md3.outline_variant
            border.width: 1

            TextEdit {
                id: textArea
                anchors.fill: parent
                anchors.margins: 8
                wrapMode: TextEdit.Wrap
                color: Colors.md3.on_surface
                font.pixelSize: 12
                selectByMouse: true

                KeyNavigation.tab: fieldRoot.nextTabTarget
                KeyNavigation.backtab: fieldRoot.prevTabTarget
                Keys.onEscapePressed: root.requestClose()

                // Full-area I-beam + native click/focus/cursor-position
                // handling — only meaningful once there's real text to
                // click into. While empty, emptyGuard below takes over
                // instead, so hovering/clicking blank space in the box
                // doesn't act like part of the input.
                HoverHandler {
                    cursorShape: Qt.IBeamCursor
                    enabled: textArea.text.length > 0
                }

                Text {
                    visible: textArea.text.length === 0
                    text: fieldRoot.placeholder
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 12
                }
            }

            MouseArea {
                id: emptyGuard
                anchors.fill: parent
                enabled: textArea.text.length === 0
                hoverEnabled: true
                cursorShape: Qt.IBeamCursor
                onClicked: textArea.forceActiveFocus()
            }
        }
    }

    // One of the three duration boxes (h/m/s) — digits only, clamped by
    // validator rather than by rejecting keystrokes outright. No default
    // text, so the "0" shown when empty is purely a placeholder — the
    // service already treats an empty/unparsed field as 0.
    component DurationField: Column {
        id: durationRoot
        required property string label
        property int maxValue: 99
        property alias text: durationInput.text
        property alias focusTarget: durationInput
        property Item nextTabTarget: null
        property Item prevTabTarget: null

        spacing: 4

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

                KeyNavigation.tab: durationRoot.nextTabTarget
                KeyNavigation.backtab: durationRoot.prevTabTarget
                Keys.onEscapePressed: root.requestClose()
                Keys.onReturnPressed: root.submit()
                Keys.onEnterPressed: root.submit()

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
        onDismissRequested: root.requestClose()

        dim: true

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
                nextTabTarget: descriptionField.focusTarget
                prevTabTarget: secondsField.focusTarget
            }

            TextAreaField {
                id: descriptionField
                label: "Description (optional)"
                placeholder: "e.g., Bocchi the Rock!"
                nextTabTarget: hoursField.focusTarget
                prevTabTarget: titleField.focusTarget
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
                        nextTabTarget: minutesField.focusTarget
                        prevTabTarget: descriptionField.focusTarget
                    }

                    DurationField {
                        id: minutesField
                        label: "min"
                        maxValue: 59
                        nextTabTarget: secondsField.focusTarget
                        prevTabTarget: hoursField.focusTarget
                    }

                    DurationField {
                        id: secondsField
                        label: "sec"
                        maxValue: 59
                        nextTabTarget: titleField.focusTarget
                        prevTabTarget: minutesField.focusTarget
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
                        onClicked: root.requestClose()
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
