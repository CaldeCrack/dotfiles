pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.config as Config
import qs.widgets as Widgets
import qs.services as Services

PanelWindow {
    id: root

    property bool panelOpen: false

    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore // popup, don't reserve screen space

    anchors {
        top: true
        left: true
    }
    margins.top: Config.Settings.bar.height // manually clear the bar, see Widgets_reference

    implicitWidth: panel.implicitWidth
    implicitHeight: panel.implicitHeight

    // Called by the owning bar button. Positions the popup under `item`
    // (computed once, on open — same one-shot convention as Tooltip).
    function openBelow(item) {
        // Maybe change in the future to center it rather than left align it
        // if (item) {
        //     const pos = item.mapToItem(null, 0, item.height)
        //     root.margins.left = pos.x
        // }
        root.visible = true;
        root.panelOpen = true;
    }

    function close() {
        root.panelOpen = false;
    }

    Widgets.PanelBase {
        id: panel
        panelOpen: root.panelOpen
        onClosed: root.visible = false

        // Memory is conventionally shown in binary GiB (matches free/htop),
        // disk capacity in decimal GB (matches how drives are marketed/df -H).
        // Kept here rather than in the service since "what's the normal unit"
        // is a display decision, not something SystemStats should bake in.
        function formatGiB(bytes) {
            return (bytes / (1024 * 1024 * 1024)).toFixed(1) + " GB";
        }

        function formatGB(bytes) {
            return (bytes / (1000 * 1000 * 1000)).toFixed(1) + " GB";
        }

        // VRAM total stays at 0 on integrated GPUs (no dedicated pool to
        // report) — show a dash instead of a nonsensical "0.0 GB".
        function formatVramTotal(bytes) {
            return bytes > 0 ? panel.formatGiB(bytes) : "—";
        }

        // 2x2 of the percentage-driven gauges. Battery/temperature will
        // sit alongside this as a vertical 2x1 block (different shape,
        // not a StatGauge) — not part of this pass.
        Grid {
            columns: 2
            rowSpacing: 8
            columnSpacing: 8

            Widgets.StatGauge {
                iconName: "cpu"
                percentage: Services.SystemStats.cpuUsage
                label: (Services.SystemStats.cpuMaxFrequencyMHz / 1000).toFixed(1) + " GHz\n" + Services.SystemStats.cpuCoreCount + " cores"
            }

            Widgets.StatGauge {
                iconName: "memory-stick"
                percentage: Services.SystemStats.memoryUsage
                label: panel.formatGiB(Services.SystemStats.memoryTotalBytes)
            }

            Widgets.StatGauge {
                iconName: "hard-drive"
                percentage: Services.SystemStats.diskUsage
                label: panel.formatGB(Services.SystemStats.diskTotalBytes)
            }

            Widgets.StatGauge {
                iconName: "gpu"
                percentage: Services.SystemStats.gpuUsage
                label: panel.formatVramTotal(Services.SystemStats.gpuTotalVramBytes)
            }
        }
    }
}
