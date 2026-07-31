import QtQuick
import qs.services as Services
import qs.widgets as Widgets
import "extra" as Extra

// Three buttons, tooltip on hover, popup to the right on click — only one
// popup open at a time (activePopup tracks which). Only volume is wired
// up for real right now, per the current build step; player/output are
// stubbed with tooltips but no popup content yet.
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

        // TODO: player selector popup not built yet — button + tooltip
        // only, click currently just toggles activePopup with nothing to
        // show for it.
        Widgets.PanelIconButton {
            id: playerButton
            iconName: "media/music" // placeholder — confirm this exists in assets/icons/
            checked: root.activePopup === "player"
            onClicked: root.activePopup = (root.activePopup === "player" ? "" : "player")
        }

        // TODO: output device selector popup not built yet — same as above.
        Widgets.PanelIconButton {
            id: outputButton
            iconName: "media/speaker" // placeholder — confirm this exists in assets/icons/
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
        text: "Player"
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
}
