import QtQuick
import Quickshell

import qs.config

// Tooltip
// -------
// A small floating label shown when a `target` item is hovered,
// implemented as a real PopupWindow rather than a plain Item positioned
// within the same surface. This matters specifically for bar buttons:
// the bar's own PanelWindow is deliberately sized to exactly bar height,
// so a tooltip living inside that surface has nowhere to render below it
// — it gets hard-clipped at the window's own edge no matter how it's
// positioned. PopupWindow is a genuinely separate Wayland surface, so it
// isn't bound by the target window's dimensions at all, and (as a bonus)
// being a Window rather than an Item, it can't accidentally get swept
// into a parent's childrenRect-based sizing the way an Item-based
// tooltip could.
//
// `target` must expose a `hovered` bool property (BarButtonBase does;
// see the hover-wrapper pattern below for plain content like Text/Icon,
// which has no hover state of its own).
//
// `anchorTarget` controls where the popup is positioned and defaults to
// `target`. This lets hover detection and positioning be separated: a
// composite button can show the tooltip because an individual icon is
// hovered while anchoring it beneath the button itself, keeping every
// tooltip at a consistent vertical position while still horizontally
// aligning with the hovered icon.
//
// Usage — single tooltip on something that already has `hovered`:
//   Tooltip {
//       target: someBarButtonBase
//       text: "Clock"
//   }
//
// Usage — per-icon tooltip in a composite button:
//   Item {
//       id: cpuWrap
//       width: cpuIcon.implicitWidth
//       height: cpuIcon.implicitHeight
//       readonly property bool hovered: cpuHover.hovered
//
//       Widgets.Icon {
//           id: cpuIcon
//           name: "cpu"
//       }
//
//       HoverHandler {
//           id: cpuHover
//       }
//   }
//
//   Tooltip {
//       target: cpuWrap
//       anchorTarget: button
//       text: "CPU: " + cpuUsage + "%"
//   }

PopupWindow {
    id: root

    required property Item target
    property Item anchorTarget: target
    property string text: ""

    // Single edge only (not a combination) — this becomes both the
    // anchor point on target (centered along the other axis) and the
    // direction the popup grows, matching standard tooltip behavior.
    property int edge: Edges.Bottom
    property int edgeMargin: anchorTarget.implicitHeight + 2
    property int showDelay: 800

    property color backgroundColor: Colors.md3.inverse_surface
    property color textColor: Colors.md3.inverse_on_surface
    property real radius: 6
    property real horizontalPadding: 8
    property real verticalPadding: 4

    // Debounced show state — only flips true once the mouse has stayed on
    // target for showDelay, so a quick pass-over doesn't flash a tooltip.
    property bool shown: false

    color: "transparent"
    visible: shown && target !== null && text.length > 0

    anchor.item: anchorTarget
    anchor.edges: edge
    anchor.gravity: edge
    anchor.margins.top: edge === Edges.Bottom ? edgeMargin : 0
    anchor.margins.bottom: edge === Edges.Top ? edgeMargin : 0
    anchor.margins.left: edge === Edges.Right ? edgeMargin : 0
    anchor.margins.right: edge === Edges.Left ? edgeMargin : 0
    anchor.rect.x: anchorTarget != target ? target.x + target.width : target.width / 2

    implicitWidth: label.implicitWidth + horizontalPadding * 2
    implicitHeight: label.implicitHeight + verticalPadding * 2

    Timer {
        id: showTimer
        interval: root.showDelay
        onTriggered: root.shown = true
    }

    Connections {
        target: root.target
        function onHoveredChanged() {
            if (root.target.hovered && root.text.length > 0) {
                showTimer.restart();
            } else {
                showTimer.stop();
                root.shown = false;
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.backgroundColor
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        color: root.textColor
        font.pixelSize: 12
    }
}
