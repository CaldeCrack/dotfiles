pragma ComponentBehavior: Bound

import QtQuick
import qs.widgets
import qs.config

DismissablePopup {
    id: root

    NavStack {
        id: nav

        Column {
            spacing: 8

            Row {
                spacing: 8

                UtilityButton {
                    iconName: "media/screenshot"
                    label: "Screenshot"
                    onClicked: nav.push(screenshotView, "Screenshot")
                }

                UtilityButton {
                    iconName: "media/record"
                    label: "Record"
                    onClicked: nav.push(recordView, "Record")
                }
            }

            Row {
                spacing: 8

                UtilityButton {
                    iconName: "media/colorpicker"
                    label: "Color Picker"
                    onClicked: nav.push(colorPickerView, "Color Picker")
                }

                UtilityButton {
                    iconName: "common/clipboard"
                    label: "Clipboard"
                    onClicked: nav.push(clipboardView, "Clipboard")
                }
            }
        }
    }

    // Placeholder sub-views — each button above swaps the popup content for
    // one of these via NavStack. Replace the Text with real controls per
    // utility; the back arrow + title in the header come from NavStack for
    // free.
    Item {
        Component {
            id: screenshotView
            Text {
                text: "Screenshot options placeholder"
                color: Colors.md3.on_surface
            }
        }

        Component {
            id: recordView
            Text {
                text: "Record options placeholder"
                color: Colors.md3.on_surface
            }
        }

        Component {
            id: colorPickerView
            Text {
                text: "Color picker options placeholder"
                color: Colors.md3.on_surface
            }
        }

        Component {
            id: clipboardView
            Text {
                text: "Clipboard options placeholder"
                color: Colors.md3.on_surface
            }
        }
    }

    // Local to this popup's home view — not promoted to widgets/ since
    // nothing outside misc apps needs this exact tile style.
    component UtilityButton: Item {
        id: utilityButton

        signal clicked

        property string iconName: ""
        property string label: ""

        readonly property bool hovered: mouseArea.containsMouse
        readonly property bool pressed: mouseArea.pressed

        implicitWidth: 88
        implicitHeight: 72

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: utilityButton.pressed ? Colors.md3.surface_container_high : utilityButton.hovered ? Colors.md3.surface_container : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 6

            Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                name: utilityButton.iconName
                size: 20
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: utilityButton.label
                color: Colors.md3.on_surface
                font.pixelSize: 11
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: utilityButton.clicked()
        }
    }
}
