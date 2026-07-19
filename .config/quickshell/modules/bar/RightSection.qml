import QtQuick
import qs.config as Config
import qs.modules.bar as Bar

// Right-aligned section of the bar. See LeftSection.qml for the registry
// lookup / placeholder fallback pattern this shares.
Row {
    id: root

    property var model: []
    readonly property real slotSize: Config.Settings.bar.height - 4

    spacing: Config.Settings.bar.spacing

    Repeater {
        model: root.model

        delegate: Item {
            id: wrapper
            required property string modelData

            width: root.slotSize
            height: root.slotSize

            readonly property var buttonComponent: Bar.ButtonRegistry.componentMap[modelData]

            Loader {
                anchors.fill: parent
                active: wrapper.buttonComponent !== undefined
                sourceComponent: wrapper.buttonComponent
            }

            Rectangle {
                anchors.fill: parent
                visible: wrapper.buttonComponent === undefined
                radius: width / 2
                color: Config.Colors.md3.surface_container_high

                Text {
                    anchors.centerIn: parent
                    text: wrapper.modelData.charAt(0).toUpperCase()
                    color: Config.Colors.md3.on_surface
                    font.pixelSize: parent.height * 0.45
                }
            }
        }
    }
}
