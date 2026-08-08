pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Owns everything about a single wf-recorder invocation: what to record,
// whether audio is captured, and the actual running process — so any
// part of the shell (this popup, a tray icon, a keybind) can start/stop
// a recording and read its state without knowing wf-recorder's command
// line itself.
//
//   Recording.start("region")
//   Recording.stop()
//   Recording.toggleAudio()
//
//   if (Recording.recording) { ... Recording.elapsedSeconds ... }
//   Recording.recordingStarted.connect(...)
Singleton {
    id: root

    // --- configuration ---------------------------------------------------
    // Toggled from the popup's Audio row; read by start() when composing
    // the wf-recorder invocation. Not persisted to config.json — promote
    // it there (via Settings/ConfigLoader) if you want it remembered
    // across restarts instead of defaulting off each time.
    property bool audioEnabled: false
    property string audioSource: "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"

    // --- state -------------------------------------------------------------
    readonly property bool recording: process.running
    readonly property string mode: _mode // "screen" | "region" | "" (idle)
    readonly property string outputPath: _outputPath
    readonly property int elapsedSeconds: _elapsedSeconds

    property string _mode: ""
    property string _outputPath: ""
    property int _elapsedSeconds: 0

    // --- signals -----------------------------------------------------------
    // `recording`/`mode`/`outputPath` already reflect current state as
    // plain properties — bind to those for UI (a tray icon, a status
    // label). These signals are for one-shot reactions a binding doesn't
    // fit well: a toast with the saved path on stop, a sound on start.
    signal recordingStarted(string mode, string path)
    signal recordingStopped(string path)
    signal recordingFailed(string reason)

    Item {
        IpcHandler {
            target: "recording"

            function toggleScreen(): void {
                if (!root.recording)
                    root.start("screen");
                else
                    root.stop();
            }

            function toggleRegion(): void {
                if (!root.recording)
                    root.start("region");
                else
                    root.stop();
            }
        }
    }

    function toggleAudio() {
        audioEnabled = !audioEnabled;
    }

    // mode: "screen" | "region"
    function start(mode) {
        if (recording) {
            recordingFailed("already recording");
            return;
        }

        _mode = mode;
        _outputPath = Quickshell.env("HOME") + "/Videos/recording_" + _timestamp() + ".mp4";

        const audioArg = audioEnabled ? " --audio=" + audioSource : "";

        if (mode === "region") {
            // slurp needs a real shell to expand $(...) — everything else
            // here is a plain argv list, so this is the one case that
            // goes through sh -c.
            process.command = ["sh", "-c", "wf-recorder -g \"$(slurp)\" -c libx264rgb -f '" + _outputPath + "'" + audioArg];
        } else {
            const args = ["wf-recorder", "-c", "libx264rgb", "-f", _outputPath];
            if (audioEnabled)
                args.push("--audio=" + audioSource);
            process.command = args;
        }

        process.running = true;
    }

    function stop() {
        if (!recording)
            return;

        // ASSUMPTION TO VERIFY: setting Process.running = false is
        // expected to send SIGTERM (a clean stop wf-recorder finalizes
        // the mp4 on), not SIGKILL (which would leave a corrupt file).
        // Check this against your Quickshell version's Process docs
        // before relying on it — if it does hard-kill, this needs to
        // track the process's pid instead and shell out `kill -INT
        // <pid>` explicitly.
        process.running = false;
    }

    function _timestamp() {
        const d = new Date();
        const pad = n => (n < 10 ? "0" : "") + n;
        return d.getFullYear() + "-" + pad(d.getMonth() + 1) + "-" + pad(d.getDate()) + "_" + pad(d.getHours()) + "-" + pad(d.getMinutes()) + "-" + pad(d.getSeconds());
    }

    Process {
        id: process

        onRunningChanged: {
            if (running) {
                root._elapsedSeconds = 0;
                elapsedTimer.start();
                root.recordingStarted(root._mode, root._outputPath);
            } else {
                elapsedTimer.stop();
                root.recordingStopped(root._outputPath);
                root._mode = "";
            }
        }
    }

    Timer {
        id: elapsedTimer
        interval: 1000
        repeat: true
        onTriggered: root._elapsedSeconds += 1
    }
}
