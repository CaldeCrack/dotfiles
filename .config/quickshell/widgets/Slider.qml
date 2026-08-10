import QtQuick

import qs.config

// Slider
// ------
// Generic horizontal 0-100 slider. Built rather than reached for a
// QtQuick Controls Slider so it draws with the shell's own palette
// (Colors.md3.*) instead of needing a separate style override.
//
// Follows the same one-way-binding contract as SidebarBase/
// DismissablePopup: this widget never writes to `value` itself, only
// emits `moved(newValue)` — the caller owns the backing property (e.g.
// Audio.volume) and updates it in response. Same reasoning as
// DismissablePopup never touching `open` directly: a binding like
// `value: Audio.volume` would silently die the instant this component
// assigned to `value` itself.
//
// Usage:
//   Slider {
//       value: Audio.volume
//       onMoved: newValue => Audio.setVolume(newValue)
//   }

Item {
    id: root

    property real value: 0 // 0-100, caller-owned — see contract above
    property real trackHeight: 4
    property real handleSize: 12
    property real handleHoverScale: 1.35
    property color trackColor: Colors.md3.surface_container_highest
    property color fillColor: Colors.md3.primary
    property color handleColor: Colors.md3.primary

    // Exposed for callers that want to react to hover, not just this
    // widget internally.
    readonly property bool hovered: mouseArea.containsMouse || mouseArea.pressed

    signal moved(real newValue)

    implicitHeight: Math.max(handleSize, trackHeight)

    readonly property real ratio: Math.max(0, Math.min(1, value / 100))

    function ratioFromX(x) {
        const usable = width - handleSize;
        if (usable <= 0)
            return 0;
        const clampedX = Math.max(0, Math.min(usable, x - handleSize / 2));
        return clampedX / usable;
    }

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: root.trackHeight
        radius: height / 2
        color: root.trackColor
    }

    Rectangle {
        id: fill
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: track.width * root.ratio
        height: root.trackHeight
        radius: height / 2
        color: root.fillColor
    }

    Rectangle {
        id: handle
        width: root.handleSize
        height: root.handleSize
        radius: width / 2
        color: root.handleColor
        anchors.verticalCenter: parent.verticalCenter
        // Position is derived from the handle's real (unscaled) size —
        // scale is a pure visual transform layered on top, so growing on
        // hover never feeds back into this and shifts the handle.
        x: root.ratio * (root.width - width)

        scale: root.hovered ? root.handleHoverScale : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: mouse => root.moved(root.ratioFromX(mouse.x) * 100)
        onPositionChanged: mouse => {
            if (pressed)
                root.moved(root.ratioFromX(mouse.x) * 100);
        }
    }
}
