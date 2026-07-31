import QtQuick
import QtQuick.Effects
import qs.config as Config
import qs.services as Services
import qs.widgets as Widgets

// Circular artwork: square Image, cover-fit, masked round via MultiEffect
// (same "square image, round mask" trick as blur — a plain solid-color
// Rectangle as maskSource, since MultiEffect only reads its alpha shape).
// A separate Rectangle with just a border draws the outline ring on top —
// Qt Quick draws Rectangle borders *inset* within the item's own bounds
// (not straddling outward), so sizing it identically to root means the
// ring's stroke naturally overlaps the artwork's outer edge.
//
// The masked artwork itself is sized slightly smaller than root (by
// maskInset on each side) rather than exactly matching it — the mask's
// anti-aliased edge doesn't perfectly line up pixel-for-pixel with the
// effect's own sampling, so a razor-exact same-size mask can leak a
// sliver of unmasked square corner at the very edge. Shrinking the
// artwork slightly means the ring (which sits right at root's edge)
// fully overlaps and hides that margin instead of it being visible
// just inside the ring.
Item {
    id: root

    property real size: 160
    property real ringWidth: 3
    property real maskInset: 1
    property real spinDuration: 12000

    implicitWidth: size
    implicitHeight: size

    readonly property bool hasArt: Services.Media.artUrl.length > 0

    Item {
        id: artworkClip
        anchors.centerIn: parent
        width: root.size - root.maskInset * 2
        height: width

        // Alpha-shape source for the mask — color is irrelevant, only its
        // circular alpha coverage matters to MultiEffect. layer.enabled
        // forces an offscreen texture explicitly, rather than relying on
        // implicit capture from a visible:false item.
        Rectangle {
            id: maskShape
            anchors.fill: parent
            radius: width / 2
            visible: false
            layer.enabled: true
            color: "white"
        }

        Image {
            id: artworkImage
            anchors.fill: parent
            visible: false
            layer.enabled: true
            asynchronous: true
            source: root.hasArt ? Services.Media.artUrl : ""
            // Cover-fit + centered, cropping overflow rather than letterboxing.
            fillMode: Image.PreserveAspectCrop
        }

        MultiEffect {
            id: maskedArtwork
            anchors.fill: parent
            visible: root.hasArt
            source: artworkImage
            maskEnabled: true
            maskSource: maskShape

            // IMPORTANT: running vs paused are NOT interchangeable here.
            // Setting `running: false` STOPS the animation and resets its
            // elapsed time — so toggling it off/on (e.g. if isPlaying
            // blips false momentarily during a seek) snapped the angle
            // back to 0 instead of resuming. `paused` is what actually
            // freezes in place and continues from the same angle —
            // running stays permanently true, only `paused` reacts to
            // playback state.
            RotationAnimation on rotation {
                running: true
                paused: !Services.Media.isPlaying
                from: 0
                to: 360
                duration: root.spinDuration
                loops: Animation.Infinite
            }
        }

        // Fallback when there's no artwork — plain filled circle rather
        // than a blank/transparent hole where the art would be. Doesn't
        // spin — nothing to spin.
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            visible: !root.hasArt
            color: Config.Colors.md3.surface_container_high

            Widgets.Icon {
                anchors.centerIn: parent
                name: "media/music-note"
                size: parent.width * 0.35
                color: Config.Colors.md3.on_surface_variant
            }
        }
    }

    // Outline ring, sized to root (not artworkClip) so it sits right at
    // the true outer edge, on top of everything.
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.width: root.ringWidth
        border.color: Config.Colors.md3.primary
    }
}
