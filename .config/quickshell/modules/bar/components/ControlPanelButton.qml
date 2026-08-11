import QtQuick

import qs.widgets
import qs.services
import qs.modules.controlPanel

// ControlPanelButton
// -------------------
// Bar button opening ControlPanel. Shows a row of four icons — volume,
// brightness, wifi, bluetooth, in that order — each with its own hover
// tooltip. Same composite pattern as SystemStatsButton's StatIcon:
// BarButtonBase's single MouseArea covers the whole button, so each
// icon needs its own tiny HoverHandler-based wrapper to get its own
// tooltip.
//
// Differs from StatIcon in one way: StatIcon always formats its tooltip
// as "N%" from a numeric value, which doesn't fit here — mute state,
// SSID, and device name aren't percentages. This takes already-
// formatted text instead.

BarButtonBase {
    id: root

    checked: controlPanel.panelOpen
    onClicked: controlPanel.panelOpen = !controlPanel.panelOpen

    component StateIcon: Item {
        id: wrap
        required property string iconName
        required property string status
        property alias size: icon.size
        readonly property bool hovered: hoverArea.hovered

        width: icon.size
        height: icon.size

        Icon {
            id: icon
            name: wrap.iconName
            size: 16
        }

        HoverHandler {
            id: hoverArea
        }

        Tooltip {
            target: wrap
            anchorTarget: root
            text: wrap.status
        }
    }

    Row {
        spacing: 6

        StateIcon {
            iconName: Audio.currentVolumeIcon
            status: Audio.muted ? "Muted" : Math.round(Audio.volume) + "%"
        }

        StateIcon {
            // Brightness has no on/off icon swap like volume's mute —
            // same icon always, only the tooltip changes.
            iconName: "display/brightness"
            status: Math.round(Brightness.brightness) + "%"
        }

        StateIcon {
            iconName: Network.currentIcon
            status: {
                if (!Network.wifiHardwareEnabled || !Network.wifiEnabled)
                    return "Disabled";
                if (Network.connectedNetwork)
                    return `${Network.connectedNetwork.name} · ${Math.round(Network.connectedNetwork.signalStrength * 100)}%`;
                return "Enabled";
            }
        }

        StateIcon {
            iconName: Bluetooth.currentIcon
            status: {
                if (!Bluetooth.bluetoothEnabled)
                    return "Disabled";
                if (Bluetooth.connectedDevice)
                    return Bluetooth.connectedDevice.name;
                return "Enabled";
            }
        }
    }

    ControlPanel {
        id: controlPanel
    }
}
