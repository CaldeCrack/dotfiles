pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Files
// ------
// Wraps `find <dir> -maxdepth 1 -mindepth 1` for the launcher's "$" mode.
// Structurally a near-copy of Calc.qml — same debounce/watchdog/kill-and-
// restart shape, because the same failure modes apply: a hung process
// (permission-denied directories, weird mounts) or an unread stderr
// stream can block indefinitely just as easily here as with qalc.
//
// Deliberately side-effect-free to read, same split as Calc: listDirectory()
// is the only thing that triggers a new `find` invocation. Launcher.qml
// only calls it when the resolved directory actually changes — filtering
// by the typed substring within that directory is pure synchronous JS
// over `entries`, same as apps-mode filtering over DesktopEntries.

Singleton {
    id: root

    property string directory: ""
    property var entries: []   // [{ name, isDir, path }]
    property bool listing: false
    property bool errored: false
    property string errorMessage: ""

    signal resultReady

    function listDirectory(dir) {
        root.directory = dir;
        root.listing = true;
        root.errored = false;
        debounce.restart();
    }

    Item {
        Timer {
            id: debounce
            // Much shorter than Calc's 200ms — this only fires on directory
            // changes, not every keystroke (filtering within a directory is
            // synchronous JS, no process involved), so there's no typing-speed
            // flood to guard against. This just coalesces rapid folder-to-
            // folder navigation in quick succession.
            interval: 80
            onTriggered: root._run()
        }

        // Same hard ceiling as Calc's watchdog, and for the same reason: a
        // permission-denied directory, a stalled network mount, or an unread
        // stderr pipe filling up can all leave `find` never exiting on its
        // own. This guarantees the UI recovers regardless of which one it is.
        Timer {
            id: watchdog
            interval: 3000
            onTriggered: {
                if (findProcess.running)
                    findProcess.running = false;
                root.listing = false;
                root.errored = true;
                root.errorMessage = "Timed out reading this folder";
                root.entries = [];
                root.resultReady();
            }
        }
    }

    function _run() {
        if (findProcess.running) {
            // Kill the stale run rather than waiting on it — see Calc.qml
            // for why passive waiting doesn't recover from a genuine hang.
            findProcess.running = false;
            Qt.callLater(() => root._startProcess());
            return;
        }
        root._startProcess();
    }

    function _startProcess() {
        _stdoutDone = false;
        _stderrDone = false;
        findProcess.command = ["find", root.directory, "-maxdepth", "1", "-mindepth", "1", "-printf", "%y\t%f\n"];
        findProcess.running = true;
        watchdog.restart();
    }

    // stdout and stderr finish as two independent streams — processing
    // results as soon as stdout closes risks reading stderr before it's
    // actually done being written. Both have to report done before the
    // permission-error-detection logic below (which reads stderr) runs.
    property bool _stdoutDone: false
    property bool _stderrDone: false

    function _maybeFinish() {
        if (!root._stdoutDone || !root._stderrDone)
            return;
        root._stdoutDone = false;
        root._stderrDone = false;
        watchdog.stop();
        root.listing = false;

        const stderrText = stderrCollector.text.trim();
        const lines = stdoutCollector.text.split("\n").filter(line => line.length > 0);

        if (lines.length === 0 && stderrText.length > 0) {
            // find produced nothing and complained on stderr — almost
            // always a permission error or a path that doesn't exist.
            // Surface that rather than silently showing an empty folder.
            root.errored = true;
            root.errorMessage = stderrText;
            root.entries = [];
            root.resultReady();
            return;
        }

        let parsed = [];
        const base = root.directory.replace(/\/+$/, "");
        for (let i = 0; i < lines.length; i++) {
            const tabIndex = lines[i].indexOf("\t");
            if (tabIndex === -1)
                continue; // malformed line, skip defensively
            const typeChar = lines[i].slice(0, tabIndex);
            const name = lines[i].slice(tabIndex + 1);
            parsed.push({
                name: name,
                isDir: typeChar === "d",
                path: base + "/" + name
            });
        }

        root.errored = false;
        root.errorMessage = "";
        root.entries = parsed;
        root.resultReady();
    }

    Process {
        id: findProcess
        running: false

        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                root._stdoutDone = true;
                root._maybeFinish();
            }
        }

        // Collected (not ignored) for the same reason as Calc.qml: an
        // unread stderr stream can fill the OS pipe buffer and block the
        // child process indefinitely if it ever writes enough to it.
        stderr: StdioCollector {
            id: stderrCollector
            onStreamFinished: {
                root._stderrDone = true;
                root._maybeFinish();
            }
        }
    }
}
