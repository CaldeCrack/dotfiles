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
//
// Callers that close/reopen the surrounding window (a popup, a sidebar)
// should call reset() on close so reopening starts back at the home view
// instead of resuming wherever navigation was left — see reset() below.
Item {
    id: root

    default property alias homeContent: homeContainer.data

    readonly property bool atHome: _stack.length === 0
    readonly property string currentTitle: atHome ? "" : _stack[_stack.length - 1].title

    property var _stack: []

    // Replace the current view with `component`, labeling the header
    // `title`. Call again from within a pushed view to go a level deeper.
    function push(component, title) {
        _stack.push({
            component: component,
            title: title
        });
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

    // Clears straight back to the home view, no per-level pop animation.
    // Intended for callers to invoke once the surrounding window has
    // finished closing, so reopening it always starts fresh.
    function reset() {
        _stack = [];
        loader.sourceComponent = null;
    }

    // Read implicit size directly off the Column rather than this Item's
    // own childrenRect — see widgets/BarButtonBase.qml for why childrenRect
    // is unreliable once a Row/Column is involved.
    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    Column {
        id: column
        spacing: 8

        Item {
            id: header
            visible: !root.atHome
            // Stretch to whatever's wider — the current content, or enough
            // room to fit the back arrow + title without them colliding —
            // so the title below can be truly centered on this width
            // rather than just centered in the leftover space next to the
            // arrow.
            width: Math.max(_contentWidth, _minWidth)
            implicitHeight: Math.max(backTapArea.implicitHeight, titleText.implicitHeight)

            readonly property real _contentWidth: root.atHome ? homeContainer.implicitWidth : loader.implicitWidth
            readonly property real _minWidth: titleText.implicitWidth + 2 * backTapArea.implicitWidth + 8

            Item {
                id: backTapArea
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: backIcon.implicitWidth + 8
                implicitHeight: backIcon.implicitHeight + 8

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: backMouseArea.containsMouse ? Colors.md3.surface_container : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                Icon {
                    id: backIcon
                    anchors.centerIn: parent
                    name: "common/back"
                    size: 14
                }

                MouseArea {
                    id: backMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.pop()
                }
            }

            Text {
                id: titleText
                anchors.centerIn: parent
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
