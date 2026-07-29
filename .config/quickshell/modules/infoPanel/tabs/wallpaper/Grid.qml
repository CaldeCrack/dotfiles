import QtQuick
import qs.services as Services
import qs.widgets as Widgets
import qs.config as Config

// Paged grid of wallpaper thumbnails. Clicking one only highlights it and
// emits wallpaperSelected — it does NOT apply anything itself; applying
// happens via the search bar's Apply button (see WallpaperTab, which owns
// the shared "selected" state between this and the search bar).
//
// Pages instead of scrolls: itemsPerPage is derived from actual available
// width/height so it stays correct if the panel is resized, and the footer
// drives currentPage via prevPage()/nextPage() rather than a scrollbar.
Item {
    id: root

    property string selectedWallpaper: ""
    property string filterText: ""

    signal wallpaperSelected(string path)

    // Fixed grid shape — cell size is derived from this to fill the
    // available width/height exactly, rather than the other way around.
    readonly property int columns: 3
    readonly property int rows: 2
    readonly property int cellSpacing: 8
    readonly property int itemsPerPage: columns * rows
    readonly property string currentWallpaperName: Services.Wallpaper.currentWallpaper

    readonly property real effectiveCellWidth: (width - columns * cellSpacing) / columns
    readonly property real effectiveCellHeight: (height - rows * cellSpacing) / rows

    readonly property var filteredWallpapers: {
        if (!root.filterText)
            return Services.Wallpaper.wallpapers;
        const needle = root.filterText.toLowerCase();
        return Services.Wallpaper.wallpapers.filter(path => path.toLowerCase().includes(needle));
    }

    readonly property int totalPages: Math.max(1, Math.ceil(filteredWallpapers.length / itemsPerPage))
    property int currentPage: 0

    // Filtering (or a resize that changes itemsPerPage) can shrink the page
    // count out from under an already-picked page — clamp back into range
    // rather than showing a blank grid.
    onTotalPagesChanged: if (currentPage >= totalPages)
        currentPage = totalPages - 1
    onFilterTextChanged: currentPage = 0

    readonly property var pagedWallpapers: filteredWallpapers.slice(currentPage * itemsPerPage, (currentPage + 1) * itemsPerPage)

    function nextPage() {
        if (currentPage < totalPages - 1)
            currentPage += 1;
    }
    function prevPage() {
        if (currentPage > 0)
            currentPage -= 1;
    }

    GridView {
        id: gridView
        anchors.fill: parent
        cellWidth: root.effectiveCellWidth + root.cellSpacing
        cellHeight: root.effectiveCellHeight + root.cellSpacing
        interactive: false // paging replaces scrolling
        model: root.pagedWallpapers

        delegate: Item {
            width: gridView.cellWidth - root.cellSpacing
            height: gridView.cellHeight - root.cellSpacing

            readonly property bool isSelected: modelData === root.selectedWallpaper
            readonly property bool isCurrent: modelData === root.currentWallpaperName
            readonly property string fileName: modelData.split("/").pop()

            Column {
                anchors.fill: parent
                spacing: 2

                Item {
                    width: parent.width
                    height: parent.height - fileNameText.height - 2

                    Rectangle {
                        anchors.fill: parent
                        color: Config.Colors.md3.surface_container_lowest
                        radius: 4

                        border.width: (isCurrent || isSelected || mouseArea.containsMouse) ? 4 : 0
                        border.color: isCurrent ? Config.Colors.md3.primary : Config.Colors.md3.tertiary

                        Behavior on border.width {
                            NumberAnimation {
                                duration: 100
                            }
                        }

                        Image {
                            anchors.fill: parent
                            anchors.margins: parent.border.width
                            source: "file://" + modelData
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            clip: true
                        }

                        Rectangle {
                            visible: isCurrent

                            width: 24
                            height: 24
                            radius: width / 2

                            anchors {
                                top: parent.top
                                right: parent.right
                                topMargin: 4
                                rightMargin: 4
                            }

                            color: Config.Colors.md3.primary

                            Widgets.Icon {
                                anchors.centerIn: parent
                                size: 14
                                name: "common/check"
                                color: Config.Colors.md3.surface_container_lowest
                            }
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: root.wallpaperSelected(isSelected ? currentWallpaperName : modelData)
                    }
                }

                Text {
                    id: fileNameText
                    width: parent.width
                    text: fileName
                    color: Config.Colors.md3.on_surface
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideMiddle
                    font.pixelSize: 12
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: "No wallpapers found"
        color: Config.Colors.md3.on_surface_variant
        visible: root.pagedWallpapers.length === 0
    }
}
