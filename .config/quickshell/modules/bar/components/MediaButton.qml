import QtQuick
import qs.widgets
import qs.config
import qs.services
import qs.modules.infoPanel

BarButtonBase {
    id: root

    readonly property int mediaTabIndex: 1

    tooltipText: Media.title + "\n" + Media.artist

    // Reflect whether the panel is currently open on this tab, so the
    // button gets BarButtonBase's checked styling for free.
    checked: InfoPanel.panelOpen && InfoPanel.currentIndex === mediaTabIndex

    onClicked: {
        if (checked)
            InfoPanel.close();
        else
            InfoPanel.show(mediaTabIndex);
    }

    Row {
        id: mediaControls

        width: 100
        spacing: 2

        MarqueeText {
            text: Media.title + " - " + Media.artist
            color: Colors.md3.on_surface
            width: parent.width
            font.pixelSize: root.height * 0.5
            font.bold: true
            anchors.verticalCenter: mediaControls.verticalCenter
            lineHeight: 0.85
            lineHeightMode: Text.ProportionalHeight
        }

        PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "media/previous"
            iconSize: 16
            padding: 4
            hoveredColor: Colors.md3.on_primary
            hoveredBackgroundColor: Colors.md3.primary
            enabled: Media.canGoPrevious
            onClicked: Media.previous()
        }

        PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: Media.isPlaying ? "media/pause" : "media/play"
            iconSize: 16
            padding: 4
            hoveredColor: Colors.md3.on_primary
            hoveredBackgroundColor: Colors.md3.primary
            enabled: Media.available
            onClicked: Media.playPause()
        }

        PanelIconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "media/next"
            iconSize: 16
            padding: 4
            hoveredColor: Colors.md3.on_primary
            hoveredBackgroundColor: Colors.md3.primary
            enabled: Media.canGoNext
            onClicked: Media.next()
        }
    }
}
