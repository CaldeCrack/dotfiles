import QtQuick
import qs.widgets
import qs.config
import qs.services
import qs.modules.infoPanel as Info

BarButtonBase {
    id: root

    readonly property int timeTabIndex: 3

    readonly property string format: "hh:mm 󰇙 ddd dd MMM"
    property string label: Qt.formatDateTime(Time.dateTime, format)

    tooltipText: "Time"

    // Reflect whether the panel is currently open on this tab, so the
    // button gets BarButtonBase's checked styling for free.
    checked: Info.InfoPanel.panelOpen && Info.InfoPanel.currentIndex === timeTabIndex

    onClicked: {
        if (checked)
            Info.InfoPanel.close();
        else
            Info.InfoPanel.show(timeTabIndex);
    }

    Text {
        text: root.label
        color: Colors.md3.on_surface
        font.pixelSize: root.height * 0.5
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        lineHeight: 0.85
        lineHeightMode: Text.ProportionalHeight
    }
}
