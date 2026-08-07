pragma ComponentBehavior: Bound

import QtQuick
import qs.widgets
import qs.config

// Shared shape behind EmojiOptions.qml and NerdFontOptions.qml — a search
// field, a grid of character cells, keyboard nav across rows/columns, and
// a position footer. Deliberately simpler than ClipboardOptions.qml: no
// id column, no image decoding, no sort/filter controls — just "type to
// narrow, hover for the name, click or Enter to copy".
//
//   PickerGrid {
//       source: Emoji              // any DataPicker instance — Emoji, NerdFont, ...
//       placeholderText: "Search emoji…"
//   }
Column {
    id: root

    // Any DataPicker instance — this file only touches the generic
    // surface DataPicker.qml exposes (entries, searchQuery, select(),
    // refresh()), nothing Emoji- or NerdFont-specific.
    required property var source
    property string placeholderText: "Search..."
    // Set for glyph fonts (Nerd Font) that need an explicit family to
    // render instead of tofu. Left empty for emoji, which render fine off
    // the default font's own unicode fallback.
    property string fontFamily: ""

    property int columns: 6
    property real cellSize: 42
    property int visibleRows: 5

    signal entrySelected
    signal escapePressed

    width: columns * cellSize
    spacing: 4

    readonly property var entries: source.entries
    property int selectedIndex: 0

    onEntriesChanged: selectedIndex = entries.length === 0 ? 0 : Math.min(selectedIndex, entries.length - 1)
    onSelectedIndexChanged: grid.positionViewAtIndex(selectedIndex, GridView.Contain)

    // DataPicker ends up as a Singleton's root object, and Singleton
    // doesn't fire Component.onCompleted (see DataPicker.qml) — same
    // reason ClipboardOptions.qml calls Clipboard.refresh() itself.
    Component.onCompleted: {
        source.refresh();
        grid.forceActiveFocus();
    }

    function _activateSelected() {
        if (entries.length === 0)
            return;

        source.select(entries[selectedIndex].char);
        root.entrySelected();
    }

    // --- search bar ------------------------------------------------------
    Item {
        id: searchBar
        width: root.width
        height: 28

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: Colors.md3.surface_container
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: root.placeholderText
            color: Colors.md3.on_surface_variant
            font.pixelSize: 12
            visible: searchInput.text.length === 0
        }

        TextInput {
            id: searchInput
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            verticalAlignment: TextInput.AlignVCenter
            color: Colors.md3.on_surface
            font.pixelSize: 12
            clip: true

            onTextChanged: root.source.searchQuery = text

            HoverHandler {
                cursorShape: Qt.IBeamCursor
            }

            // Left/Right move within a row, Up/Down jump a full row
            // (± columns) — 2D nav, unlike ClipboardOptions.qml's plain
            // Up/Down list stepping.
            Keys.onLeftPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
            Keys.onRightPressed: root.selectedIndex = Math.min(root.entries.length - 1, root.selectedIndex + 1)
            Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - root.columns)
            Keys.onDownPressed: root.selectedIndex = Math.min(root.entries.length - 1, root.selectedIndex + root.columns)
            Keys.onReturnPressed: root._activateSelected()
            Keys.onEnterPressed: root._activateSelected()
            Keys.onEscapePressed: root.escapePressed()
        }
    }

    // --- results grid -----------------------------------------------------
    GridView {
        id: grid
        width: root.width
        height: root.cellSize * root.visibleRows
        clip: true
        model: root.entries
        currentIndex: root.selectedIndex
        cellWidth: root.cellSize
        cellHeight: root.cellSize
        boundsBehavior: Flickable.StopAtBounds

        Keys.onLeftPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
        Keys.onRightPressed: root.selectedIndex = Math.min(root.entries.length - 1, root.selectedIndex + 1)
        Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - root.columns)
        Keys.onDownPressed: root.selectedIndex = Math.min(root.entries.length - 1, root.selectedIndex + root.columns)
        Keys.onReturnPressed: root._activateSelected()
        Keys.onEnterPressed: root._activateSelected()
        Keys.onEscapePressed: root.escapePressed()

        delegate: GridEntry {}
    }

    // --- footer: fetch + last-fetch timestamp + position indicator ---------
    Item {
        id: footer
        width: root.width
        height: 24

        IconLabelButton {
            id: fetchButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            iconName: "common/refresh"
            label: root.source.fetching ? "Fetching..." : ""
            tooltipText: "Refetch data"
            enabled: !root.source.fetching
            onClicked: root.source.fetch()
        }

        Text {
            anchors.left: fetchButton.right
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            visible: root.source.lastFetchedAt !== null
            text: root.source.lastFetchedAt !== null ? Qt.formatDateTime(root.source.lastFetchedAt, "MMM d, hh:mm") : ""
            color: Colors.md3.on_surface_variant
            font.pixelSize: 12
        }

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            rightPadding: 8
            text: root.entries.length === 0 ? "0 / 0" : (root.selectedIndex + 1) + " / " + root.entries.length
            color: Colors.md3.on_surface_variant
            font.pixelSize: 12
        }
    }

    // --- local component ----------------------------------------------------
    // Icon + text-label button, e.g. the footer's Fetch button — distinct
    // from GridEntry's icon-only cells since nothing else here needs a
    // label alongside its icon.
    component IconLabelButton: Item {
        id: button

        property string iconName: ""
        property string label: ""
        property string tooltipText: ""
        property bool enabled: true
        signal clicked

        readonly property bool hovered: mouseArea.containsMouse

        implicitWidth: content.implicitWidth + 12
        implicitHeight: 24
        opacity: enabled ? 1 : 0.5

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: mouseArea.containsMouse ? Colors.md3.surface_container_high : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Row {
            id: content
            anchors.centerIn: parent
            spacing: 4

            Icon {
                anchors.verticalCenter: parent.verticalCenter
                name: button.iconName
                size: 14
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: button.label
                color: Colors.md3.on_surface_variant
                font.pixelSize: 11
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: button.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: if (button.enabled)
                button.clicked()
        }

        Tooltip {
            target: button
            text: button.tooltipText
        }
    }

    component GridEntry: Item {
        id: cell

        required property var modelData
        required property int index

        width: root.cellSize
        height: root.cellSize

        implicitHeight: root.cellSize

        readonly property bool hovered: mouseArea.containsMouse

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            radius: 6
            color: cell.GridView.isCurrentItem ? Colors.md3.surface_container_high : cell.hovered ? Colors.md3.surface_container : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: cell.modelData.char
            font.pixelSize: 20
            font.family: root.fontFamily.length > 0 ? root.fontFamily : Qt.application.font.family
            color: Colors.md3.on_surface
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.selectedIndex = cell.index;
                root.source.select(cell.modelData.char);
                root.entrySelected();
            }
        }

        Tooltip {
            target: cell
            anchorTarget: cell
            text: cell.modelData.name
        }
    }
}
