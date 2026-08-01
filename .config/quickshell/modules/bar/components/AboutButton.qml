import QtQuick
import qs.widgets
import qs.config
import qs.modules.infoPanel

BarButtonBase {
    id: root

    // Which tab index this button opens — About is last in InfoPanel's
    // tabModel (index 4).
    readonly property int aboutTabIndex: 2

    // The label shown in the button. \n splits it across up to 2 lines.
    property string label: "Calde\nCrack"

    tooltipText: "About"

    // Reflect whether the panel is currently open on this tab, so the
    // button gets BarButtonBase's checked styling for free.
    checked: InfoPanel.panelOpen && InfoPanel.currentIndex === aboutTabIndex

    onClicked: {
        if (checked)
            InfoPanel.close();
        else
            InfoPanel.show(aboutTabIndex);
    }

    Text {
        text: root.label
        color: Colors.md3.on_surface
        font.pixelSize: 10
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        lineHeight: 0.85
        lineHeightMode: Text.ProportionalHeight
    }
}
