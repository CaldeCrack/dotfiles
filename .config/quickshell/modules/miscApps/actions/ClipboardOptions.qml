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

    // TextInput holds active focus while typing, and Escape isn't
    // guaranteed to bubble back up through the Loader/NavStack chain to
    // DismissablePopup's own Keys.onEscapePressed. Reporting it
    // explicitly here (same pattern as entrySelected) sidesteps relying
    // on that propagation at all.
    signal escapePressed

    width: 300
    spacing: 4

    readonly property var entries: Clipboard.entries
    property int selectedIndex: 0

    onEntriesChanged: selectedIndex = entries.length === 0 ? 0 : Math.min(selectedIndex, entries.length - 1)
    onSelectedIndexChanged: list.positionViewAtIndex(selectedIndex, ListView.Contain)

    // Clipboard (a Singleton) doesn't fire its own Component.onCompleted,
    // so whatever first shows this view is responsible for populating it.
    Component.onCompleted: {
        Clipboard.refresh();
        list.forceActiveFocus();
    }

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

                onTextChanged: Clipboard.searchQuery = text

                HoverHandler {
                    cursorShape: Qt.IBeamCursor
                }

                Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
                Keys.onDownPressed: root.selectedIndex = Math.min(root.entries.length - 1, root.selectedIndex + 1)
                Keys.onReturnPressed: root._activateSelected()
                Keys.onEnterPressed: root._activateSelected()
                Keys.onEscapePressed: root.escapePressed()
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
                    Clipboard.filter = "all";
                    Clipboard.sortOrder = "desc";
                    Clipboard.sortMode = "numeric";
                }
            }

            IconToggleButton {
                iconName: "search/" + (Clipboard.filter === "text" ? "abc" : Clipboard.filter === "image" ? "image" : "filter-off")
                tooltipText: Clipboard.filter === "text" ? "Filter: Text" : Clipboard.filter === "image" ? "Filter: Images" : "Filter: None"
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
        focus: true

        Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
        Keys.onDownPressed: root.selectedIndex = Math.min(root.entries.length - 1, root.selectedIndex + 1)
        Keys.onReturnPressed: root._activateSelected()
        Keys.onEnterPressed: root._activateSelected()
        Keys.onEscapePressed: root.escapePressed()

        delegate: EntryDelegate {
            width: list.width
        }
    }

    // --- footer: wipe history + position indicator -------------------------
    Item {
        id: footer
        width: root.width
        height: 24

        IconLabelButton {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            iconName: "common/trash"
            label: "Clear"
            tooltipText: "Wipe clipboard history"
            onClicked: Clipboard.clear()
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

    // Same idea as IconToggleButton, but with a text label alongside the
    // icon — IconToggleButton stays icon-only since that's all the search
    // bar needs, rather than growing an optional label nobody else uses.
    component IconLabelButton: Item {
        id: labelButton

        property string iconName: ""
        property string label: ""
        property string tooltipText: ""
        signal clicked

        readonly property bool hovered: mouseArea.containsMouse

        implicitWidth: content.implicitWidth + 12
        implicitHeight: 24

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
                name: labelButton.iconName
                size: 14
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: labelButton.label
                color: Colors.md3.on_surface_variant
                font.pixelSize: 11
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: labelButton.clicked()
        }

        Tooltip {
            target: labelButton
            text: labelButton.tooltipText
        }
    }

    component EntryDelegate: Item {
        id: delegate

        required property var modelData
        required property int index

        implicitHeight: content.implicitHeight + 8

        readonly property string previewPath: Clipboard._imagePreviewPaths[String(delegate.modelData.id)] || ""

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

        Column {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.topMargin: 4
            spacing: 8

            Row {
                Text {
                    width: 28
                    anchors.verticalCenter: parent.verticalCenter
                    text: String(delegate.modelData.id)
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: delegate.modelData.isImage && delegate.previewPath === ""
                    text: "Loading image..."
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 12
                    font.italic: true
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !delegate.modelData.isImage
                    width: content.width - 44
                    text: delegate.modelData.preview
                    color: Colors.md3.on_surface
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }
            }

            // Full row width rather than a fixed icon-sized box — height
            // follows the source image's real aspect ratio once it's
            // loaded (implicitWidth/Height reflect the natural source
            // size), falling back to a placeholder height while it's
            // still loading so the row doesn't start at 0 height.
            Image {
                id: previewImage
                visible: delegate.modelData.isImage && delegate.previewPath !== ""
                width: content.width
                height: implicitWidth > 0 ? width * (implicitHeight / implicitWidth) : 100
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                source: delegate.previewPath !== "" ? Qt.resolvedUrl(delegate.previewPath) : ""
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
