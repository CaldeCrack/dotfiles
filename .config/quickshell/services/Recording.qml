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
//
// --- why capture RGB and transcode afterwards -------------------------
// wf-recorder's default yuv420/yuv422 encode visibly shifts colors vs
// what's on screen. libx264rgb fixes that, but it's lossless-only (huge
// files, and lossless H.264 doesn't play back everywhere/upload cleanly
// to most platforms). Feeding libx264 yuv444p directly, instead of via
// rgb24, produces a blurrier image than either of the above even though
// it should be a lossless-equivalent conversion — this looks like an
// encoder/filter quirk rather than anything we're doing wrong:
//   https://github.com/ammen99/wf-recorder/issues/147 (and follow-ups)
// The two-step approach below is the documented workaround: record
// losslessly in RGB in real time (cheap, keeps up with the screen), then
// let ffmpeg transcode that to a normal, shareable yuv444p/libx264 file
// once recording stops, when we're no longer racing the compositor.
Singleton {
    id: root

    // --- configuration ---------------------------------------------------
    // Toggled from the popup's Audio row; read by start() when composing
    // the wf-recorder invocation. Not persisted to config.json — promote
    // it there (via Settings/ConfigLoader) if you want it remembered
    // across restarts instead of defaulting off each time.
    property bool audioEnabled: false
    property string audioSource: "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"

    // Quality/speed knobs for the *post-process* pass only. The capture
    // pass is always qp=0 (lossless) since it has to keep up in real
    // time; these control the final, shareable output.
    property int postProcessCrf: 18
    property string postProcessPreset: "medium"
    // yuv420p, not yuv444p: 4:4:4 needs the "High 4:4:4 Predictive" H.264
    // profile, which basically only desktop software decoders (mpv,
    // ffplay, VLC) support. Phone hardware decoders, browsers, and
    // Discord's own player expect 4:2:0 — a 4:4:4 file plays fine locally
    // and looks corrupted (or refuses to play) everywhere else, even on
    // a plain download, since nothing is transcoding it in between; the
    // decoder is just choking on a profile it doesn't implement. Going
    // from the lossless RGB source through a normal offline ffmpeg
    // conversion to yuv420p doesn't reintroduce the blur from the GitHub
    // thread — that was specific to wf-recorder's realtime capture path,
    // not an ffmpeg format conversion. Some chroma detail is lost vs.
    // 4:4:4, but it's the universally-playable trade to make.
    property string postProcessPixFmt: "yuv420p"

    // --- state -------------------------------------------------------------
    // `starting` covers the gap between "process spawned" and "wf-recorder
    // has actually opened the output and begun encoding frames" — codec
    // init, region selection via slurp, etc. all happen in that gap.
    // `recording` only flips once we've seen confirmation in stderr.
    readonly property bool starting: process.running && !_confirmedRecording
    readonly property bool recording: _confirmedRecording
    // True while the post-recording ffmpeg transcode (raw RGB -> shareable
    // yuv444p) is running. The UI should probably show a "finishing up"
    // state during this, since `recording` is already false by then.
    readonly property bool processing: postProcess.running
    readonly property string mode: _mode // "screen" | "region" | "" (idle)
    readonly property string outputPath: _outputPath
    readonly property int elapsedSeconds: _elapsedSeconds

    property bool _confirmedRecording: false
    property string _mode: ""
    property string _outputPath: ""
    property string _rawPath: ""
    property int _elapsedSeconds: 0

    // --- signals -----------------------------------------------------------
    // `recording`/`starting`/`processing`/`mode`/`outputPath` already
    // reflect current state as plain properties — bind to those for UI (a
    // tray icon, a status label). These signals are for one-shot reactions
    // a binding doesn't fit well: a toast with the saved path once the
    // final file is actually ready, a sound on start.
    signal recordingStarted(string mode, string path)
    // Fires once the *final*, shareable file at `path` is ready — i.e.
    // after the post-process transcode finishes, not when wf-recorder
    // itself exits. Use `processing` if you need to show an in-between
    // "wrapping up" state.
    signal recordingStopped(string path)
    signal recordingFailed(string reason)
    signal postProcessFailed(string reason)

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
        if (recording || starting) {
            recordingFailed("already recording");
            return;
        }

        _mode = mode;
        _confirmedRecording = false;

        const ts = _timestamp();
        // Intermediate lossless RGB capture — never shown to the user,
        // cleaned up once the transcode succeeds.
        _rawPath = Quickshell.env("HOME") + "/Videos/.recording_" + ts + "_raw.mkv";
        _outputPath = Quickshell.env("HOME") + "/Videos/recording_" + ts + ".mp4";

        const audioArg = audioEnabled ? " --audio=" + audioSource : "";
        // qp=0 (lossless) + ultrafast/zerolatency: preset only trades
        // encode speed for compression efficiency, not quality, so at
        // qp=0 there's no quality reason to use a slower preset — and a
        // slower one risks not keeping up with real-time capture.
        const captureOpts = "-F format=rgb24 -x rgb24 -c libx264rgb -p qp=0 -p preset=ultrafast -p tune=zerolatency";

        if (mode === "region") {
            // slurp needs a real shell to expand $(...) — everything else
            // here is a plain argv list, so this is the one case that
            // goes through sh -c.
            process.command = ["sh", "-c", "wf-recorder -g \"$(slurp)\" " + captureOpts + " -f '" + _rawPath + "'" + audioArg];
        } else {
            const args = ["wf-recorder", "-F", "format=rgb24", "-x", "rgb24", "-c", "libx264rgb", "-p", "qp=0", "-p", "preset=ultrafast", "-p", "tune=zerolatency", "-f", _rawPath];
            if (audioEnabled)
                args.push("--audio=" + audioSource);
            process.command = args;
        }

        process.running = true;
    }

    function stop() {
        if (!process.running)
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

    function _startPostProcess() {
        const args = ["ffmpeg", "-y", "-i", _rawPath, "-c:v", "libx264", "-crf", String(postProcessCrf), "-preset", postProcessPreset, "-vf", "format=" + postProcessPixFmt,
            // Belt-and-suspenders alongside the -vf format filter above:
            // -pix_fmt makes sure the muxer actually signals yuv420p to
            // the container/decoder rather than relying on the filter
            // output being picked up implicitly.
            "-pix_fmt", postProcessPixFmt,
            // Pin to a profile/level every hardware decoder we care about
            // (phones, browsers, Discord's player) understands, rather
            // than whatever libx264 would auto-pick.
            "-profile:v", "high", "-level", "4.1"];
        if (audioEnabled)
            args.push("-c:a", "copy");
        args.push("-movflags", "+faststart", _outputPath);

        postProcess.command = args;
        postProcess.running = true;
    }

    Process {
        id: process

        stderr: SplitParser {
            // wf-recorder logs like ffmpeg does, to stderr. This line
            // (from libav's av_dump_format) is printed once the output
            // container is actually open and about to receive frames —
            // the closest reliable signal that recording has *really*
            // started, as opposed to the process merely having launched
            // (codec setup, slurp's region selection, etc. all happen
            // before this).
            onRead: line => {
                if (!root._confirmedRecording && /^Output #0,/.test(line)) {
                    root._confirmedRecording = true;
                    root._elapsedSeconds = 0;
                    elapsedTimer.start();
                    root.recordingStarted(root._mode, root._outputPath);
                }
            }
        }

        onRunningChanged: {
            if (!running) {
                elapsedTimer.stop();

                if (!root._confirmedRecording) {
                    // Process exited before we ever saw confirmation —
                    // treat as a failed start, not a completed recording.
                    root._mode = "";
                    root.recordingFailed("wf-recorder exited before recording started");
                    return;
                }

                root._confirmedRecording = false;
                root._mode = "";
                root._startPostProcess();
            }
        }
    }

    Process {
        id: postProcess

        onRunningChanged: {
            if (!running) {
                // exitCode isn't available until onExited below on some
                // Quickshell versions; if yours exposes it here instead,
                // move this check up.
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                cleanupRaw.command = ["rm", "-f", root._rawPath];
                cleanupRaw.running = true;
                root.recordingStopped(root._outputPath);
            } else {
                root.postProcessFailed("ffmpeg exited with code " + exitCode);
            }
        }
    }

    Process {
        id: cleanupRaw
    }

    Timer {
        id: elapsedTimer
        interval: 1000
        repeat: true
        onTriggered: root._elapsedSeconds += 1
    }
}
