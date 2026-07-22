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
            return bytes > 0 ? popup.formatGiB(bytes) : "—";
        }

        // Only celsius comes from SystemStats — fahrenheit/kelvin are pure
        // math, so they're derived here rather than the service tracking
        // three redundant copies of the same reading.
        function toFahrenheit(celsius) {
            return celsius * 9 / 5 + 32;
        }

        function toKelvin(celsius) {
            return celsius + 273.15;
        }

        // Gauge range for the thermometer fill — 0-100°C per the requested
        // min/max. Anything outside that still clamps visually (handled
        // inside Thermometer itself) rather than over/underflowing the tube.
        readonly property real tempMinCelsius: 0
        readonly property real tempMaxCelsius: 100

        function tempPercentage(celsius) {
            return (celsius - popup.tempMinCelsius) / (popup.tempMaxCelsius - popup.tempMinCelsius) * 100;
        }

        // Single shared size for every tile in the popup — both StatGauge
        // (square) and StatCardVertical (2x this height, same width) read
        // from this instead of each defaulting to its own implicit size, so
        // resizing the popup's tiles later is a one-line change here rather
        // than two components needing to independently agree on a number.
        readonly property real statCellSize: 100
        readonly property real statSpacing: 8

        Row {
            spacing: popup.statSpacing

            // Temperature.
            Widgets.StatCardVertical {
                width: popup.statCellSize
                height: popup.statCellSize * 2 + popup.statSpacing

                Item {
                    anchors.fill: parent
                    anchors.margins: 8

                    // Celsius (big, left) + fahrenheit/kelvin (small,
                    // grayed, right, stacked) — celsius reads as the
                    // primary/actual measurement, the other two as
                    // secondary conversions of it.
                    //
                    // Both children center on tempLabels' own vertical
                    // center rather than aligning to its top: celsius is a
                    // single line, so its own center IS that line; the F/K
                    // column is two lines, so centering the column places
                    // the gap between them at that same center line —
                    // that's what actually makes "the space between the
                    // two small labels sit at the middle of the big one",
                    // not a manually guessed margin.
                    //
                    // The Row itself sizes to its natural content width
                    // (no more parent.width * 0.55/0.45 stretch) and
                    // centers as a whole unit within the card, rather than
                    // pinning celsius to the left edge and F/K to the
                    // right edge.
                    Row {
                        id: tempLabels
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 6
                        // Needs a real height for verticalCenter anchoring
                        // below to have something to center against — Row
                        // would otherwise size itself from its tallest
                        // child, which is circular once that child is
                        // itself centering on the Row.
                        height: 40

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: Math.round(Services.SystemStats.temperature) + "°C"
                            color: Config.Colors.md3.primary
                            font.pixelSize: 20
                            font.bold: true
                        }

                        Column {
                            id: tempSecondaryColumn
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                id: fahrenheitLabel
                                text: Math.round(popup.toFahrenheit(Services.SystemStats.temperature)) + "°F"
                                color: Config.Colors.md3.on_surface
                                font.pixelSize: 10
                            }

                            Text {
                                id: kelvinLabel
                                text: Math.round(popup.toKelvin(Services.SystemStats.temperature)) + "K"
                                color: Config.Colors.md3.on_surface
                                font.pixelSize: 10
                            }
                        }
                    }

                    // Two thirds of this card's available vertical space,
                    // anchored to the bottom — the empty space above (not
                    // taken by tempLabels) is deliberate breathing room, not
                    // unclaimed layout.
                    Widgets.Thermometer {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        height: parent.height * 0.8
                        width: height
                        percentage: popup.tempPercentage(Services.SystemStats.temperature)
                    }
                }
            }

            // 2x2 of the percentage-driven gauges.
            Grid {
                columns: 2
                rowSpacing: popup.statSpacing
                columnSpacing: popup.statSpacing

                Widgets.StatGauge {
                    width: popup.statCellSize
                    height: popup.statCellSize
                    iconName: "cpu"
                    percentage: Services.SystemStats.cpuUsage
                    label: (Services.SystemStats.cpuMaxFrequencyMHz / 1000).toFixed(1) + " GHz\n" + Services.SystemStats.cpuCoreCount + " cores"
                }

                Widgets.StatGauge {
                    width: popup.statCellSize
                    height: popup.statCellSize
                    iconName: "memory-stick"
                    percentage: Services.SystemStats.memoryUsage
                    label: popup.formatGiB(Services.SystemStats.memoryTotalBytes)
                }

                Widgets.StatGauge {
                    width: popup.statCellSize
                    height: popup.statCellSize
                    iconName: "hard-drive"
                    percentage: Services.SystemStats.diskUsage
                    label: popup.formatGB(Services.SystemStats.diskTotalBytes)
                }

                Widgets.StatGauge {
                    width: popup.statCellSize
                    height: popup.statCellSize
                    iconName: "gpu"
                    percentage: Services.SystemStats.gpuUsage
                    label: popup.formatVramTotal(Services.SystemStats.gpuTotalVramBytes)
                }
            }

            // Battery — fill glyph plus a percentage label above it.
            Widgets.StatCardVertical {
                width: popup.statCellSize
                height: popup.statCellSize * 2 + popup.statSpacing

                Text {
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Math.round(Services.Battery.percentage) + "%"
                    color: Config.Colors.md3.primary
                    font.pixelSize: 32
                    font.bold: true
                }

                Widgets.BatteryIndicator {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    height: parent.height * 0.74
                    width: height
                    percentage: Services.Battery.percentage
                }
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
