pragma Singleton

import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    // Sorted list of used workspaces — drives the Repeater
    readonly property var workspaces: {
        let ws = [];
        for (let i = 0; i < Hyprland.workspaces.values.length; ++i)
            ws.push(Hyprland.workspaces.values[i]);
        ws.sort((a, b) => a.id - b.id);
        return ws;
    }

    // Globally the same everywhere: focused workspace of the focused monitor
    readonly property int activeId: Hyprland.focusedMonitor?.activeWorkspace?.id ?? -1

    function focus(id) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = " + id + " })");
    }
}
