import QtQuick
import Quickshell

import qs.config
import qs.widgets

// ControlPanel
// ------------
// Sidebar window hosting SidebarBase. Volume and Brightness are in
// place; Wifi/Bluetooth get added one at a time in later steps, stacked
// below them.
//
// Caller owns `panelOpen`, same one-way contract as SidebarBase itself:
//
//   property bool controlPanelOpen: false
//
//   ControlPanelButton {
//       checked: controlPanelOpen
//       onClicked: controlPanelOpen = !controlPanelOpen
//   }
//
//   ControlPanel {
//       panelOpen: controlPanelOpen
//   }

PanelWindow {
    id: root

    property bool panelOpen: false

    anchors {
        top: true
        right: true
        bottom: true
    }

    // Overlay, not a strut — the bar already reserves its own space.
    exclusionMode: ExclusionMode.Ignore

    // Manually clear the bar since we're not benefiting from its
    // exclusion zone (see ExclusionMode note above).
    margins.top: Settings.bar.height

    implicitWidth: sidebar.implicitWidth
    color: "transparent"

    // Stay mapped while the close animation plays; SidebarBase.closed
    // (fired after the slide finishes) is what actually drops us.
    onPanelOpenChanged: if (panelOpen)
        visible = true

    SidebarBase {
        id: sidebar
        anchors.fill: parent
        edge: Qt.RightEdge

        panelOpen: root.panelOpen
        onClosed: root.visible = false

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: 8

            VolumeSlider {
                width: parent.width
            }

            BrightnessSlider {
                width: parent.width
            }

            // Wifi, Bluetooth land here next, same pattern.
        }
    }
}
