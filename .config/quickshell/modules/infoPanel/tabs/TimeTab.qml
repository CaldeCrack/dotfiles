import QtQuick
import "time"

// Time tab layout — same skeleton as AboutTab, mirrored: the single "big"
// section sits on the right instead of the left, with the two stacked
// sections on the left. Content for each section is still TBD, this file
// only owns sizing/positioning.
Item {
    id: root

    // Instantiated via Loader's sourceComponent from InfoPanel — this fills
    // whatever size the Loader (and in turn the fixed content area) gives it.
    anchors.fill: parent

    readonly property int sectionSpacing: 8
    // Width available for the 2 top-level sections (left column / big right
    // section) once the 1 gap between them is accounted for.
    readonly property real usableWidth: width - sectionSpacing
    // Width fraction taken by the big (right) section.
    readonly property real proportion: 0.3

    Row {
        anchors.fill: parent
        spacing: root.sectionSpacing

        Clock {
            width: root.usableWidth * root.proportion
            height: parent.height
        }

        Calendar {
            width: root.usableWidth * (1 - root.proportion)
            height: parent.height
        }
    }
}
