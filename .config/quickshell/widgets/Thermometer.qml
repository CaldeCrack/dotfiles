import QtQuick
import QtQuick.Effects
import qs.config as Config

// Renders the thermometer glyph with a dynamic fill level.
//
// The outline and the fill are two separate layers rather than one SVG,
// for two reasons:
//  - Qt's SVG renderer doesn't reliably honor <clipPath>/clip-path inside a
//    data-URI SVG, so the fill geometry is clipped with QML's own masking.
//  - The outline only depends on tubeColor/tubeStrokeWidth, not on
//    percentage, so it is generated only once while the fill animates using
//    ordinary QML geometry.
Item {
    id: root

    required property real percentage

    property color fillColor: Config.Colors.md3.primary
    property color tubeColor: Config.Colors.md3.on_surface
    property real tubeStrokeWidth: 1.4

    // Convenience property for square sizing.
    property real size: 24
    implicitWidth: size
    implicitHeight: size

    // ---------------------------------------------------------------------
    // Fill geometry (24x24 SVG coordinate space)
    // ---------------------------------------------------------------------

    // Bottom bulb.
    property real bulbCenterX: 12
    property real bulbCenterY: 18
    property real bulbRadius: 2.4

    // Vertical temperature column.
    property real columnWidth: 1
    property real columnTopY: 3.5
    property real columnBottomY: 18

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
    readonly property real _scale: width / _viewBoxSize

    // ---------------------------------------------------------------------
    // Static outline
    // ---------------------------------------------------------------------

    readonly property string _outlineSvg: `
<svg xmlns="http://www.w3.org/2000/svg"
     width="24"
     height="24"
     viewBox="0 0 24 24"
     fill="none"
     stroke="${tubeColor}"
     stroke-width="${tubeStrokeWidth}"
     stroke-linecap="round"
     stroke-linejoin="round">
    <path d="M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z"/>
</svg>`

    // Filled silhouette used only as a mask.
    readonly property string _maskSvg: `
<svg xmlns="http://www.w3.org/2000/svg"
     width="24"
     height="24"
     viewBox="0 0 24 24">
    <path d="M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z"
          fill="white"/>
</svg>`

    Image {
        id: maskImage

        anchors.fill: parent
        visible: false
        layer.enabled: true

        fillMode: Image.PreserveAspectFit
        smooth: true

        sourceSize.width: root.width * 2
        sourceSize.height: root.height * 2

        source: "data:image/svg+xml;utf8," + encodeURIComponent(root._maskSvg)
    }

    Item {
        id: fillContainer

        anchors.fill: parent
        visible: false
        layer.enabled: true

        // Temperature column.
        Rectangle {
            color: root.fillColor

            width: root.columnWidth * root._scale
            radius: width / 2

            x: (root.bulbCenterX - root.columnWidth / 2) * root._scale

            y: root._columnY * root._scale
            height: root._columnHeight * root._scale
        }

        // Bottom bulb (always visible).
        Rectangle {
            color: root.fillColor

            width: root.bulbRadius * 2 * root._scale
            height: width
            radius: width / 2

            x: (root.bulbCenterX - root.bulbRadius) * root._scale
            y: (root.bulbCenterY - root.bulbRadius) * root._scale
        }
    }

    MultiEffect {
        anchors.fill: parent

        source: fillContainer

        maskEnabled: true
        maskSource: maskImage
    }

    Image {
        anchors.fill: parent

        fillMode: Image.PreserveAspectFit
        smooth: true

        sourceSize.width: root.width * 2
        sourceSize.height: root.height * 2

        source: "data:image/svg+xml;utf8," + encodeURIComponent(root._outlineSvg)
    }
}
