import QtQuick
import qs.config as Config
import qs.widgets as Widgets
import qs.services as Services

Widgets.BarButtonBase {
    id: root

    onClicked: root.checked ? close() : open(root)

    function open() {
        root.checked = true;
    }

    function close() {
        root.checked = false;
    }

    // Icon + hover-wrapper + tooltip, repeated per stat. Item/Icon have no
    // hover state of their own (the button's MouseArea covers the whole
    // button), so each one gets its own tiny hover-tracking wrapper —
    // same composite pattern as Widgets_reference.md.
    component StatIcon: Item {
        id: wrap
        required property string iconName
        required property real value
        property alias size: icon.size

        width: icon.size
        height: icon.size
        readonly property bool hovered: hoverArea.hovered

        Widgets.Icon {
            id: icon
            name: wrap.iconName
            size: 16
        }

        HoverHandler {
            id: hoverArea
        }

        Widgets.Tooltip {
            target: wrap
            anchorTarget: root
            text: Math.round(wrap.value) + "%"
        }
    }

    Widgets.DismissablePopup {
        id: popup

        open: root.checked
        onDismissRequested: root.checked = false

        contentX: root.x
        contentY: Config.Settings.bar.height

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
                label: popup.formatGiB(Services.SystemStats.memoryTotalBytes)
            }

            Widgets.StatGauge {
                iconName: "hard-drive"
                percentage: Services.SystemStats.diskUsage
                label: popup.formatGB(Services.SystemStats.diskTotalBytes)
            }

            Widgets.StatGauge {
                iconName: "gpu"
                percentage: Services.SystemStats.gpuUsage
                label: popup.formatVramTotal(Services.SystemStats.gpuTotalVramBytes)
            }
        }
    }

    Row {
        spacing: 6

        StatIcon {
            iconName: "cpu"
            value: Services.SystemStats.cpuUsage
        }

        StatIcon {
            iconName: "memory-stick"
            value: Services.SystemStats.memoryUsage
        }

        StatIcon {
            iconName: "hard-drive"
            value: Services.SystemStats.diskUsage
        }

        StatIcon {
            visible: Services.Battery.available
            iconName: Services.Battery.iconName
            value: Services.Battery.percentage
        }
    }
}
