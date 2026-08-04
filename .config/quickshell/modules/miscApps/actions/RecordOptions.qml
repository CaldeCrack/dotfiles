import QtQuick
import qs.widgets
import qs.config

Column {
    id: root

    // Same contract as ScreenshotOptions — emits the shell command,
    // doesn't run or dismiss anything itself.
    signal optionSelected(string command)

    // Persists only for as long as this view is loaded — NavStack resets
    // its Loader's sourceComponent on pop/reset, so this reverts to false
    // each time Record is reopened rather than remembering the last
    // choice. Fine for now; promote to a real setting if that turns out
    // to be annoying.
    property bool audioEnabled: false

    readonly property string _audioFlag: audioEnabled ? " --audio=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" : ""
    readonly property string _outputPath: "\"$HOME/Videos/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4\""

    spacing: 4

    RecordOption {
        iconName: audioEnabled ? "media/volume-2" : "media/volume-x"
        label: "Audio"
        toggle: true
        checked: root.audioEnabled
        onClicked: root.audioEnabled = !root.audioEnabled
    }

    RecordOption {
        iconName: "common/monitor"
        label: "Screen"
        onClicked: root.optionSelected("wf-recorder -f " + root._outputPath + root._audioFlag)
    }

    RecordOption {
        iconName: "common/selection"
        label: "Region"
        onClicked: root.optionSelected("wf-recorder -g \"$(slurp)\" -f " + root._outputPath + root._audioFlag)
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
