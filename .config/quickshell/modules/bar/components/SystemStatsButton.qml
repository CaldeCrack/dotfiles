import QtQuick
import qs.widgets as Widgets
import qs.services as Services
import qs.modules.systemStatsPopup as StatsPopup

Widgets.BarButtonBase {
    id: root

    checked: popup.panelOpen
    onClicked: popup.panelOpen ? popup.close() : popup.openBelow(root)

    // Icon + hover-wrapper + tooltip, repeated per stat. Item/Icon have no
    // hover state of their own (the button's MouseArea covers the whole
    // button), so each one gets its own tiny hover-tracking wrapper —
    // same composite pattern as Widgets_reference.md.
    component StatIcon: Item {
        id: wrap
        required property string iconName
        required property real value
        property alias size: icon.size

        width: icon.size
        height: icon.size
        readonly property bool hovered: hoverArea.hovered

        Widgets.Icon {
            id: icon
            name: wrap.iconName
            size: 16
        }

        HoverHandler {
            id: hoverArea
        }

        Widgets.Tooltip {
            target: wrap
            text: Math.round(wrap.value) + "%"
        }
    }

    StatsPopup.SystemStatsPopup {
        id: popup
    }

    Row {
        spacing: 6

        StatIcon {
            iconName: "cpu"
            value: Services.SystemStats.cpuUsage
        }

        StatIcon {
            iconName: "memory-stick"
            value: Services.SystemStats.memoryUsage
        }

        StatIcon {
            iconName: "hard-drive"
            value: Services.SystemStats.diskUsage
        }

        StatIcon {
            visible: Services.Battery.available
            iconName: Services.Battery.iconName
            value: Services.Battery.percentage
        }
    }
}
