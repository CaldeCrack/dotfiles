import QtQuick
import Quickshell
import qs.config as Config

// Top-level bar window. Anchored to the top edge, sized/margined/rounded
// entirely from config. Buttons are declared here only as ordered id lists;
// ButtonRegistry.qml (shared by all three sections) resolves each id to its
// real component, or a placeholder pill if that component doesn't exist yet.
PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: Config.Settings.bar.margin
        left: Config.Settings.bar.margin
        right: Config.Settings.bar.margin
    }

    implicitHeight: Config.Settings.bar.height
    color: "transparent"

    // Reserve space for the bar itself plus the gap above it so other
    // windows/layer-shell surfaces don't slide underneath it.
    exclusiveZone: implicitHeight + Config.Settings.bar.margin

    // Ordered id lists — the only thing that needs to change to reorder,
    // add, or move a button between sections. Ids are resolved against
    // ButtonRegistry.componentMap by each section.
    readonly property var leftButtons: ["distro", "systemStats", "workspaces"]
    readonly property var middleButtons: ["about", "time"]
    readonly property var rightButtons: ["media", "tray", "controlPanel", "notifications", "power"]

    Rectangle {
        id: background
        anchors.fill: parent
        radius: Config.Settings.bar.radius
        color: Config.Colors.md3.surface_container
    }

    LeftSection {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        model: root.leftButtons
    }

    // A plain Item spanning the full bar width, purely so MiddleSection's
    // `parent.width` (used to compute its centerOn offset) is unambiguous:
    // the true full bar width, not whatever width MiddleSection's Row
    // happens to have itself. anchors.fill here is safe from the
    // horizontal-centering fight anchors.centerIn would otherwise cause,
    // since MiddleSection now positions its own `x` explicitly.
    Item {
        id: middleAnchor
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        MiddleSection {
            anchors.verticalCenter: parent.verticalCenter
            model: root.middleButtons
            // Set to the id of a button in middleButtons (e.g. "time") to
            // anchor the bar's true center on that button specifically,
            // rather than the row's overall midpoint. Leave empty to
            // center the row as a whole.
            centerOn: "about"
        }
    }

    RightSection {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        model: root.rightButtons
    }
}
