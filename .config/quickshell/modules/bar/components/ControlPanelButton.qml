import QtQuick

import qs.widgets
import qs.config
import qs.modules.controlPanel

// ControlPanelButton
// -------------------
// Placeholder bar button for opening ControlPanel. Just a text label for
// now — real icons (wifi/bluetooth/volume/brightness state at a glance)
// get added once the sidebar's content is fully built out, per plan.
//
// Caller owns `checked` the same way it owns ControlPanel's `panelOpen`
// — this button doesn't toggle its own state, it just reports clicks.
// See ControlPanel.qml's header comment for the wiring example.

BarButtonBase {
    id: root

    tooltipText: "Control Panel"

    checked: controlPanel.panelOpen
    onClicked: controlPanel.panelOpen = !controlPanel.panelOpen

    Text {
        text: "C"
        font.bold: true
        font.pixelSize: root.height * 0.5
        color: Colors.md3.on_surface
    }

    ControlPanel {
        id: controlPanel
    }
}
