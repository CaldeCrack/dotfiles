import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.services
import qs.widgets

// Launcher
// --------
// Window shell + slide animation + search bar, wired to real results:
// apps mode enumerates installed applications via DesktopEntries, calc
// mode ("=") shells out to qalc via the Calc service, keybind mode ("/")
// searches config/keybinds.json via KeybindsLoader, file mode ("$")
// browses the filesystem via the Files service.

PanelWindow {
    id: launcherWindow

    // ── Public API ──────────────────────────────────────────────
    property bool launcherOpen: false
    function open() {
        launcherOpen = true;
    }
    function close() {
        launcherOpen = false;
    }
    function toggle() {
        launcherOpen = !launcherOpen;
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcherWindow.toggle();
        }
    }

    // ── Fixed card size ──────────────────────────────────────────
    // Deliberately NOT PanelBase — PanelBase auto-sizes to content via
    // childrenRect, which fights a fixed-size requirement. This window
    // hardcodes its own dimensions instead, closer to how SidebarBase
    // treats sidebarWidth as fixed rather than content-driven.
    readonly property int cardWidth: 640
    readonly property int cardHeight: 420

    // Room the card slides through before reaching its resting position.
    // This has to be part of the WINDOW's own bounds, not just an
    // animation value — a layer-shell surface only ever paints what's
    // inside its own buffer (same lesson as PanelBase's shadow margin
    // and Tooltip needing its own PopupWindow). If slideDistance isn't
    // baked into implicitHeight, the card gets hard-clipped the moment
    // it tries to sit below y:0 of this window.
    readonly property int slideDistance: cardHeight + 24
    readonly property int bottomGap: 16

    // No native "anchor to bottom-center" on PanelWindow, so centering
    // happens at the content level: span the full screen width (like
    // DismissablePopup's screen-covering window) and center the card
    // inside via anchors.horizontalCenter, rather than fighting the
    // window's own positioning.
    anchors {
        left: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore // overlay — don't reserve a bar-style strut
    color: "transparent"

    // A PanelWindow accepts no keyboard input by default — that's the
    // whole cause of "typing does nothing, it falls through to whatever's
    // behind the launcher." This is the same fix DismissablePopup already
    // relies on for its Escape handling (see Widgets_reference: "a
    // screen-covering surface with exclusive keyboard focus can,
    // consistently, across compositors"). Exclusive while open grabs all
    // keyboard input for the launcher, same as DismissablePopup does;
    // None while closed releases it immediately rather than waiting on
    // hideTimer, since there's nothing left to type into during the
    // close animation anyway.
    WlrLayershell.keyboardFocus: launcherOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    implicitHeight: cardHeight + slideDistance + bottomGap
    visible: false

    onLauncherOpenChanged: {
        if (launcherOpen) {
            visible = true;
            // Qt.callLater, not a direct call: forceActiveFocus() only
            // does anything once the window is actually mapped and has
            // keyboard focus from the compositor. Calling it synchronously
            // in the same handler that just set visible = true risks
            // running before that's actually true yet.
            Qt.callLater(() => searchBar.forceActiveFocus());
        } else {
            // Keep the surface alive until the close animation finishes,
            // same closed-fires-after-animation contract PanelBase and
            // SidebarBase use — flipping `visible` immediately would cut
            // the slide-down short.
            hideTimer.start();
            // Clear on close, not on next open — otherwise the previous
            // query (and its stale results) would flash for a frame the
            // next time the launcher appears. Setting searchBar.text
            // fires queryChanged, which naturally resets resultsModel
            // back to the unfiltered app list too.
            searchBar.text = "";
        }
    }

    Timer {
        id: hideTimer
        interval: 240 // must match slideTransform's animation duration
        onTriggered: launcherWindow.visible = false
    }

    // qalc runs async (debounced Process, not a synchronous call) — this
    // is what re-renders the calc entry once a result actually comes
    // back, separately from the immediate re-render onQueryChanged
    // already does for the "computing..." placeholder state. Guarded by
    // mode so a slow qalc response can't clobber results after the
    // person has already moved on to a different query/mode.
    Connections {
        target: Calc
        function onResultReady() {
            if (launcherWindow.modeFor(searchBar.text) === "calc") {
                launcherWindow.resultsModel = launcherWindow.buildResultsFor(searchBar.text);
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: launcherWindow.launcherOpen
        onClicked: launcherWindow.close()
    }

    // Same shape as Calc's Connections above, and for the same reason:
    // `find` runs async, so this is what re-renders the file list once a
    // directory listing actually completes, separate from the immediate
    // "Loading..." re-render onQueryChanged already does. Guarded by mode
    // so a slow listing can't clobber results after the person has
    // already switched away from file mode (or navigated further).
    Connections {
        target: Files
        function onResultReady() {
            if (launcherWindow.modeFor(searchBar.text) === "file") {
                launcherWindow.resultsModel = launcherWindow.buildResultsFor(searchBar.text);
            }
        }
    }

    Item {
        id: card
        width: launcherWindow.cardWidth
        height: launcherWindow.cardHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: launcherWindow.bottomGap

        transform: Translate {
            id: slideTransform
            y: launcherWindow.launcherOpen ? 0 : launcherWindow.slideDistance

            Behavior on y {
                NumberAnimation {
                    duration: 240
                    easing.type: Easing.OutCubic
                }
            }
        }

        opacity: launcherWindow.launcherOpen ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 180
            }
        }

        Rectangle {
            id: chrome
            anchors.fill: parent
            radius: 16
            color: Colors.md3.surface
            border.width: 1
            border.color: Colors.md3.outline_variant
        }

        // Item, not Column: results needs to fill whatever height is left
        // after the search bar, and Column has no fill-height concept for
        // children — anchoring is more direct here than fighting spacers.
        Item {
            id: content
            anchors.fill: parent
            anchors.margins: 12

            LauncherSearchBar {
                id: searchBar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                onQueryChanged: query => {
                    // Calc evaluation and file-directory listing are both
                    // triggered here, exactly once per actual text change
                    // — NOT inside buildResultsFor, which also gets called
                    // from the resultReady handlers above to re-render
                    // once qalc/find finish. If those rebuilds also
                    // triggered new work, they'd restart their respective
                    // debounce timers forever.
                    const mode = launcherWindow.modeFor(query);
                    if (mode === "calc") {
                        Calc.evaluate(query.slice(1));
                    } else if (mode === "file") {
                        const parsed = launcherWindow.parseFileQuery(query.slice(1));
                        // Only re-list when the resolved directory actually
                        // changes — typing more filter characters within
                        // the same folder is pure synchronous filtering
                        // over Files.entries, no process spawn needed.
                        if (parsed.dir !== Files.directory) {
                            Files.listDirectory(parsed.dir);
                        }
                    }
                    launcherWindow.resultsModel = launcherWindow.buildResultsFor(query);
                }
                onSubmitted: results.activateCurrent()
                onEscapePressed: launcherWindow.close()
                onNavigateUp: results.moveUp()
                onNavigateDown: results.moveDown()
                onNavigateLeft: results.moveLeft()
                onNavigateRight: results.moveRight()
            }

            LauncherResults {
                id: results
                anchors.top: searchBar.bottom
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                model: launcherWindow.resultsModel
                layoutMode: searchBar.layoutMode

                onActivateIndex: index => launcherWindow.activateEntry(index)
            }
        }
    }

    // ── Results production ──────────────────────────────────────
    // One flat, mode-agnostic entry shape feeds both List and Grid views:
    //   { icon: {name} | {systemIcon, systemIconFallback}, label, keys,
    //     description, activatable, onActivate }
    // `keys` is presence-checked by LauncherEntry to decide whether to
    // render a Keybind or plain Text label — that's the only branch the
    // views themselves ever need to make. Keybind entries below are the
    // reason that branch exists at all.

    property var resultsModel: buildResultsFor("")

    function modeFor(query) {
        if (query.startsWith("="))
            return "calc";
        if (query.startsWith("/"))
            return "keybind";
        if (query.startsWith("$"))
            return "file";
        return "apps";
    }

    function buildResultsFor(query) {
        const mode = modeFor(query);
        if (mode === "apps") {
            return buildAppResults(query);
        }
        if (mode === "calc") {
            return buildCalcResults(query.slice(1));
        }
        if (mode === "file") {
            return buildFileResults(query.slice(1));
        }
        return buildKeybindResults(query.slice(1));
    }

    function buildAppResults(query) {
        const q = query.toLowerCase().trim();
        // DesktopEntries.applications is a Quickshell ObjectModel, not a
        // plain array — .values is what actually supports filter/map/sort.
        // See: https://quickshell.org/docs/types/Quickshell/ObjectModel/
        const all = DesktopEntries.applications.values;
        if (!all)
            return [];

        let matches = all.filter(entry => {
            if (!q)
                return true;
            const name = (entry.name || "").toLowerCase();
            const comment = (entry.comment || "").toLowerCase();
            return name.includes(q) || comment.includes(q);
        });

        matches.sort((a, b) => {
            const aName = (a.name || "").toLowerCase();
            const bName = (b.name || "").toLowerCase();
            const aStarts = aName.startsWith(q) ? 0 : 1;
            const bStarts = bName.startsWith(q) ? 0 : 1;
            if (aStarts !== bStarts)
                return aStarts - bStarts;
            return aName.localeCompare(bName);
        });

        return matches.map(entry => ({
                    icon: {
                        systemIcon: entry.icon,
                        systemIconFallback: "application-x-executable"
                    },
                    label: entry.name,
                    keys: null,
                    description: entry.comment || "",
                    activatable: true,
                    onActivate: () => {
                        launcherWindow.launchEntry(entry);
                        launcherWindow.close();
                    }
                }));
    }

    // DesktopEntry.execute() explicitly ignores runInTerminal (confirmed
    // against Quickshell's own docs: "the provided command does not
    // invoke a terminal even if runInTerminal is true") — that's the
    // entire reason neovim et al. silently do nothing while GUI apps like
    // Audacity work fine. TUI entries have to be wrapped in a terminal
    // emulator by hand.
    function launchEntry(entry) {
        if (entry.runInTerminal) {
            Quickshell.execDetached({
                command: [Settings.general.terminal, "-e", ...entry.command],
                workingDirectory: entry.workingDirectory
            });
        } else {
            entry.execute();
        }
    }

    // Always exactly one entry, per spec — the result (or its current
    // provisional/error state) pinned at index 0. Purely a read of
    // Calc's current state; never calls Calc.evaluate() itself (see the
    // note on onQueryChanged above for why that split matters).
    function buildCalcResults(expr) {
        const trimmed = expr.trim();

        let label, description, activatable;

        if (trimmed.length === 0) {
            label = "Type an expression...";
            description = "";
            activatable = false;
        } else if (Calc.computing) {
            // Provisional: show the raw input while qalc is still
            // running rather than leaving the list blank for 200ms+.
            label = trimmed;
            description = "Calculating...";
            activatable = false;
        } else if (Calc.errored) {
            label = "No result";
            description = trimmed;
            activatable = false;
        } else {
            label = Calc.result;
            description = trimmed;
            activatable = true;
        }

        return [
            {
                icon: {
                    name: "search/calculator"
                },
                label: label,
                keys: null,
                description: description,
                activatable: activatable,
                onActivate: () => {
                    // wl-copy (wl-clipboard), not Quickshell.clipboardText —
                    // Quickshell's own docs warn that property goes empty on
                    // Wayland "unless a quickshell window is focused," which
                    // is exactly what stops being true the instant the
                    // launcher closes right after this. wl-copy spawns an
                    // independent process that stays clipboard owner on its
                    // own, so the value survives the launcher closing.
                    // Requires wl-clipboard installed.
                    Quickshell.execDetached({
                        command: ["wl-copy", Calc.result]
                    });
                    launcherWindow.close();
                }
            }
        ];
    }

    function activateEntry(index) {
        const entry = resultsModel[index];
        if (entry && entry.activatable !== false) {
            entry.onActivate();
        }
    }

    // ── Keybind mode ("/") ──────────────────────────────────────
    // Search-only per spec: entries are never activatable, click/Enter
    // do nothing. Category → icon is the one bit of hand-maintained data
    // this needs — fill in real categories from your keybinds.json as
    // you go; unmapped ones fall back to a generic keyboard icon rather
    // than rendering nothing.
    readonly property var categoryIcons: ({
            "Apps": "search/apps",
            "Window Management": "search/window",
            "Wallpaper": "search/image",
            "System": "search/settings",
            "Media": "search/media",
            "Audio": "search/audio",
            "Screenshots": "search/screenshot"
        })
    readonly property string fallbackCategoryIcon: "search/keyboard"

    // Flattened once as a reactive property (re-evaluates only when
    // KeybindsLoader.categories actually changes, e.g. the file being
    // hand-edited), not rebuilt on every keystroke — the plan explicitly
    // called this out: filtering the flat list per keystroke is cheap,
    // re-flattening categories→shortcuts on every keystroke would be
    // needless repeated work for something that rarely changes.
    readonly property var flatKeybinds: {
        const cats = KeybindsLoader.categories;
        let flat = [];
        for (let i = 0; i < cats.length; i++) {
            const cat = cats[i];
            const shortcuts = cat.shortcuts || [];
            for (let j = 0; j < shortcuts.length; j++) {
                flat.push({
                    category: cat.category,
                    keybind: shortcuts[j].keybind,
                    description: shortcuts[j].description || ""
                });
            }
        }
        return flat;
    }

    function buildKeybindResults(query) {
        const q = query.toLowerCase().trim();

        const matches = flatKeybinds.filter(item => {
            if (!q)
                return true;
            const category = item.category.toLowerCase();
            const description = item.description.toLowerCase();
            const keysText = item.keybind.join("+").toLowerCase();
            return category.includes(q) || description.includes(q) || keysText.includes(q);
        });

        return matches.map(item => ({
                    icon: {
                        name: categoryIcons[item.category] || fallbackCategoryIcon
                    },
                    // `label` is unused whenever `keys` is set (LauncherEntry
                    // renders a Keybind instead) — kept populated anyway so the
                    // entry is still sane if something ever reads it directly.
                    label: item.keybind.join("+"),
                    keys: item.keybind,
                    description: item.description,
                    activatable: false,
                    onActivate: () => {} // search-only, per spec — never called anyway
                }));
    }

    // ── File mode ("$") ──────────────────────────────────────────
    // Splits the query into a directory portion (resolved to an absolute
    // path — "~" and "/" are recognized explicitly, a bare word with no
    // slash at all defaults to filtering within $HOME) and a filter
    // portion (whatever comes after the last "/"). Only the directory
    // portion ever triggers a new `find` — see the guard in
    // onQueryChanged above.
    function parseFileQuery(rest) {
        const home = Quickshell.env("HOME");

        // Lone "~" or "/" — someone's mid-way through typing a path and
        // hasn't reached a second character yet. Handled explicitly so
        // these don't get treated as a literal filter substring (which
        // would just show "no matches" until a "/" is typed).
        if (rest === "~")
            return {
                dir: home,
                filter: ""
            };
        if (rest === "/")
            return {
                dir: "/",
                filter: ""
            };

        const lastSlash = rest.lastIndexOf("/");
        let dirPart, filter;
        if (lastSlash === -1) {
            // No slash anywhere — the whole thing is a filter, directory
            // defaults to home. This is the plain "$searchterm" case.
            dirPart = "";
            filter = rest;
        } else {
            dirPart = rest.slice(0, lastSlash + 1); // keep the trailing "/"
            filter = rest.slice(lastSlash + 1);
        }

        let resolvedDir;
        if (dirPart === "") {
            resolvedDir = home;
        } else if (dirPart.startsWith("~")) {
            resolvedDir = home + dirPart.slice(1); // drop the "~", keep the rest incl. "/"
        } else if (dirPart.startsWith("/")) {
            resolvedDir = dirPart;
        } else {
            // A slash showed up but the path doesn't start with "~" or
            // "/" (e.g. "Documents/") — treat it as relative to home
            // rather than rejecting it outright.
            resolvedDir = home + "/" + dirPart;
        }

        // Normalize away a trailing slash so Files.directory/entry.path
        // building stays consistent regardless of how it was typed.
        resolvedDir = resolvedDir.replace(/\/+$/, "") || "/";

        return {
            dir: resolvedDir,
            filter: filter
        };
    }

    // Extension → icon is the one hand-maintained table this mode needs,
    // same pattern as categoryIcons above — systemIcon does real
    // freedesktop icon-theme lookup, so mapping ".py" to "text-x-python"
    // gets the actual Python logo for free, no custom rendering required.
    // Grow this as gaps show up; unmapped extensions fall back to a
    // generic file icon rather than rendering nothing.
    readonly property var extensionIcons: ({
            "py": "text-x-python",
            "js": "text-x-javascript",
            "ts": "text-x-typescript",
            "json": "application-json",
            "md": "text-x-markdown",
            "txt": "text-plain",
            "sh": "text-x-shellscript",
            "c": "text-x-csrc",
            "h": "text-x-chdr",
            "cpp": "text-x-c++src",
            "hpp": "text-x-c++hdr",
            "qml": "text-x-qml",
            "html": "text-html",
            "css": "text-css",
            "pdf": "application-pdf",
            "png": "image-png",
            "jpg": "image-jpeg",
            "jpeg": "image-jpeg",
            "svg": "image-svg+xml",
            "mp3": "audio-mpeg",
            "mp4": "video-mp4",
            "zip": "application-zip",
            "tar": "application-x-tar",
            "gz": "application-x-compressed-tar"
        })
    readonly property string fallbackFileIcon: "text-x-generic"

    function iconForFileEntry(entry) {
        if (entry.isDir)
            return "inode-directory";
        const dotIndex = entry.name.lastIndexOf(".");
        // No extension at all, or a dotfile like ".bashrc" (dot is index
        // 0, not a real extension separator) — both fall back rather than
        // treating the whole filename as an "extension".
        if (dotIndex <= 0)
            return fallbackFileIcon;
        const ext = entry.name.slice(dotIndex + 1).toLowerCase();
        return extensionIcons[ext] || fallbackFileIcon;
    }

    // Purely a read of Files' current state, same split as buildCalcResults
    // — never calls Files.listDirectory() itself, that only happens from
    // onQueryChanged when the resolved directory actually changes.
    function buildFileResults(rest) {
        const parsed = parseFileQuery(rest);

        // Files hasn't caught up to this directory yet — either the
        // listing was just triggered by onQueryChanged and is still
        // running, or it's mid-listing a previous folder. Either way,
        // showing stale entries from a different directory would be
        // actively misleading, so a provisional placeholder goes here
        // instead (mirrors Calc's "Calculating..." provisional state).
        if (Files.directory !== parsed.dir || Files.listing) {
            return [
                {
                    icon: {
                        name: "common/folder-open"
                    },
                    label: "Loading...",
                    keys: null,
                    description: parsed.dir,
                    activatable: false,
                    onActivate: () => {}
                }
            ];
        }

        if (Files.errored) {
            return [
                {
                    icon: {
                        name: "common/circle-x"
                    },
                    label: "Can't read this folder",
                    keys: null,
                    description: Files.errorMessage || parsed.dir,
                    activatable: false,
                    onActivate: () => {}
                }
            ];
        }

        const q = parsed.filter.toLowerCase();
        let matches = Files.entries.filter(entry => {
            return !q || entry.name.toLowerCase().includes(q);
        });

        matches.sort((a, b) => {
            if (a.isDir !== b.isDir)
                return a.isDir ? -1 : 1; // folders first
            return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
        });

        return matches.map(entry => ({
                    icon: {
                        systemIcon: iconForFileEntry(entry),
                        systemIconFallback: entry.isDir ? "inode-directory" : fallbackFileIcon
                    },
                    label: entry.name,
                    keys: null,
                    description: entry.path,
                    activatable: true,
                    onActivate: () => {
                        if (entry.isDir) {
                            launcherWindow.navigateToFolder(entry.path);
                        } else {
                            launcherWindow.openFile(entry.path);
                        }
                    }
                }));
    }

    // Re-writing searchBar.text (rather than e.g. a separate "current
    // directory" property) is deliberate: it reuses the exact same
    // queryChanged → parse → Files.listDirectory() chain that typing a
    // path by hand already goes through, no separate code path needed.
    // Does NOT close the launcher — selecting a folder navigates, it
    // doesn't activate.
    function navigateToFolder(path) {
        searchBar.text = "$" + path + "/";
    }

    // Plain `xdg-open <path>` works fine for GUI-handled files (images,
    // PDFs, etc.) but hits the exact same bug launchEntry() already
    // works around for apps: xdg-open resolves the file's mime type to
    // whatever .desktop entry is registered as its default handler, then
    // launches it while ignoring Terminal=true on that entry — same as
    // DesktopEntry.execute() does. If the default handler for a text
    // file happens to be a CLI editor (vim/nvim/nano — common if that
    // was ever set via xdg-mime or a file manager), it execs with no
    // terminal attached and just runs invisibly.
    //
    // So: resolve the mime type ourselves (`file --mime-type`), look up
    // the registered default (`xdg-mime query default`), then read that
    // .desktop file directly rather than going through
    // DesktopEntries.byId() — mime-handler-only entries like nvim.desktop
    // are typically marked NoDisplay=true (they're meant to be a file-
    // association target, not something that shows in an app menu), and
    // Quickshell's application index may not surface those the same way
    // it does normal launchable apps. Reading the file ourselves sidesteps
    // that uncertainty entirely. Falls back to plain xdg-open whenever
    // any step is inconclusive — i.e. everything that already worked
    // (GUI apps) keeps working exactly as before.
    property string _pendingOpenPath: ""

    function openFile(path) {
        _pendingOpenPath = path;
        mimeTypeProcess.command = ["file", "--mime-type", "-b", path];
        mimeTypeProcess.running = true;
        // Closing immediately, not waiting on the lookup — the person
        // already committed to opening this file, no reason to hold the
        // launcher open for a background mime-type query.
        launcherWindow.close();
    }

    Process {
        id: mimeTypeProcess
        running: false
        stdout: StdioCollector {
            id: mimeTypeCollector
            onStreamFinished: {
                const mimeType = mimeTypeCollector.text.trim();
                if (!mimeType) {
                    Quickshell.execDetached({
                        command: ["xdg-open", launcherWindow._pendingOpenPath]
                    });
                    return;
                }
                defaultAppProcess.command = ["xdg-mime", "query", "default", mimeType];
                defaultAppProcess.running = true;
            }
        }
    }

    Process {
        id: defaultAppProcess
        running: false
        stdout: StdioCollector {
            id: defaultAppCollector
            onStreamFinished: {
                const desktopId = defaultAppCollector.text.trim();
                if (!desktopId) {
                    Quickshell.execDetached({
                        command: ["xdg-open", launcherWindow._pendingOpenPath]
                    });
                    return;
                }
                // Search the standard XDG application directories in
                // priority order (user's own first, matching real
                // xdg-mime resolution order) and print the first match's
                // content — combining find+cat into one process instead
                // of two, and `-quit` stops after the first hit so
                // multiple installs of the same app don't get concatenated
                // together.
                const home = Quickshell.env("HOME");
                desktopFileProcess.command = ["find", home + "/.local/share/applications", "/usr/local/share/applications", "/usr/share/applications", "-maxdepth", "1", "-name", desktopId, "-exec", "cat", "{}", ";", "-quit"];
                desktopFileProcess.running = true;
            }
        }
    }

    Process {
        id: desktopFileProcess
        running: false
        stdout: StdioCollector {
            id: desktopFileCollector
            onStreamFinished: {
                const path = launcherWindow._pendingOpenPath;
                const content = desktopFileCollector.text;

                if (!content.trim()) {
                    // Desktop file wasn't found in any standard
                    // location — fall back rather than guessing further.
                    Quickshell.execDetached({
                        command: ["xdg-open", path]
                    });
                    return;
                }

                const isTerminal = /^Terminal\s*=\s*true\s*$/mi.test(content);
                if (!isTerminal) {
                    // Confirmed GUI handler — xdg-open already handles
                    // this correctly, no need to second-guess it.
                    Quickshell.execDetached({
                        command: ["xdg-open", path]
                    });
                    return;
                }

                const execMatch = content.match(/^Exec\s*=\s*(.+)$/mi);
                if (!execMatch) {
                    Quickshell.execDetached({
                        command: ["xdg-open", path]
                    });
                    return;
                }

                // Strip field codes (%f/%F/%u/%U/%i/%c/%k/%%) rather than
                // substituting them properly — the real path gets
                // appended as a trailing argument instead. That's a
                // heuristic covering editors that accept a bare filename
                // (most of them), not a full implementation of the Exec
                // key spec.
                const execTokens = execMatch[1].replace(/%[fFuUick%]/g, "").trim().split(/\s+/).filter(t => t.length > 0);

                if (execTokens.length === 0) {
                    Quickshell.execDetached({
                        command: ["xdg-open", path]
                    });
                    return;
                }

                Quickshell.execDetached({
                    command: [Settings.general.terminal, "-e", ...execTokens, path]
                });
            }
        }
    }
}
