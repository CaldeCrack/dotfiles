pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Calc
// -----
// Wraps `qalc` (libqalculate's CLI — handles unit conversions, not just
// arithmetic, for free) for the launcher's "=" mode. One-shot process per
// evaluation, debounced so a full qalc invocation doesn't fire on every
// single keystroke while typing an expression.
//
// Deliberately side-effect-free to read: `computing`/`result`/`errored`
// are just state, and `resultReady` fires once qalc's output is parsed.
// The launcher calls evaluate() itself to trigger a computation — reading
// these properties elsewhere never re-triggers one. That separation
// matters: Launcher.qml rebuilds its calc entry both when the query
// changes AND when resultReady fires, and the second case must not call
// evaluate() again or it'd restart the debounce forever.

Singleton {
    id: root

    property string expression: ""
    property string result: ""
    property bool computing: false
    property bool errored: false

    signal resultReady

    function evaluate(expr) {
        root.expression = expr;

        if (!expr || expr.trim().length === 0) {
            root.computing = false;
            root.errored = false;
            root.result = "";
            watchdog.stop();
            if (qalcProcess.running)
                qalcProcess.running = false;
            return;
        }

        root.computing = true;
        root.errored = false;
        debounce.restart();
    }

    Timer {
        id: debounce
        interval: 200
        onTriggered: root._run()
    }

    // Hard ceiling on how long a single evaluation can leave the UI
    // stuck on "Calculating…" — if qalc hangs (e.g. blocked writing to
    // an unread stderr pipe, or some pathological input that makes it
    // wait on stdin) this is what actually unsticks things, rather than
    // relying on the process to ever exit on its own.
    Timer {
        id: watchdog
        interval: 3000
        onTriggered: {
            if (qalcProcess.running)
                qalcProcess.running = false;
            root.computing = false;
            root.errored = true;
            root.result = "";
            root.resultReady();
        }
    }

    function _run() {
        if (qalcProcess.running) {
            // Actively kill the stale run rather than waiting on it — if
            // it was ever going to hang, waiting would just get stuck
            // forever instead of recovering. Qt.callLater defers the
            // restart to the next event-loop tick so the SIGTERM has a
            // moment to actually take effect before we reuse the same
            // Process instance.
            qalcProcess.running = false;
            Qt.callLater(() => root._startProcess());
            return;
        }
        root._startProcess();
    }

    function _startProcess() {
        qalcProcess.command = ["qalc", "-t", root.expression];
        qalcProcess.running = true;
        watchdog.restart();
    }

    Process {
        id: qalcProcess
        running: false

        stdout: StdioCollector {
            id: collector
            onStreamFinished: {
                watchdog.stop();
                root.computing = false;
                const text = collector.text.trim();
                if (text.length === 0) {
                    root.errored = true;
                    root.result = "";
                } else {
                    root.errored = false;
                    root.result = text;
                }
                root.resultReady();
            }
        }

        // Collecting this too, even unused, matters: with only stdout
        // captured, any meaningful output qalc sends to stderr (parse
        // warnings, etc.) can fill the OS pipe buffer with nothing
        // draining it, which blocks the child process indefinitely —
        // a classic subprocess deadlock, and a very plausible cause of
        // "stuck on Calculating… forever."
        stderr: StdioCollector {}
    }
}
