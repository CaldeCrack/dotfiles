import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.widgets

// Launcher
// --------
// Window shell + slide animation + search bar, now wired to real results:
// apps mode enumerates installed applications via DesktopEntries. Calc
// ("=") and keybind ("/") modes still land in later steps — `modeFor()`
// below is the seam where they plug in.

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
            color: Colors.md3.surface_container
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
                    launcherWindow.resultsModel = launcherWindow.buildResultsFor(query);
                }
                onSubmitted: launcherWindow.activateTopResult()
                onEscapePressed: launcherWindow.close()
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
    // views themselves ever need to make. Calc and keybind modes (steps
    // 6-7) just need to produce more entries in this same shape.

    property var resultsModel: buildResultsFor("")

    function modeFor(query) {
        if (query.startsWith("="))
            return "calc";
        if (query.startsWith("/"))
            return "keybind";
        return "apps";
    }

    function buildResultsFor(query) {
        const mode = modeFor(query);
        if (mode === "apps") {
            return buildAppResults(query);
        }
        // Calc and keybind modes land in later steps — empty results for
        // now rather than silently falling back to app search, so the
        // prefix behaves consistently once those modes exist.
        return [];
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

    function activateEntry(index) {
        const entry = resultsModel[index];
        if (entry && entry.activatable !== false) {
            entry.onActivate();
        }
    }

    function activateTopResult() {
        if (resultsModel.length > 0) {
            activateEntry(0);
        }
    }
}
