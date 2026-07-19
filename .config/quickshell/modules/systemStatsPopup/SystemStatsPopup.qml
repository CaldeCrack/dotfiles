pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.config as Config
import qs.widgets as Widgets

PanelWindow {
    id: root

    property bool panelOpen: false

    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore // popup, don't reserve screen space

    anchors { top: true; left: true }
    margins.top: Config.Settings.bar.height // manually clear the bar, see Widgets_reference

    implicitWidth: panel.implicitWidth
    implicitHeight: panel.implicitHeight

    // Called by the owning bar button. Positions the popup under `item`
    // (computed once, on open — same one-shot convention as Tooltip).
    function openBelow(item) {
        if (item) {
            const pos = item.mapToItem(null, 0, item.height)
            root.margins.left = pos.x
        }
        root.visible = true
        root.panelOpen = true
    }

    function close() {
        root.panelOpen = false
    }

    Widgets.PanelBase {
        id: panel
        panelOpen: root.panelOpen
        onClosed: root.visible = false

        // Intentionally empty — cpu/memory/disk/battery/gpu/temperature
        // values already come from Services.SystemStats and
        // Services.Battery, this just isn't laid out yet.
        Item {
            implicitWidth: 240
            implicitHeight: 160
        }
    }
}
