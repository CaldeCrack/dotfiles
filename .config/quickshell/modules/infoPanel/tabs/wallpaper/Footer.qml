import QtQuick
import qs.config

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
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Rectangle {
            width: 16
            height: 16
            radius: 8
            color: Colors.md3.primary
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.currentWallpaperName
            color: Colors.md3.on_surface
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Row {
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 24
            height: 24
            radius: 12
            color: mousePrev.containsMouse && root.currentPage > 0 ? Qt.rgba(1, 1, 1, 0.12) : "transparent"

            Text {
                anchors.centerIn: parent
                text: "<"
                color: root.currentPage > 0 ? Colors.md3.on_surface : Colors.md3.on_surface_variant
            }

            MouseArea {
                id: mousePrev
                anchors.fill: parent
                hoverEnabled: true
                enabled: root.currentPage > 0
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                onClicked: root.prevRequested()
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: (root.currentPage + 1) + " / " + root.totalPages
            color: Colors.md3.on_surface
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 24
            height: 24
            radius: 12
            color: mouseNext.containsMouse && root.currentPage < root.totalPages - 1 ? Qt.rgba(1, 1, 1, 0.12) : "transparent"

            Text {
                anchors.centerIn: parent
                text: ">"
                color: root.currentPage < root.totalPages - 1 ? Colors.md3.on_surface : Colors.md3.on_surface_variant
            }

            MouseArea {
                id: mouseNext
                anchors.fill: parent
                hoverEnabled: true
                enabled: root.currentPage < root.totalPages - 1
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                onClicked: root.nextRequested()
            }
        }
    }
}
