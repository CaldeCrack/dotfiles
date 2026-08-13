pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Central notification service.
//
// Consumers:
//   - Notifications.history       -> array, newest first, for the
//                                     notification center. Treat as
//                                     read-only; mutate only via the
//                                     methods below.
//   - Notifications.activeToasts  -> array, newest first, for the toast
//                                     popup stack. Same read-only contract.
//   - Notifications.silentMode    -> bool, bindable directly or toggled via
//                                     toggleSilent().
//
// Both lists hold plain JS objects, not QtObjects or ListModel entries —
// see the note above the property declarations for why.
//
// Firing a notification from elsewhere in the shell (fire-and-forget, no
// handle returned — once sent it's owned by history/activeToasts like any
// other notification):
//
//   import Quickshell.Services.Notifications
//   import qs.services
//
//   Notifications.notify({
//       appName: "Wallpaper",
//       summary: "Wallpaper changed successfully",
//       urgency: NotificationUrgency.Low
//   })
//
// urgency reuses Quickshell's own NotificationUrgency enum (Low / Normal /
// Critical) rather than a shell-invented vocabulary, so it lines up 1:1
// with what real DBus clients send and callers don't need to remember a
// separate set of strings.
Singleton {
    id: root

    // -----------------------------------------------------------------
    // Config
    // -----------------------------------------------------------------

    // Oldest entries are evicted past this cap.
    readonly property int maxHistory: 100

    // Fallback auto-dismiss timeout (ms) applied when a notification
    // doesn't specify its own via expireTimeout/opts.timeout. Critical
    // defaults to 0 (stays until dismissed), matching normal desktop
    // notification conventions.
    readonly property var defaultTimeouts: ({
            [NotificationUrgency.Low]: 4000,
            [NotificationUrgency.Normal]: 6000,
            [NotificationUrgency.Critical]: 10000
        })

    // -----------------------------------------------------------------
    // Public state
    // -----------------------------------------------------------------

    property bool silentMode: false

    // Deliberately plain JS arrays, NOT ListModel. Records carry a nested
    // `actions` array ({identifier, text}[]) and ListModel's role system
    // does not reliably round-trip nested arrays-of-objects when set via
    // insert()/set() from JS — behavior here has shifted across Qt
    // versions and isn't worth depending on. A plain array sidesteps it
    // entirely: every mutation below reassigns the whole array (never
    // pushes/splices in place), because QML property bindings only react
    // to the property *reference* changing, not to in-place mutation of
    // the same array object.
    property var history: []
    property var activeToasts: []

    // -----------------------------------------------------------------
    // Internal bookkeeping
    // -----------------------------------------------------------------

    property int _nextId: 0

    // notifId -> { notification: Notification, actionsByIdentifier: {} }
    // Only populated for real (DBus-sourced) notifications — custom ones
    // have nothing "live" to invoke or hint back to.
    property var _live: ({})

    // -----------------------------------------------------------------
    // DBus notification server
    // -----------------------------------------------------------------

    NotificationServer {
        id: server

        bodySupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        actionsSupported: true
        actionIconsSupported: false
        persistenceSupported: true
        keepOnReload: false

        onNotification: notification => {
            notification.tracked = true;
            root._ingestLive(notification);
        }
    }

    // -----------------------------------------------------------------
    // Public API
    // -----------------------------------------------------------------

    // Fire-and-forget custom notification. No handle is returned — once
    // fired, it's fully owned by history/activeToasts like any other
    // notification.
    function notify(opts) {
        opts = opts || {};
        const urgency = opts.urgency !== undefined ? opts.urgency : NotificationUrgency.Normal;
        root._push({
            notifId: "c" + (root._nextId++),
            appName: opts.appName || "Shell",
            appIcon: opts.appIcon || "",
            summary: opts.summary || "",
            body: opts.body || "",
            image: opts.image || "",
            urgency: urgency,
            timestamp: Date.now(),
            timeout: opts.timeout !== undefined ? opts.timeout : root.defaultTimeouts[urgency],
            actions: opts.actions || [] // {identifier, text} — display-only for custom notifications, see invokeAction()
            ,
            read: false
        });
    }

    // Explicit user dismissal — removes from both lists and, for real
    // notifications, hints the sending app that the user closed it.
    function dismiss(notifId) {
        root.activeToasts = root.activeToasts.filter(n => n.notifId !== notifId);
        root.history = root.history.filter(n => n.notifId !== notifId);

        const live = root._live[notifId];
        if (live) {
            live.notification.dismiss();
            delete root._live[notifId];
        }
    }

    // Timeout-driven removal, meant to be called by the toast stack's own
    // per-item timer (the one already driving its countdown bar) rather
    // than a second timer living in this service. Only affects the toast
    // — the history entry stays.
    function expireToast(notifId) {
        root.activeToasts = root.activeToasts.filter(n => n.notifId !== notifId);

        const live = root._live[notifId];
        if (live)
            live.notification.expire();
    }

    function clearAll() {
        // Snapshot ids first — dismiss() mutates root.history as it runs,
        // and iterating a list while filtering it out from under yourself
        // is asking for skipped entries.
        const ids = root.history.map(n => n.notifId);
        for (const id of ids)
            root.dismiss(id);
    }

    function toggleSilent() {
        root.silentMode = !root.silentMode;
    }

    // Clears the unread flag used for the bar button's badge count. No-op
    // work skipped (map only replaces entries that actually change) so
    // this doesn't thrash bindings when called on an already-read list.
    function markAllRead() {
        if (!root.history.some(n => !n.read))
            return;
        root.history = root.history.map(n => n.read ? n : Object.assign({}, n, {
                read: true
            }));
    }

    // No-op for custom notifications (opts.actions is display-only there —
    // there's nothing on the other end to invoke, unlike a real DBus
    // notification's actions).
    function invokeAction(notifId, identifier) {
        const live = root._live[notifId];
        if (!live)
            return;
        const action = live.actionsByIdentifier[identifier];
        if (action)
            action.invoke();
    }

    // -----------------------------------------------------------------
    // Internal
    // -----------------------------------------------------------------

    function _ingestLive(notification) {
        const notifId = "n" + (root._nextId++);

        const actionsByIdentifier = ({});
        const actions = [];
        for (let i = 0; i < notification.actions.length; i++) {
            const action = notification.actions[i];
            actionsByIdentifier[action.identifier] = action;
            actions.push({
                identifier: action.identifier,
                text: action.text
            });
        }
        root._live[notifId] = {
            notification,
            actionsByIdentifier
        };

        notification.closed.connect(() => {
            // Covers remote close (app withdrew it) as well as our own
            // dismiss()/expire() calls completing — either way, the live
            // reference is no longer valid. History entry is untouched.
            root.activeToasts = root.activeToasts.filter(n => n.notifId !== notifId);
            delete root._live[notifId];
        });

        // expireTimeout is in seconds; -1 means "server decides" (use our
        // default), 0 means "never expire", >0 is an explicit timeout.
        const timeout = notification.expireTimeout === 0 ? 0 : notification.expireTimeout > 0 ? Math.min(notification.expireTimeout * 1000, root.defaultTimeouts[notification.urgency]) : root.defaultTimeouts[notification.urgency];

        root._push({
            notifId,
            appName: notification.appName,
            appIcon: notification.appIcon,
            summary: notification.summary,
            body: notification.body,
            image: notification.image,
            urgency: notification.urgency,
            timestamp: Date.now(),
            timeout,
            actions,
            read: false
        });
    }

    function _push(record) {
        const combined = [record, ...root.history];
        const kept = combined.slice(0, root.maxHistory);
        const dropped = combined.slice(root.maxHistory);

        // A record aging out of history past the cap should let go of its
        // live DBus reference too — otherwise a busy notifier could pin
        // Notification objects in _live indefinitely, past the point
        // where the shell has any UI left showing them anywhere.
        for (const d of dropped) {
            const live = root._live[d.notifId];
            if (live) {
                live.notification.tracked = false; // equivalent to dismiss()
                delete root._live[d.notifId];
            }
        }

        root.history = kept;

        if (root.silentMode)
            return;
        root.activeToasts = [record, ...root.activeToasts];
    }
}
