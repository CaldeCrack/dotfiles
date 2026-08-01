import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.config
import qs.widgets

// ShortcutsWindow
// ---------------
// Full-screen scrim behind a card that fills the rest of the screen (inset
// by config margins, clearing the bar). Deliberately simpler than InfoPanel
// (no tabs, no service) since it only ever shows one thing. Owned/
// instantiated directly by ArchButton — see that file for why this isn't a
// shared singleton.
//
// Keybinds come from KeybindsLoader.categories (see
// config/KeybindsLoader.qml), rendered as 3 equal-width columns. Each
// category's "column" (1-3) and "index" (order within that column) fields
// in keybinds.json decide where it lands — any number of categories per
// column is fine, not just a fixed 2. Each category is a subtitle over a
// 2-column GridLayout — column 1 holds the Keybind widgets (sized to its
// widest entry), column 2 the descriptions (Layout.fillWidth: true, so it
// stretches to the category's full available width rather than just
// hugging its own text).
//
// Toggled externally via IpcHandler (see below) — bind a Hyprland key to
// `qs ipc call shortcuts toggle` rather than handling the hotkey here,
// since a layer-shell client can't grab global keys on its own.
PanelWindow {
    id: root

    visible: false
    exclusionMode: ExclusionMode.Ignore

    // Layer-shell surfaces don't get keyboard focus by default. OnDemand
    // requests it only while this window is actually visible/interactive,
    // rather than permanently stealing focus from everything else.
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusiveZone: 0

    function toggle() {
        visible = !visible;
    }

    function close() {
        visible = false;
    }

    // Bridges an external Hyprland keybind to this window. Wayland
    // compositors own all global keyboard input, so a layer-shell client
    // can't grab a hotkey by itself — Hyprland captures the key and execs
    // a command, this just gives that command something to call into.
    IpcHandler {
        target: "shortcuts"

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

    // Dims everything behind the panel; click anywhere on it to dismiss.
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
        // Top clears the bar (its height + its own gap from the screen
        // edge) plus the usual vertical margin, so the card never sits
        // under the bar; the other three sides just use the configured
        // margins directly.
        anchors.topMargin: Settings.bar.height + Settings.shortcutsWindow.verticalMargin
        anchors.bottomMargin: Settings.shortcutsWindow.verticalMargin
        anchors.leftMargin: Settings.shortcutsWindow.horizontalMargin
        anchors.rightMargin: Settings.shortcutsWindow.horizontalMargin
        radius: 16
        color: Colors.md3.surface_container

        // Swallow clicks here so they don't fall through to the scrim
        // behind and close the panel.
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
                text: "Cheat Sheet"
                font.pixelSize: 20
                font.bold: true
                color: Colors.md3.on_surface
            }

            // Simple hover-highlighted close button. Not built on
            // BarButtonBase since that's sized/styled specifically for the
            // bar (implicitHeight defaults to Settings.bar.height,
            // which has nothing to do with this panel). If more panels
            // end up needing this same close-button look, pull it into
            // its own widgets/PanelCloseButton.qml.
            Rectangle {
                id: closeButton

                width: 28
                height: 28
                radius: width / 2
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: closeArea.containsMouse ? Colors.md3.surface : Colors.md3.surface_container

                Behavior on opacity {
                    NumberAnimation {
                        duration: 100
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "\u2715"
                    color: Colors.md3.on_surface
                    font.pixelSize: 14
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }
        }

        // One Loader instance renders either a keybind or a description,
        // depending on which of the two the (parent) cell's index needs.
        // Loaded items get parented to their Loader, so `parent.shortcut`
        // reaches back into the cell that spawned them — this lets a single
        // pair of Components serve every category's Grid rather than each
        // category defining its own.
        Component {
            id: keybindCell
            Keybind {
                keys: parent.shortcut.keybind
            }
        }

        Component {
            id: descriptionCell
            Text {
                text: parent.shortcut.description
                color: Colors.md3.on_surface_variant
                verticalAlignment: Text.AlignVCenter
            }
        }

        RowLayout {
            id: content

            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            anchors.topMargin: 10

            spacing: 12

            Repeater {
                // 3 columns. Which categories land in which column, and in
                // what order, is driven entirely by each category's
                // "column"/"index" fields — see categoriesForColumn below.
                model: 3

                delegate: ColumnLayout {
                    id: columnDelegate
                    required property int index

                    // preferredWidth: 0 removes each column's own content
                    // as a sizing baseline, so fillWidth splits the FULL
                    // width three ways equally instead of only splitting
                    // whatever's left over after each column's natural
                    // (content-driven) width.
                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 16

                    // Each category now declares its own placement via
                    // "column" (1-3) and "index" (order within that
                    // column) in keybinds.json, rather than being assumed
                    // to fall 2-per-column in file order. A category with
                    // no matching column (missing/out-of-range) simply
                    // won't render in any of the three — nothing crashes,
                    // it's just silently skipped.
                    readonly property var categoriesForColumn: KeybindsLoader.categories.filter(category => category.column === index + 1).sort((a, b) => a.index - b.index)

                    Repeater {
                        model: columnDelegate.categoriesForColumn

                        delegate: ColumnLayout {
                            id: categoryBlock
                            required property var modelData

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            spacing: 16

                            Text {
                                text: categoryBlock.modelData.category
                                font.bold: true
                                font.pixelSize: 20
                                color: Colors.md3.on_surface
                            }

                            GridLayout {
                                columns: 2
                                rowSpacing: 6
                                columnSpacing: 16
                                Layout.fillWidth: true

                                Repeater {
                                    // Doubled so each shortcut contributes
                                    // two grid cells (keybind, description)
                                    // in row-major order.
                                    model: categoryBlock.modelData.shortcuts.length * 2

                                    delegate: Loader {
                                        id: cellLoader
                                        required property int index

                                        readonly property var shortcut: categoryBlock.modelData.shortcuts[Math.floor(index / 2)]
                                        readonly property bool isDescription: index % 2 === 1

                                        // Only the description column stretches — the
                                        // keybind column should stay sized to its
                                        // widest entry, not spread out.
                                        Layout.fillWidth: isDescription
                                        Layout.alignment: Qt.AlignVCenter

                                        sourceComponent: isDescription ? descriptionCell : keybindCell
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
