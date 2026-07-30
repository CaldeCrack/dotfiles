pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets as Widgets
import qs.config as Config
import "tabs" as Tabs

// Singleton so there can only ever be one InfoPanel window in the shell —
// every bar button (wallpaper/media/time/weather/about) reaches this same
// instance via InfoPanel.show(tabIndex) instead of each owning its own
// popup. Import as `import qs.modules.infoPanel`, then call
// `InfoPanel.show(n)` directly — same pattern as Config.Colors/Config.Settings,
// no namespace prefix needed since this folder holds a single singleton type.
Singleton {
    id: root

    // ---- Public API -------------------------------------------------

    function show(tabIndex) {
        currentIndex = tabIndex;
        panelOpen = true;
    }

    function close() {
        panelOpen = false;
    }

    property bool panelOpen: false
    property int currentIndex: 0

    // ---- Fixed panel geometry ----------------------------------------
    // Deliberately constant, not content-derived — the panel shouldn't
    // resize as tabs change. Each tab is expected to fill this area.

    readonly property int panelWidth: 640
    readonly property int panelHeight: 420

    // ---- Tab model -----------------------------------------------------
    // Single source of truth for both the tab bar and which index maps to
    // which content. Add a tab by adding one entry here.

    readonly property var tabModel: [
        {
            label: "Wallpaper",
            icon: "common/wallpaper"
        },
        {
            label: "Media",
            icon: "common/music"
        },
        {
            label: "About",
            icon: "common/about"
        },
        {
            label: "Time",
            icon: "common/calendar"
        },
        {
            label: "Weather",
            icon: "weather/default"
        },
    ]

    // The actual window. DismissablePopup IS a window (a full-screen
    // PanelWindow under the hood, needed for outside-click detection +
    // exclusive keyboard focus for Escape) — it lives as a child of the
    // singleton rather than being the singleton's own root, since a
    // Singleton's root type can't be a window/popup itself.
    Widgets.DismissablePopup {
        id: popup

        open: root.panelOpen
        onDismissRequested: root.panelOpen = false

        // Screen-centered, using this window's own full-screen width/height.
        // To later position relative to the section a button lives in
        // (left/middle/right), swap this for a passed-in anchorX from
        // show(tabIndex, anchorX) and clamp it to keep the panel on-screen.
        contentX: (width - root.panelWidth) / 2 - 8
        contentY: Config.Settings.bar.height + Config.Settings.bar.margin

        // A real FocusScope, not just a plain Item — this is what makes
        // "Escape blurs the wallpaper search field, then Escape again
        // closes the panel" work. Per Qt Quick's FocusScope rules, when
        // the item currently holding active focus within a scope clears
        // its own focus (WallpaperSearchBar's TextInput does exactly this
        // on its first Escape), active focus reverts to the nearest
        // enclosing FocusScope — which, without this wrapper, was
        // undefined (InfoPanel had no explicit scope at all), so the
        // second Escape had nowhere reliable to land. Now it lands here.
        FocusScope {
            id: panelFocusScope

            width: root.panelWidth
            height: root.panelHeight
            focus: true

            Keys.onEscapePressed: root.close()

            ColumnLayout {
                id: panelContent

                anchors.fill: parent
                spacing: 0

                // ---- Tab bar -------------------------------------------------

                Item {
                    id: tabBar

                    Layout.fillWidth: true
                    Layout.preferredHeight: 60

                    Row {
                        id: tabRow
                        anchors.fill: parent

                        Repeater {
                            id: tabRepeater
                            model: root.tabModel

                            delegate: Item {
                                id: tabDelegate

                                required property var modelData
                                required property int index

                                width: tabRow.width / root.tabModel.length
                                height: tabRow.height

                                readonly property bool selected: index === root.currentIndex

                                // Subtle background tint on hover, independent
                                // of the selected-tab indicator below — margins
                                // keep it from touching neighboring tabs/edges.
                                Rectangle {
                                    anchors.fill: parent
                                    topLeftRadius: 16
                                    topRightRadius: 16
                                    color: tabMouse.containsMouse ? Config.Colors.md3.surface_container_high : "transparent"
                                }

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 5

                                    Widgets.Icon {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        name: tabDelegate.modelData.icon
                                        size: 22
                                        color: tabDelegate.selected ? Config.Colors.md3.primary : Config.Colors.md3.on_surface_variant
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: tabDelegate.modelData.label
                                        color: tabDelegate.selected ? Config.Colors.md3.primary : Config.Colors.md3.on_surface
                                        font.bold: tabDelegate.selected
                                        font.pixelSize: 14
                                    }
                                }

                                MouseArea {
                                    id: tabMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.currentIndex = tabDelegate.index
                                }
                            }
                        }
                    }

                    // Selected-tab indicator: thicker bar sitting just above
                    // the separator line. Tracks the delegate's real x/width
                    // (read off the Repeater, not the model) and slides
                    // between tabs.
                    Rectangle {
                        id: indicator

                        readonly property Item currentTab: tabRepeater.itemAt(root.currentIndex)

                        height: 3
                        radius: 1.5
                        color: Config.Colors.md3.primary
                        y: tabBar.height - height - 1 // 1px above the separator
                        x: currentTab ? currentTab.x : 0
                        width: currentTab ? currentTab.width : 0

                        Behavior on x {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }
                        Behavior on width {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    // Separator line between the tab bar and content.
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Config.Colors.md3.outline_variant
                    }
                }

                // ---- Content area ----------------------------------------------
                // Fixed size, clipped. Wallpaper + Media stay instantiated at all
                // times (visible toggling only) so their state never resets when
                // switching away. Time/Weather/About are behind Loaders and are
                // only instantiated once their tab is actually selected.

                Item {
                    id: contentArea

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 8
                    clip: true

                    Tabs.WallpaperTab {
                        anchors.fill: parent
                        visible: root.currentIndex === 0
                    }

                    Tabs.MediaTab {
                        anchors.fill: parent
                        visible: root.currentIndex === 1
                    }

                    Loader {
                        anchors.fill: parent
                        active: root.currentIndex === 2
                        visible: active
                        sourceComponent: Tabs.AboutTab {}
                    }

                    Loader {
                        anchors.fill: parent
                        active: root.currentIndex === 3
                        visible: active
                        sourceComponent: Tabs.TimeTab {}
                    }

                    Tabs.WeatherTab {
                        anchors.fill: parent
                        visible: root.currentIndex === 4
                    }
                }
            }
        }
    }
}
