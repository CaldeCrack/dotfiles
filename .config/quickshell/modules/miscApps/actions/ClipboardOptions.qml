pragma ComponentBehavior: Bound

import QtQuick
import qs.widgets
import qs.config
import qs.services

Column {
    id: root

    // Fires once an entry has actually been copied back to the clipboard
    // (via Enter or a click) — MiscAppsPanel listens for this to close the
    // popup. No delay needed here unlike screenshot/record: copying to
    // the clipboard has no "still visible in the capture" race to avoid.
    signal entrySelected

    width: 280
    spacing: 4

    readonly property var entries: Clipboard.entries
    property int selectedIndex: 0

    onEntriesChanged: selectedIndex = entries.length === 0 ? 0 : Math.min(selectedIndex, entries.length - 1)
    onSelectedIndexChanged: list.positionViewAtIndex(selectedIndex, ListView.Contain)

    Component.onCompleted: Clipboard.refresh()

    function _activateSelected() {
        if (entries.length === 0)
            return;

        Clipboard.select(entries[selectedIndex].id);
        root.entrySelected();
    }

    function _cycleFilter() {
        const order = ["all", "text", "image"];
        Clipboard.filter = order[(order.indexOf(Clipboard.filter) + 1) % order.length];
    }

    // --- search bar ------------------------------------------------------
    Item {
        id: searchBar
        width: root.width
        height: 28

        Item {
            id: fieldWrap
            anchors.left: parent.left
            anchors.right: buttonsRow.left
            anchors.rightMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: Colors.md3.surface_container
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: "Search clipboard..."
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
                focus: true

                onTextChanged: Clipboard.searchQuery = text

                Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
                Keys.onDownPressed: root.selectedIndex = Math.min(root.entries.length - 1, root.selectedIndex + 1)
                Keys.onReturnPressed: root._activateSelected()
                Keys.onEnterPressed: root._activateSelected()
            }
        }

        Row {
            id: buttonsRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            IconToggleButton {
                iconName: "common/x"
                tooltipText: "Clear search"
                onClicked: {
                    searchInput.text = "";
                    searchInput.forceActiveFocus();
                }
            }

            IconToggleButton {
                iconName: "search/" + (Clipboard.filter === "text" ? "abc" : Clipboard.filter === "image" ? "image" : "filter-off")
                tooltipText: Clipboard.filter === "text" ? "Filter: Text" : Clipboard.filter === "image" ? "Filter: Images" : "Filter: All"
                onClicked: root._cycleFilter()
            }

            IconToggleButton {
                iconName: "search/" + (Clipboard.sortOrder === "asc" ? "sort-ascending" : "sort-descending")
                tooltipText: Clipboard.sortOrder === "asc" ? "Order: Ascending" : "Order: Descending"
                onClicked: Clipboard.sortOrder = Clipboard.sortOrder === "asc" ? "desc" : "asc"
            }

            IconToggleButton {
                iconName: "search/" + (Clipboard.sortMode === "alphabetic" ? (Clipboard.sortOrder === "asc" ? "sort-a-z" : "sort-z-a") : (Clipboard.sortOrder === "asc" ? "sort-0-9" : "sort-9-0"))
                tooltipText: Clipboard.sortMode === "alphabetic" ? "Sort: Alphabetic" : "Sort: Numeric"
                onClicked: Clipboard.sortMode = Clipboard.sortMode === "alphabetic" ? "numeric" : "alphabetic"
            }
        }
    }

    // --- results -----------------------------------------------------------
    ListView {
        id: list
        width: root.width
        height: 320
        clip: true
        model: root.entries
        currentIndex: root.selectedIndex
        boundsBehavior: Flickable.StopAtBounds

        delegate: EntryDelegate {
            width: list.width
        }
    }

    // --- footer: position indicator ---------------------------------------
    Text {
        width: root.width
        horizontalAlignment: Text.AlignRight
        rightPadding: 8
        text: root.entries.length === 0 ? "0 / 0" : (root.selectedIndex + 1) + " / " + root.entries.length
        color: Colors.md3.on_surface_variant
        font.pixelSize: 11
    }

    // --- local components ----------------------------------------------------
    component IconToggleButton: Item {
        id: button

        default property alias data: content.data

        property string iconName: ""
        property string tooltipText: ""
        signal clicked

        readonly property bool hovered: mouseArea.containsMouse

        implicitWidth: 24
        implicitHeight: 24

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: mouseArea.containsMouse ? Colors.md3.surface_container_high : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Item {
            id: content
            anchors.fill: parent

            Icon {
                anchors.centerIn: parent
                name: button.iconName
                size: 14
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }

        Tooltip {
            target: button
            text: button.tooltipText
        }
    }

    component EntryDelegate: Item {
        id: delegate

        required property var modelData
        required property int index

        implicitHeight: 32
        property string previewPath: ""

        Connections {
            target: Clipboard
            function onImagePreviewReady(id, path) {
                if (id === delegate.modelData.id)
                    delegate.previewPath = path;
            }
        }

        Component.onCompleted: {
            if (delegate.modelData.isImage)
                Clipboard.requestImagePreview(delegate.modelData.id);
        }

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: delegate.ListView.isCurrentItem ? Colors.md3.surface_container_high : rowMouse.containsMouse ? Colors.md3.surface_container : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
                width: 28
                text: String(delegate.modelData.id)
                color: Colors.md3.on_surface_variant
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Image {
                visible: delegate.modelData.isImage && delegate.previewPath !== ""
                source: delegate.previewPath !== "" ? "file://" + delegate.previewPath : ""
                height: 24
                width: 24
                fillMode: Image.PreserveAspectFit
                asynchronous: true
            }

            Text {
                visible: delegate.modelData.isImage && delegate.previewPath === ""
                text: "Loading image..."
                color: Colors.md3.on_surface_variant
                font.pixelSize: 12
                font.italic: true
            }

            Text {
                visible: !delegate.modelData.isImage
                width: parent.width - 44
                text: delegate.modelData.preview
                color: Colors.md3.on_surface
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }

        MouseArea {
            id: rowMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.selectedIndex = delegate.index;
                Clipboard.select(delegate.modelData.id);
                root.entrySelected();
            }
        }
    }
}
