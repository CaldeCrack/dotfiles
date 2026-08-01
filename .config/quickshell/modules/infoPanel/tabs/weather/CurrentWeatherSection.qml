import QtQuick
import qs.widgets
import qs.config
import qs.services

// Left part of the Weather tab's top section — current conditions.
// Split left/right: the important stuff (icon, current temp, description,
// location) anchored left and given more space; secondary stats (feels
// like, humidity, wind) anchored right in a smaller column.
Item {
    id: root

    readonly property int columnSpacing: 16
    // Width fraction given to the left (important) column vs the right
    // (secondary stats) column.
    readonly property real columnProportion: 0.55

    readonly property var current: Weather.current
    readonly property bool loading: !current

    // Weather.current starts as an empty object before the first
    // fetch resolves, so every field access below is potentially
    // undefined — this formats a value defensively with a placeholder
    // rather than showing "undefined" or "NaN" during that window.
    function fmt(value, unit) {
        return (value === undefined || value === null || isNaN(value)) ? ("--" + unit) : (Math.round(value) + unit);
    }

    function windDir8(dir) {
        const map = {
            N: "N",
            NNE: "NE",
            NE: "NE",
            ENE: "NE",
            E: "E",
            ESE: "SE",
            SE: "SE",
            SSE: "SE",
            S: "S",
            SSW: "SW",
            SW: "SW",
            WSW: "SW",
            W: "W",
            WNW: "NW",
            NW: "NW",
            NNW: "NW"
        };

        return map[dir] || "--";
    }

    function windArrow(dir8) {
        switch (dir8) {
        case "N":
            return "↑";
        case "NE":
            return "↗";
        case "E":
            return "→";
        case "SE":
            return "↘";
        case "S":
            return "↓";
        case "SW":
            return "↙";
        case "W":
            return "←";
        case "NW":
            return "↖";
        default:
            return "•";
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Colors.md3.surface_container
        border.color: Colors.md3.primary
    }

    Row {
        id: contentRow

        anchors.fill: parent
        anchors.margins: 16
        spacing: root.columnSpacing

        readonly property real usableWidth: width - root.columnSpacing

        // ---- Left: icon + temp (big), description, location ---------------

        Item {
            id: leftColumn

            width: contentRow.usableWidth * root.columnProportion
            height: parent.height

            Row {
                id: mainRow

                anchors.top: parent.top
                anchors.left: parent.left
                spacing: 12

                Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    name: root.current.iconName || "weather/cloudy"
                    size: 48
                    color: Colors.md3.on_surface
                    opacity: loading ? 0.35 : 1
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        id: currTemp
                        text: root.fmt(root.current.tempC, "°C")
                        color: Colors.md3.on_surface
                        font.pixelSize: 40
                        font.bold: true
                    }

                    Text {
                        anchors.horizontalCenter: currTemp.horizontalCenter
                        text: root.fmt(root.current.maxTempC, "°") + " / " + root.fmt(root.current.minTempC, "°")
                        color: Colors.md3.on_surface_variant
                        font.pixelSize: 14
                    }
                }
            }

            Text {
                width: parent.width
                anchors {
                    top: mainRow.bottom
                    topMargin: 8
                    left: parent.left
                }
                text: root.current.description || ""
                color: Colors.md3.on_surface
                font.pixelSize: 16
                wrapMode: Text.WordWrap
            }

            Text {
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                }
                width: parent.width
                text: Weather.locationName
                color: Colors.md3.on_surface_variant
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }

        // ---- Right: feels like / humidity / wind (secondary stats) --------
        // Auto-sized and vertically centered as a block, rather than
        // stretched to the row's full height — Row only manages the x-axis
        // for its children, so anchors.verticalCenter here doesn't fight it.

        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: contentRow.usableWidth * (1 - root.columnProportion)
            spacing: 8

            Row {
                width: parent.width
                spacing: 6

                Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    name: "weather/thermometer"
                    size: 16
                    color: "#ea999c"
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.fmt(root.current.feelsLikeC, "°C feels")
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 14
                }
            }

            Row {
                width: parent.width
                spacing: 6

                Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    name: "weather/humidity"
                    size: 16
                    color: "#85c1dc"
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.fmt(root.current.humidity, "% humidity")
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 14
                }
            }

            Row {
                width: parent.width
                spacing: 6

                Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    name: "weather/wind"
                    size: 16
                    color: "#a6d189"
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.fmt(root.current.windSpeedKmph, " km/h wind")
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 14
                }
            }

            Row {
                width: parent.width
                spacing: 6

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.windArrow(root.windDir8(root.current.windDir))
                    color: Colors.md3.on_surface
                    font.pixelSize: 16
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.windDir8(root.current.windDir) + " wind direction"
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 14
                }
            }
        }
    }
}
