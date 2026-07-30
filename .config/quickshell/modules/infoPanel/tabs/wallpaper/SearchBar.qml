import QtQuick
import qs.widgets as Widgets
import qs.config as Config

// Search field + open-folder / refresh / apply actions, plus an inline
// clear button. Layout is right-anchored: the icon buttons claim fixed
// width on the right, the input area fills whatever's left.
Item {
    id: root

    property alias searchText: searchField.text
    property bool canApply: false

    signal openFolderRequested
    signal refreshRequested
    signal applyRequested

    readonly property int iconSize: 24
    readonly property int buttonSize: 34
    readonly property int buttonSpacing: 8

    // Shared chrome for the folder/refresh/apply icon buttons — declared as
    // an inline component (same pattern Colors.qml uses for its Md3/Base16/
    // Palette JsonObjects) so each button below is just a one-liner.
    component ActionButton: Item {
        id: btn

        property string iconName: ""
        property string tooltipText: ""
        property bool enabled: true
        signal clicked

        // Widgets.Tooltip requires its target to expose a `hovered` bool —
        // BarButtonBase already does this natively, this is the same
        // contract for our own hover-tracking Item.
        readonly property bool hovered: hoverArea.containsMouse

        width: root.buttonSize
        height: root.buttonSize
        implicitWidth: root.buttonSize
        implicitHeight: root.buttonSize

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: hoverArea.containsMouse && btn.enabled ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
        }

        Widgets.Icon {
            anchors.centerIn: parent
            name: btn.iconName
            size: root.iconSize
            color: btn.enabled ? Config.Colors.md3.on_surface : Config.Colors.md3.outline_variant
        }

        MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            enabled: btn.enabled
            cursorShape: btn.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: btn.clicked()
        }

        Widgets.Tooltip {
            target: btn
            text: btn.tooltipText
        }
    }

    Item {
        id: inputArea
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: actionButtons.left
        anchors.rightMargin: 8

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: 4
            border.width: 1
            border.color: searchField.activeFocus ? Config.Colors.md3.primary : Config.Colors.md3.on_surface_variant
        }

        TextInput {
            id: searchField
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: (clearButton.visible ? clearButton.width : 0) + 8
            verticalAlignment: TextInput.AlignVCenter
            color: Config.Colors.md3.on_surface
            clip: true

            // Escape drops keyboard focus rather than being swallowed or
            // bubbling up to close the whole panel — matches the general
            // "Escape backs out one level" expectation for a text field.
            Keys.onEscapePressed: searchField.focus = false

            // TextInput doesn't switch the system cursor to an I-beam on
            // its own reliably across compositors — this overlay only
            // exists for that; acceptedButtons: Qt.NoButton means it never
            // grabs the click, so presses fall through to the field below.
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.IBeamCursor
            }
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "Search wallpapers..."
            color: Config.Colors.md3.on_surface_variant
            visible: searchField.text.length === 0
        }

        Item {
            id: clearButton
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: visible ? root.iconSize + 8 : 0
            height: root.iconSize + 8
            implicitWidth: root.iconSize + 8
            implicitHeight: root.iconSize + 8
            visible: searchField.text.length > 0

            readonly property bool hovered: clearHover.containsMouse

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: clearHover.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
            }

            Widgets.Icon {
                anchors.centerIn: parent
                name: "common/x"
                size: root.iconSize
                color: Config.Colors.md3.on_surface
            }

            MouseArea {
                id: clearHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: searchField.text = ""
            }

            Widgets.Tooltip {
                target: clearButton
                text: "Clear"
            }
        }
    }

    Row {
        id: actionButtons
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.buttonSpacing

        ActionButton {
            iconName: "common/folder-open"
            tooltipText: "Open folder location"
            onClicked: root.openFolderRequested()
        }
        ActionButton {
            iconName: "common/refresh"
            tooltipText: "Refresh"
            onClicked: root.refreshRequested()
        }
        ActionButton {
            iconName: "common/circle-check"
            tooltipText: "Apply wallpaper"
            enabled: root.canApply
            onClicked: root.applyRequested()
        }
    }
}
