import QtQuick

import qs.config
import qs.services
import qs.widgets

// WifiSection
// -----------
// ControlPanel content slice: clickable status icon (toggles wifi
// on/off), a label (state or connected SSID + signal), a reload button,
// and a dropdown toggle. Unlike Volume/Brightness, the dropdown isn't a
// popup — it's inline content that expands within this same component,
// so it pushes everything below it down the Column rather than
// floating over it. That's the shape difference Volume/Brightness
// couldn't tell us about on their own.

Item {
    id: root

    property real headerHeight: 40
    property real rowHeight: 40
    property int maxVisibleRows: 5
    property real dropdownSpacing: 4
    // Dropdown reads narrower than the header card and centers within
    // it, per spec — this is the horizontal inset on each side.
    property real dropdownInset: 12
    property real iconButtonSize: 28

    property bool expanded: false
    onExpandedChanged: Network.setScanning(expanded)

    readonly property int networkCount: Network.sortedNetworks.length
    readonly property real dropdownContentHeight: Math.min(networkCount, maxVisibleRows) * rowHeight

    implicitHeight: headerHeight + (expanded && networkCount > 0 ? dropdownSpacing + dropdownContentHeight : 0)
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

            // --- status icon (click to toggle wifi) ------------------------
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
                    name: Network.currentIcon
                    size: 18
                    color: Colors.md3.on_surface
                }

                MouseArea {
                    id: statusMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Network.toggleWifiEnabled()
                }
            }

            Tooltip {
                target: statusIcon
                text: Network.wifiEnabled ? "Disable Wi-Fi" : "Enable Wi-Fi"
            }

            // --- label: state, or SSID + signal when connected --------------
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
                    if (!Network.wifiHardwareEnabled || !Network.wifiEnabled)
                        return "Disabled";
                    if (Network.connectedNetwork)
                        return `${Network.connectedNetwork.name} · ${Math.round(Network.connectedNetwork.signalStrength * 100)}%`;
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
                    onClicked: Network.rescan()
                }
            }

            Tooltip {
                target: reloadButton
                text: "Refresh networks"
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
                text: root.expanded ? "Hide networks" : "Show networks"
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
            model: Network.sortedNetworks

            delegate: Item {
                id: networkRow
                required property var modelData
                width: ListView.view.width
                height: root.rowHeight

                Rectangle {
                    anchors.fill: parent
                    color: Colors.md3.on_surface
                    radius: 16
                    opacity: networkMouse.containsMouse ? 0.08 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                Icon {
                    id: networkIcon
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    name: Network.iconForSignal(networkRow.modelData.signalStrength)
                    size: 16
                    color: Colors.md3.on_surface
                }

                Text {
                    anchors.left: networkIcon.right
                    anchors.leftMargin: 10
                    anchors.right: lockIcon.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    color: Colors.md3.on_surface
                    text: `${networkRow.modelData.name} · ${Math.round(networkRow.modelData.signalStrength * 100)}%`
                }

                Icon {
                    id: lockIcon
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    name: Network.isSecured(networkRow.modelData) ? "network/lock" : "network/lock-open"
                    size: 14
                    color: Colors.md3.on_surface_variant
                }

                MouseArea {
                    id: networkMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Network.connectToNetwork(networkRow.modelData)
                }
            }
        }
    }
}
