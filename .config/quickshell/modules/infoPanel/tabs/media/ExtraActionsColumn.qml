import QtQuick
import qs.services
import qs.widgets
import "extra"

// Three buttons, tooltip on hover, popup to the right on click — only one
// popup open at a time (activePopup tracks which). Only volume and player
// are wired up for real right now; output is stubbed with a tooltip but no
// popup content yet.
Item {
    id: root

    property string activePopup: "" // "", "volume", "player", "output"

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    Column {
        id: column
        spacing: 12

        PanelIconButton {
            id: volumeButton
            iconName: Audio.currentVolumeIcon
            checked: root.activePopup === "volume"
            onClicked: root.activePopup = (root.activePopup === "volume" ? "" : "volume")
        }

        // Shows the active player's real system icon (e.g. Spotify's own
        // icon, Zen's own icon) via Media.resolveIconName —
        // falls back to the bundled media/music icon whenever that
        // resolves to nothing (no active player, or the lookup failed).
        PanelIconButton {
            id: playerButton
            iconName: "media/music"
            systemIconName: Media.available ? Media.resolveIconName(Media.activePlayer.desktopEntry) : ""
            checked: root.activePopup === "player"
            onClicked: root.activePopup = (root.activePopup === "player" ? "" : "player")
        }

        PanelIconButton {
            id: outputButton
            iconName: Audio.iconNameForSink(Audio.sink)
            checked: root.activePopup === "output"
            onClicked: root.activePopup = (root.activePopup === "output" ? "" : "output")
        }
    }

    // Tooltips are siblings, not children — PanelIconButton has no
    // default content slot (unlike BarButtonBase), and Tooltip is a
    // PopupWindow anchored via `target` rather than parent/child anyway.
    Tooltip {
        target: volumeButton
        text: "Volume"
    }
    Tooltip {
        target: playerButton
        text: "Players"
    }
    Tooltip {
        target: outputButton
        text: "Output device"
    }

    VolumePopup {
        anchorItem: volumeButton
        open: root.activePopup === "volume"
        onDismissRequested: root.activePopup = ""
        volume: Audio.volume
        muted: Audio.muted
        onVolumeChangeRequested: newVolume => Audio.setVolume(newVolume)
    }

    PlayerSelectorPopup {
        anchorItem: playerButton
        open: root.activePopup === "player"
        onDismissRequested: root.activePopup = ""
    }

    OutputSelectorPopup {
        anchorItem: outputButton
        open: root.activePopup === "output"
        onDismissRequested: root.activePopup = ""
    }
}
