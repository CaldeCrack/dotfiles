import QtQuick
import Quickshell
import Quickshell.Io

// Shared machinery behind Emoji.qml and NerdFont.qml: load a generated
// JSON array from assets/data/, search/filter it, re-run the script that
// generates it, and copy a selected entry's character to the clipboard.
//
// NOT itself a Singleton — Emoji.qml/NerdFont.qml each instantiate this
// as their own root type with the bits that differ filled in:
//
//   // Emoji.qml
//   pragma Singleton
//   import Quickshell
//   DataPicker {
//       dataPath: Quickshell.shellDir + "/assets/data/emojis.json"
//       fetchScript: Quickshell.shellDir + "/services/scripts/fetch-emoji-data.sh"
//       searchFields: ["name", "keywords", "category"]
//   }
Item {
    id: root

    // --- configuration, set by the concrete picker -----------------------
    property string dataPath: ""
    property string fetchScript: ""
    // Entry fields checked against searchQuery. A field can be a plain
    // string (substring match) or an array of strings (matches if any
    // element does) — covers Emoji's `keywords` array and NerdFont's
    // plain `name`/`code` strings without needing a per-picker override.
    property var searchFields: ["name"]

    // --- data ---------------------------------------------------------
    property var _rawEntries: []
    readonly property int totalCount: _rawEntries.length

    property string searchQuery: ""
    readonly property var entries: _computeEntries()

    // --- fetch state -----------------------------------------------------
    property bool fetching: false
    property string lastFetchLog: ""
    // The data file's actual mtime, queried by refresh() (which also
    // means it's populated on first load, not just after an explicit
    // fetch()) — this answers "when was the data on disk last
    // regenerated", surviving shell restarts, rather than "when did this
    // session last click Fetch". null if the file doesn't exist yet or
    // the stat failed.
    property var lastFetchedAt: null

    signal fetchCompleted(int count)
    signal fetchFailed(string reason)

    // No Component.onCompleted here — like Clipboard.qml, this ends up as
    // the root object of a pragma Singleton file, and Singleton doesn't
    // fire it. Whatever view first shows this data is responsible for
    // calling refresh() itself (see ClipboardOptions.qml's own
    // onCompleted for the established pattern).
    function refresh() {
        loadProcess.command = ["cat", dataPath];
        loadProcess.running = true;

        // `stat -c %Y` is GNU coreutils syntax (Linux) — fine for the
        // Arch/Hyprland target here, but not portable to BSD/macOS stat
        // if this shell ever runs there. 2>/dev/null so a missing file
        // (never fetched yet) just yields empty output instead of stderr
        // noise, handled below by the NaN check.
        statProcess.command = ["sh", "-c", "stat -c %Y " + _shellQuote(dataPath) + " 2>/dev/null"];
        statProcess.running = true;
    }

    // Re-runs the generator script (fetch-emoji-data.sh /
    // fetch-nerdfont-data.sh) and reloads once it finishes. Invoked via
    // `bash <script>` rather than executing the file directly — file
    // transfers/clones don't reliably preserve the executable bit, and
    // this sidesteps depending on it.
    function fetch() {
        if (fetching)
            return;

        fetching = true;
        fetchProcess.command = ["bash", fetchScript];
        fetchProcess.running = true;
    }

    function select(char) {
        Quickshell.execDetached(["sh", "-c", "printf '%s' " + _shellQuote(char) + " | wl-copy"]);
    }

    function _computeEntries() {
        const query = searchQuery.trim().toLowerCase();
        if (query.length === 0)
            return _rawEntries;

        return _rawEntries.filter(entry => _matchesQuery(entry, query));
    }

    function _matchesQuery(entry, query) {
        for (const field of searchFields) {
            const value = entry[field];
            if (value === undefined || value === null)
                continue;

            if (Array.isArray(value)) {
                if (value.some(v => String(v).toLowerCase().includes(query)))
                    return true;
            } else if (String(value).toLowerCase().includes(query)) {
                return true;
            }
        }
        return false;
    }

    function _shellQuote(str) {
        return "'" + String(str).replace(/'/g, "'\\''") + "'";
    }

    // Loading goes through `cat` + a tracked Process rather than a direct
    // file read, since that's the file-reading approach already proven to
    // work in this shell (Clipboard.qml's `cliphist list`). FileView's
    // plain-text-read mode (as opposed to the JsonAdapter fixed-schema
    // mode Colors.qml/ConfigLoader.qml use, which doesn't fit an
    // arbitrary JSON array) isn't something we'd actually verified here —
    // swap to it if you confirm that API on your Quickshell version and
    // prefer it over an extra process spawn.
    Process {
        id: loadProcess

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root._rawEntries = JSON.parse(text);
                } catch (e) {
                    console.log("DataPicker: failed to parse " + root.dataPath + ":", e);
                    root._rawEntries = [];
                }
            }
        }
    }

    Process {
        id: statProcess

        stdout: StdioCollector {
            onStreamFinished: {
                const seconds = parseInt(text.trim(), 10);
                root.lastFetchedAt = isNaN(seconds) ? null : new Date(seconds * 1000);
            }
        }
    }

    Process {
        id: fetchProcess

        stdout: StdioCollector {
            onStreamFinished: root.lastFetchLog = text
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.length > 0)
                    root.lastFetchLog += "\n" + text;
            }
        }

        onExited: exitCode => {
            root.fetching = false;

            if (exitCode === 0) {
                // refresh() re-queries the mtime too, so lastFetchedAt
                // ends up reflecting the file's real, just-updated
                // timestamp rather than "whenever this function ran".
                root.refresh();
                root.fetchCompleted(root.totalCount);
            } else {
                root.fetchFailed("fetch script exited with code " + exitCode);
            }
        }
    }
}
