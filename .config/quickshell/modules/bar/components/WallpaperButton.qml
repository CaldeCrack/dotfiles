import QtQuick
import qs.widgets as Widgets
import qs.config as Config
import qs.modules.infoPanel as Info

Widgets.BarButtonBase {
    id: root

    // Which tab index this button opens — About is last in Info.InfoPanel's
    readonly property int wallpaperTabIndex: 0

    // The label shown in the button. \n splits it across up to 2 lines.
    tooltipText: "Change wallpaper"

    // Reflect whether the panel is currently open on this tab, so the
    // button gets BarButtonBase's checked styling for free.
    checked: Info.InfoPanel.panelOpen && Info.InfoPanel.currentIndex === wallpaperTabIndex

    onClicked: {
        if (checked)
            Info.InfoPanel.close();
        else
            Info.InfoPanel.show(wallpaperTabIndex);
    }

    Widgets.Icon {
        name: "common/wallpaper"
        size: 16
        color: Config.Colors.md3.on_surface
    }
}
