pragma Singleton

import Quickshell
import Quickshell.Io

// Wraps cliphist (paired with wl-clipboard) for clipboard history: listing
// entries, searching/sorting/filtering that list, selecting an old entry
// back onto the clipboard, deleting entries, and decoding images for
// preview. No UI of its own — a future component binds to `entries` and
// calls the functions below.
//
//   Clipboard.refresh()
//   Clipboard.searchQuery = "foo"
//   Clipboard.sortMode = "alphabetic"; Clipboard.sortOrder = "asc"
//   Clipboard.filter = "image"
//   ... Clipboard.entries ...       // filtered/sorted, ready to display
//   ... Clipboard.totalCount ...    // unfiltered count, for pagination
//
//   Clipboard.select(id)            // re-copies that entry to the clipboard
//   Clipboard.remove(id)
//   Clipboard.clear()
//   Clipboard.requestImagePreview(id)
//   Clipboard.imagePreviewReady.connect((id, path) => ...)
Singleton {
    id: root

    // --- raw data ------------------------------------------------------
    // Parsed straight from `cliphist list`, unfiltered and in whatever
    // order cliphist returned (newest first, in practice). Everything
    // else below is derived from this.
    property var _rawEntries: [] // [{ id, preview, isImage, _rawLine }]

    readonly property int totalCount: _rawEntries.length

    // --- query controls --------------------------------------------------
    // "content or number": a query matches either the preview text
    // (case-insensitive substring) or the entry's id — so typing "42"
    // finds both an entry #42 and any entry whose text contains "42".
    property string searchQuery: ""

    // "asc" | "desc"
    property string sortOrder: "desc"
    // "numeric" (by id) | "alphabetic" (by preview text)
    property string sortMode: "numeric"
    // "all" | "text" | "image"
    property string filter: "all"

    readonly property var entries: _computeEntries()

    function refresh() {
        listProcess.running = true;
    }

    // Re-copies an existing entry's content onto the clipboard, same as
    // picking it in cliphist's own rofi/wofi integration. cliphist decode
    // takes no positional argument — like `delete`, it reads `<id>\t...`
    // from stdin and only looks at the part before the first tab, so the
    // id needs to be piped in with a trailing tab, not passed as an arg.
    function select(id) {
        _runShellTracked(mutateProcess, "printf '%s\\t' " + _shellQuote(String(id)) + " | cliphist decode | wl-copy");
    }

    // cliphist's `delete` reads the exact line `list` produced for that
    // entry from stdin — it doesn't take a bare id as an argument. Piping
    // the id alone would silently no-op, so this keeps the original raw
    // line around per-entry specifically to feed back in here.
    function remove(id) {
        const entry = _rawEntries.find(e => e.id === id);
        if (!entry)
            return;

        _runShellTracked(mutateProcess, "printf '%s' " + _shellQuote(entry._rawLine) + " | cliphist delete");
    }

    function clear() {
        _runShellTracked(mutateProcess, "cliphist wipe");
    }

    // --- image preview ------------------------------------------------
    // Decodes an image entry to a cache file and reports the path via
    // imagePreviewReady, for an Image element to point at. Requests are
    // processed one at a time (a small FIFO queue) rather than spawning a
    // process per request.
    signal imagePreviewReady(string id, string path)
    signal imagePreviewFailed(string id, string reason)

    property var _imageQueue: []
    property string _cacheDir: Quickshell.env("HOME") + "/.cache/quickshell/clipboard-previews"

    function requestImagePreview(id) {
        const entry = _rawEntries.find(e => e.id === id);
        if (!entry) {
            imagePreviewFailed(id, "unknown entry");
            return;
        }
        if (!entry.isImage) {
            imagePreviewFailed(id, "not an image entry");
            return;
        }

        _imageQueue.push(id);
        _pumpImageQueue();
    }

    function _pumpImageQueue() {
        if (imageProcess.running || _imageQueue.length === 0)
            return;

        const id = _imageQueue.shift();
        const entry = _rawEntries.find(e => e.id === id);
        if (!entry) {
            imagePreviewFailed(id, "entry no longer exists");
            _pumpImageQueue();
            return;
        }

        const path = _cacheDir + "/" + id + "." + entry._imageExt;
        imageProcess._currentId = id;
        imageProcess._currentPath = path;
        // Same stdin form as select()/remove() — decode has no id argument.
        _runShellTracked(imageProcess, "mkdir -p " + _shellQuote(_cacheDir) + " && printf '%s\\t' " + _shellQuote(String(id)) + " | cliphist decode > " + _shellQuote(path));
    }

    // --- parsing / derived view --------------------------------------------
    function _computeEntries() {
        let list = _rawEntries;

        if (filter === "text")
            list = list.filter(e => !e.isImage);
        else if (filter === "image")
            list = list.filter(e => e.isImage);

        const query = searchQuery.trim().toLowerCase();
        if (query.length > 0) {
            list = list.filter(e => String(e.id).includes(query) || e.preview.toLowerCase().includes(query));
        }

        list = list.slice().sort((a, b) => {
            let cmp;
            if (sortMode === "alphabetic")
                cmp = a.preview.localeCompare(b.preview);
            else
                cmp = a.id - b.id;
            return sortOrder === "asc" ? cmp : -cmp;
        });

        return list;
    }

    // cliphist marks non-text entries in `list` output with something
    // like "[[ binary data ... png ... ]]" rather than printing their
    // bytes. Capturing the extension here (not just detecting "binary")
    // means the cache file in _pumpImageQueue gets a real matching
    // extension instead of always guessing .png. Wording/format here is
    // version-dependent — check against `cliphist list` on your system if
    // entries aren't classified as expected.
    function _imageExtension(preview) {
        const m = /binary.*\b(jpe?g|png|bmp|gif|webp)\b/i.exec(preview);
        return m ? m[1].toLowerCase() : null;
    }

    function _parseLine(line) {
        const tabIndex = line.indexOf("\t");
        if (tabIndex === -1)
            return null;

        const id = parseInt(line.slice(0, tabIndex), 10);
        const preview = line.slice(tabIndex + 1);
        if (isNaN(id))
            return null;

        const imageExt = _imageExtension(preview);

        return {
            id: id,
            preview: preview,
            isImage: imageExt !== null,
            _imageExt: imageExt || "png",
            _rawLine: line
        };
    }

    function _shellQuote(str) {
        return "'" + String(str).replace(/'/g, "'\\''") + "'";
    }

    function _runShellTracked(process, shellCommand) {
        process.command = ["sh", "-c", shellCommand];
        process.running = true;
    }

    Process {
        id: listProcess
        command: ["cliphist", "list"]

        stdout: StdioCollector {
            onStreamFinished: {
                root._rawEntries = text.split("\n").filter(line => line.length > 0).map(root._parseLine).filter(entry => entry !== null);
            }
        }
    }

    // Reused for select/remove/clear — running them through a tracked
    // Process (rather than Quickshell.execDetached) means refresh() only
    // fires once cliphist has actually finished mutating its history, not
    // immediately on launch. Not queued like the image requests below:
    // firing a second one while the first is still running overwrites
    // `command` on an already-running Process. Fine for a single user
    // clicking one entry at a time; worth a proper queue if that stops
    // being true.
    Process {
        id: mutateProcess
        onExited: root.refresh()
    }

    Process {
        id: imageProcess
        property string _currentId: ""
        property string _currentPath: ""

        onExited: exitCode => {
            if (exitCode === 0)
                root.imagePreviewReady(_currentId, _currentPath);
            else
                root.imagePreviewFailed(_currentId, "cliphist decode exited with code " + exitCode);

            root._pumpImageQueue();
        }
    }

    // No Component.onCompleted here — Singleton doesn't fire it. Whatever
    // first uses this service (ClipboardOptions.qml's own onCompleted, in
    // practice) is responsible for calling refresh() to populate entries
    // initially.
}
