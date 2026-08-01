import QtQuick
import QtQuick.Shapes
import qs.config
import qs.services

// Layout:
//   [-------------------- track --------------------]
//   [elapsed]                              [duration]
//
// Timestamps sit directly below the track's start/end points (not
// flanking it at the sides) — trackArea now spans the component's full
// width, and the two labels anchor underneath its left/right edges.
//
// Handle hover-grow is scoped to a small hit area centered on the handle
// itself (acceptedButtons: Qt.NoButton, so it only tracks hover and lets
// clicks fall through to the full-width drag area beneath it) — same
// hover-wrapper trick documented for composite bar buttons, applied here
// so hovering anywhere else on the bar doesn't trigger the grow.
//
// Dragging still doesn't touch Media at all until release — see
// dragging/dragPosition below.
Item {
    id: root

    // --- styling knobs ---------------------------------------------------
    property real trackHeight: 4
    property real trackRadius: trackHeight / 2
    property real handleRadius: 6
    property real handleHoverScale: 1.35
    property real waveAmplitude: 2
    property real waveWavelength: 24 // px per full sine cycle
    property real waveAnimDuration: 1400 // ms per full cycle of motion

    property real labelVerticalSpacing: 4

    implicitHeight: trackArea.height + labelVerticalSpacing + startLabel.implicitHeight

    // --- drag state, local to this component ------------------------------
    property bool dragging: false
    property real dragPosition: 0

    readonly property real displayPosition: dragging ? dragPosition : Media.position

    function formatTime(totalSeconds) {
        if (!totalSeconds || totalSeconds < 0 || isNaN(totalSeconds))
            return "0:00";
        const total = Math.floor(totalSeconds);
        const mins = Math.floor(total / 60);
        const secs = total % 60;
        return mins + ":" + (secs < 10 ? "0" : "") + secs;
    }

    // --- track area: full width -----------------------------------------
    Item {
        id: trackArea
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: Math.max(root.trackHeight, root.handleRadius * 2 * root.handleHoverScale)

        readonly property real progress: Media.length > 0 ? Math.max(0, Math.min(1, root.displayPosition / Media.length)) : 0

        // Handle center x — spans the full 0..width range so the circle's
        // *center* lands exactly at the track's start/end.
        readonly property real handleX: progress * width

        // --- unfilled remainder: starts at the handle ------------------------
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: trackArea.handleX
            width: Math.max(0, parent.width - trackArea.handleX)
            height: root.trackHeight
            radius: root.trackRadius
            color: Colors.md3.surface_container_highest
        }

        // --- played portion: animated sine wave -------------------------------
        Shape {
            id: waveShape

            property real wavePhase: 0
            NumberAnimation on wavePhase {
                from: 0
                to: root.waveWavelength
                duration: root.waveAnimDuration
                loops: Animation.Infinite
                running: Media.isPlaying
            }

            readonly property real capPad: root.trackHeight / 2

            anchors.verticalCenter: parent.verticalCenter
            x: -capPad
            width: trackArea.handleX + capPad
            height: root.waveAmplitude * 2 + root.trackHeight

            preferredRendererType: Shape.CurveRenderer
            antialiasing: true

            ShapePath {
                strokeColor: Colors.md3.primary
                strokeWidth: root.trackHeight
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin

                // Kept as PathPolyline rather than Bezier — with wavePhase
                // animating every frame, generating bezier control points
                // per segment costs more per frame than sampling points
                // for a polyline, for a visual difference that's already
                // negligible at a 2px sample step.
                PathPolyline {
                    path: {
                        const midY = waveShape.height / 2;
                        const capPad = waveShape.capPad;
                        const phase = waveShape.wavePhase;
                        const w = trackArea.handleX;

                        if (w <= 0)
                            return [Qt.point(capPad, midY), Qt.point(capPad, midY)];

                        const step = 2;
                        const pts = [];
                        for (let localX = 0; localX < w; localX += step) {
                            const y = midY + Math.sin(((localX + phase) / root.waveWavelength) * 2 * Math.PI) * root.waveAmplitude;
                            pts.push(Qt.point(localX + capPad, y));
                        }
                        pts.push(Qt.point(w + capPad, midY + Math.sin(((w + phase) / root.waveWavelength) * 2 * Math.PI) * root.waveAmplitude));
                        return pts;
                    }
                }
            }
        }

        // --- handle, grows only when the circle itself is hovered/dragged -----
        Rectangle {
            id: handle
            anchors.verticalCenter: parent.verticalCenter
            x: trackArea.handleX - root.handleRadius
            width: root.handleRadius * 2
            height: root.handleRadius * 2
            radius: root.handleRadius
            color: Colors.md3.primary
            scale: (handleHoverArea.hovered || root.dragging) ? root.handleHoverScale : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutBack
                }
            }
        }

        // Small hover-only hit area centered on the handle's unscaled
        // bounds (scale doesn't move handle.x/y, so this stays correctly
        // centered whether or not the handle is currently grown). Slightly
        // larger than the visual circle for an easier target. NoButton so
        // it never intercepts clicks — those fall through to dragArea.
        Item {
            id: handleHoverArea
            anchors.centerIn: handle
            width: handle.width * 1.6
            height: handle.height * 1.6
            readonly property bool hovered: handleHoverMouse.containsMouse

            MouseArea {
                id: handleHoverMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
            }
        }

        // --- drag / click to seek, across the whole track ------------------------
        MouseArea {
            id: dragArea
            anchors.fill: parent

            function positionFromX(x) {
                const ratio = Math.max(0, Math.min(1, x / trackArea.width));
                return ratio * Media.length;
            }

            onPressed: mouse => {
                root.dragging = true;
                root.dragPosition = positionFromX(mouse.x);
            }

            onPositionChanged: mouse => {
                if (root.dragging)
                    root.dragPosition = positionFromX(mouse.x);
            }

            onReleased: mouse => {
                Media.seek(root.dragPosition);
                root.dragging = false;
            }
        }
    }

    // --- elapsed / duration, below the track's start/end points -----------
    Text {
        id: startLabel
        anchors {
            top: trackArea.bottom
            topMargin: root.labelVerticalSpacing
            left: parent.left
        }
        text: root.formatTime(root.displayPosition)
        color: Colors.md3.on_surface_variant
        font.pixelSize: 11
    }

    Text {
        anchors {
            top: trackArea.bottom
            topMargin: root.labelVerticalSpacing
            right: parent.right
        }
        text: root.formatTime(Media.length)
        color: Colors.md3.on_surface_variant
        font.pixelSize: 11
    }
}
