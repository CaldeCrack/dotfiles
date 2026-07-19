import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.config as Config
import qs.widgets as Widgets

// ShortcutsWindow
// ---------------
// Full-screen scrim behind a card that fills the rest of the screen (inset
// by config margins, clearing the bar). Deliberately simpler than InfoPanel
// (no tabs, no service) since it only ever shows one thing. Owned/
// instantiated directly by ArchButton — see that file for why this isn't a
// shared singleton.
//
// Keybinds come from Config.KeybindsLoader.categories (see
// config/KeybindsLoader.qml), rendered as 3 equal-width columns of 2
// categories each, in the order they appear in keybinds.json. Each category
// is a subtitle over a 2-column Grid — column 1 holds the Keybind widgets,
// column 2 the descriptions. Grid (rather than two independent Columns) is
// what keeps the description column aligned to the widest keybind in that
// specific category, row by row.
PanelWindow {
    id: root

    visible: false

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

    Shortcut {
        sequence: "Escape"
        enabled: root.visible
        onActivated: root.close()
    }

    // Dims everything behind the panel; click anywhere on it to dismiss.
    Rectangle {
        anchors.fill: parent
        color: Config.Colors.md3.scrim
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
        anchors.topMargin: Config.Settings.bar.margin + Config.Settings.shortcutsWindow.verticalMargin
        anchors.bottomMargin: Config.Settings.shortcutsWindow.verticalMargin
        anchors.leftMargin: Config.Settings.shortcutsWindow.horizontalMargin
        anchors.rightMargin: Config.Settings.shortcutsWindow.horizontalMargin
        radius: 16
        color: Config.Colors.md3.surface_container

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
                color: Config.Colors.md3.on_surface
            }

            // Simple hover-highlighted close button. Not built on
            // BarButtonBase since that's sized/styled specifically for the
            // bar (implicitHeight defaults to Config.Settings.bar.height,
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
                color: closeArea.containsMouse ? Config.Colors.md3.surface : Config.Colors.md3.surface_container

                Behavior on opacity {
                    NumberAnimation {
                        duration: 100
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "\u2715"
                    color: Config.Colors.md3.on_surface
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
            Widgets.Keybind {
                keys: parent.shortcut.keybind
            }
        }

        Component {
            id: descriptionCell
            Text {
                text: parent.shortcut.description
                color: Config.Colors.md3.on_surface_variant
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
                // 3 columns, 2 categories each, in the order they appear
                // in keybinds.json — column 0 gets categories[0:2],
                // column 1 gets categories[2:4], column 2 gets [4:6].
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

                    readonly property var categoriesForColumn: Config.KeybindsLoader.categories.slice(index * 2, index * 2 + 2)

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
                                color: Config.Colors.md3.on_surface
                            }

                            Grid {
                                columns: 2
                                rowSpacing: 6
                                columnSpacing: 16

                                Repeater {
                                    // Doubled so each shortcut contributes
                                    // two grid cells (keybind, description)
                                    // in row-major order.
                                    model: categoryBlock.modelData.shortcuts.length * 2

                                    delegate: Loader {
                                        id: cellLoader
                                        required property int index

                                        readonly property var shortcut: categoryBlock.modelData.shortcuts[Math.floor(index / 2)]

                                        sourceComponent: (index % 2 === 0) ? keybindCell : descriptionCell
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
