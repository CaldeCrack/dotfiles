import QtQuick
import qs.widgets
import qs.config
import qs.modules.miscApps

BarButtonBase {
    id: root
    checked: popup.open
    tooltipText: "Utils"

    onClicked: popup.open = !popup.open

    Icon {
        name: "common/apps"
        size: 16
    }

    MiscAppsPanel {
        id: popup
        open: false
        onDismissRequested: open = false

        target: root
    }
}
