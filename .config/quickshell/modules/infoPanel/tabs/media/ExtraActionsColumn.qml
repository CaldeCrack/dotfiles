import QtQuick
import qs.services as Services
import qs.widgets as Widgets
import "extra" as Extra

// Three buttons, tooltip on hover, popup to the right on click — only one
// popup open at a time (activePopup tracks which). Only volume and player
// are wired up for real right now; output is stubbed with a tooltip but no
// popup content yet.
Item {
    id: root

    property string activePopup: "" // "", "volume", "player", "output"

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    function volumeIconName(vol, isMuted) {
        if (isMuted)
            return "media/volume-off";
        if (vol <= 0)
            return "media/volume-x";
        if (vol < 40)
            return "media/volume";
        if (vol < 80)
            return "media/volume-1";
        return "media/volume-2";
    }

    Column {
        id: column
        spacing: 12

        Widgets.PanelIconButton {
            id: volumeButton
            iconName: root.volumeIconName(Services.Audio.volume, Services.Audio.muted)
            checked: root.activePopup === "volume"
            onClicked: root.activePopup = (root.activePopup === "volume" ? "" : "volume")
        }

        // Shows the active player's real system icon (e.g. Spotify's own
        // icon, Zen's own icon) via Services.Media.resolveIconName —
        // falls back to the bundled media/music icon whenever that
        // resolves to nothing (no active player, or the lookup failed).
        Widgets.PanelIconButton {
            id: playerButton
            iconName: "media/music"
            systemIconName: Services.Media.available ? Services.Media.resolveIconName(Services.Media.activePlayer.desktopEntry) : ""
            checked: root.activePopup === "player"
            onClicked: root.activePopup = (root.activePopup === "player" ? "" : "player")
        }

        Widgets.PanelIconButton {
            id: outputButton
            iconName: Services.Audio.iconNameForSink(Services.Audio.sink)
            checked: root.activePopup === "output"
            onClicked: root.activePopup = (root.activePopup === "output" ? "" : "output")
        }
    }

    // Tooltips are siblings, not children — PanelIconButton has no
    // default content slot (unlike BarButtonBase), and Tooltip is a
    // PopupWindow anchored via `target` rather than parent/child anyway.
    Widgets.Tooltip {
        target: volumeButton
        text: "Volume"
    }
    Widgets.Tooltip {
        target: playerButton
        text: "Players"
    }
    Widgets.Tooltip {
        target: outputButton
        text: "Output device"
    }

    Extra.VolumePopup {
        anchorItem: volumeButton
        open: root.activePopup === "volume"
        onDismissRequested: root.activePopup = ""
        volume: Services.Audio.volume
        muted: Services.Audio.muted
        onVolumeChangeRequested: newVolume => Services.Audio.setVolume(newVolume)
    }

    Extra.PlayerSelectorPopup {
        anchorItem: playerButton
        open: root.activePopup === "player"
        onDismissRequested: root.activePopup = ""
    }

    Extra.OutputSelectorPopup {
        anchorItem: outputButton
        open: root.activePopup === "output"
        onDismissRequested: root.activePopup = ""
    }
}
