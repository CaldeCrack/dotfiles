import QtQuick
import "media"

Item {
    id: root

    anchors.fill: parent

    readonly property int artworkSize: 160
    readonly property int extraActionsRightMargin: 12
    readonly property int blockSpacing: 30
    readonly property int innerSpacing: 8
    readonly property int extraActionsWidth: 64

    BlurredBackground {
        anchors.fill: parent
    }

    ExtraActionsColumn {
        id: extraActions

        anchors {
            right: parent.right
            rightMargin: root.extraActionsRightMargin
            verticalCenter: parent.verticalCenter
        }
    }

    Column {
        id: infoColumn

        width: 260
        spacing: root.innerSpacing

        anchors {
            right: extraActions.left
            rightMargin: root.blockSpacing
            verticalCenter: parent.verticalCenter
        }

        MetadataSection {
            width: parent.width
        }

        GeneralControls {
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Seekbar {
            width: parent.width
        }
    }

    // Region between the left edge and the metadata column.
    // The artwork is centered within this space.
    Item {
        id: artworkRegion

        anchors {
            left: parent.left
            right: infoColumn.left
            top: parent.top
            bottom: parent.bottom
        }

        ArtworkVisualizer {
            size: root.artworkSize

            anchors.centerIn: parent
        }
    }
}
