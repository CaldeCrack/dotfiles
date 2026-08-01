import QtQuick
import QtQuick.Effects

import qs.config

// PanelBase
// ---------
// Shared visual chrome for any popup/panel in the shell (bar dropdowns,
// InfoPanel, SystemStatsPopup, etc). This is NOT a window — it's an Item
// meant to be placed as the content of whatever PanelWindow/PopupWindow
// the caller creates. Window placement/anchoring stays with the caller;
// this only owns look (background, radius, border, shadow) and the
// open/close animation.
//
// Usage:
//   PanelBase {
//       panelOpen: someButton.expanded
//       onClosed: hostWindow.visible = false   // wait for fade-out to finish
//
//       Text { text: "panel content here" }
//   }

Item {
    id: root

    // --- content -------------------------------------------------------
    default property alias contentChildren: contentContainer.children
    readonly property alias contentItem: contentContainer

    // --- appearance ------------------------------------------------------
    property color color: Colors.md3.surface
    property color borderColor: Colors.md3.outline_variant
    property real borderWidth: 1
    property real radius: 24
    property real contentPadding: 8

    // --- shadow ------------------------------------------------------
    property bool shadowEnabled: true
    property color shadowColor: Colors.md3.shadow
    property real shadowBlur: 0.2
    property real shadowOpacity: 1.0
    property real shadowSpread: 2

    readonly property real shadowMarginLeft: shadowEnabled ? shadowSpread : 0
    readonly property real shadowMarginRight: shadowEnabled ? shadowSpread : 0
    readonly property real shadowMarginTop: shadowEnabled ? shadowSpread : 0
    readonly property real shadowMarginBottom: shadowEnabled ? shadowSpread : 0

    // --- open/close animation ------------------------------------------------------
    property bool panelOpen: false
    property int animationDuration: 180
    property real closedScale: 0.92

    // Emitted the instant panelOpen flips to true.
    signal opened
    // Emitted once the close transition has fully finished (not on the
    // panelOpen flip itself) so callers can safely hide/destroy the host
    // window without a visual jump.
    signal closed

    implicitWidth: contentContainer.childrenRect.width + contentPadding * 2 + shadowMarginLeft + shadowMarginRight
    implicitHeight: contentContainer.childrenRect.height + contentPadding * 2 + shadowMarginTop + shadowMarginBottom

    // Interaction is only meaningful once the panel is actually open.
    enabled: panelOpen

    transformOrigin: Item.Top

    opacity: 0
    scale: closedScale

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

    states: [
        State {
            name: "open"
            when: root.panelOpen
            PropertyChanges {
                target: root
                opacity: 1
                scale: 1
            }
        },
        State {
            name: "closed"
            when: !root.panelOpen
            PropertyChanges {
                target: root
                opacity: 0
                scale: root.closedScale
            }
        }
    ]

    transitions: [
        Transition {
            to: "open"
            NumberAnimation {
                properties: "opacity,scale"
                duration: root.animationDuration
                easing.type: Easing.OutCubic
            }
            onRunningChanged: if (!running)
                root.opened()
        },
        Transition {
            to: "closed"
            NumberAnimation {
                properties: "opacity,scale"
                duration: root.animationDuration
                easing.type: Easing.InCubic
            }
            onRunningChanged: if (!running)
                root.closed()
        }
    ]
}
