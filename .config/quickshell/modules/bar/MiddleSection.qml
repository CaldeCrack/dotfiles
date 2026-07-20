import QtQuick
import qs.config as Config
import qs.modules.bar as Bar

// Center section of the bar. See LeftSection.qml for the registry lookup /
// placeholder fallback pattern this shares.
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

            readonly property var buttonComponent: Bar.ButtonRegistry.componentMap[modelData]

            implicitWidth: buttonComponent !== undefined ? loader.implicitWidth : root.slotSize
            implicitHeight: buttonComponent !== undefined ? loader.implicitHeight : root.slotSize

            Loader {
                id: loader
                anchors.centerIn: parent
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
