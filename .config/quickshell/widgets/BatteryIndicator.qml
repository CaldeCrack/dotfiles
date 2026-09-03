import QtQuick
import qs.config
import qs.widgets

// Battery glyph with a dynamic fill level, same idea as Thermometer but
// simpler: the body here is a straight-sided rounded rect (no bulb curve),
// so a fill Rectangle sized to sit inside the body's interior can't poke
// past the outline the way the thermometer's fill could — no MultiEffect
// masking needed, it's just a Rectangle positioned under the outline.
//
// Outline uses Icon.qml directly (per Widgets_reference, it already does
// the currentColor substitution + theme coloring this needs) rather than
// a hand-rolled Image like Thermometer's outline — no reason to duplicate
// that machinery when Icon already exists for exactly this.
Item {
    id: root

    required property real percentage

    property color fillColor: Colors.md3.primary
    property color outlineColor: Colors.md3.on_surface

    // Convenience for quick testing — same pattern as Icon.qml's own
    // `size` and Thermometer's.
    property real size: 24
    implicitWidth: size
    implicitHeight: size

    // Fill geometry, in the same 24x24 coordinate space as the source SVG
    // path. The body interior (excluding the narrow top terminal/nub,
    // which isn't meant to fill) runs roughly x:8-16, y:8-19 — these are
    // hand-eyeballed off the path's control points, not measured, so
    // they're exposed as properties specifically to be nudged once this
    // is actually on screen.
    property real fillX: 9
    property real fillWidth: 6
    property real fillBottomY: 18
    property real fillMaxHeight: 11
    property real fillRadius: 0

    property real _displayPercentage: percentage
    Behavior on _displayPercentage {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    readonly property real _clamped: Math.max(0, Math.min(100, _displayPercentage))
    readonly property real _fillHeightUnits: _clamped / 100 * fillMaxHeight
    readonly property real _fillYUnits: fillBottomY - _fillHeightUnits
    readonly property real _viewBoxSize: 24
    readonly property real _scale: root.width / _viewBoxSize

    // Sits behind the outline, not masked — the straight-sided body means
    // a correctly-sized rect just naturally stays inside it.
    Rectangle {
        color: root.fillColor
        radius: root.fillRadius * root._scale
        x: root.fillX * root._scale
        width: root.fillWidth * root._scale
        y: root._fillYUnits * root._scale
        height: root._fillHeightUnits * root._scale
    }

    Icon {
        anchors.fill: parent
        name: "battery/vertical"
        size: root.size
    }
}
