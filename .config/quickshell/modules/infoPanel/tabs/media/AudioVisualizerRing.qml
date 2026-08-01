import QtQuick
import qs.config
import qs.services

// Radial cava visualizer — draws CavaService.bars as line segments
// arranged in a ring. innerRadius is a plain property, not something this
// component derives on its own — the caller (MusicTab) is expected to set
// it just outside ArtworkVisualizer's own outline ring, so this component
// doesn't need to know anything about artwork sizing to stay correctly
// positioned around it.
//
// Canvas rather than a Repeater of Items: with barCount (32, see
// CavaService) segments potentially redrawing on every cava frame (up to
// `framerate` in cava.conf), a single imperative repaint is cheaper than
// 32 separate QML items each re-evaluating bindings every frame. Different
// tradeoff than the seekbar's wave, which only ever draws one continuous
// path, not many independent segments.
Item {
    id: root

    property real innerRadius: 90
    property real maxBarLength: 45
    property real barWidth: 8
    property color barColor: Colors.md3.primary

    // Animation state
    property var displayBars: []
    property var collapseFrom: []
    property real collapseProgress: 0
    property int collapseDuration: 800

    implicitWidth: (innerRadius + maxBarLength) * 2
    implicitHeight: parent.height

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

            const cx = width / 2;
            const cy = height / 2;
            const angleStep = (2 * Math.PI) / count;

            ctx.strokeStyle = root.barColor;
            ctx.lineWidth = root.barWidth;
            ctx.lineCap = "round";

            for (let i = 0; i < count; i++) {
                const level = bars[i];
                const angle = i * angleStep - Math.PI / 2;
                const barLength = root.maxBarLength * level;

                const x1 = cx + Math.cos(angle) * root.innerRadius;
                const y1 = cy + Math.sin(angle) * root.innerRadius;
                const x2 = cx + Math.cos(angle) * (root.innerRadius + barLength);
                const y2 = cy + Math.sin(angle) * (root.innerRadius + barLength);

                ctx.beginPath();
                ctx.moveTo(x1, y1);
                ctx.lineTo(x2, y2);
                ctx.stroke();
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
