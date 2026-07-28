import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.config as Config
import qs.services as Services

// Left column of the Time tab — vertical clock section, filling the whole
// remaining space next to the calendar. Top: weekday + day number. Middle:
// a circular gauge showing the current hour's progress through the day,
// with hour/minute/second stacked in the center. Bottom: month + year.
Item {
    id: root

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Config.Colors.md3.surface_container
        border.color: Config.Colors.md3.primary
    }

    // Circular progress ring. Track + progress arcs, based on the
    // Shape/PathAngleArc pattern provided — startAngle/totalSweep default
    // to a full 360° ring starting at the top (12 o'clock), matching the
    // "clock" framing: progress travels all the way around once per day.
    component Gauge: Item {
        id: gauge

        property real percentage: 0 // 0-100
        property color trackColor: Config.Colors.md3.surface_container_highest
        property color progressColor: Config.Colors.md3.primary
        property real strokeWidth: 8
        property real startAngle: -80
        property real totalSweep: 340

        Shape {
            id: shape
            anchors.fill: parent
            anchors.margins: 4
            layer.enabled: true
            layer.samples: 4

            ShapePath {
                fillColor: "transparent"
                strokeColor: gauge.trackColor
                strokeWidth: gauge.strokeWidth
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    radiusX: shape.width / 2 - gauge.strokeWidth / 2
                    radiusY: shape.height / 2 - gauge.strokeWidth / 2
                    startAngle: gauge.startAngle
                    sweepAngle: gauge.totalSweep
                }
            }

            ShapePath {
                fillColor: "transparent"
                strokeColor: gauge.progressColor
                strokeWidth: gauge.strokeWidth
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    id: progressArc
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    radiusX: shape.width / 2 - gauge.strokeWidth / 2
                    radiusY: shape.height / 2 - gauge.strokeWidth / 2
                    startAngle: gauge.startAngle
                    sweepAngle: gauge.totalSweep * Math.max(0, Math.min(100, gauge.percentage)) / 100

                    Behavior on sweepAngle {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        // ---- Top: weekday + day number ------------------------------------

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 0

            Text {
                Layout.alignment: Qt.AlignHCenter
                // Full weekday name — formatted directly via Qt.formatDate
                // rather than Qt.locale().dayName(), which sidesteps the
                // classic Qt gotcha where QLocale's day index (1=Monday..
                // 7=Sunday) doesn't match JS Date.getDay() (0=Sunday..
                // 6=Saturday).
                text: Qt.formatDate(Services.Time.dateTime, "dddd")
                color: Config.Colors.md3.on_surface_variant
                font.pixelSize: 20
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Services.Time.dateTime.getDate()
                color: Config.Colors.md3.on_surface
                font.pixelSize: 30
                font.bold: true
            }
        }

        // ---- Middle: hour gauge with centered hour/min/sec -----------------

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Gauge {
                id: hourGauge

                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) - 8
                height: width

                percentage: ((Services.Time.dateTime.getHours() + Services.Time.dateTime.getMinutes() / 60) / 24) * 100
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: -18

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatTime(Services.Time.dateTime, "HH")
                    color: Config.Colors.md3.primary
                    font.pixelSize: 40
                    font.bold: true
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatTime(Services.Time.dateTime, "mm")
                    color: Config.Colors.md3.secondary
                    font.pixelSize: 40
                    font.bold: true
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatTime(Services.Time.dateTime, "ss")
                    color: Config.Colors.md3.on_surface_variant
                    font.pixelSize: 22
                    topPadding: 6
                }
            }
        }

        // ---- Bottom: month + year -------------------------------------------

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 0

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDate(Services.Time.dateTime, "MMMM")
                color: Config.Colors.md3.on_surface_variant
                font.pixelSize: 20
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Services.Time.dateTime.getFullYear()
                color: Config.Colors.md3.on_surface
                font.pixelSize: 30
                font.bold: true
            }
        }
    }
}
