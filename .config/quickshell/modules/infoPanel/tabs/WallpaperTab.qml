import QtQuick
import "wallpaper" as Wallpaper
import qs.services as Services

// Wallpaper tab: three stacked sections, full width each. This file owns
// sizing/positioning AND wiring between the sections (unlike a pure layout
// file like About's) since it's the natural place for state that's shared
// across siblings — selection needs to reach both the grid (highlight) and
// the search bar (enable Apply), and pagination needs to reach both the
// grid (owns the math) and the footer (displays/drives it).
Item {
    id: root

    anchors.fill: parent

    readonly property int sectionSpacing: 8
    readonly property real searchBarHeight: 40
    readonly property real footerHeight: 36
    readonly property real gridHeight: height - searchBarHeight - footerHeight - sectionSpacing * 2

    // Highlighted-but-not-yet-applied selection. Starts on whatever's
    // actually active; only becomes the new "current" once Apply is
    // pressed and WallpaperService round-trips through matugen — Colors.qml
    // picks that up on its own via its FileView watch.
    property string selectedWallpaper: Services.Wallpaper.currentWallpaper

    Column {
        anchors.fill: parent
        spacing: root.sectionSpacing

        Wallpaper.SearchBar {
            width: parent.width
            height: root.searchBarHeight

            canApply: root.selectedWallpaper !== "" && root.selectedWallpaper !== Services.Wallpaper.currentWallpaper

            onSearchTextChanged: grid.filterText = searchText
            onOpenFolderRequested: Services.Wallpaper.openFolder()
            onRefreshRequested: Services.Wallpaper.refresh()
            onApplyRequested: Services.Wallpaper.applyWallpaper(root.selectedWallpaper)
        }

        Wallpaper.Grid {
            id: grid
            width: parent.width
            height: root.gridHeight

            selectedWallpaper: root.selectedWallpaper

            onWallpaperSelected: path => root.selectedWallpaper = path
        }

        Wallpaper.Footer {
            width: parent.width
            height: root.footerHeight

            currentWallpaperPath: Services.Wallpaper.currentWallpaper
            currentPage: grid.currentPage
            totalPages: grid.totalPages

            onPrevRequested: grid.prevPage()
            onNextRequested: grid.nextPage()
        }
    }
}
