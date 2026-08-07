import QtQuick
import QtQuick.Effects
import qs.config

// Tall stat tile — same card chrome as StatGauge (background, border, hover
// glow) but no gauge ring: used for stats that don't have a natural
// percentage/total shape (temperature, battery). Sits at the start/end of
// SystemStatsButton's popup, each one square-width but 2x the height of a
// StatGauge cell.
//
// Deliberately no implicitWidth/implicitHeight here, same reasoning as
// StatGauge — the caller (SystemStatsButton) owns one shared size and sets
// width on both this and StatGauge, with height: width * 2 on this one, so
// the two stay in sync by construction rather than by two components
// independently agreeing on a magic number.
//
// This is only the shared shell for now — icon/value/whatever-visual-form
// temperature and battery end up taking gets added on top of this later.
Item {
    id: root

    property color backgroundColor: Colors.md3.surface_container
    property color borderColor: Colors.md3.primary
    property color glowColor: Colors.md3.primary
    property real cornerRadius: 20

    readonly property bool hovered: hoverHandler.hovered

    // Where actual content (icon, value text, whatever visual the
    // temperature/battery variants need) gets placed once designed.
    default property alias content: contentContainer.data

    HoverHandler {
        id: hoverHandler
    }

    // Same background + border treatment as StatGauge, so a temperature or
    // battery card reads as visually consistent with the 2x2 gauges next to
    // it, not like a different component family.
    Rectangle {
        id: background
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.backgroundColor
        border.width: 1
        border.color: root.borderColor
    }

    Item {
        id: contentContainer
        anchors.fill: parent
    }
}
