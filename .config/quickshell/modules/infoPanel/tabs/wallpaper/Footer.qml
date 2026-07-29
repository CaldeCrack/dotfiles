import QtQuick
import qs.config as Config

// Left: current wallpaper filename + icon. Center: pagination (prev arrow /
// current-total display / next arrow). Pure display + input relay — page
// state itself is owned by WallpaperGrid, reached here via WallpaperTab.
Item {
    id: root

    property string currentWallpaperPath: ""
    readonly property string currentWallpaperName: currentWallpaperPath ? currentWallpaperPath.substring(currentWallpaperPath.lastIndexOf("/") + 1) : "No wallpaper set"

    property int currentPage: 0
    property int totalPages: 1

    signal prevRequested
    signal nextRequested

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Rectangle {
            width: 16
            height: 16
            radius: 8
            color: Config.Colors.md3.primary
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.currentWallpaperName
            color: Config.Colors.md3.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: 12

        Text {
            text: "<"
            color: root.currentPage > 0 ? "white" : "gray"
            MouseArea {
                anchors.fill: parent
                enabled: root.currentPage > 0
                onClicked: root.prevRequested()
            }
        }

        Text {
            text: (root.currentPage + 1) + " / " + root.totalPages
            color: "gray"
        }

        Text {
            text: ">"
            color: root.currentPage < root.totalPages - 1 ? "white" : "gray"
            MouseArea {
                anchors.fill: parent
                enabled: root.currentPage < root.totalPages - 1
                onClicked: root.nextRequested()
            }
        }
    }
}
