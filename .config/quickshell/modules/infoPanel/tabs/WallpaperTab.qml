import QtQuick
import "wallpaper" as Wallpaper
import qs.services as Services
import qs.modules.infoPanel

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

    // Hands keyboard focus to the grid whenever this tab becomes the
    // active one, so arrow keys work immediately without a click first.
    //
    // This can't be driven by this item's own `visible` — InfoPanel binds
    // it (`visible: root.currentIndex === 0`), but if Wallpaper is already
    // the default tab (index 0) when the panel first opens, `visible` was
    // already true at creation and never actually *changes*, so
    // onVisibleChanged wouldn't fire on that first open. Watching
    // InfoPanel's own state directly covers both cases: opening straight
    // into this tab, and switching to it later.
    Connections {
        target: InfoPanel
        function onPanelOpenChanged() {
            if (InfoPanel.panelOpen && InfoPanel.currentIndex === 0)
                grid.forceActiveFocus();
        }
        function onCurrentIndexChanged() {
            if (InfoPanel.panelOpen && InfoPanel.currentIndex === 0)
                grid.forceActiveFocus();
        }
    }

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
