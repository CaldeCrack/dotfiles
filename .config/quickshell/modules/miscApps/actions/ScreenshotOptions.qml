import QtQuick
import qs.widgets
import qs.config

Column {
    id: root

    // Emits the shell command for the caller to run. This view doesn't run
    // anything or dismiss anything itself — it just reports the choice, so
    // whoever pushed this view decides what "selecting an option" means.
    signal optionSelected(string command)

    spacing: 4

    ScreenshotOption {
        iconName: "common/monitor"
        label: "Screen"
        onClicked: root.optionSelected("hyprshot -m output")
    }

    ScreenshotOption {
        iconName: "common/window"
        label: "Window"
        onClicked: root.optionSelected("hyprshot -m window")
    }

    ScreenshotOption {
        iconName: "common/selection"
        label: "Region"
        onClicked: root.optionSelected("hyprshot -m region")
    }

    component ScreenshotOption: Item {
        id: option

        signal clicked

        property string iconName: ""
        property string label: ""

        readonly property bool hovered: mouseArea.containsMouse

        implicitWidth: 160
        implicitHeight: 36

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: option.hovered ? Colors.md3.surface_container : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Icon {
                anchors.verticalCenter: parent.verticalCenter
                name: option.iconName
                size: 16
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: option.label
                color: Colors.md3.on_surface
                font.pixelSize: 12
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: option.clicked()
        }
    }
}
