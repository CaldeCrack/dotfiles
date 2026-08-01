pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

// Runs cava as a subprocess and parses its raw-ascii output into a plain
// array of 0..1 bar levels. Deliberately knows nothing about HOW the data
// gets drawn — AudioVisualizerRing and AudioVisualizerBars both just read
// `bars` and render it differently, so switching between them (via `mode`
// below) is a rendering choice, not a re-plumb of this file.
//
// Config lives at services/cava/cava.conf, checked into the project
// rather than generated at runtime — edit it directly for now.
Singleton {
    id: root

    // --- external gating ----------------------------------------------------
    //
    // This is a singleton and has no way to know on its own whether the
    // music tab is currently visible — that's UI state, not service
    // state. MusicTab is expected to bind this to its own `visible`
    // property. Combined with Media.isPlaying, this is what actually
    // gates the subprocess: no point running cava's FFT work when
    // nothing's showing it, or nothing's playing.
    property bool tabVisible: false

    readonly property bool shouldRun: tabVisible && Media.isPlaying

    // "ring" (around the artwork) or "bars" (flat strip in the
    // background) — which renderer MusicTab should show. Doesn't affect
    // this file's own behavior at all; just forwarded state so both
    // renderers can exist side by side and the tab picks one.
    property string mode: "ring"

    readonly property int barCount: 32
    property var bars: [] // length barCount once running, each 0..1

    readonly property string configPath: Quickshell.shellDir + "/services/cava/cava.conf"

    Process {
        id: cavaProcess
        command: ["cava", "-p", root.configPath]
        running: root.shouldRun

        stdout: SplitParser {
            onRead: data => {
                if (!data || !root.shouldRun)
                    return;
                const raw = data.split(";").filter(v => v.length > 0);
                root.bars = raw.map(v => Math.max(0, Math.min(1, parseInt(v, 10) / 255)));
            }
        }
    }

    // Zero out immediately when gating turns off, rather than waiting for
    // the process to actually stop — avoids the last real frame hanging
    // visibly on screen right as playback pauses or the tab closes.
    onShouldRunChanged: {
        if (!shouldRun)
            bars = [];
    }
}
