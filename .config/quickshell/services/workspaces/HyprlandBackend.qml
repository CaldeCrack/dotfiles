import QtQml
import Quickshell.Hyprland

// Instantiated by services/Workspaces.qml's Loader — not a singleton itself,
// since a Loader needs to own the instance's lifetime.
QtObject {
    id: root

    // Sorted list of used workspaces
    readonly property var workspaces: {
        let ws = [];
        for (let i = 0; i < Hyprland.workspaces.values.length; ++i) {
            let workspace = Hyprland.workspaces.values[i];
            if (workspace.id >= 0)
                ws.push(workspace);
        }
        ws.sort((a, b) => a.id - b.id);
        return ws;
    }

    // Focused workspace of the focused monitor
    readonly property int activeId: Hyprland.focusedMonitor?.activeWorkspace?.id ?? -1

    function focus(id) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = " + id + " })");
    }

    // v1 preview data: [{ title, iconName }] for the windows on workspace `id`.
    // Hyprland already associates toplevels with their workspace, so no
    // matching against the generic Wayland toplevel manager is needed.
    function windowsFor(id) {
        const ws = root.workspaces.find(w => w.id === id);
        if (!ws)
            return [];

        let out = [];
        for (let i = 0; i < ws.toplevels.values.length; ++i) {
            const t = ws.toplevels.values[i];
            out.push({
                title: t.title,
                iconName: t.wayland?.appId ?? ""
            });
        }
        return out;
    }
}
