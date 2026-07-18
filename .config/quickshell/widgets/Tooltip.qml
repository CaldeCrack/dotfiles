import QtQuick

import qs.config as Config

// Tooltip
// -------
// A small floating label anchored to a `target` item. This is a plain
// Item positioned with QML anchors — NOT a separate window/popup — so it
// lives inside whatever surface its target already lives in. That matters
// under wlr-layer-shell: a real popup window (like QtQuick Controls'
// ToolTip) wants an xdg-shell positioner to anchor itself, which layer
// surfaces generally can't provide. Anchoring within the same surface
// sidesteps that entirely.
//
// Deliberately standalone rather than baked into BarButtonBase, so
// composite buttons (multiple icons under one button, e.g. a system-stats
// button showing cpu/gpu/ram/battery) can attach one Tooltip per icon
// instead of being limited to a single tooltip for the whole button.
//
// Usage:
//   Tooltip {
//       target: someIcon
//       text: "42%"
//   }
//
// Caveat: since this is just an anchored Item (not reparented to a window
// root), it can get visually clipped if something between it and the
// window root sets clip: true, and it stacks in normal z-order with
// siblings unless you bump z yourself. Fine for a single-row bar; revisit
// with reparenting to the window's root item if that stops being true.

Item {
	id: root

	required property Item target
	property string text: ""

	property int edge: Qt.BottomEdge // Qt.TopEdge | Qt.BottomEdge | Qt.LeftEdge | Qt.RightEdge
	property int edgeMargin: 6
	property int showDelay: 400
	property int hideDelay: 0

	property color backgroundColor: Config.Colors.md3.inverse_surface
	property color textColor: Config.Colors.md3.inverse_on_surface
	property real radius: 6
	property real horizontalPadding: 8
	property real verticalPadding: 4

	readonly property bool wantsShown: target !== null && target.hovered === true && text.length > 0

	parent: target ? target.parent : null
	z: 1000

	implicitWidth: label.implicitWidth + horizontalPadding * 2
	implicitHeight: label.implicitHeight + verticalPadding * 2

	visible: opacity > 0
	opacity: 0
	scale: 0.96
	transformOrigin: edge === Qt.BottomEdge ? Item.Top
		: edge === Qt.TopEdge ? Item.Bottom
		: edge === Qt.LeftEdge ? Item.Right : Item.Left

	states: State {
		name: "shown"
		when: root.wantsShown
		PropertyChanges { target: root; opacity: 1; scale: 1 }
	}

	transitions: Transition {
		NumberAnimation { properties: "opacity,scale"; duration: 120; easing.type: Easing.OutCubic }
	}

	// Debounce so a quick mouse pass-over doesn't flash a tooltip.
	Timer {
		id: showTimer
		interval: root.showDelay
		onTriggered: root.state = "shown"
	}

	Connections {
		target: root.target
		function onHoveredChanged() {
			if (root.target.hovered && root.text.length > 0)
				showTimer.restart()
			else
				showTimer.stop()
		}
	}

	anchors {
		top: edge === Qt.BottomEdge ? target.bottom : (edge === Qt.TopEdge ? undefined : undefined)
		bottom: edge === Qt.TopEdge ? target.top : undefined
		left: edge === Qt.RightEdge ? target.right : undefined
		right: edge === Qt.LeftEdge ? target.left : undefined
		horizontalCenter: (edge === Qt.TopEdge || edge === Qt.BottomEdge) ? target.horizontalCenter : undefined
		verticalCenter: (edge === Qt.LeftEdge || edge === Qt.RightEdge) ? target.verticalCenter : undefined
		topMargin: edge === Qt.BottomEdge ? edgeMargin : 0
		bottomMargin: edge === Qt.TopEdge ? edgeMargin : 0
		leftMargin: edge === Qt.RightEdge ? edgeMargin : 0
		rightMargin: edge === Qt.LeftEdge ? edgeMargin : 0
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
