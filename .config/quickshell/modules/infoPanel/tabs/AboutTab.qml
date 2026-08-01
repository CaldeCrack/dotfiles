import QtQuick
import "about"

// About tab layout: left section (profile/system info) takes a fixed
// proportion of the width; the remaining space is split into two stacked
// sections (distro info on top, shell info below). Each section's actual
// content lives in about/ — this file only owns sizing/positioning.
Item {
    id: root

    // Instantiated via Loader's sourceComponent from InfoPanel — this fills
    // whatever size the Loader (and in turn the fixed content area) gives it.
    anchors.fill: parent

    readonly property int sectionSpacing: 8
    // Width available for the 2 top-level sections (left / right column)
    // once the 1 gap between them is accounted for.
    readonly property real usableWidth: width - sectionSpacing
    readonly property real proportion: 0.38

    Row {
        anchors.fill: parent
        spacing: root.sectionSpacing

        ProfileSection {
            width: root.usableWidth * root.proportion
            height: parent.height
        }

        Item {
            id: rightColumn

            width: root.usableWidth * (1 - root.proportion)
            height: parent.height

            Column {
                anchors.fill: parent
                spacing: root.sectionSpacing

                DistroSection {
                    width: parent.width
                    height: (parent.height - root.sectionSpacing) / 2
                }

                ShellSection {
                    width: parent.width
                    height: (parent.height - root.sectionSpacing) / 2
                }
            }
        }
    }
}
