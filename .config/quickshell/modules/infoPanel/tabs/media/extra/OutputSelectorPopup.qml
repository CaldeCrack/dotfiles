import QtQuick
import qs.config
import qs.services
import qs.widgets

// "Current" here means this node is Pipewire's actual defaultAudioSink —
// the one everything's actually playing through right now, not just a
// preference hint.
AnchoredPopup {
    id: root

    property real popupContentWidth: 240

    Column {
        width: root.popupContentWidth
        spacing: 4
        topPadding: 12
        bottomPadding: 8
        leftPadding: 12
        rightPadding: 12

        Text {
            width: parent.width - parent.leftPadding - parent.rightPadding
            text: "Outputs (" + Audio.availableSinks.length + ")"
            font.bold: true
            font.pixelSize: 13
            color: Colors.md3.on_surface
            bottomPadding: 4
        }

        // availableSinks is already a plain filtered array (see Audio.qml),
        // not an ObjectModel — no .values needed here, unlike the player
        // selector's Repeater.
        Repeater {
            model: Audio.availableSinks

            delegate: Item {
                id: entry
                required property var modelData

                width: root.popupContentWidth - 24 // account for Column's left/right padding
                height: 44

                readonly property bool isCurrent: modelData === Audio.sink

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: mouseArea.containsMouse ? Colors.md3.surface_container_high : "transparent"
                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                Icon {
                    id: sinkIcon
                    anchors {
                        left: parent.left
                        leftMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    name: Audio.iconNameForSink(entry.modelData)
                    size: 22
                }

                Column {
                    anchors {
                        left: sinkIcon.right
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 1

                    Text {
                        width: parent.width
                        text: entry.modelData.nickname || entry.modelData.description || entry.modelData.name
                        color: Colors.md3.on_surface
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        text: entry.isCurrent ? "Current" : "Available"
                        color: entry.isCurrent ? Colors.md3.primary : Colors.md3.on_surface_variant
                        font.pixelSize: 11
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Audio.setDefaultSink(entry.modelData)
                }
            }
        }
    }
}
