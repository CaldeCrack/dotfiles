import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.widgets as Widgets

Item {
    id: root

    property var hourlyForecast: Services.Weather.hourlyForecast
    readonly property string lastFetchTimeString: Services.Weather.lastFetchTimeString

    readonly property bool loading: !hourlyForecast || hourlyForecast.length === 0

    readonly property var displayForecast: loading ? [
        {
            time: "--:--",
            tempC: "--",
            iconName: "weather/cloudy"
        },
        {
            time: "--:--",
            tempC: "--",
            iconName: "weather/cloudy"
        },
        {
            time: "--:--",
            tempC: "--",
            iconName: "weather/cloudy"
        },
        {
            time: "--:--",
            tempC: "--",
            iconName: "weather/cloudy"
        },
        {
            time: "--:--",
            tempC: "--",
            iconName: "weather/cloudy"
        }
    ] : hourlyForecast

    Row {
        anchors.fill: parent
        spacing: 8

        Item {
            id: forecastSection

            width: (parent.width - 12 * 2) * root.displayForecast.length / (root.displayForecast.length + 1)
            height: parent.height

            Rectangle {
                anchors.fill: parent
                radius: 16
                color: Config.Colors.md3.surface_container
                border.color: Config.Colors.md3.primary
            }

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 0

                Repeater {
                    model: root.displayForecast

                    Item {
                        width: parent.width / root.displayForecast.length
                        height: parent.height

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                text: modelData.time
                                color: Config.Colors.md3.on_surface
                                font.pixelSize: 20
                                font.bold: true
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Widgets.Icon {
                                    anchors.centerIn: parent

                                    name: modelData.iconName || "weather/cloudy"
                                    size: 48
                                    color: Config.Colors.md3.on_surface
                                    opacity: root.loading ? 0.35 : 1
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                text: modelData.tempC + "°C"
                                color: Config.Colors.md3.on_surface_variant
                                font.pixelSize: 18
                                opacity: root.loading ? 0.35 : 1
                            }

                            Row {
                                Layout.alignment: Qt.AlignHCenter

                                spacing: 2

                                Widgets.Icon {
                                    name: "weather/humidity"
                                    size: 18
                                    color: "#85c1dc"
                                    opacity: root.loading ? 0.35 : 1
                                }

                                Text {
                                    text: (modelData.humidity || "--") + "%"
                                    color: Config.Colors.md3.on_surface_variant
                                    font.pixelSize: 18
                                    opacity: root.loading ? 0.35 : 1
                                }
                            }
                        }

                        Rectangle {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right

                            width: 1
                            visible: index < root.displayForecast.length - 1
                            color: Config.Colors.md3.outline_variant
                        }
                    }
                }
            }
        }

        Item {
            id: updateSection

            width: parent.width - forecastSection.width - parent.spacing
            height: parent.height

            Rectangle {
                anchors.fill: parent
                radius: 16
                color: Config.Colors.md3.surface_container
                border.color: Config.Colors.md3.primary
            }

            Item {
                anchors.fill: parent
                anchors.margins: 8

                Column {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap

                        text: "Last updated at\n" + root.lastFetchTimeString

                        color: Config.Colors.md3.on_surface
                        font.pixelSize: 18
                        font.bold: true
                    }

                    Rectangle {
                        id: refreshButton

                        width: 40
                        height: 40
                        radius: width / 2

                        color: mouseArea.containsMouse ? Config.Colors.md3.surface_container_highest : Config.Colors.md3.surface_container

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }

                        Widgets.Icon {
                            id: refreshIcon

                            anchors.centerIn: parent

                            name: "common/refresh"
                            size: 28
                            color: Config.Colors.md3.primary

                            RotationAnimator {
                                target: refreshIcon
                                from: 0
                                to: -360
                                duration: 1000
                                loops: Animation.Infinite
                                running: Services.Weather.loading
                            }

                            Connections {
                                target: Services.Weather

                                function onLoadingChanged() {
                                    if (!Services.Weather.loading)
                                        refreshIcon.rotation = 0;
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea

                            anchors.fill: parent

                            hoverEnabled: true
                            cursorShape: Services.Weather.loading ? Qt.ArrowCursor : Qt.PointingHandCursor

                            onClicked: {
                                if (!Services.Weather.loading)
                                    Services.Weather.refresh();
                            }
                        }
                    }
                }
            }
        }
    }
}
