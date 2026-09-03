import QtQuick
import qs.services
import qs.widgets
import qs.config

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

    readonly property int columns: 3
    readonly property int rows: 2
    readonly property int cellSpacing: 8
    readonly property int itemsPerPage: columns * rows
    readonly property string currentWallpaperName: Wallpaper.currentWallpaper

    readonly property real effectiveCellWidth: (width - (columns - 1) * cellSpacing) / columns
    readonly property real effectiveCellHeight: (height - (rows - 1) * cellSpacing) / rows

    readonly property var filteredWallpapers: {
        if (!root.filterText)
            return Wallpaper.wallpapers;
        const needle = root.filterText.toLowerCase();
        return Wallpaper.wallpapers.filter(path => path.toLowerCase().includes(needle));
    }

    readonly property int totalPages: Math.max(1, Math.ceil(filteredWallpapers.length / itemsPerPage))
    property int currentPage: 0

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

    // ---- Keyboard navigation -----------------------------------------
    // Moves the highlight by (dx, dy) in grid terms, derived from wherever
    // selectedWallpaper currently sits within pagedWallpapers. Vertical
    // movement clamps at the current page's top/bottom row. Horizontal
    // movement past the current page's left/right edge changes page
    // instead of clamping — landing on the matching edge column of the
    // new page.

    focus: true

    Keys.onLeftPressed: moveFocus(-1, 0)
    Keys.onRightPressed: moveFocus(1, 0)
    Keys.onUpPressed: moveFocus(0, -1)
    Keys.onDownPressed: moveFocus(0, 1)

    function moveFocus(dx, dy) {
        if (pagedWallpapers.length === 0)
            return;

        const idx = pagedWallpapers.indexOf(selectedWallpaper);
        if (idx === -1) {
            // Nothing on this page is highlighted yet (e.g. current
            // selection got filtered out) — land on the first item rather
            // than trying to compute a relative move from nothing.
            wallpaperSelected(pagedWallpapers[0]);
            return;
        }

        const row = Math.floor(idx / columns);
        const newCol = (idx % columns) + dx;

        if (newCol < 0 && currentPage > 0) {
            prevPage();
            selectAtEdge(row, columns - 1); // rightmost column of the new page
            return;
        }
        if (newCol >= columns && currentPage < totalPages - 1) {
            nextPage();
            selectAtEdge(row, 0); // leftmost column of the new page
            return;
        }

        const col = Math.max(0, Math.min(columns - 1, newCol));
        const newRow = Math.max(0, Math.min(rows - 1, row + dy));

        let newIndex = newRow * columns + col;
        if (newIndex >= pagedWallpapers.length)
            newIndex = pagedWallpapers.length - 1;

        wallpaperSelected(pagedWallpapers[newIndex]);
    }

    // Lands the highlight on a specific row/column of whatever page is
    // *now* current — called right after prevPage()/nextPage(), by which
    // point pagedWallpapers has already recomputed for the new page.
    function selectAtEdge(row, col) {
        if (pagedWallpapers.length === 0)
            return;
        let idx = row * columns + col;
        if (idx >= pagedWallpapers.length)
            idx = pagedWallpapers.length - 1;
        wallpaperSelected(pagedWallpapers[idx]);
    }

    Grid {
        anchors.fill: parent

        columns: root.columns
        rows: root.rows

        columnSpacing: root.cellSpacing
        rowSpacing: root.cellSpacing

        Repeater {
            model: root.pagedWallpapers

            delegate: Item {
                width: root.effectiveCellWidth
                height: root.effectiveCellHeight

                readonly property bool isSelected: modelData === root.selectedWallpaper
                readonly property bool isCurrent: modelData === root.currentWallpaperName
                readonly property string fileName: Wallpaper.relativePath(modelData)

                Column {
                    anchors.fill: parent
                    spacing: 2

                    Item {
                        width: parent.width
                        height: parent.height - fileNameText.height - 2

                        Rectangle {
                            anchors.fill: parent
                            color: Colors.md3.surface_container_lowest
                            radius: 4

                            border.width: (isCurrent || isSelected || mouseArea.containsMouse) ? 4 : 0
                            border.color: isCurrent ? Colors.md3.primary : Colors.md3.tertiary

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
                                    topMargin: 6
                                    rightMargin: 6
                                }

                                color: Colors.md3.primary

                                Icon {
                                    anchors.centerIn: parent
                                    size: 14
                                    name: "common/check"
                                    color: Colors.md3.surface_container_lowest
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                // Reclaim keyboard focus on click too — e.g.
                                // after typing in the search field, clicking
                                // a thumbnail directly (without Escape first)
                                // should let arrow keys pick up from here.
                                root.forceActiveFocus();
                                root.wallpaperSelected(isSelected ? root.currentWallpaperName : modelData);
                            }
                        }
                    }

                    Text {
                        id: fileNameText
                        width: parent.width
                        text: fileName
                        color: Colors.md3.on_surface
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideMiddle
                        font.pixelSize: 12
                    }
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: "No wallpapers found"
        color: Colors.md3.on_surface_variant
        visible: root.pagedWallpapers.length === 0
    }
}
