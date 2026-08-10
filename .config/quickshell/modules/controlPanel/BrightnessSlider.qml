import QtQuick
import Quickshell

import qs.config
import qs.services
import qs.widgets

// BrightnessSlider
// -----------------
// ControlPanel content slice: static brightness icon, fixed-width
// percentage readout, horizontal slider (drag to set backlight level),
// trailing button toggling a blue-light filter via hyprsunset.
//
// Same row shape as VolumeSlider (icon / percentage / slider / trailing
// button on its own background card) — confirms that shape is worth
// keeping as-is rather than extracting a shared wrapper prematurely,
// since Wifi/Bluetooth are still a genuinely different shape (no
// slider, has a dropdown).
//
// Unlike Volume's icon, the brightness icon isn't clickable — there's
// no equivalent "mute" action for backlight, so it's purely
// informational and skips the hover state layer VolumeSlider's icon
// has.

Item {
    id: root

    implicitHeight: 40

    // Fixed so "5%" vs "100%" never moves the slider's start position.
    property real percentageWidth: 34
    property real rowPadding: 8
    property real iconButtonSize: 28

    // Temperature (Kelvin) hyprsunset applies when the filter is on.
    property int blueLightTemperature: 2500

    // Local UI state — hyprsunset has no query command, so this can't
    // be read back from the system. See file header note.
    property bool blueLightEnabled: false

    function toggleBlueLight() {
        blueLightEnabled = !blueLightEnabled;
        if (blueLightEnabled)
            Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", String(blueLightTemperature)]);
        else
            // Resets to hyprsunset's own default rather than picking a
            // specific "off" temperature ourselves.
            Quickshell.execDetached(["hyprctl", "hyprsunset", "identity"]);
    }

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

        // --- brightness icon (informational, not clickable) ---------------
        Item {
            id: iconWrap
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: root.iconButtonSize
            height: root.iconButtonSize
            implicitWidth: width
            implicitHeight: height

            Icon {
                anchors.centerIn: parent
                name: "display/brightness"
                size: 18
                color: Colors.md3.on_surface
            }
        }

        // --- percentage -----------------------------------------------------
        Text {
            id: percentageText
            anchors.left: iconWrap.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            width: root.percentageWidth
            horizontalAlignment: Text.AlignRight
            color: Colors.md3.on_surface_variant
            text: Math.round(Brightness.brightness) + "%"
        }

        // --- blue light toggle -----------------------------------------------
        // MD3 filled-icon-button pattern: enabled = filled circle
        // (primary/on_primary), disabled = transparent circle
        // (on_surface_variant icon). Hover is a separate overlay
        // rectangle in both cases, rather than reusing the base fill's
        // own color/opacity — that's what made hover invisible in the
        // disabled state before, since the base fill there was the same
        // color as the row background it sits on.
        Item {
            id: blueLightButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: root.iconButtonSize
            height: root.iconButtonSize
            implicitWidth: width
            implicitHeight: height
            property bool hovered: blueLightMouse.containsMouse

            Rectangle {
                id: fillLayer
                anchors.fill: parent
                radius: width / 2
                color: root.blueLightEnabled ? Colors.md3.primary : "transparent"
                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }
            }

            Rectangle {
                id: hoverLayer
                anchors.fill: parent
                radius: width / 2
                color: root.blueLightEnabled ? Colors.md3.on_primary : Colors.md3.on_surface
                opacity: blueLightMouse.containsMouse ? (root.blueLightEnabled ? 0.16 : 0.12) : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }

            Icon {
                anchors.centerIn: parent
                name: "display/blue-light-filter"
                size: 16
                color: root.blueLightEnabled ? Colors.md3.on_primary : Colors.md3.on_surface_variant
                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }
            }

            MouseArea {
                id: blueLightMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggleBlueLight()
            }
        }

        Tooltip {
            target: blueLightButton
            text: "Blue light filter"
        }

        // --- slider -----------------------------------------------------------
        Slider {
            id: slider
            anchors.left: percentageText.right
            anchors.right: blueLightButton.left
            anchors.leftMargin: root.rowPadding
            anchors.rightMargin: root.rowPadding
            anchors.verticalCenter: parent.verticalCenter

            value: Brightness.brightness
            onMoved: newValue => Brightness.setBrightness(newValue)
        }
    }
}
