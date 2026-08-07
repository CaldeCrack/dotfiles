pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.config
import "tabs"

// Singleton so there can only ever be one InfoPanel window in the shell —
// every bar button (wallpaper/media/time/weather/about) reaches this same
// instance via InfoPanel.show(tabIndex) instead of each owning its own
// popup. Import as `import qs.modules.infoPanel`, then call
// `InfoPanel.show(n)` directly — same pattern as Colors/Settings,
// no namespace prefix needed since this folder holds a single singleton type.
Singleton {
    id: root

    // ---- Public API -------------------------------------------------

    // Set by show() right before currentIndex changes, so contentArea's
    // transition handler can tell "this change came from a bar button"
    // apart from "the user clicked a different tab inside the already-open
    // panel" — only the latter should animate. Consumed (reset to false)
    // the moment it's read.
    property bool _suppressNextTransition: false

    function show(tabIndex) {
        if (tabIndex !== currentIndex)
            _suppressNextTransition = true;
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
    DismissablePopup {
        id: popup

        open: root.panelOpen
        onDismissRequested: root.panelOpen = false

        // Screen-centered, using this window's own full-screen width/height.
        // To later position relative to the section a button lives in
        // (left/middle/right), swap this for a passed-in anchorX from
        // show(tabIndex, anchorX) and clamp it to keep the panel on-screen.
        contentX: (width - root.panelWidth) / 2 - 8
        contentY: Settings.bar.height + Settings.bar.margin

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
                                    color: tabMouse.containsMouse ? Colors.md3.surface_container_high : "transparent"
                                }

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 5

                                    Icon {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        name: tabDelegate.modelData.icon
                                        size: 22
                                        color: tabDelegate.selected ? Colors.md3.primary : Colors.md3.on_surface_variant
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: tabDelegate.modelData.label
                                        color: tabDelegate.selected ? Colors.md3.primary : Colors.md3.on_surface
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
                        color: Colors.md3.primary
                        y: tabBar.height - height - 1 // 1px above the separator
                        x: currentTab ? currentTab.x : 0
                        width: currentTab ? currentTab.width : 0

                        function updateGeometry() {
                            const tab = tabRepeater.itemAt(root.currentIndex);
                            if (!tab)
                                return;
                            x = tab.x;
                            width = tab.width;
                        }

                        Component.onCompleted: Qt.callLater(updateGeometry)

                        Connections {
                            target: root
                            function onCurrentIndexChanged() {
                                indicator.updateGeometry();
                            }
                        }

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
                        color: Colors.md3.outline_variant
                    }
                }

                // ---- Content area ----------------------------------------------
                // Fixed size, clipped. All 5 tabs are real sibling items that
                // stay permanently visible: true — switching tabs slides them
                // via x rather than toggling visibility, since imperatively
                // touching .visible mid-animation would permanently break a
                // declarative `visible: root.currentIndex === n` binding (the
                // same one-way-binding rule noted elsewhere in this file, e.g.
                // DismissablePopup's `open`). clip: true on this Item is what
                // actually hides whichever tabs are currently parked
                // off-screen to either side.
                //
                // Wallpaper/Media/Weather stay instantiated at all times (an
                // empty activate()/deactivate() — they were already meant to
                // never reset). About/Time are still Loader-backed and only
                // instantiated while active, via their slot's activate()/
                // deactivate(), which now also gate the actual mount/unmount
                // instead of a currentIndex-driven binding.

                Item {
                    id: contentArea

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 8
                    clip: true

                    // previousIndex is deliberately NOT `property int
                    // previousIndex: root.currentIndex` — that would be a
                    // live binding, and QML re-evaluates dependent bindings
                    // as part of the same synchronous write that changes
                    // root.currentIndex, before this file's Connections
                    // handler below even runs. That meant reading
                    // previousIndex inside the handler already reflected
                    // the NEW index, so fromIndex === toIndex every time
                    // and animateTransition() silently no-op'd via its
                    // early return — content never moved off whatever
                    // slot was active at startup. Plain imperative
                    // assignment (set once in Component.onCompleted, then
                    // only ever updated at the end of the handler) avoids
                    // that entirely.
                    property int previousIndex: 0

                    function slotFor(index) {
                        switch (index) {
                        case 0:
                            return slotWallpaper;
                        case 1:
                            return slotMedia;
                        case 2:
                            return slotAbout;
                        case 3:
                            return slotTime;
                        case 4:
                            return slotWeather;
                        }
                        return null;
                    }

                    // Instantly places `index`'s slot at rest and parks
                    // every other slot off-screen, with no animation — used
                    // for the very first tab shown and for tabs opened via
                    // a bar button (see the suppress-flag handling below).
                    function snapToIndex(index) {
                        outgoingAnim.complete();
                        incomingAnim.complete();

                        for (let i = 0; i < root.tabModel.length; i++) {
                            const slot = slotFor(i);
                            if (!slot)
                                continue;
                            if (i === index) {
                                slot.x = 0;
                                slot.activate();
                            } else {
                                slot.x = width;
                                slot.deactivate();
                            }
                        }
                    }

                    function animateTransition(fromIndex, toIndex) {
                        if (fromIndex === toIndex)
                            return;

                        // Snap any in-flight transition to its resting state
                        // first (rather than leaving a stale target/position
                        // behind) — handles rapid tab clicking cleanly since
                        // this also runs each animation's onStopped cleanup
                        // synchronously before we reassign targets below.
                        outgoingAnim.complete();
                        incomingAnim.complete();

                        const direction = toIndex > fromIndex ? 1 : -1; // 1 = slide left (moving to a later tab), -1 = slide right
                        const outgoing = slotFor(fromIndex);
                        const incoming = slotFor(toIndex);
                        if (!outgoing || !incoming)
                            return;

                        incoming.activate();
                        incoming.x = direction * width;

                        outgoingAnim.target = outgoing;
                        outgoingAnim.from = 0;
                        outgoingAnim.to = -direction * width;

                        incomingAnim.target = incoming;
                        incomingAnim.from = direction * width;
                        incomingAnim.to = 0;

                        outgoingAnim.restart();
                        incomingAnim.restart();
                    }

                    Component.onCompleted: {
                        previousIndex = root.currentIndex;
                        snapToIndex(root.currentIndex);
                    }

                    Connections {
                        target: root
                        function onCurrentIndexChanged() {
                            if (root._suppressNextTransition) {
                                root._suppressNextTransition = false;
                                contentArea.snapToIndex(root.currentIndex);
                            } else {
                                contentArea.animateTransition(contentArea.previousIndex, root.currentIndex);
                            }
                            contentArea.previousIndex = root.currentIndex;
                        }
                    }

                    NumberAnimation {
                        id: outgoingAnim
                        property: "x"
                        duration: 220
                        easing.type: Easing.OutCubic
                        onStopped: if (target)
                            target.deactivate()
                    }

                    NumberAnimation {
                        id: incomingAnim
                        property: "x"
                        duration: 220
                        easing.type: Easing.OutCubic
                    }

                    Item {
                        id: slotWallpaper
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width

                        function activate() {
                        }
                        function deactivate() {
                        }

                        WallpaperTab {
                            anchors.fill: parent
                        }
                    }

                    Item {
                        id: slotMedia
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width

                        function activate() {
                        }
                        function deactivate() {
                        }

                        MediaTab {
                            anchors.fill: parent
                        }
                    }

                    Item {
                        id: slotAbout
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width

                        function activate() {
                            aboutLoader.active = true;
                        }
                        function deactivate() {
                            aboutLoader.active = false;
                        }

                        Loader {
                            id: aboutLoader
                            anchors.fill: parent
                            active: false
                            sourceComponent: AboutTab {}
                        }
                    }

                    Item {
                        id: slotTime
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width

                        function activate() {
                            timeLoader.active = true;
                        }
                        function deactivate() {
                            timeLoader.active = false;
                        }

                        Loader {
                            id: timeLoader
                            anchors.fill: parent
                            active: false
                            sourceComponent: TimeTab {}
                        }
                    }

                    Item {
                        id: slotWeather
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width

                        function activate() {
                        }
                        function deactivate() {
                        }

                        WeatherTab {
                            anchors.fill: parent
                        }
                    }
                }
            }
        }
    }
}
