import QtQuick
import qs.services as Services
import "media" as Media

// Music tab layout: mirrors AboutTab's pattern — this file owns sizing and
// positioning only, actual content lives in sibling files under music/.
//
// Layout, per spec:
//   - whole content block vertically centered
//   - artwork circle on the left
//   - metadata anchored to the right of the artwork
//   - controls below metadata, seekbar below controls
//   - extra actions in a column, anchored to the tab's right edge
//     independently of the centered block
//
// Right now most pieces are flat placeholder Rects so the proportions can
// be checked against the real InfoPanel content area before any of them
// have real content. MetadataSection is the one exception — it's wired to
// Media already, since the whole point of this step is confirming the
// service works end to end.
Item {
    id: root

    anchors.fill: parent

    readonly property int artworkSize: 160
    readonly property int blockSpacing: 16
    readonly property int innerSpacing: 8
    readonly property int extraActionsWidth: 64

    Media.BlurredBackground {
        anchors.fill: parent
    }

    // --- centered block: artwork + (metadata / controls / seekbar) --------
    Row {
        id: centeredBlock
        anchors.centerIn: parent
        spacing: root.blockSpacing

        Media.ArtworkVisualizer {
            size: root.artworkSize
        }

        Column {
            spacing: root.innerSpacing
            // Keeps the column's own width from collapsing to its
            // narrowest child — metadata text lines wrap/elide against a
            // fixed width rather than the column auto-shrinking around
            // whichever placeholder is currently widest.
            width: 260

            Media.MetadataSection {
                width: parent.width
            }

            Media.GeneralControls {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Media.Seekbar {
                width: parent.width
            }
        }
    }

    Media.ExtraActionsColumn {
        anchors {
            right: parent.right
            rightMargin: root.blockSpacing
            verticalCenter: parent.verticalCenter
        }
    }
}
