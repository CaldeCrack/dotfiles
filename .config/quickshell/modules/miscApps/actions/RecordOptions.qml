import QtQuick
import qs.widgets
import qs.config
import qs.services

Column {
    id: root

    // Screen/Region report which mode was picked — they don't call
    // Recording.start() themselves. Same reason ScreenshotOptions only
    // reports a command instead of running it: the popup needs to delay
    // the actual capture until after it's visually gone, and that timing
    // decision belongs to whoever owns the popup, not this view.
    signal recordRequested(string mode)

    spacing: 4

    // Audio is the one row that doesn't go through recordRequested — it's
    // a live preference on the service, not an action, so it toggles
    // Recording.audioEnabled directly and the popup stays open.
    RecordOption {
        iconName: Recording.audioEnabled ? "media/volume-2" : "media/volume-x"
        label: "Audio"
        toggle: true
        checked: Recording.audioEnabled
        onClicked: Recording.toggleAudio()
    }

    RecordOption {
        iconName: "common/monitor"
        label: "Screen"
        onClicked: root.recordRequested("screen")
    }

    RecordOption {
        iconName: "common/selection"
        label: "Region"
        onClicked: root.recordRequested("region")
    }

    component RecordOption: Item {
        id: option

        signal clicked

        property string iconName: ""
        property string label: ""

        // Screen/Region leave these at their defaults and just fire
        // clicked. Audio sets toggle: true and reflects checked visually
        // instead — clicking it flips state in place rather than
        // selecting/dismissing.
        property bool toggle: false
        property bool checked: false

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

        // Toggle indicator — only relevant (and visible) for the audio
        // row; action rows leave `toggle` false so this never renders.
        Rectangle {
            visible: option.toggle
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 10
            height: 10
            radius: 5
            color: option.checked ? Colors.md3.primary : Colors.md3.outline_variant

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
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
