import QtQuick
import Quickshell
import qs.config
import qs.services
import qs.widgets

// Toast stack — top-right corner, below the bar. Shows Notifications.activeToasts
// as a stack of NotificationItem cards.
//
// Built on ListView rather than a positioner (Column/Row/...) specifically
// because positioners have no `remove` transition and no delayed-destruction
// mechanism at all — an item removed from a Column's model is just gone,
// instantly, no matter what transitions you configure. ListView's
// ListView.delayRemove exists precisely to let a delegate finish animating
// itself out before it's actually destroyed, which NotificationItem uses
// (see its ListView.onAdd/onRemove handlers) — so the actual enter/exit
// animation lives on the item, not here.
//
// The window itself does NOT reactively resize to content. Anchoring
// top+right+bottom gives it a fixed height spanning the working area once,
// and content just anchors to the top inside it. This is deliberate: a
// PanelWindow's implicitHeight drives a REAL layer-shell surface resize,
// which is a compositor round-trip — reactively binding that to a
// per-frame animated height (as an earlier version of this file did, via
// NotificationItem's exit animation shrinking card.height) meant resizing
// the actual OS-level surface 60 times over 180ms, which is what was
// stalling the whole shell's frame pacing, not just this window. Content
// still animates freely every frame; the window's real geometry just
// never has to move.
//
// The empty space below the toasts would normally still capture clicks
// (a window's input region defaults to its whole rect) — `mask` restricts
// the clickable area to toastList's actual current bounds, and unlike
// implicitHeight, mask updates are deferred to Qt's polish cycle rather
// than triggering a surface reconfigure, so it's cheap to update per frame.
PanelWindow {
    id: toastWindow

    readonly property int toastWidth: 320

    anchors {
        top: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore // overlay — doesn't reserve bar-style screen space
    margins.top: Settings.bar.height + 4 // manually clear the bar, per Widgets_reference.md
    margins.right: 8
    margins.bottom: 8

    implicitWidth: toastWidth
    color: "transparent"

    mask: Region { item: toastList }

    ListView {
        id: toastList

        anchors.top: parent.top
        width: toastWindow.toastWidth
        height: contentHeight // drives the mask region, not the window's real size — cheap to update every frame
        interactive: false     // a stack, not something meant to scroll
        spacing: 8

        // This is ONLY for existing items shifting position when a sibling
        // is added/removed elsewhere in the stack — deliberately vertical
        // only. The newly-added/removed item's own animation (fade + side
        // slide in, fade + collapse out) lives on NotificationItem itself;
        // conflating the two was what made the old Column-based version
        // slide sideways when it should've just been sliding down.
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.OutCubic }
        }

        // Notifications.activeToasts is reassigned to a brand-new array on
        // every mutation (see Notifications.qml). A view bound straight to
        // a plain array doesn't diff — any reassignment destroys and
        // recreates every delegate, which would restart every *other*
        // toast's timer bar the moment a new one arrives. ScriptModel diffs
        // old vs. new values and only adds/removes what actually changed.
        // objectProp keys the comparison on notifId rather than object
        // identity — the array elements happen to survive filter()
        // untouched today, but this doesn't rely on that staying true.
        model: ScriptModel {
            values: Notifications.activeToasts
            objectProp: "notifId"
        }

        delegate: NotificationItem {
            cardWidth: toastWindow.toastWidth

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
