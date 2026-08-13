import QtQuick
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.config

// A single notification card — used both by the toast stack (with a live
// countdown bar) and by the history sidebar (same component, timeout: 0
// there just hides the bar). Content container only, like everything else
// in widgets/ — no window, no anchoring; the caller places this inside
// whatever surface it owns.
//
// Usage:
//
//   NotificationItem {
//       notifId: modelData.notifId
//       appName: modelData.appName
//       appIcon: modelData.appIcon
//       summary: modelData.summary
//       body: modelData.body
//       image: modelData.image
//       urgency: modelData.urgency
//       timestamp: modelData.timestamp
//       timeout: modelData.timeout   // 0 = no bar, stays until dismissed
//       actions: modelData.actions
//
//       onDismissRequested: (id) => Notifications.dismiss(id)
//       onTimedOut: (id) => Notifications.expireToast(id)
//       onActionTriggered: (id, identifier) => Notifications.invokeAction(id, identifier)
//   }
//
// Deliberately has no idea Notifications the service exists — it only
// emits what happened. The host decides what dismiss vs. expire actually
// means for the surface it's showing this in (see Notifications.qml's
// dismiss()/expireToast() split).
Item {
    id: root

    // -----------------------------------------------------------------
    // Public API
    // -----------------------------------------------------------------

    property string notifId: ""
    property string appName: ""
    property string appIcon: ""
    property string summary: ""
    property string body: ""
    property string image: ""
    property int urgency: NotificationUrgency.Normal
    property real timestamp: 0   // ms since epoch
    property int timeout: 0      // ms; 0 = persistent, no timer bar
    property var actions: []     // [{identifier, text}]

    property int cardWidth: 320

    signal dismissRequested(string notifId)
    signal actionTriggered(string notifId, string identifier)
    // Fired when the timer bar finishes growing (i.e. the notification's
    // time is up). The host is expected to call Notifications.expireToast
    // — this component never touches the service directly.
    signal timedOut(string notifId)

    implicitWidth: cardWidth
    implicitHeight: card.height

    readonly property int _padding: 8
    readonly property bool _hasTimer: root.timeout > 0
    readonly property color _urgencyColor: root._colorForUrgency(root.urgency)

    property real _now: Date.now()

    function _colorForUrgency(u) {
        switch (u) {
        case NotificationUrgency.Critical:
            return Colors.md3.error;
        case NotificationUrgency.Low:
            return Colors.md3.secondary;
        default:
            return Colors.md3.primary;
        }
    }

    // Coarse on purpose (30s tick) — this only feeds a "3m ago"-style
    // label, no need for anything finer-grained.
    function _relativeTime(ts, now) {
        const diffSec = Math.max(0, Math.floor((now - ts) / 1000));
        if (diffSec < 60)
            return "now";
        const min = Math.floor(diffSec / 60);
        if (min < 60)
            return min + "m";
        const hr = Math.floor(min / 60);
        if (hr < 24)
            return hr + "h";
        return Math.floor(hr / 24) + "d";
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root._now = Date.now()
    }

    Rectangle {
        id: card
        width: root.cardWidth
        implicitHeight: mainColumn.implicitHeight + root._padding * 2
        height: implicitHeight
        radius: 14
        color: Colors.md3.surface_container
        border.width: 1
        border.color: cardHover.containsMouse ? Colors.md3.outline : Colors.md3.outline_variant

        MouseArea {
            id: cardHover
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton // purely for hover state; real content below gets clicks
        }

        Column {
            id: mainColumn
            x: root._padding
            y: root._padding
            width: parent.width - root._padding * 2
            spacing: 8
            leftPadding: 2
            rightPadding: 2
            bottomPadding: 2

            // ---- header: urgency dot, app icon, app name, time, close ----
            Item {
                id: header
                width: parent.width
                height: Math.max(appNameText.implicitHeight, closeButton.height, 16)

                Rectangle {
                    id: urgencyDot
                    width: 8
                    height: 8
                    radius: 4
                    color: root._urgencyColor
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Icon {
                    id: appIconImg
                    visible: root.appIcon !== ""
                    systemIcon: root.appIcon
                    systemIconFallback: "application-x-executable"
                    size: 16
                    anchors.left: urgencyDot.right
                    anchors.leftMargin: 6
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    id: closeButton
                    width: 24
                    height: width
                    radius: width / 2
                    color: closeHover.containsMouse ? Colors.md3.surface_container_highest : "transparent"

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Icon {
                        id: closeIcon
                        name: "common/x"
                        size: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: closeHover
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: root.dismissRequested(root.notifId)
                    }
                }

                Text {
                    id: timeText
                    text: root._relativeTime(root.timestamp, root._now)
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 11
                    anchors.right: closeButton.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: appNameText
                    text: root.appName
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    anchors.left: appIconImg.visible ? appIconImg.right : urgencyDot.right
                    anchors.leftMargin: 6
                    anchors.right: timeText.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // ---- summary ----
            Text {
                width: parent.width
                visible: root.summary !== ""
                text: root.summary
                color: Colors.md3.on_surface
                font.pixelSize: 14
                font.weight: Font.DemiBold
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            // ---- body ----
            Text {
                width: parent.width
                visible: root.body !== ""
                text: root.body
                color: Colors.md3.on_surface_variant
                font.pixelSize: 13
                wrapMode: Text.Wrap
                maximumLineCount: 4
                elide: Text.ElideRight
            }

            // ---- image ----
            ClippingRectangle {
                width: parent.width
                height: 140
                radius: 10
                visible: root.image !== ""
                color: "transparent"

                Image {
                    anchors.fill: parent
                    source: root.image
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
            }

            // ---- actions ----
            Flow {
                width: parent.width
                visible: root.actions.length > 0
                spacing: 6

                Repeater {
                    model: root.actions

                    Rectangle {
                        id: actionChip
                        required property var modelData

                        radius: 8
                        color: actionHover.containsMouse ? Colors.md3.secondary_container : "transparent"
                        border.width: 1
                        border.color: Colors.md3.outline_variant
                        implicitWidth: actionLabel.implicitWidth + 20
                        implicitHeight: actionLabel.implicitHeight + 12

                        Text {
                            id: actionLabel
                            anchors.centerIn: parent
                            text: actionChip.modelData.text
                            color: Colors.md3.on_surface
                            font.pixelSize: 12
                        }

                        MouseArea {
                            id: actionHover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.actionTriggered(root.notifId, actionChip.modelData.identifier)
                        }
                    }
                }
            }

            // ---- timer bar: grows outward from the horizontal center ----
            Item {
                id: timerTrack
                width: parent.width - parent.rightPadding - parent.leftPadding
                height: 6
                visible: root._hasTimer

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: Colors.md3.surface_container_high
                }

                Rectangle {
                    id: timerFill
                    width: 0
                    height: parent.height
                    radius: height / 2
                    color: root._urgencyColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    // Center-anchored + animated width is what makes this
                    // grow toward both edges symmetrically rather than
                    // sliding in from one side.
                    NumberAnimation {
                        id: timerAnim
                        target: timerFill
                        property: "width"
                        from: 0
                        to: timerTrack.width
                        duration: root.timeout
                        easing.type: Easing.Linear
                        running: false
                        paused: root._hasTimer ? (cardHover.containsMouse || closeHover.containsMouse) : false
                        onFinished: root.timedOut(root.notifId)
                    }
                }

                Component.onCompleted: if (root._hasTimer)
                    timerAnim.start()
            }
        }
    }
}
