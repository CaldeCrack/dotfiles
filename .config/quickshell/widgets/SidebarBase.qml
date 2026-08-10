import QtQuick
import QtQuick.Effects

import qs.config

// SidebarBase
// -----------
// Shared slide-in behavior and chrome for edge-attached sidebars
// (ControlPanel, NotificationsSidebar). Like PanelBase, this is a plain
// Item meant to be the content of whatever PanelWindow the caller
// creates — window anchoring/exclusivity stays with the caller, this
// only owns the visual card (background, border, shadow) and the
// slide-in/out animation.
//
// Differs from PanelBase in two ways that matter for a sidebar rather
// than a small popup:
//   - Animates via an x-offset slide (Translate), not fade+scale — a
//     sidebar visually enters from off-screen, it doesn't materialize
//     in place.
//   - Has no auto-sizing from content. A popup should hug its content;
//     a sidebar should have a fixed, predictable width regardless of
//     what's inside it (sidebarWidth), and fill whatever height the
//     host window gives it. Set the host PanelWindow's anchors to
//     opposing top+bottom edges so its height is forced to the screen
//     height automatically — see the usage note below.
//
// Usage:
//   PanelWindow {
//       anchors { top: true; right: true; bottom: true }
//       margins.top: bar.height   // leave room for the bar
//       implicitWidth: sidebar.implicitWidth
//       color: "transparent"
//
//       SidebarBase {
//           id: sidebar
//           anchors.fill: parent
//           edge: Qt.RightEdge
//           panelOpen: someState
//           onClosed: hostWindow.visible = false
//
//           Text { text: "sidebar content here" }
//       }
//   }

Item {
    id: root

    // --- content -------------------------------------------------------
    default property alias contentChildren: contentContainer.data
    readonly property alias contentItem: contentContainer

    // --- edge -------------------------------------------------------
    // Which screen edge this sidebar is attached to. Drives both the
    // slide direction and which side skips its shadow margin (the
    // screen-attached edge doesn't need one — there's nothing to render
    // a shadow into past the edge of the screen).
    property int edge: Qt.RightEdge // Qt.LeftEdge | Qt.RightEdge

    // --- sizing / appearance ------------------------------------------------------
    property real sidebarWidth: 340
    property real contentPadding: 16
    property real radius: 16
    property color color: Colors.md3.surface_container
    property color borderColor: Colors.md3.outline_variant
    property real borderWidth: 1
    property int edgeMargin: 4

    // --- shadow ------------------------------------------------------
    property bool shadowEnabled: true
    property color shadowColor: Colors.md3.shadow
    property real shadowBlur: 0.2
    property real shadowOpacity: 1.0
    property real shadowSpread: 2

    readonly property real shadowMarginLeft: (shadowEnabled && edge !== Qt.LeftEdge ? shadowSpread : 0) + edgeMargin
    readonly property real shadowMarginRight: (shadowEnabled && edge !== Qt.RightEdge ? shadowSpread : 0) + edgeMargin
    readonly property real shadowMarginTop: shadowEnabled ? shadowSpread : 0
    readonly property real shadowMarginBottom: shadowEnabled ? shadowSpread : 0

    // --- slide animation ------------------------------------------------------
    property bool panelOpen: false
    property int animationDuration: 220

    // Emitted the instant panelOpen flips to true.
    signal opened
    // Emitted once the slide-out has fully finished (not on the
    // panelOpen flip itself) so callers can safely hide/destroy the
    // host window without a visual jump.
    signal closed

    implicitWidth: sidebarWidth + shadowMarginLeft + shadowMarginRight

    // Interaction only meaningful once fully open.
    enabled: panelOpen

    transform: Translate {
        id: slide
        x: root.panelOpen ? 0 : (root.edge === Qt.RightEdge ? root.width : -root.width)

        Behavior on x {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: root.panelOpen ? Easing.OutCubic : Easing.InCubic
                onRunningChanged: if (!running) {
                    if (root.panelOpen)
                        root.opened();
                    else
                        root.closed();
                }
            }
        }
    }

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: root.shadowMarginLeft
        anchors.rightMargin: root.shadowMarginRight
        anchors.topMargin: root.shadowMarginTop
        anchors.bottomMargin: root.shadowMarginBottom
        radius: root.radius
        color: root.color
        border.color: root.borderColor
        border.width: root.borderWidth

        layer.enabled: root.shadowEnabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: root.shadowColor
            shadowOpacity: root.shadowOpacity
            shadowBlur: root.shadowBlur
        }
    }

    Item {
        id: contentContainer
        anchors.fill: background
        anchors.margins: root.contentPadding
    }
}
