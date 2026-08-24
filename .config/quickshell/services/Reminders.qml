pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

// Reminders
// ---------
// Data + timing engine only — no UI here. A reminder is a plain JS
// object: { id, title, description, urgency, notifyAt, fired }.
// `notifyAt` is an absolute epoch timestamp (createdAt + requested
// delay), not a countdown — so a shell restart recomputes remaining
// time correctly instead of resetting the clock.
//
// Fired reminders are never auto-removed. `fired` just flips true once
// the notification's been sent; the entry stays in `reminders` until
// dismissReminder() (tick — confirms done) or deleteReminder() (x —
// discards without confirming) is called on it. This service doesn't
// enforce which button is allowed on which state — that's a UI
// decision for ReminderRow to make.
//
// Countdown precision (minute vs. second) is deliberately NOT decided
// here — `now` just ticks every second so bound values stay live;
// ReminderRow picks the display granularity from remainingMs(), same
// reasoning SystemStatsButton's popup keeps unit formatting out of
// SystemStats itself.
Singleton {
    id: root

    // --- persistence -------------------------------------------------
    //
    // Lives in state, not config/ — this is runtime data the user
    // creates through the UI, not something they hand-edit, same
    // distinction XDG draws between ~/.config and ~/.local/state.
    readonly property string storagePath: Quickshell.env("HOME") + "/.local/state/quickshell/reminders.json"

    // Best-effort: ~/.local/state/quickshell may not exist on a fresh
    // install. writeAdapter() would fail silently without a parent
    // directory to write into, so this runs once up front to guarantee
    // one exists before the FileView below ever tries to save.
    Process {
        running: true
        command: ["mkdir", "-p", Quickshell.env("HOME") + "/.local/state/quickshell"]
    }

    FileView {
        id: fileView
        path: root.storagePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound)
                writeAdapter();
        }

        JsonAdapter {
            id: adapter

            // A plain var array rather than individual JsonAdapter
            // properties — reminders are created/removed dynamically
            // with no fixed count, and JsonAdapter explicitly supports
            // "JSON objects and arrays, as a var type" for exactly this.
            //
            // IMPORTANT: being a var, mutating in place (push/splice)
            // does NOT trigger change notification or a save. Every
            // mutation below reassigns a brand new array instead.
            property var reminders: []
        }
    }

    // --- live countdown ------------------------------------------------
    property double now: Date.now()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = Date.now()
    }

    // --- read model --------------------------------------------------------
    //
    // Sorted soonest-due first, re-derived from the raw stored array
    // rather than kept pre-sorted — storage order doesn't matter and
    // add/remove can't desync it from what's displayed.
    readonly property var sortedReminders: [...adapter.reminders].sort((a, b) => a.notifyAt - b.notifyAt)
    readonly property int count: adapter.reminders.length

    function remainingMs(reminder) {
        return reminder.notifyAt - root.now;
    }

    function isOverdue(reminder) {
        return root.now >= reminder.notifyAt;
    }

    // --- mutation ----------------------------------------------------------
    function addReminder(title, description, urgency, delayMs) {
        const reminder = {
            id: Date.now() + "-" + Math.random().toString(36).slice(2),
            title: title,
            description: description ?? "",
            urgency: urgency ?? "low",
            notifyAt: Date.now() + delayMs,
            fired: false
        };
        adapter.reminders = [...adapter.reminders, reminder];
    }

    function dismissReminder(id) {
        adapter.reminders = adapter.reminders.filter(r => r.id !== id);
    }

    function deleteReminder(id) {
        adapter.reminders = adapter.reminders.filter(r => r.id !== id);
    }

    // --- firing --------------------------------------------------------
    //
    // Piggybacks on the same tick that drives the countdown rather than
    // running a second timer. Anything whose notifyAt has just passed
    // and hasn't fired yet gets notified exactly once.
    onNowChanged: {
        const due = adapter.reminders.filter(r => !r.fired && root.now >= r.notifyAt);
        if (due.length === 0)
            return;

        for (const reminder of due) {
            Notifications.notify({
                appName: "Reminders",
                summary: reminder.title,
                body: reminder.description,
                urgency: urgencyToNotificationUrgency(reminder.urgency)
            });
        }

        const dueIds = new Set(due.map(r => r.id));
        adapter.reminders = adapter.reminders.map(function (r) {
            if (!dueIds.has(r.id))
                return r;

            return {
                id: r.id,
                title: r.title,
                description: r.description,
                urgency: r.urgency,
                notifyAt: r.notifyAt,
                fired: true
            };
        });
    }

    function urgencyToNotificationUrgency(urgency) {
        switch (urgency) {
        case "low":
            return NotificationUrgency.Low;
        case "critical":
            return NotificationUrgency.Critical;
        default:
            return NotificationUrgency.Normal;
        }
    }
}
