pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // "hyprland" | "i3" | "none" — decided once, at startup, since the
    // compositor doesn't change mid-session.
    property string backendType: "none"

    // Only relevant for the i3 backend: which CLI tool to shell out to.
    property string i3ToolCmd: ""

    Component.onCompleted: {
        if (Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")) {
            backendType = "hyprland";
        } else if (Quickshell.env("SWAYSOCK")) {
            backendType = "i3";
            i3ToolCmd = "swaymsg";
        } else if (Quickshell.env("I3SOCK")) {
            backendType = "i3";
            i3ToolCmd = "i3-msg";
        } else {
            console.warn("Workspaces: no supported window manager detected (checked Hyprland, Sway, i3) — workspace list will stay empty");
        }
    }

    readonly property string backendSource: {
        switch (backendType) {
        case "hyprland":
            return "workspaces/HyprlandBackend.qml";
        case "i3":
            return "workspaces/I3Backend.qml";
        default:
            return "";
        }
    }

    Loader {
        id: backendLoader
        source: root.backendSource ? Qt.resolvedUrl(root.backendSource) : ""

        onLoaded: {
            // Only the i3 backend needs this; harmless no-op otherwise.
            if (item.hasOwnProperty("toolCmd"))
                item.toolCmd = root.i3ToolCmd;

            // Backends that need to kick off processes after toolCmd is set
            // (rather than at their own Component.onCompleted, which would
            // fire before toolCmd is assigned) expose an explicit start().
            if (typeof item.start === "function")
                item.start();
        }
    }

    readonly property var workspaces: backendLoader.item ? backendLoader.item.workspaces : []
    readonly property int activeId: backendLoader.item ? backendLoader.item.activeId : -1

    function focus(id) {
        if (backendLoader.item)
            backendLoader.item.focus(id);
    }

    function windowsFor(id) {
        return backendLoader.item?.windowsFor?.(id) ?? [];
    }
}
