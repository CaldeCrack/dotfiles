import QtQuick
import qs.config
import qs.services

// Flat horizontal cava strip, meant to sit as a background layer rather
// than around the artwork. Same data source as AudioVisualizerRing, just
// different geometry — switching modes in CavaService.mode doesn't
// require touching the process/parsing layer at all, only which of these
// two components MusicTab shows.
Item {
    id: root

    property real barSpacing: 2
    property real maxBarHeight: 90
    property color barColor: Colors.md3.primary
    property real barOpacity: 0.6
    property real cornerRadius: 16

    // Animation state
    property var displayBars: []
    property var collapseFrom: []
    property real collapseProgress: 0
    property int collapseDuration: 800

    Canvas {
        id: canvas

        anchors.fill: parent

        Connections {
            target: Cava

            function onBarsChanged() {
                const newBars = Cava.bars;

                if (newBars.length === 0) {
                    if (root.displayBars.length > 0) {
                        root.collapseFrom = root.displayBars.slice();
                        root.collapseProgress = 0;

                        collapseTimer.startTime = Date.now();
                        collapseTimer.restart();
                    }
                } else {
                    // Cava produced new data, so stop any ongoing collapse.
                    collapseTimer.stop();
                    root.displayBars = newBars.slice();
                    canvas.requestPaint();
                }
            }
        }

        onPaint: {
            const ctx = getContext("2d");

            ctx.clearRect(0, 0, width, height);

            const bars = root.displayBars;
            const count = bars.length;

            if (count === 0)
                return;

            const barWidth = (width - (count - 1) * root.barSpacing) / count;

            // Clip the drawing to the canvas' rounded shape.
            const r = Math.min(root.cornerRadius, width / 2, height / 2);

            ctx.beginPath();
            ctx.moveTo(r, 0);
            ctx.lineTo(width - r, 0);
            ctx.arcTo(width, 0, width, r, r);
            ctx.lineTo(width, height - r);
            ctx.arcTo(width, height, width - r, height, r);
            ctx.lineTo(r, height);
            ctx.arcTo(0, height, 0, height - r, r);
            ctx.lineTo(0, r);
            ctx.arcTo(0, 0, r, 0, r);
            ctx.closePath();
            ctx.clip();

            ctx.fillStyle = root.barColor;
            ctx.globalAlpha = root.barOpacity;

            for (let i = 0; i < count; i++) {
                const level = bars[i];
                const barHeight = root.maxBarHeight * level;
                const x = i * (barWidth + root.barSpacing);
                const y = height - barHeight;

                ctx.fillRect(x, y, barWidth, barHeight);
            }
        }
    }

    Timer {
        id: collapseTimer

        interval: 16
        repeat: true

        property double startTime: 0

        onTriggered: {
            const elapsed = Date.now() - startTime;

            root.collapseProgress = Math.min(1, elapsed / root.collapseDuration);

            // Cubic ease-out:
            // starts quickly and gradually slows down near zero.
            const t = 1 - Math.pow(1 - root.collapseProgress, 3);

            root.displayBars = root.collapseFrom.map(level => level * (1 - t));

            canvas.requestPaint();

            if (root.collapseProgress >= 1) {
                stop();
                root.displayBars = [];
                canvas.requestPaint();
            }
        }
    }
}
