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

    // Raw material for an output-device selector later — every sink node
    // on the system. isSink + a non-null audio block filters out
    // source-only and non-audio nodes.
    readonly property var availableSinks: Pipewire.nodes.values.filter(node => node.isSink && node.audio !== null)

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
