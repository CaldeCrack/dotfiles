import QtQuick
import qs.widgets
import qs.config
import qs.modules.infoPanel

BarButtonBase {
    id: root

    // Which tab index this button opens
    readonly property int wallpaperTabIndex: 0

    // The label shown in the button. \n splits it across up to 2 lines.
    tooltipText: "Change wallpaper"

    // Reflect whether the panel is currently open on this tab, so the
    // button gets BarButtonBase's checked styling for free.
    checked: InfoPanel.panelOpen && InfoPanel.currentIndex === wallpaperTabIndex

    onClicked: {
        if (checked)
            InfoPanel.close();
        else
            InfoPanel.show(wallpaperTabIndex);
    }

    Icon {
        name: "common/wallpaper"
        size: 16
        color: Colors.md3.on_surface
    }
}
