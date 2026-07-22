import QtQuick
import qs.config as Config
import qs.widgets as Widgets
import qs.services as Services

Widgets.BarButtonBase {
    id: root
    horizontalPadding: 4
    hoverOpacity: 0

    // This button has no single click target of its own — each segment
    // handles its own click — so leave onClicked/onRightClicked unset.

    Row {
        id: row
        spacing: 1

        Repeater {
            model: Services.Workspaces.workspaces

            delegate: Item {
                id: segment

                required property var modelData
                readonly property int wsId: modelData.id
                readonly property bool active: wsId === Services.Workspaces.activeId
                readonly property bool hovered: hoverArea.containsMouse
                readonly property real activeWidthMultiplier: segment.active ? 1.6 : 1

                width: (Config.Settings.bar.height - 8) * activeWidthMultiplier
                height: Config.Settings.bar.height - 8

                Rectangle {
                    id: highlight
                    anchors.fill: parent
                    radius: height / 2
                    color: segment.active ? Config.Colors.md3.primary : Config.Colors.md3.on_surface
                    opacity: segment.active ? 1 : (segment.hovered ? 0.12 : 0)

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: segment.wsId
                    color: segment.active ? Config.Colors.md3.on_primary : Config.Colors.md3.on_surface
                    font.pixelSize: 12
                }

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Services.Workspaces.focus(segment.wsId)
                }
            }
        }
    }
}
