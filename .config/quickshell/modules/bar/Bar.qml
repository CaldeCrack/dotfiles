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
    readonly property var leftButtons: ["arch", "systemStats", "workspaces"]
    readonly property var middleButtons: ["clock"]
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

    MiddleSection {
        // Centered on the bar as a whole, independent of how wide the left
        // and right sections end up being.
        anchors.centerIn: parent
        model: root.middleButtons
    }

    RightSection {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        model: root.rightButtons
    }
}
