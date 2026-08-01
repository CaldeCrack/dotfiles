pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

// Thin wrapper around Quickshell's Pipewire integration. Volume is
// exposed as 0-100 here (matching VerticalSlider/VolumePopup's existing
// scale) rather than Pipewire's native 0.0-1.0 float — the conversion
// happens in this one place so nothing downstream needs to care.
//
// PwObjectTracker below is NOT optional. Pipewire nodes are created and
// destroyed dynamically as the audio graph changes (devices plugged in,
// apps opened/closed) — without tracking, the node references held here
// could be garbage-collected out from under us while still in use. This
// is Quickshell's own documented pattern for this, not a style choice.
Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool ready: sink?.ready ?? false
    readonly property bool muted: sink?.audio?.muted ?? true
    readonly property real volume: (sink?.audio?.volume ?? 0) * 100

    // Raw material for the output-device selector — every sink node on
    // the system. isSink + a non-null audio block filters out
    // source-only and non-audio nodes.
    //
    // .values is required, not optional — Pipewire.nodes is an
    // ObjectModel (same as Mpris.players elsewhere in this project), and
    // calling .filter() directly on an ObjectModel doesn't work the way
    // it would on a plain array; .values is Quickshell's documented way
    // to view one reactively as a real list.
    readonly property var availableSinks: Pipewire.nodes.values.filter(node => node.isSink && node.audio !== null && node.properties?.["device.api"] === "alsa")

    // --- Icon selection: headphones vs speaker ------------------------------
    //
    // There's no direct "is this headphones" boolean on PwNode. Best
    // available signal is the device.form-factor Pipewire property (when
    // present — it's not guaranteed to be set depending on the driver/
    // backend), with a text search over description/nickname/name as a
    // fallback for cases where it's missing. Defaults to speaker on any
    // inconclusive result, since misclassifying headphones as a speaker
    // icon is a smaller mistake than the reverse for most setups.
    function isHeadphoneNode(node) {
        if (!node)
            return false;
        const formFactor = (node.properties?.["device.form-factor"] || "").toLowerCase();
        if (formFactor.includes("headphone") || formFactor.includes("headset"))
            return true;
        const text = `${node.description || ""} ${node.nickname || ""} ${node.name || ""}`.toLowerCase();
        return text.includes("headphone") || text.includes("headset");
    }

    function iconNameForSink(node) {
        return isHeadphoneNode(node) ? "media/headphones" : "media/speaker";
    }

    function setVolume(percent) {
        if (!sink?.ready || !sink?.audio)
            return;
        const clamped = Math.max(0, Math.min(100, percent));
        // Unmuting on volume change matches how most volume sliders
        // behave — dragging the slider is an unambiguous "I want sound"
        // signal, even if it was muted a moment ago.
        sink.audio.muted = false;
        sink.audio.volume = clamped / 100;
    }

    function toggleMuted() {
        if (sink?.ready && sink?.audio)
            sink.audio.muted = !sink.audio.muted;
    }

    // For the output device selector, once that's built — swaps
    // Pipewire's preferred default sink, which is a hint; the actual
    // defaultAudioSink may briefly lag or differ if Pipewire can't honor
    // it immediately.
    function setDefaultSink(node) {
        Pipewire.preferredDefaultAudioSink = node;
    }

    PwObjectTracker {
        objects: [root.sink, root.source, ...root.availableSinks]
    }
}
