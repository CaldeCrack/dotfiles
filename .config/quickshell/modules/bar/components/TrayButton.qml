import QtQuick

import qs.widgets
import qs.services
import qs.config

BarButtonBase {
    id: root
    checked: popup.open
    tooltipText: Tray.count + " background app" + (Tray.count === 1 ? "" : "s")

    onClicked: popup.open = !popup.open

    Text {
        text: ""
        font.bold: true
        font.pixelSize: root.height * 0.5
        color: Colors.md3.on_surface
    }

    DismissablePopup {
        id: popup
        open: false
        onDismissRequested: popup.open = false
        target: root

        GridView {
            id: grid

            width: implicitWidth
            height: implicitHeight
            implicitWidth: Math.min(Tray.count, 5) * cellWidth
            implicitHeight: Math.ceil(Tray.count / 5) * cellHeight
            cellWidth: 40
            cellHeight: 40
            model: Tray.items

            delegate: TrayIcon {
                required property var modelData

                width: grid.cellWidth
                height: grid.cellHeight
                trayItem: modelData
                onActionTriggered: popup.open = false
            }
        }
    }
}
