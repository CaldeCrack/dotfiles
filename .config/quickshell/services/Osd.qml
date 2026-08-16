pragma Singleton

import QtQuick
import Quickshell

// Central OSD state — the one thing every "flash a value on screen"
// consumer (volume, brightness, caps/num lock) feeds into, and the one
// thing the OSD window reads from. Deliberately much simpler than
// Notifications.qml: no history, no persistence — just "what's showing
// right now."
//
// This file is the integration point, not Audio/Brightness/InputLocks
// themselves — those stay exactly as given, with no idea an OSD exists.
// Osd.qml watches their state via Connections and decides what counts as
// "worth flashing," which keeps the actual state-tracking services
// focused purely on "what is true right now."
//
// current is either null (hidden) or one of:
//   { kind: "volume",     mode: "level",   value, muted, iconName }
//   { kind: "brightness", mode: "level",   value, iconName }
//   { kind: "capslock",   mode: "boolean", active, label }
//   { kind: "numlock",    mode: "boolean", active, label }
//
// `mode` is what OsdIndicator actually switches its layout on — see that
// file. `kind` is carried along for anything that wants to branch on the
// specific source (logging, per-kind styling later, etc.).
Singleton {
    id: root

    readonly property int autoHideMs: 1500

    property var current: null

    function show(payload) {
        root.current = payload;
        _hideTimer.restart();
    }

    Timer {
        id: _hideTimer
        interval: root.autoHideMs
        onTriggered: root.current = null
    }

    // -----------------------------------------------------------------
    // Baseline gate
    // -----------------------------------------------------------------
    // Every watched property fires its changed signal once at startup as
    // each service resolves its initial real value (Pipewire connecting,
    // the backlight/LED sysfs paths resolving) — that first sync isn't a
    // user action and shouldn't pop an OSD.
    //
    // Gated on each service's own `ready` becoming true, not a fixed
    // delay — an earlier version of this used Qt.callLater to defer one
    // tick before accepting changes, but Pipewire/sysfs resolution
    // reliably takes longer than that single tick, so the gate was
    // opening before the real initial value ever arrived, and that
    // arrival got shown as if it were a user action. Waiting for the
    // actual readiness signal (checked both for "already ready by the
    // time this loads" and "becomes ready later") ties the gate to what
    // it's actually meant to detect instead of guessing at timing.
    property bool _audioBaselined: false
    property bool _brightnessBaselined: false
    property bool _locksBaselined: false

    Component.onCompleted: {
        if (Audio.ready) root._audioBaselined = true;
        if (Brightness.ready) root._brightnessBaselined = true;
        if (InputLocks.ready) root._locksBaselined = true;
    }

    Connections {
        target: Audio
        function onReadyChanged() {
            if (Audio.ready)
                Qt.callLater(() => root._audioBaselined = true);
        }
        function onVolumeChanged() {
            if (root._audioBaselined)
                root.show({ kind: "volume", mode: "level", value: Audio.volume, muted: Audio.muted, iconName: Audio.currentVolumeIcon });
        }
        function onMutedChanged() {
            if (root._audioBaselined)
                root.show({ kind: "volume", mode: "level", value: Audio.volume, muted: Audio.muted, iconName: Audio.currentVolumeIcon });
        }
    }

    // ---- brightness ----
    // No per-level icon variants the way volume has (Brightness.qml
    // exposes a flat percentage, nothing to switch on) — one constant
    // icon.
    Connections {
        target: Brightness
        function onReadyChanged() {
            if (Brightness.ready)
                Qt.callLater(() => root._brightnessBaselined = true);
        }
        function onBrightnessChanged() {
            if (root._brightnessBaselined)
                root.show({ kind: "brightness", mode: "level", value: Brightness.brightness, iconName: "display/brightness" });
        }
    }

    // ---- caps / num lock ----
    Connections {
        target: InputLocks
        function onReadyChanged() {
            if (InputLocks.ready)
                Qt.callLater(() => root._locksBaselined = true);
        }
        function onCapsLockOnChanged() {
            if (root._locksBaselined)
                root.show({ kind: "capslock", mode: "boolean", active: InputLocks.capsLockOn, label: "Caps Lock" });
        }
        function onNumLockOnChanged() {
            if (root._locksBaselined)
                root.show({ kind: "numlock", mode: "boolean", active: InputLocks.numLockOn, label: "Num Lock" });
        }
    }
}
