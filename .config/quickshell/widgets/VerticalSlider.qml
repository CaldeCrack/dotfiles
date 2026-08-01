import QtQuick
import qs.config

// Generic vertical slider — drag or click anywhere on the track to set
// `value` within [min, max]. Fill grows from the bottom (top = max,
// bottom = min), matching the usual volume-slider convention.
//
// `value` is a plain, fully-internal property: this component owns it
// once created and updates it directly during drag, then emits `moved`.
// It's deliberately NOT designed to be driven by a live `value: someExpr`
// binding from outside — an external imperative write during drag would
// permanently break that binding (same footgun hit earlier with the
// seekbar's position). If a caller needs to keep this in sync with an
// external source of truth (e.g. a real volume value that can also
// change from outside), use a `Binding { target: slider; property:
// "value"; value: external; when: !slider.dragging }` — `dragging` is
// exposed below specifically for that `when` clause.
Item {
    id: root

    property real value: 50
    property real min: 0
    property real max: 100
    property real length: 120 // vertical extent of the track

    property real trackWidth: 4
    property real trackRadius: trackWidth / 2
    property real handleRadius: 6
    property real handleHoverScale: 1.35

    readonly property bool dragging: dragArea.pressed

    signal moved(real value)

    implicitWidth: Math.max(trackWidth, handleRadius * 2 * handleHoverScale)
    implicitHeight: length

    readonly property real progress: max > min ? Math.max(0, Math.min(1, (value - min) / (max - min))) : 0

    // Handle y measured from the top — progress:1 (max) sits at y:0,
    // progress:0 (min) sits at y:height.
    readonly property real handleY: height - progress * height

    // --- unfilled portion: top segment, above the handle -------------------
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
        width: root.trackWidth
        height: root.handleY
        radius: root.trackRadius
        color: Colors.md3.surface_container_highest
    }

    // --- filled portion: bottom segment, below the handle -------------------
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.handleY
        width: root.trackWidth
        height: root.height - root.handleY
        radius: root.trackRadius
        color: Colors.md3.primary
    }

    // --- handle, grows on hover/drag (hover scoped to the handle itself,
    //     same pattern as the seekbar) ---------------------------------------
    Rectangle {
        id: handle
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.handleY - root.handleRadius
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

    // --- drag / click to set value, across the whole track -----------------
    MouseArea {
        id: dragArea
        anchors.fill: parent

        function valueFromY(y) {
            const ratio = 1 - Math.max(0, Math.min(1, y / root.height));
            return root.min + ratio * (root.max - root.min);
        }

        onPressed: mouse => {
            root.value = valueFromY(mouse.y);
            root.moved(root.value);
        }

        onPositionChanged: mouse => {
            if (pressed) {
                root.value = valueFromY(mouse.y);
                root.moved(root.value);
            }
        }
    }
}
