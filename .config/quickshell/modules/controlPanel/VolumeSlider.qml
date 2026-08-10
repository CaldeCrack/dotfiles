import QtQuick
import Quickshell

import qs.config
import qs.services
import qs.widgets

// VolumeSlider
// ------------
// ControlPanel content slice: icon (click to mute/unmute), fixed-width
// percentage readout, horizontal slider (drag to set volume), trailing
// button opening pavucontrol.
//
// Sits on its own background card so it reads as a distinct row once
// Brightness/Wifi/Bluetooth stack below it — a shade lighter than the
// sidebar itself (surface_container_high vs the sidebar's own
// surface_container) rather than a border, to keep things quiet.

Item {
    id: root

    implicitHeight: 40

    // Fixed so "5%" vs "100%" never changes where the slider starts —
    // only the text's own alignment shifts within this width.
    property real percentageWidth: 34
    property real rowPadding: 8
    property real iconButtonSize: 28

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 16
        color: Colors.md3.surface_container_high
    }

    Item {
        id: content
        anchors.fill: background
        anchors.margins: root.rowPadding

        // --- mute toggle ------------------------------------------------
        Item {
            id: iconWrap
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: root.iconButtonSize
            height: root.iconButtonSize
            implicitWidth: width
            implicitHeight: height
            property bool hovered: iconMouse.containsMouse

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: Colors.md3.on_surface
                opacity: iconMouse.containsMouse ? 0.12 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }

            Icon {
                anchors.centerIn: parent
                name: Audio.currentVolumeIcon
                size: 18
                color: Colors.md3.on_surface
            }

            MouseArea {
                id: iconMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Audio.toggleMuted()
            }
        }

        Tooltip {
            target: iconWrap
            text: Audio.muted ? "Unmute" : "Mute"
        }

        // --- percentage ---------------------------------------------------
        Text {
            id: percentageText
            anchors.left: iconWrap.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            width: root.percentageWidth
            horizontalAlignment: Text.AlignRight
            color: Colors.md3.on_surface_variant
            text: Math.round(Audio.volume) + "%"
        }

        // --- mixer ---------------------------------------------------------
        Item {
            id: mixerButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: root.iconButtonSize
            height: root.iconButtonSize
            implicitWidth: width
            implicitHeight: height
            property bool hovered: mixerMouse.containsMouse

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: Colors.md3.on_surface
                opacity: mixerMouse.containsMouse ? 0.12 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }

            Icon {
                anchors.centerIn: parent
                name: "media/sliders-horizontal"
                size: 16
                color: Colors.md3.on_surface_variant
            }

            MouseArea {
                id: mixerMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                // No custom mixer UI — pavucontrol already covers
                // per-app volume, device routing, etc.
                onClicked: Quickshell.execDetached(["pavucontrol"])
            }
        }

        Tooltip {
            target: mixerButton
            text: "Volume mixer"
        }

        // --- slider ---------------------------------------------------------
        Slider {
            id: slider
            anchors.left: percentageText.right
            anchors.right: mixerButton.left
            anchors.leftMargin: root.rowPadding
            anchors.rightMargin: root.rowPadding
            anchors.verticalCenter: parent.verticalCenter

            value: Audio.volume
            onMoved: newValue => Audio.setVolume(newValue)
        }
    }
}
