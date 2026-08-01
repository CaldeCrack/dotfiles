pragma Singleton

import QtQuick
import Quickshell

// Central clock — single source of truth for the current date/time so every
// consumer (bar clock button, InfoPanel's Time tab, anywhere else) reads the
// same synced value instead of each running its own Date()/Timer and
// potentially drifting a tick apart from one another.
//
// Sits alongside the other services/ singletons, so import as:
//   import qs.services as Services
// then reference Services.Time.time / Services.Time.date directly — same
// multi-singleton-per-folder convention as Colors / Settings.
Singleton {
    id: root

    // Raw value, kept around in case a consumer wants to format it
    // differently (e.g. a big clock display wanting seconds, or a locale-
    // specific format) rather than being limited to the two strings below.
    property date dateTime: new Date()

    // 24-hour time, e.g. "14:37"
    readonly property string time: Qt.formatTime(dateTime, "HH:mm")

    // e.g. "Saturday, July 25"
    readonly property string date: Qt.formatDate(dateTime, "dddd, MMMM d")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.dateTime = new Date()
    }
}
