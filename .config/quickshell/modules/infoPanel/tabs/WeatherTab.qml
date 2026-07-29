import QtQuick
import "weather" as WeatherSections

// Weather tab layout: split top/bottom via `proportion`. The top section is
// itself split left/right via `topSectionProportion` — only the left part
// (current conditions) is built so far; the rest are placeholders until
// their content is decided.
Item {
    id: root

    // Instantiated via Loader's sourceComponent from InfoPanel — this fills
    // whatever size the Loader (and in turn the fixed content area) gives it.
    anchors.fill: parent

    readonly property int sectionSpacing: 8
    // Height available for the 2 stacked sections (top / bottom) once the
    // 1 gap between them is accounted for.
    readonly property real usableHeight: height - sectionSpacing
    // Height fraction taken by the top section.
    readonly property real proportion: 0.5

    // Width fraction taken by the top section's left (current conditions)
    // part vs its right part.
    readonly property real topSectionProportion: 0.55

    Column {
        anchors.fill: parent
        spacing: root.sectionSpacing

        Row {
            id: topSection

            width: parent.width
            height: root.usableHeight * root.proportion
            spacing: root.sectionSpacing

            readonly property real usableWidth: width - root.sectionSpacing

            WeatherSections.CurrentWeatherSection {
                width: topSection.usableWidth * root.topSectionProportion
                height: parent.height
            }

            WeatherSections.DailyForecast {
                width: topSection.usableWidth * (1 - root.topSectionProportion)
                height: parent.height
            }
        }

        WeatherSections.HourlyForecast {
            width: parent.width
            height: root.usableHeight * (1 - root.proportion)
        }
    }
}
