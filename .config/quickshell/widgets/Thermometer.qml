import QtQuick
import qs.config
import qs.widgets

// Pixel-art thermometer with a dynamic fill level.
//
// No masking here anymore — the previous version needed MultiEffect
// masking because the fill rectangle's corners could poke past a curved
// bulb outline. The new asset's body is entirely straight-edged blocks
// (matching the pixel-art style), so a correctly-positioned Rectangle
// can't overflow it, same reasoning BatteryIndicator already uses. Outline
// is Icon.qml directly instead of a hand-rolled Image — no reason to
// duplicate that machinery when Icon already does the currentColor
// substitution + theme coloring this needs.
Item {
    id: root

    required property real percentage // 0-100, clamped internally

    property color fillColor: Colors.md3.primary
    property color tubeColor: Colors.md3.on_surface

    // Convenience for quick testing — same pattern as Icon.qml's own
    // `size` and BatteryIndicator's.
    property real size: 24
    implicitWidth: size
    implicitHeight: size

    // Fill geometry, in the same 24x24 coordinate space as the source SVG.
    // Hand-eyeballed off the new asset, not measured — exposed as
    // properties specifically to be nudged once this is actually on
    // screen, same convention as BatteryIndicator's fillX/fillWidth/etc.

    // Bottom block — square now instead of the old circular bulb, always
    // fully filled (doesn't animate with percentage, just anchors the
    // column visually).
    property real bulbCenterX: 12
    property real bulbCenterY: 19
    property real bulbSize: 4

    // Vertical column that actually represents the reading.
    property real columnWidth: 1
    property real columnTopY: 3.5
    property real columnBottomY: 17

    property real _displayPercentage: percentage
    Behavior on _displayPercentage {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    readonly property real _clamped: Math.max(0, Math.min(100, _displayPercentage))
    readonly property real _columnHeight: _clamped / 100 * (columnBottomY - columnTopY)
    readonly property real _columnY: columnBottomY - _columnHeight

    readonly property real _viewBoxSize: 24
    readonly property real _scale: root.width / _viewBoxSize

    // Column — grows upward from the bulb as percentage increases. Sharp
    // corners (no radius), matching the blocky pixel-art look rather than
    // the old rounded-cap version.
    Rectangle {
        color: root.fillColor
        width: root.columnWidth * root._scale
        x: (root.bulbCenterX - root.columnWidth / 2) * root._scale
        y: root._columnY * root._scale
        height: root._columnHeight * root._scale
    }

    // Bottom block — square, always fully filled.
    Rectangle {
        color: root.fillColor
        width: root.bulbSize * root._scale
        height: width
        x: (root.bulbCenterX - root.bulbSize / 2) * root._scale
        y: (root.bulbCenterY - root.bulbSize / 2) * root._scale
    }

    Icon {
        anchors.fill: parent
        name: "weather/thermometer"
        size: root.size
    }
}
