import QtQuick
import qs.services
import qs.widgets
import qs.config

// One row: shuffle | previous | play/pause | next | loop. Shuffle and loop
// live here rather than in ExtraActionsColumn — they're playback behavior,
// not miscellaneous actions like player-switching, per the tab spec.
Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    // Icon names are placeholders matching common naming conventions —
    // swap for whatever actually exists in assets/icons/. The loop button
    // swaps icon per state instead of needing 3 separate assets with a
    // dot/badge treatment — simplest starting point, revisit if "off" vs
    // "track" vs "playlist" need a more distinct visual than icon swap.
    readonly property var loopIconNames: ({
            0: "media/repeat-off" // MprisLoopState.None
            ,
            1: "media/repeat-one"     // MprisLoopState.Playlist
            ,
            2: "media/repeat"  // MprisLoopState.Track
        })

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 12

        PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: Media.shuffle ? "media/shuffle" : "media/shuffle-off"
            iconSize: 16
            enabled: Media.available
            onClicked: Media.toggleShuffle()
        }

        PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "media/previous"
            enabled: Media.canGoPrevious
            onClicked: Media.previous()
        }

        // Primary action — bigger than its neighbors, no checked state
        // (play/pause is reflected via icon swap, not a toggle highlight).
        PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: Media.isPlaying ? "media/pause" : "media/play"
            iconSize: 24
            padding: 12
            color: Colors.md3.on_surface
            backgroundColor: Colors.md3.surface_container_high
            hoveredColor: Colors.md3.on_primary
            hoveredBackgroundColor: Colors.md3.primary
            enabled: Media.available
            onClicked: Media.playPause()
        }

        PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "media/next"
            enabled: Media.canGoNext
            onClicked: Media.next()
        }

        PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: root.loopIconNames[Media.loopState] ?? "media/repeat-off"
            iconSize: 16
            enabled: Media.available
            onClicked: Media.cycleLoop()
        }
    }
}
