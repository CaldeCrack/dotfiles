import QtQuick
import Quickshell
import qs.config
import qs.services
import qs.widgets

// Toast stack — top-right corner, below the bar. Shows Notifications.activeToasts
// as a stack of NotificationItem cards; each one drives its own countdown
// and reports back via signals rather than touching the service directly
// (see NotificationItem.qml's usage note).
//
// This is the first real consumer of the shared card widget — the history
// sidebar (next) reuses the exact same NotificationItem, just with
// timeout: 0 so no bar is shown.
PanelWindow {
    id: toastWindow

    anchors {
        top: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore // overlay — doesn't reserve bar-style screen space
    margins.top: Settings.bar.height + 4
    margins.right: 8

    implicitWidth: toastColumn.implicitWidth
    implicitHeight: toastColumn.implicitHeight
    color: "transparent"

    Column {
        id: toastColumn
        spacing: 8

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: 320
                to: 0
                duration: 400
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                properties: "y"
                from: 0
                to: 0
                duration: 0
            }
        }

        Repeater {
            // Notifications.activeToasts is reassigned to a brand-new array
            // on every mutation (see Notifications.qml). A Repeater bound
            // straight to a plain array doesn't diff — any reassignment
            // destroys and recreates every delegate, which would restart
            // every *other* toast's timer bar the moment a new one arrives.
            // ScriptModel diffs old vs. new values and only adds/removes
            // what actually changed. objectProp keys the comparison on
            // notifId rather than object identity — the array elements
            // themselves happen to survive filter() untouched today, but
            // this doesn't rely on that staying true.
            model: ScriptModel {
                values: Notifications.activeToasts
                objectProp: "notifId"
            }

            NotificationItem {
                notifId: modelData.notifId
                appName: modelData.appName
                appIcon: modelData.appIcon
                summary: modelData.summary
                body: modelData.body
                image: modelData.image
                urgency: modelData.urgency
                timestamp: modelData.timestamp
                timeout: modelData.timeout
                actions: modelData.actions

                onDismissRequested: id => Notifications.dismiss(id)
                onTimedOut: id => Notifications.expireToast(id)
                onActionTriggered: (id, identifier) => Notifications.invokeAction(id, identifier)
            }
        }
    }
}
