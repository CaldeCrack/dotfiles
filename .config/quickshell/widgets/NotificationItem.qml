import QtQuick
import Quickshell
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
//
// Enter/exit animation lives here rather than on whatever hosts it, so
// every host gets the same feel for free. It's driven by the ListView
// attached signals (ListView.onAdd / ListView.onRemove + delayRemove) —
// harmless no-ops if this item isn't inside a ListView. Plain positioners
// (Column/Row/etc.) don't support delayed removal at all, which is why a
// ListView is the right host for anything that needs an exit animation.
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
    // Plain Item does NOT bind width/height to implicit* automatically —
    // without this, root.height silently stays 0 and only "works" because
    // QML doesn't clip children to a zero-sized parent by default. Any
    // container that actually measures this item (ListView, Column, ...)
    // needs a real height here, not just an implicit one.
    width: implicitWidth
    height: implicitHeight

    readonly property int _padding: 12
    readonly property bool _hasTimer: root.timeout > 0
    readonly property color _urgencyColor: root._colorForUrgency(root.urgency)

    property real _now: Date.now()

    function _colorForUrgency(u) {
        switch (u) {
        case NotificationUrgency.Critical: return Colors.md3.error
        case NotificationUrgency.Low: return Colors.md3.secondary
        default: return Colors.md3.primary
        }
    }

    // Coarse on purpose (30s tick) — this only feeds a "3m ago"-style
    // label, no need for anything finer-grained.
    function _relativeTime(ts, now) {
        const diffSec = Math.max(0, Math.floor((now - ts) / 1000))
        if (diffSec < 60) return "now"
        const min = Math.floor(diffSec / 60)
        if (min < 60) return min + "m"
        const hr = Math.floor(min / 60)
        if (hr < 24) return hr + "h"
        return Math.floor(hr / 24) + "d"
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root._now = Date.now()
    }

    // -----------------------------------------------------------------
    // Enter / exit animation
    // -----------------------------------------------------------------
    // Entrance: fade + drop in from above. Exit: fade + collapse height to
    // 0 in place ("cramp vertically") rather than sliding — dismissal
    // isn't directional the way arrival is.
    //
    // The entrance offset is a Translate transform, NOT an animation on
    // the real y property. ListView actively manages each delegate's y as
    // part of its own layout (and is doing so concurrently for siblings
    // via the displaced: transition) — animating y directly would fight
    // that. A transform sits on top purely visually and never touches the
    // property the view itself is driving.

    transform: Translate { id: _entryOffset }

    ListView.onAdd: _enterAnimation.start()
    ListView.onRemove: {
        root.ListView.delayRemove = true
        _exitAnimation.start()
    }

    ParallelAnimation {
        id: _enterAnimation
        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: 300; easing.type: Easing.OutCubic }
        NumberAnimation { target: _entryOffset; property: "y"; from: -card.implicitHeight; to: 0; duration: 300; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: _exitAnimation
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: 200; easing.type: Easing.InCubic }
            NumberAnimation { target: card; property: "height"; to: 0; duration: 200; easing.type: Easing.InCubic }
        }
        ScriptAction { script: root.ListView.delayRemove = false }
    }

    Rectangle {
        id: card
        width: root.cardWidth
        implicitHeight: mainColumn.implicitHeight + root._padding * 2
        height: implicitHeight
        radius: 14
        color: Colors.md3.surface_container
        border.width: 1
        border.color: (cardHover.containsMouse || closeHover.containsMouse) ? Colors.md3.outline : Colors.md3.outline_variant
        clip: true // needed once height animates below content's natural size on exit

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

            // ---- header: urgency dot, app icon, app name, time, close ----
            Item {
                id: header
                width: parent.width
                height: Math.max(appNameText.implicitHeight, closeIcon.height, 16)

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
                    width: 22
                    height: 22
                    radius: 6
                    color: closeHover.containsMouse ? Colors.md3.surface_container_high : "transparent"
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
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
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
                width: parent.width
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
                        paused: cardHover.containsMouse || closeHover.containsMouse
                        onFinished: root.timedOut(root.notifId)
                    }
                }

                Component.onCompleted: if (root._hasTimer) timerAnim.start()
            }
        }
    }
}
