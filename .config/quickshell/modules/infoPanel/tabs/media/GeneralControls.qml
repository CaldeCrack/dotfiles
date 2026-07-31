import QtQuick
import qs.services as Services
import qs.widgets as Widgets
import qs.config as Config

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
            0: "media/repeat-off" // MprisLoopState.None      — TODO: confirm actual enum values
            ,
            1: "media/repeat"     // MprisLoopState.Track
            ,
            2: "media/repeat-one"  // MprisLoopState.Playlist
        })

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 12

        Widgets.PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: Services.Media.shuffle ? "media/shuffle" : "media/shuffle-off"
            iconSize: 16
            enabled: Services.Media.available
            onClicked: Services.Media.toggleShuffle()
        }

        Widgets.PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "media/previous"
            enabled: Services.Media.canGoPrevious
            onClicked: Services.Media.previous()
        }

        // Primary action — bigger than its neighbors, no checked state
        // (play/pause is reflected via icon swap, not a toggle highlight).
        Widgets.PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: Services.Media.isPlaying ? "media/pause" : "media/play"
            iconSize: 24
            padding: 12
            color: Config.Colors.md3.on_surface
            backgroundColor: Config.Colors.md3.surface_container_high
            hoveredColor: Config.Colors.md3.on_primary
            hoveredBackgroundColor: Config.Colors.md3.primary
            enabled: Services.Media.available
            onClicked: Services.Media.playPause()
        }

        Widgets.PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "media/next"
            enabled: Services.Media.canGoNext
            onClicked: Services.Media.next()
        }

        Widgets.PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: root.loopIconNames[Services.Media.loopState] ?? "media/repeat-off"
            iconSize: 16
            enabled: Services.Media.available
            onClicked: Services.Media.cycleLoop()
        }
    }
}
