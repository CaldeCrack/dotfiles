import Quickshell
import QtQuick
import Quickshell.Services.SystemTray
import qs.config

Item {
    id: iconWrap
    required property SystemTrayItem trayItem
    required width
    required height
    implicitWidth: width
    implicitHeight: height
    readonly property bool hovered: hoverArea.containsMouse

    signal actionTriggered

    Rectangle {
        id: chip
        anchors.centerIn: parent
        width: 32
        height: 32
        radius: 16
        color: hoverArea.pressed ? Colors.md3.surface_container_highest : (hovered ? Colors.md3.surface_container_high : Colors.md3.surface_container)
    }

    Image {
        anchors.centerIn: chip
        source: trayItem.icon
        width: 24
        height: 24
    }

    MouseArea {
        id: hoverArea
        anchors.fill: chip
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                menuAnchor.open();
                return;
            }
            if (mouse.button === Qt.MiddleButton) {
                if (trayItem.onlyMenu)
                    return;
                trayItem.secondaryActivate();
            } else {
                trayItem.activate();
            }
            iconWrap.actionTriggered();
        }
    }

    Tooltip {
        target: iconWrap
        text: trayItem.title || trayItem.tooltipTitle || trayItem.id
    }

    QsMenuAnchor {
        id: menuAnchor
        menu: trayItem.menu
        anchor.item: iconWrap
        anchor.rect.y: iconWrap.height
    }
}
