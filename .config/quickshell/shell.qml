import qs.config as Config
import qs.widgets as Widgets
import Quickshell
import QtQuick

Scope {
    id: root

    property bool popupOpen: false
    // window stays alive slightly longer than panelOpen so the close
    // animation has time to actually play before we hide the surface
    property bool popupVisible: false

    function togglePopup() {
        if (!popupOpen) {
            popupVisible = true;
            popupOpen = true;
        } else {
            popupOpen = false;
            // popupVisible flips off in PanelBase.onClosed below,
            // once the fade-out transition finishes
        }
    }

    PanelWindow {
        id: bar

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: Config.Settings.bar.height

        Row {
            anchors.centerIn: parent
            spacing: 8

            // Simple case: one icon, one tooltip, drives the popup.
            Widgets.BarButtonBase {
                id: clockButton
                checked: root.popupOpen
                tooltipText: "Clock"

                onClicked: root.togglePopup()

                Text {
                    text: "12:34"
                    color: Config.Colors.md3.background
                }
            }

            // Composite case: two "icons" sharing one button, each with
            // its own independent tooltip. Text has no hover state of its
            // own, so each icon gets a tiny hover-tracking wrapper (see
            // Tooltip.qml's header comment for why).
            Widgets.BarButtonBase {
                id: statsButton

                Row {
                    id: statsRow
                    spacing: 6

                    Item {
                        id: cpuWrap
                        width: cpuIcon.implicitWidth
                        height: cpuIcon.implicitHeight
                        readonly property bool hovered: cpuHover.containsMouse

                        Text {
                            id: cpuIcon
                            anchors.fill: parent
                            text: "CPU"
                            color: Config.Colors.md3.background
                        }
                        MouseArea {
                            id: cpuHover
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                        }
                    }

                    Item {
                        id: ramWrap
                        width: ramIcon.implicitWidth
                        height: ramIcon.implicitHeight
                        readonly property bool hovered: ramHover.containsMouse

                        Text {
                            id: ramIcon
                            anchors.fill: parent
                            text: "RAM"
                            color: Config.Colors.md3.background
                        }
                        MouseArea {
                            id: ramHover
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                        }
                    }
                }

                Widgets.Tooltip {
                    target: cpuWrap
                    text: "CPU: 23%"
                }
                Widgets.Tooltip {
                    target: ramWrap
                    text: "RAM: 8.1 / 16 GB"
                }
            }
        }
    }

    PanelWindow {
        id: popup

        visible: root.popupVisible
        color: "transparent"

        anchors {
            top: true
            right: true
        }
        margins {
            top: 8
            right: 4
        }

        implicitWidth: panel.implicitWidth
        implicitHeight: panel.implicitHeight

        Widgets.PanelBase {
            id: panel

            panelOpen: root.popupOpen
            onClosed: root.popupVisible = false

            Column {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: "PanelBase test"
                    color: Config.Colors.md3.on_surface
                    font.bold: true
                }
                Text {
                    text: "click hello world to close"
                    color: Config.Colors.md3.on_surface_variant
                }
            }
        }
    }
}
