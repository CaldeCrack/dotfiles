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

Item {
    id: root

    property var model: []
    property string layoutMode: "list"

    signal activateIndex(int index)

    // A Loader swap, not two always-alive views with one hidden — cheaper
    // (only the active layout's delegates ever exist) at the cost of
    // losing scroll position across a toggle, which is an acceptable
    // trade for a launcher that's freshly opened each time anyway.
    Loader {
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

            // No real keyboard navigation yet (step 5) — index 0 is
            // always "the" selection for now, matching Enter-activates-
            // top-result in LauncherSearchBar/Launcher.qml.
            currentIndex: 0

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
            currentIndex: 0

            // Fixed cellWidth left a leftover gap on the right edge
            // whenever the card width wasn't an exact multiple of it.
            // Picking the column count from the available width and then
            // dividing back into cellWidth makes each column stretch to
            // fill the row exactly, no matter the card size.
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
