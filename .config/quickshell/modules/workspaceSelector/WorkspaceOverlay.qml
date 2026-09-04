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
// its own) — the only real difference is what's inside the card: a grid of
// workspace thumbnails instead of a keybind cheat sheet.
//
// Empty workspaces are excluded entirely — there's nothing useful to
// preview or switch to. "Empty" here means no windows, per
// Workspaces.windowsFor(), not just excluded by the >=0 id filter the
// backends already apply for the bar button.
//
// Thumbnails come from Workspaces.thumbnailSourceFor(id), which is only
// ever non-null on Hyprland (hyprland-toplevel-export-v1 can render an
// off-screen window on request; no equivalent protocol exists for i3/sway).
// On i3/sway every tile falls back to just the selected window's icon —
// see ScreencopyView.hasContent below.
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

    // How many non-empty workspaces exist, in the same order the grid
    // renders them — recomputed whenever the underlying workspace/window
    // state changes, since it's just a filter over Workspaces.workspaces.
    readonly property var visibleWorkspaces: Workspaces.workspaces.filter(w => Workspaces.windowsFor(w.id).length > 0)

    readonly property int columns: Settings.workspaceOverlay.columns

    // Index into visibleWorkspaces — keyboard/mouse selection, kept in
    // sync between the two (hovering a tile also updates this).
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
        const idx = root.visibleWorkspaces.findIndex(w => w.id === Workspaces.activeId);
        root.selectedIndex = idx >= 0 ? idx : 0;
    }

    function moveSelection(delta) {
        if (root.visibleWorkspaces.length === 0)
            return;
        const next = root.selectedIndex + delta;
        if (next >= 0 && next < root.visibleWorkspaces.length)
            root.selectedIndex = next;
    }

    function activateSelected() {
        const ws = root.visibleWorkspaces[root.selectedIndex];
        if (ws) {
            Workspaces.focus(ws.id);
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
        anchors.topMargin: Settings.bar.height + (Settings.workspaceOverlay.verticalMargin)
        anchors.bottomMargin: Settings.workspaceOverlay.verticalMargin
        anchors.leftMargin: Settings.workspaceOverlay.horizontalMargin
        anchors.rightMargin: Settings.workspaceOverlay.horizontalMargin
        radius: 16
        color: Colors.md3.surface_container

        MouseArea {
            anchors.fill: parent
        }

        Item {
            id: header

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            height: closeButton.height

            Text {
                anchors.centerIn: parent
                text: "Workspaces"
                font.pixelSize: 20
                font.bold: true
                color: Colors.md3.on_surface
            }

            PanelCloseButton {
                id: closeButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.close()
            }
        }

        Text {
            anchors.centerIn: parent
            visible: root.visibleWorkspaces.length === 0
            text: "No windows open"
            color: Colors.md3.on_surface_variant
            font.pixelSize: 16
        }

        GridLayout {
            id: grid

            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            anchors.topMargin: 10

            columns: root.columns
            rowSpacing: 16
            columnSpacing: 16

            Repeater {
                model: root.visibleWorkspaces

                delegate: Rectangle {
                    id: tile

                    required property var modelData
                    required property int index

                    readonly property int wsId: modelData.id
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

                    Behavior on border.width {
                        NumberAnimation {
                            duration: 100
                        }
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
                        // Toplevel handle can persist across opens while its
                        // on-screen contents have changed in the meantime.
                        Connections {
                            target: root
                            function onVisibleChanged() {
                                if (root.visible && capture.captureSource)
                                    capture.captureFrame();
                            }
                        }
                    }

                    // No capture source at all (i3/sway, always) or no
                    // frame yet (Hyprland, briefly) — icon-only fallback,
                    // same graceful-nothing pattern Icon already uses.
                    Icon {
                        anchors.centerIn: parent
                        visible: !capture.hasContent
                        appId: tile.selectedWindow?.iconName ?? ""
                        systemIconFallback: "application-x-executable"
                        size: 32
                    }

                    // Selected window's icon badge, over the thumbnail.
                    Icon {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 6
                        visible: capture.hasContent
                        appId: tile.selectedWindow?.iconName ?? ""
                        systemIconFallback: "application-x-executable"
                        size: 20
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.margins: 6
                        width: idLabel.implicitWidth + 8
                        height: idLabel.implicitHeight + 4
                        radius: 4
                        color: Colors.md3.scrim
                        opacity: 0.6

                        Text {
                            id: idLabel
                            anchors.centerIn: parent
                            text: tile.wsId
                            color: "white"
                            font.pixelSize: 11
                            font.bold: true
                        }
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
