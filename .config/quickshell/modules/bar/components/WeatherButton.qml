import QtQuick
import qs.widgets as Widgets
import qs.config as Config
import qs.services as Services
import qs.modules.infoPanel as Info

Widgets.BarButtonBase {
    id: root

    readonly property int weatherTabIndex: 3

    readonly property bool loading: Services.Weather.current.tempC === undefined
    property string label: loading ? "--°C" : Services.Weather.current.tempC + "°C"

    tooltipText: loading ? "Loading..." : Services.Weather.current.description

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

        Widgets.Icon {
            name: Services.Weather.current.iconName || "weather/default"
            size: 16
            color: Config.Colors.md3.on_surface
            opacity: loading ? 0.35 : 1
        }

        Text {
            text: root.label
            color: Config.Colors.md3.on_surface
            font.pixelSize: root.height * 0.5
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight: 0.85
            lineHeightMode: Text.ProportionalHeight
        }
    }
}
