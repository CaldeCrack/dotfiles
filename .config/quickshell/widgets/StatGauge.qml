import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import qs.config

// Square stat tile: icon centered, a used/total label just below it, and a
// circular gauge wrapped around both. Used for the 4 detail cells inside
// SystemStatsPopup (cpu/memory/disk/gpu, temperature, battery, ...).
//
// The gauge itself only cares about `percentage` — callers are responsible
// for turning their own value/total pair into both that percentage and the
// `label` text, since formatting differs per stat (e.g. "4.2/16 GB" for
// memory vs "58°C" for temperature, which has no natural "total").
//
// `showPercentageInGap` only really makes sense when `percentage` IS the
// stat itself (cpu/memory/gpu/disk) — leave it off for anything else
// (e.g. temperature, battery) if those end up reusing this component.
Item {
    id: root

    required property string iconName
    required property real percentage // 0-100, drives the gauge sweep
    required property string label    // e.g. "4.2/16 GB", "42%", "58°C"

    property color backgroundColor: Colors.md3.surface_container
    property color borderColor: Colors.md3.primary
    property color trackColor: Colors.md3.surface_container_highest
    property color progressColor: Colors.md3.primary

    property real strokeWidth: 8
    property real iconSize: 28
    property real cornerRadius: 20
    property real percentageRadialOffset: 4
    property real pullInFactor: 0.92
    property bool showPercentageInGap: true

    readonly property bool hovered: hoverHandler.hovered

    // 270° gauge starting at 135° — leaves a 90° gap at the bottom rather
    // than a full ring, purely a style choice, change freely. The gap is
    // where showPercentageInGap places its text, see percentageLabel below.
    readonly property real startAngle: -20
    readonly property real totalSweep: 300

    implicitWidth: 100
    implicitHeight: 100

    HoverHandler {
        id: hoverHandler
    }

    // Card background — a different shade + a visible border so each tile
    // reads as distinct at a glance, separate from the popup behind it.
    Rectangle {
        id: background
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.backgroundColor
        border.width: 1
        border.color: root.borderColor
    }

    Shape {
        id: gauge
        anchors.fill: parent
        anchors.margins: 4
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            fillColor: "transparent"
            strokeColor: root.trackColor
            strokeWidth: root.strokeWidth
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: gauge.width / 2
                centerY: gauge.height / 2
                radiusX: gauge.width / 2 - root.strokeWidth / 2
                radiusY: gauge.height / 2 - root.strokeWidth / 2
                startAngle: root.startAngle
                sweepAngle: root.totalSweep
            }
        }

        ShapePath {
            fillColor: "transparent"
            strokeColor: root.progressColor
            strokeWidth: root.strokeWidth
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                id: progressArc
                centerX: gauge.width / 2
                centerY: gauge.height / 2
                radiusX: gauge.width / 2 - root.strokeWidth / 2
                radiusY: gauge.height / 2 - root.strokeWidth / 2
                startAngle: root.startAngle
                sweepAngle: root.totalSweep * Math.max(0, Math.min(100, root.percentage)) / 100

                Behavior on sweepAngle {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 4

        Icon {
            anchors.horizontalCenter: parent.horizontalCenter
            name: root.iconName
            size: root.iconSize
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text: root.label
            color: Colors.md3.on_surface
            font.pixelSize: 12
        }
    }

    // Sits in the ring's opening. The gap is whatever's left over after the
    // track (startAngle → startAngle+totalSweep), so its middle is just
    // startAngle + totalSweep/2 — this is the actual angle math rather than
    // an assumption that the gap is at the bottom. PathAngleArc's angle
    // convention is 0°=right, increasing clockwise (since the coordinate
    // system is y-down), which is exactly standard x = cx + r·cos(θ),
    // y = cy + r·sin(θ) — no sign flipping needed.
    Text {
        id: percentageLabel
        visible: root.showPercentageInGap
        text: Math.round(root.percentage) + "%"
        color: root.progressColor
        font.pixelSize: 14
        font.bold: true
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        readonly property real gapMidAngleDeg: root.startAngle - (360 - root.totalSweep) / 2 + root.percentageRadialOffset
        readonly property real gapMidAngleRad: gapMidAngleDeg * Math.PI / 180
        // Same radius as the ring itself (not the icon/label in the center)
        // so the label sits right in the opening, not floating elsewhere.
        readonly property real ringRadius: (root.width / 2 - root.strokeWidth / 2) * root.pullInFactor

        x: root.width / 2 + ringRadius * Math.cos(gapMidAngleRad) - width / 2
        y: root.height / 2 + ringRadius * Math.sin(gapMidAngleRad) - height / 2
    }
}
