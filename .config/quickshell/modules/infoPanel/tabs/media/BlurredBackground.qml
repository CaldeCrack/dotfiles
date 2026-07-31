import QtQuick
import QtQuick.Effects
import qs.config as Config
import qs.services as Services

// Fills whatever size the caller gives it (caller anchors this, same
// convention as everything else in music/). Two states:
//   - artwork present: blurred + darkened, cropped to cover (no letterbox,
//     overflow clipped rather than showing bars)
//   - no artwork: a subtle theme-colored gradient instead of a blank/black
//     panel
Item {
    id: root

    // --- styling knobs -----------------------------------------------------
    property real blurAmount: 1.0     // 0..1, intensity within blurMax
    property real blurMax: 64
    property real dimAmount: -0.35    // MultiEffect.brightness, -1..1

    readonly property bool hasArt: Services.Media.artUrl.length > 0

    // --- fallback: no artwork ------------------------------------------------
    Rectangle {
        anchors.fill: parent
        visible: !root.hasArt

        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Config.Colors.md3.primary_container }
            GradientStop { position: 1.0; color: Config.Colors.md3.surface_container_lowest }
        }
    }

    // --- artwork source, cover-fit ------------------------------------------
    //
    // visible: false is deliberate, not a bug — MultiEffect grabs this via
    // an offscreen texture regardless of its own on-screen visibility, so
    // hiding it here just stops the sharp, undimmed original from also
    // being drawn underneath the blurred output.
    Image {
        id: artSource
        anchors.fill: parent
        visible: false
        asynchronous: true
        source: root.hasArt ? Services.Media.artUrl : ""
        // Cover-fit: fills the whole area, cropping whatever overflows
        // rather than letterboxing — matches "centered and fit in the
        // cover way."
        fillMode: Image.PreserveAspectCrop
    }

    MultiEffect {
        anchors.fill: parent
        visible: root.hasArt
        source: artSource

        blurEnabled: true
        blur: root.blurAmount
        blurMax: root.blurMax

        // Darkens the blurred art so foreground text/controls keep
        // contrast regardless of how bright the source artwork is.
        brightness: root.dimAmount
    }
}
