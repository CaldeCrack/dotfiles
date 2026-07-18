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

        Text {
            anchors.centerIn: parent
            text: "hello world"
            color: Config.Colors.md3.primary

            MouseArea {
                anchors.fill: parent
                onClicked: root.togglePopup()
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
