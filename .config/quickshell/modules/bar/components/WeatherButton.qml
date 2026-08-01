import QtQuick
import qs.widgets
import qs.config
import qs.services
import qs.modules.infoPanel as Info

BarButtonBase {
    id: root

    readonly property int weatherTabIndex: 4

    readonly property bool loading: Weather.current.tempC === undefined
    property string label: loading ? "--°C" : Weather.current.tempC + "°C"

    tooltipText: loading ? "Loading..." : Weather.current.description

    // Reflect whether the panel is currently open on this tab, so the
    // button gets BarButtonBase's checked styling for free.
    checked: Info.InfoPanel.panelOpen && Info.InfoPanel.currentIndex === weatherTabIndex

    onClicked: {
        if (checked)
            Info.InfoPanel.close();
        else
            Info.InfoPanel.show(weatherTabIndex);
    }

    Row {
        spacing: 4

        Icon {
            name: Weather.current.iconName || "weather/default"
            size: 16
            color: Colors.md3.on_surface
            opacity: loading ? 0.35 : 1
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
}
