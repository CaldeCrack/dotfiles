import QtQuick
import QtQuick.Layouts
import qs.widgets as Widgets
import qs.config as Config
import qs.services as Services

Item {
    id: root

    readonly property var forecast: Services.Weather.dailyForecast
    readonly property bool loading: !forecast || forecast.length === 0
    readonly property var placeholderForecast: [
        {
            dayName: "Today"
        },
        {
            dayName: "Tomorrow"
        },
        {
            dayName: "---"
        }
    ]

    function fmt(value) {
        return (value === undefined || value === null || isNaN(value)) ? "--°" : Math.round(value) + "°";
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Config.Colors.md3.surface_container
        border.color: Config.Colors.md3.primary
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        Text {
            text: "Daily Forecast"

            color: Config.Colors.md3.on_surface
            font.pixelSize: 18
            font.bold: true
        }

        ListView {
            id: forecastList

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: root.loading ? root.placeholderForecast : root.forecast
            interactive: false
            spacing: 8
            clip: true

            readonly property int rowCount: Math.max(count, 1)

            delegate: Item {
                width: ListView.view.width
                height: (forecastList.height - (forecastList.rowCount - 1) * forecastList.spacing) / forecastList.rowCount

                readonly property bool placeholder: root.loading
                readonly property bool isToday: index === 0

                Row {
                    anchors.fill: parent

                    Text {
                        width: parent.width - iconRow.width
                        anchors.verticalCenter: parent.verticalCenter

                        text: placeholder ? modelData.dayName : (isToday ? "Today" : modelData.dayName)

                        color: Config.Colors.md3.on_surface
                        opacity: placeholder ? 0.35 : 1.0

                        font.pixelSize: 16
                        font.bold: isToday
                    }

                    Row {
                        id: iconRow

                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 14

                        RowLayout {
                            spacing: 2

                            Widgets.Icon {
                                Layout.alignment: Qt.AlignVCenter
                                name: "weather/humidity"
                                size: 20
                                color: "#85c1dc"
                                opacity: placeholder ? 0.35 : 1
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: placeholder ? "--%" : (modelData.humidity || "--") + "%"

                                color: Config.Colors.md3.on_surface
                                opacity: placeholder ? 0.5 : 1

                                font.pixelSize: 14
                            }
                        }

                        Widgets.Icon {
                            name: placeholder ? "weather/cloudy" : modelData.iconName

                            size: 20
                            color: Config.Colors.md3.on_surface
                            opacity: placeholder ? 0.35 : 1
                        }

                        Text {
                            width: 24
                            horizontalAlignment: Text.AlignRight

                            text: placeholder ? "--°" : root.fmt(modelData.maxTempC)

                            color: Config.Colors.md3.on_surface
                            opacity: placeholder ? 0.5 : 1

                            font.pixelSize: 16
                            font.bold: true
                        }

                        Text {
                            width: 24
                            horizontalAlignment: Text.AlignRight

                            text: placeholder ? "--°" : root.fmt(modelData.minTempC)

                            color: Config.Colors.md3.on_surface_variant
                            opacity: placeholder ? 0.5 : 1

                            font.pixelSize: 16
                        }
                    }
                }
            }
        }
    }
}
