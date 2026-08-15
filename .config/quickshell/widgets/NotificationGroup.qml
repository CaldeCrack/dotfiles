import QtQuick
import qs.config
import qs.services
import qs.widgets

// One collapsed-by-default group per app in the notification center —
// "wrapping multiple notifications into one dropdown like messaging apps."
// required property var modelData is auto-populated when this is used
// directly as a ListView delegate (no manual `modelData: modelData` needed).
Item {
    id: root

    required property var modelData // { appName, appIcon, notifications: [...] }

    property bool expanded: false

    implicitHeight: header.height + (expanded ? notifColumn.implicitHeight : 0)
    clip: true

    Behavior on implicitHeight {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    Column {
        width: parent.width

        Rectangle {
            id: header
            width: parent.width
            height: 44
            radius: 10
            color: headerHover.containsMouse ? Colors.md3.surface_container_high : Colors.md3.surface_container

            MouseArea {
                id: headerHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.expanded = !root.expanded
            }

            Icon {
                id: groupIcon
                visible: root.modelData.appIcon !== ""
                systemIcon: root.modelData.appIcon
                systemIconFallback: "application-x-executable"
                size: 18
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.modelData.appName
                color: Colors.md3.on_surface
                font.pixelSize: 13
                anchors.left: groupIcon.visible ? groupIcon.right : parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.modelData.notifications.length
                color: Colors.md3.on_surface_variant
                font.pixelSize: 12
                anchors.right: chevron.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            // Plain glyph rather than an icon asset name I haven't confirmed
            // exists — flip to Icon { name: "..." } if you've got a chevron
            // in assets/icons and want it to match the rest visually.
            Text {
                id: chevron
                text: root.expanded ? "\u25B4" : "\u25BE"
                color: Colors.md3.on_surface_variant
                font.pixelSize: 12
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Column {
            id: notifColumn
            width: parent.width
            spacing: 8
            visible: root.expanded
            topPadding: 8

            Repeater {
                model: root.modelData.notifications

                NotificationItem {
                    cardWidth: notifColumn.width
                    notifId: modelData.notifId
                    appName: modelData.appName
                    appIcon: modelData.appIcon
                    summary: modelData.summary
                    body: modelData.body
                    image: modelData.image
                    urgency: modelData.urgency
                    timestamp: modelData.timestamp
                    timeout: 0 // history entries are persistent — no countdown bar
                    actions: modelData.actions

                    onDismissRequested: id => Notifications.dismiss(id)
                    onActionTriggered: (id, identifier) => Notifications.invokeAction(id, identifier)
                }
            }
        }
    }
}
