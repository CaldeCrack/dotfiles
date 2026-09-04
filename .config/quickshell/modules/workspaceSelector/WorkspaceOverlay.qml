import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.services
import qs.widgets

// WorkspaceOverlay
// ----------------
// Same shape as ShortcutsWindow (full-screen scrim + inset card, toggled
// via IpcHandler since a layer-shell client can't grab a global hotkey on
// its own) — no header here though, just the grid, since there's nothing
// to title and closing is Escape/the toggle shortcut/clicking the scrim.
//
// Always shows a fixed grid of workspaceCount tiles (ids 1..workspaceCount),
// not just currently-existing/non-empty ones — an id with no real workspace
// behind it yet just renders an empty tile (no thumbnail, no icon, still
// clickable to create/focus it, same as clicking that number on the bar).
//
// Thumbnails come from Workspaces.thumbnailSourceFor(id), which is only
// ever non-null on Hyprland (hyprland-toplevel-export-v1 can render an
// off-screen window on request; no equivalent protocol exists for i3/sway).
// On i3/sway, and for any genuinely empty tile, only the big background
// number and (if there IS a selected window) its icon show.
//
// Not instantiated by any bar button — this only ever opens via its own
// shortcut, so it should be instantiated once directly in shell.qml
// alongside the other always-present overlays (Launcher, PowerOverlay),
// not owned by a bar component the way ShortcutsWindow is owned by
// ArchButton.
PanelWindow {
    id: root

    visible: false
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusiveZone: 0

    // Fixed range shown, independent of how many workspaces actually
    // exist/have windows. Not yet a config key you've added — default 10
    // until it is. Combined with columns (5, per your config) that's the
    // 2-row/5-per-row layout.
    readonly property int workspaceCount: Settings.workspaceOverlay.count ?? 10
    readonly property var workspaceIds: Array.from({
        length: root.workspaceCount
    }, (_, i) => i + 1)

    readonly property int columns: Settings.workspaceOverlay.columns

    // Index into workspaceIds — keyboard/mouse selection, kept in sync
    // between the two (hovering a tile also updates this).
    property int selectedIndex: 0

    function toggle() {
        visible = !visible;
        if (visible)
            open();
    }

    function close() {
        visible = false;
    }

    // Freshens last-focused-window data and resets the selection to
    // whatever workspace is currently active, so opening the overlay
    // always starts the keyboard cursor on "where you already are."
    function open() {
        Workspaces.refresh();
        const idx = root.workspaceIds.indexOf(Workspaces.activeId);
        root.selectedIndex = idx >= 0 ? idx : 0;
    }

    function moveSelection(delta) {
        const next = root.selectedIndex + delta;
        if (next >= 0 && next < root.workspaceIds.length)
            root.selectedIndex = next;
    }

    function activateSelected() {
        const id = root.workspaceIds[root.selectedIndex];
        if (id !== undefined) {
            Workspaces.focus(id);
            root.close();
        }
    }

    // Same bridge pattern as ShortcutsWindow's IpcHandler — bind a WM key
    // (SUPER+TAB or similar) to `qs ipc call workspaceOverlay toggle`.
    IpcHandler {
        target: "workspaceOverlay"

        function toggle(): void {
            root.toggle();
        }

        function close(): void {
            root.close();
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.visible
        onActivated: root.close()
    }

    Shortcut {
        sequence: "Return"
        enabled: root.visible
        onActivated: root.activateSelected()
    }

    Shortcut {
        sequence: "Enter"
        enabled: root.visible
        onActivated: root.activateSelected()
    }

    Shortcut {
        sequence: "Left"
        enabled: root.visible
        onActivated: root.moveSelection(-1)
    }

    Shortcut {
        sequence: "Right"
        enabled: root.visible
        onActivated: root.moveSelection(1)
    }

    Shortcut {
        sequence: "Up"
        enabled: root.visible
        onActivated: root.moveSelection(-root.columns)
    }

    Shortcut {
        sequence: "Down"
        enabled: root.visible
        onActivated: root.moveSelection(root.columns)
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.scrim
        opacity: 0.5

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    Rectangle {
        id: panel

        anchors.fill: parent
        anchors.topMargin: Settings.bar.height + Settings.workspaceOverlay.verticalMargin
        anchors.bottomMargin: Settings.workspaceOverlay.verticalMargin
        anchors.leftMargin: Settings.workspaceOverlay.horizontalMargin
        anchors.rightMargin: Settings.workspaceOverlay.horizontalMargin
        radius: 16
        color: Colors.md3.surface_container

        MouseArea {
            anchors.fill: parent
        }

        GridLayout {
            id: grid

            anchors.fill: parent
            anchors.margins: 20

            columns: root.columns
            rowSpacing: 16
            columnSpacing: 16

            Repeater {
                model: root.workspaceIds

                delegate: Rectangle {
                    id: tile

                    required property int modelData
                    required property int index

                    readonly property int wsId: modelData
                    readonly property bool selected: index === root.selectedIndex
                    readonly property var selectedWindow: Workspaces.selectedWindowFor(wsId)

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: Settings.workspaceOverlay.tileWidth
                    Layout.preferredHeight: Settings.workspaceOverlay.tileHeight

                    radius: 12
                    color: Colors.md3.surface_container_high
                    border.width: selected ? 2 : 0
                    border.color: Colors.md3.primary
                    // The background number and the screencap are both
                    // rectangular by default — clip so neither pokes out
                    // past the tile's own rounded corners.
                    clip: true

                    Behavior on border.width {
                        NumberAnimation {
                            duration: 100
                        }
                    }

                    // Big, muted workspace number, centered — sits BEHIND
                    // everything else. Primarily visible on empty tiles
                    // (nothing to cover it) and on i3/sway (no thumbnail
                    // protocol at all); a populated Hyprland tile's
                    // thumbnail will generally cover it entirely, which is
                    // expected — it's a placeholder, not meant to compete
                    // with real content once there is any.
                    Text {
                        anchors.centerIn: parent
                        text: tile.wsId
                        font.pixelSize: Math.min(parent.width, parent.height) * 0.55
                        font.bold: true
                        color: Colors.md3.on_surface_variant
                        opacity: 0.25
                    }

                    ScreencopyView {
                        id: capture
                        anchors.fill: parent
                        anchors.margins: 4
                        captureSource: Workspaces.thumbnailSourceFor(tile.wsId)
                        live: false

                        onCaptureSourceChanged: if (captureSource)
                            captureFrame()
                        Component.onCompleted: if (captureSource)
                            captureFrame()

                        // Re-capture every time the overlay opens, not just
                        // when captureSource's identity changes — the same
                        // Toplevel handle can persist across opens while
                        // its on-screen contents have changed since.
                        Connections {
                            target: root
                            function onVisibleChanged() {
                                if (root.visible && capture.captureSource)
                                    capture.captureFrame();
                            }
                        }
                    }

                    // Selected window's icon, centered, in front of the
                    // thumbnail. Renders nothing if there's no selected
                    // window (empty tile) — same graceful-nothing behavior
                    // Icon already has for an unresolved appId.
                    Icon {
                        anchors.centerIn: parent
                        appId: tile.selectedWindow?.iconName ?? ""
                        systemIconFallback: "application-x-executable"
                        size: 48
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: root.selectedIndex = tile.index
                        onClicked: {
                            root.selectedIndex = tile.index;
                            root.activateSelected();
                        }
                    }
                }
            }
        }
    }
}
