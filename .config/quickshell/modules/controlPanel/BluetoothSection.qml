import QtQuick
import Quickshell

import qs.config
import qs.services
import qs.widgets

// BluetoothSection
// -----------------
// ControlPanel content slice: clickable status icon (toggles bluetooth
// on/off), a label (state or connected device name), a reload button,
// and a dropdown toggle — same inline-expanding shape as WifiSection,
// including the same "not a popup, actually pushes content below it
// down" behavior.
//
// Two differences from WifiSection, both per spec: each row uses the
// device's own system icon (BlueZ reports one per device type) rather
// than a single icon function, and rows have no click interaction at
// all for now.

Item {
    id: root

    property real headerHeight: 40
    property real rowHeight: 40
    property int maxVisibleRows: 5
    property real dropdownSpacing: 4
    property real dropdownInset: 12
    property real iconButtonSize: 28

    property bool expanded: false
    onExpandedChanged: Bluetooth.setScanning(expanded)

    readonly property int deviceCount: Bluetooth.sortedDevices.length
    readonly property real dropdownContentHeight: Math.min(deviceCount, maxVisibleRows) * rowHeight

    implicitHeight: headerHeight + (expanded && deviceCount > 0 ? dropdownSpacing + dropdownContentHeight : 0)
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    // --- header card ------------------------------------------------------
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.headerHeight
        radius: 16
        color: Colors.md3.surface_container_high

        Item {
            id: content
            anchors.fill: parent
            anchors.margins: 8

            // --- status icon (click to toggle bluetooth) ---------------------
            Item {
                id: statusIcon
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: root.iconButtonSize
                height: root.iconButtonSize
                implicitWidth: width
                implicitHeight: height
                property bool hovered: statusMouse.containsMouse

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: Colors.md3.on_surface
                    opacity: statusMouse.containsMouse ? 0.12 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                Icon {
                    anchors.centerIn: parent
                    name: Bluetooth.currentIcon
                    size: 18
                    color: Colors.md3.on_surface
                }

                MouseArea {
                    id: statusMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Bluetooth.toggleBluetoothEnabled()
                }
            }

            Tooltip {
                target: statusIcon
                text: Bluetooth.bluetoothEnabled ? "Disable Bluetooth" : "Enable Bluetooth"
            }

            // --- label: state, or connected device name -----------------------
            Text {
                id: statusLabel
                anchors.left: statusIcon.right
                anchors.leftMargin: 8
                anchors.right: reloadButton.left
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                color: Colors.md3.on_surface
                text: {
                    if (!Bluetooth.bluetoothEnabled)
                        return "Disabled";
                    // Bluetooth allows several simultaneous connections
                    // (mouse + headphones, say) — this shows the first
                    // one only, same simplification WifiSection makes
                    // for its single active network.
                    if (Bluetooth.connectedDevice)
                        return Bluetooth.connectedDevice.name;
                    return "Enabled";
                }
            }

            // --- reload -------------------------------------------------------
            Item {
                id: reloadButton
                anchors.right: dropdownToggle.left
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                width: root.iconButtonSize
                height: root.iconButtonSize
                implicitWidth: width
                implicitHeight: height
                property bool hovered: reloadMouse.containsMouse

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: Colors.md3.on_surface
                    opacity: reloadMouse.containsMouse ? 0.12 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                Icon {
                    anchors.centerIn: parent
                    name: "common/refresh"
                    size: 15
                    color: Colors.md3.on_surface_variant
                }

                MouseArea {
                    id: reloadMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Bluetooth.rescan()
                }
            }

            Tooltip {
                target: reloadButton
                text: "Refresh devices"
            }

            // --- dropdown toggle (nerd font chevron, right → down) -----------
            Item {
                id: dropdownToggle
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: root.iconButtonSize
                height: root.iconButtonSize
                implicitWidth: width
                implicitHeight: height
                property bool hovered: dropdownMouse.containsMouse

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: Colors.md3.on_surface
                    opacity: dropdownMouse.containsMouse ? 0.12 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 14
                    color: Colors.md3.on_surface_variant
                    text: root.expanded ? "\uf107" : "\uf105"
                }

                MouseArea {
                    id: dropdownMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.expanded = !root.expanded
                }
            }

            Tooltip {
                target: dropdownToggle
                text: root.expanded ? "Hide devices" : "Show devices"
            }
        }
    }

    // --- dropdown: inline, narrower, centered, scrolls past 5 rows --------
    Item {
        id: dropdown
        anchors.top: header.bottom
        anchors.topMargin: root.dropdownSpacing
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - root.dropdownInset * 2
        height: root.expanded ? root.dropdownContentHeight : 0
        clip: true
        visible: height > 0

        Behavior on height {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: Colors.md3.surface_container_high
        }

        ListView {
            anchors.fill: parent
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: Bluetooth.sortedDevices

            delegate: Item {
                id: deviceRow
                required property var modelData
                width: ListView.view.width
                height: root.rowHeight

                Rectangle {
                    anchors.fill: parent
                    color: Colors.md3.on_surface
                    radius: 16
                    opacity: bluetoothMouse.containsMouse ? 0.08 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                Icon {
                    id: deviceIcon
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    systemIcon: deviceRow.modelData.icon || "bluetooth"
                    systemIconFallback: "bluetooth"
                    size: 16
                }

                Text {
                    anchors.left: deviceIcon.right
                    anchors.leftMargin: 10
                    anchors.right: statusIconEntry.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    color: Colors.md3.on_surface
                    text: deviceRow.modelData.name
                }

                Icon {
                    id: statusIconEntry
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    name: Bluetooth.statusIconForDevice(deviceRow.modelData)
                    size: 14
                    color: Colors.md3.on_surface_variant
                }

                MouseArea {
                    id: bluetoothMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
