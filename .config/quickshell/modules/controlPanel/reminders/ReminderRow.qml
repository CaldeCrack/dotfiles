import QtQuick

import qs.config
import qs.services
import qs.widgets

// ReminderRow
// -----------
// A reminder, stacked top to bottom:
//   - countdown line ("23m", "45s" once under a minute, "Overdue" once
//     fired), with the urgency dot
//   - title, single line, elided
//   - description, single line + ellipsis when collapsed
// Tick/x sits in its own top-right corner, anchored to the whole row
// rather than nested inside the (short) countdown line — nesting it
// there was what caused the clipping, since the icon button was taller
// than that line.
//
// The row itself is clickable to expand the description to full
// wrapped text, but only when there's actually more to show —
// Text.truncated (a real Qt property, not a guess from character
// count) reports whether the collapsed single line actually got cut
// off. No description, or a description that already fits, means the
// row stays inert and the cursor stays a normal arrow.

Item {
    id: root

    required property var reminder

    property real horizontalPadding: 8
    property real verticalPadding: 6
    property real lineSpacing: 2
    property real iconButtonSize: 22

    property bool expanded: false

    readonly property bool fired: reminder.fired
    readonly property bool hasDescription: reminder.description && reminder.description.length > 0
    readonly property bool canExpand: hasDescription && (root.expanded || descriptionText.truncated)

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

    implicitHeight: verticalPadding * 2 + countdownRow.height + lineSpacing + titleText.height + (hasDescription ? lineSpacing + descriptionText.height : 0)

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }

    // Passive — covers the whole row (including the action corner) so
    // the hover highlight still shows there, independent of the click
    // zone below which deliberately excludes it. Cursor shape lives on
    // that MouseArea instead, not here — a MouseArea with hoverEnabled
    // claims cursor ownership within its own bounds regardless of what
    // a HoverHandler underneath requests, so setting it here only ever
    // took effect outside the MouseArea's area (in practice: barely
    // anywhere, since the MouseArea covers almost the entire row).
    HoverHandler {
        id: rowHover
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        border.color: Colors.md3.outline_variant
        border.width: 1
        color: (rowHover.hovered && !actionMouse.containsMouse) ? Colors.md3.surface_container_highest : Colors.md3.surface_container_high
        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }
    }

    // Click zone for expand/collapse. No manual exclusion for the
    // action button's corner — that used to be a rightMargin trim, but
    // margin only trims that edge for the row's FULL height, which cut
    // a dead strip through every line (including the ellipsis, which
    // sits at the right end of a truncated line). actionSlot is
    // declared after this MouseArea, so it naturally stacks on top and
    // claims its own small bounds first — precise exclusion, not an
    // approximated margin.
    MouseArea {
        anchors.fill: parent
        enabled: root.canExpand
        hoverEnabled: true
        cursorShape: root.canExpand ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.expanded = !root.expanded
    }

    // --- countdown line: urgency dot + countdown text ----------------------
    Item {
        id: countdownRow
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: actionSlot.left
        anchors.topMargin: root.verticalPadding
        anchors.leftMargin: root.horizontalPadding
        anchors.rightMargin: 4
        height: 16

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
    }

    // --- title -----------------------------------------------------------
    Text {
        id: titleText
        anchors.top: countdownRow.bottom
        anchors.topMargin: root.lineSpacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.horizontalPadding
        anchors.rightMargin: root.horizontalPadding
        elide: Text.ElideRight
        font.pixelSize: 13
        color: Colors.md3.on_surface
        text: root.reminder.title
    }

    // --- description: one line + ellipsis, wraps fully when expanded -------
    Text {
        id: descriptionText
        anchors.top: titleText.bottom
        anchors.topMargin: root.lineSpacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.horizontalPadding
        anchors.rightMargin: root.horizontalPadding
        visible: root.hasDescription
        font.pixelSize: 12
        color: Colors.md3.on_surface_variant
        text: root.reminder.description ?? ""
        wrapMode: root.expanded ? Text.Wrap : Text.NoWrap
        elide: root.expanded ? Text.ElideNone : Text.ElideRight
    }

    // --- tick/x: independent top-right corner, not nested in countdownRow --
    Item {
        id: actionSlot
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: root.verticalPadding - 2
        anchors.rightMargin: root.horizontalPadding
        width: root.iconButtonSize
        height: root.iconButtonSize

        Rectangle {
            anchors.fill: parent
            radius: width / 2
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
