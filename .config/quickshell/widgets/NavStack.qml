pragma ComponentBehavior: Bound

import QtQuick
import qs.config

// Wraps a "home" view (whatever's placed as normal children) with push/pop
// navigation to other views, replacing the content in place — a button
// inside `homeContent` pushes a view, the header's back arrow pops it.
// Not opinionated about what's being shown; that's on the caller.
//
//   NavStack {
//       id: nav
//
//       Column { // home content, shown when nav.atHome
//           SomeButton { onClicked: nav.push(detailView, "Details") }
//       }
//   }
//
//   Component { id: detailView; Text { text: "detail content" } }
Item {
	id: root

	default property alias homeContent: homeContainer.data

	readonly property bool atHome: _stack.length === 0
	readonly property string currentTitle: atHome ? "" : _stack[_stack.length - 1].title

	property var _stack: []

	// Replace the current view with `component`, labeling the header
	// `title`. Call again from within a pushed view to go a level deeper.
	function push(component, title) {
		_stack.push({ component: component, title: title });
		_stack = _stack.slice(); // plain mutation doesn't trigger bindings
		loader.sourceComponent = component;
	}

	// Step back one view. No-op at the home view — the back arrow is
	// hidden there anyway, but callers driving this programmatically
	// don't need to guard atHome themselves.
	function pop() {
		if (atHome)
			return;

		_stack.pop();
		_stack = _stack.slice();
		loader.sourceComponent = atHome ? null : _stack[_stack.length - 1].component;
	}

	// Read implicit size directly off the Column rather than this Item's
	// own childrenRect — see widgets/BarButtonBase.qml for why childrenRect
	// is unreliable once a Row/Column is involved.
	implicitWidth: column.implicitWidth
	implicitHeight: column.implicitHeight

	Column {
		id: column
		spacing: 8

		Row {
			id: header
			visible: !root.atHome
			spacing: 8

			Item {
				id: backTapArea
				implicitWidth: backIcon.implicitWidth + 8
				implicitHeight: backIcon.implicitHeight + 8

				Icon {
					id: backIcon
					anchors.centerIn: parent
					name: "common/back"
					size: 14
				}

				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: root.pop()
				}
			}

			Text {
				anchors.verticalCenter: backTapArea.verticalCenter
				text: root.currentTitle
				color: Colors.md3.on_surface
				font.pixelSize: 13
				font.bold: true
			}
		}

		// Home view. Positioners exclude invisible children from layout,
		// so this contributes nothing to `column`'s size while a pushed
		// view is showing.
		Item {
			id: homeContainer
			visible: root.atHome
			implicitWidth: childrenRect.width
			implicitHeight: childrenRect.height
		}

		// Pushed view. Loader forwards the loaded item's implicit size,
		// so no manual sizing needed here.
		Loader {
			id: loader
			visible: !root.atHome
			active: !root.atHome
		}
	}
}
