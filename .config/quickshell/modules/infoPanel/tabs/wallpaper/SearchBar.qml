import QtQuick

// Search field + open-folder / refresh / apply actions. Plain TextInput and
// Text-as-button stand-ins for now — swap for a themed input and
// BarButtonBase-styled icon buttons once icons exist for folder/refresh/
// apply in assets/icons/.
Item {
    id: root

    property alias searchText: searchField.text
    property bool canApply: false

    signal openFolderRequested()
    signal refreshRequested()
    signal applyRequested()

    Row {
        anchors.fill: parent
        spacing: 8

        Item {
            width: parent.width * 0.5
            height: parent.height

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: "gray"
                radius: 4
            }

            TextInput {
                id: searchField
                anchors.fill: parent
                anchors.margins: 8
                verticalAlignment: TextInput.AlignVCenter
                color: "white"
                clip: true
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: "Search wallpapers…"
                color: "gray"
                visible: searchField.text.length === 0
            }
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            // TODO: replace with real BarButtonBase-styled icon buttons
            Text {
                text: "Open folder"
                color: "gray"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea { anchors.fill: parent; onClicked: root.openFolderRequested() }
            }

            Text {
                text: "Refresh"
                color: "gray"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea { anchors.fill: parent; onClicked: root.refreshRequested() }
            }

            Text {
                text: "Apply"
                color: root.canApply ? "white" : "gray"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    enabled: root.canApply
                    onClicked: root.applyRequested()
                }
            }
        }
    }
}
