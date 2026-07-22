import QtQuick
import QtQuick.Effects
import qs.config as Config

// Renders the thermometer glyph with a dynamic fill level.
//
// The outline and the fill are two separate layers rather than one SVG,
// for two reasons:
//  - Qt's SVG renderer doesn't reliably honor <clipPath>/clip-path inside a
//    data-URI SVG, so the fill rectangle's corners could poke past the
//    tube's rounded silhouette once near-full. The fill is clipped with
//    QML's own MultiEffect masking instead (same mechanism already used
//    elsewhere in this file for the hover glow) — real compositing, not
//    the SVG parser.
//  - The outline only depends on tubeColor/tubeStrokeWidth, not on
//    percentage. Baking both into one SVG meant regenerating and
//    re-decoding the whole image every animation frame, which is
//    asynchronous and produced a visible blank flash each tick. The fill
//    is now a plain Rectangle animated via ordinary property bindings —
//    the outline/mask images are built once and never touched again by
//    the percentage animation.
Item {
    id: root

    required property real percentage // 0-100, clamped internally

    property color fillColor: Config.Colors.md3.primary
    property color tubeColor: Config.Colors.md3.surface_container_highest
    property real tubeStrokeWidth: 2

    // Convenience for quick testing — same pattern as Icon.qml's `size`.
    // Sets both dimensions at once; override width/height individually at
    // the call site instead if a non-square footprint is ever needed.
    property real size: 24
    implicitWidth: size
    implicitHeight: size

    // Fill geometry, in the same 24x24 coordinate space as the source SVG
    // path — pulled out as named properties (rather than left inline in a
    // template string) specifically so these are easy to nudge while
    // testing, without hunting through SVG markup.
    property real fillX: 9
    property real fillWidth: 6
    property real fillBottomY: 21   // bottom of the fillable region
    property real fillMaxHeight: 18 // height at 100% — tune this against fillBottomY so the top edge lands inside the tube's actual drawn bounds (path starts at y=4), not above it

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

    // --- Static outline (rebuilt only if color/stroke props change) ---
    readonly property string _outlineSvg: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="${root.tubeColor}" stroke-width="${root.tubeStrokeWidth}" stroke-linecap="round" stroke-linejoin="round">
<path d="M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z"/>
</svg>`

    // Solid silhouette of that same path — used purely as an alpha mask,
    // never shown directly.
    readonly property string _maskSvg: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
<path d="M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z" fill="white"/>
</svg>`

    Image {
        id: maskImage
        anchors.fill: parent
        visible: false
        layer.enabled: true // capturable as a texture while hidden
        fillMode: Image.PreserveAspectFit
        smooth: true
        // Bound to the widget's actual rendered size rather than a fixed
        // constant — a mismatch between sourceSize and the real display
        // size is what was making this blurrier than Icon.qml's SVGs (the
        // fixed 96x96 raster was getting resampled up/down to whatever
        // size the widget actually ended up at). Doubled for a bit of
        // supersampling headroom so edges stay clean even after masking.
        sourceSize.width: root.width * 2
        sourceSize.height: root.height * 2
        source: "data:image/svg+xml;utf8," + encodeURIComponent(root._maskSvg)
    }

    // The red fill — plain geometry, animates cheaply, gets clamped to the
    // tube silhouette by the mask below rather than trusting hand-tuned
    // x/width numbers alone to never overflow.
    //
    // fillRect sits inside a full-size container rather than being used as
    // MultiEffect's source directly: MultiEffect captures `source` at that
    // item's own bounding size, then stretches the captured texture to
    // fill MultiEffect's own bounds. A bare fillRect is only ever as big
    // as the fill itself, so that capture-then-stretch step was blowing
    // the small rect up to cover the entire tube regardless of its real
    // height — reliably "full" no matter what percentage said. Sizing the
    // container to match root exactly means the captured texture already
    // has the rect at the right position/proportion within transparent
    // space, so the later 1:1 stretch onto MultiEffect's own same-size
    // bounds doesn't distort anything.
    Item {
        id: fillContainer
        anchors.fill: parent
        visible: false
        layer.enabled: true

        Rectangle {
            id: fillRect
            color: root.fillColor
            x: root.fillX * root._scale
            width: root.fillWidth * root._scale
            y: root._fillYUnits * root._scale
            height: root._fillHeightUnits * root._scale
        }
    }

    MultiEffect {
        anchors.fill: parent
        source: fillContainer
        maskEnabled: true
        maskSource: maskImage
    }

    // Outline drawn last, on top, completely unmasked — always crisp
    // regardless of fill level.
    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        sourceSize.width: root.width * 2
        sourceSize.height: root.height * 2
        source: "data:image/svg+xml;utf8," + encodeURIComponent(root._outlineSvg)
    }
}
