import QtQuick
import qs.widgets as Widgets
import qs.config as Config
import qs.modules.infoPanel as Info

Widgets.BarButtonBase {
    id: root

    // Which tab index this button opens — About is last in Info.InfoPanel's
    // tabModel (index 4).
    readonly property int aboutTabIndex: 2

    // The label shown in the button. \n splits it across up to 2 lines.
    property string label: "Calde\nCrack"

    tooltipText: "About"

    // Reflect whether the panel is currently open on this tab, so the
    // button gets BarButtonBase's checked styling for free.
    checked: Info.InfoPanel.panelOpen && Info.InfoPanel.currentIndex === aboutTabIndex

    onClicked: {
        if (checked)
            Info.InfoPanel.close();
        else
            Info.InfoPanel.show(aboutTabIndex);
    }

    Text {
        text: root.label
        color: Config.Colors.md3.on_surface
        font.pixelSize: 10
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        lineHeight: 0.85
        lineHeightMode: Text.ProportionalHeight
    }
}
