import QtQuick
import qs.config
import qs.widgets

// LauncherResults
// ----------------
// Mode-agnostic by design: it never knows whether `model` came from apps,
// calc, or keybind search — it just renders whatever unified entries it's
// handed (see Launcher.qml's buildResultsFor). List/grid toggling swaps
// between LauncherEntry and LauncherGridEntry delegates via a Loader,
// both reading the same `model`.
//
// This is also where keyboard navigation lives: currentIndex is owned
// here (not in Launcher.qml) because moving up/down a step needs to know
// how many columns the grid currently has, and that number only exists
// inside the live GridView instance. List mode is just the grid-nav math
// with columns pinned to 1 — no separate code path needed.

Item {
    id: root

    property var model: []
    property string layoutMode: "list"
    property int currentIndex: 0

    signal activateIndex(int index)

    // A fresh result set (every keystroke) should always start selected
    // at the top match, same as before keyboard nav existed.
    onModelChanged: currentIndex = 0

    function columnCount() {
        return (root.layoutMode === "grid" && resultsLoader.item) ? resultsLoader.item.columns : 1;
    }

    function clampIndex(i) {
        if (!root.model || root.model.length === 0)
            return 0;
        return Math.max(0, Math.min(root.model.length - 1, i));
    }

    function moveUp() {
        root.currentIndex = clampIndex(root.currentIndex - columnCount());
    }
    function moveDown() {
        root.currentIndex = clampIndex(root.currentIndex + columnCount());
    }

    // Left/right only mean anything once entries sit side by side — in
    // list mode they're left alone entirely so the search field's own
    // text-cursor movement isn't hijacked (see LauncherSearchBar's
    // Keys.onLeftPressed/onRightPressed, which only forward here when
    // layoutMode is "grid").
    function moveLeft() {
        if (root.layoutMode !== "grid")
            return;
        root.currentIndex = clampIndex(root.currentIndex - 1);
    }
    function moveRight() {
        if (root.layoutMode !== "grid")
            return;
        root.currentIndex = clampIndex(root.currentIndex + 1);
    }

    function activateCurrent() {
        root.activateIndex(root.currentIndex);
    }

    // A Loader swap, not two always-alive views with one hidden — cheaper
    // (only the active layout's delegates ever exist) at the cost of
    // losing scroll position across a toggle, which is an acceptable
    // trade for a launcher that's freshly opened each time anyway.
    Loader {
        id: resultsLoader
        anchors.fill: parent
        sourceComponent: root.layoutMode === "grid" ? gridComp : listComp
    }

    Component {
        id: listComp

        ListView {
            id: listView
            clip: true
            spacing: 2
            model: root.model
            currentIndex: root.currentIndex // view auto-scrolls to follow

            delegate: LauncherEntry {
                width: listView.width
                onActivated: root.activateIndex(index)
            }
        }
    }

    Component {
        id: gridComp

        GridView {
            id: gridView
            clip: true
            model: root.model
            currentIndex: root.currentIndex // view auto-scrolls to follow

            // Fixed cellWidth left a leftover gap on the right edge
            // whenever the card width wasn't an exact multiple of it.
            // Picking the column count from the available width and then
            // dividing back into cellWidth makes each column stretch to
            // fill the row exactly, no matter the card size. columnCount()
            // above reads this same property to do left/right/up/down math.
            readonly property int targetCellSize: 96
            readonly property int columns: Math.max(1, Math.floor(width / targetCellSize))
            cellWidth: width / columns
            cellHeight: 96

            delegate: LauncherGridEntry {
                onActivated: root.activateIndex(index)
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: !root.model || root.model.length === 0
        text: "No results"
        color: Colors.md3.on_surface_variant
    }
}
