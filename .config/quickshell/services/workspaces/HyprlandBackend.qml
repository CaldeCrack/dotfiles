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

    // Freshens data that doesn't auto-update: lastIpcObject (used below for
    // last-focused-window lookup) only updates when explicitly refetched.
    // Called by the facade before the overlay reads representative windows.
    function refresh() {
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
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

    // The window to represent workspace `id` with (overlay thumbnail + icon
    // overlay) — the one that was actually last focused there, not just
    // whichever happens to be first in the toplevel list.
    //
    // `lastIpcObject.lastwindow` is a hex address for the workspace's last
    // focused window, per hyprctl's own JSON schema; matched against each
    // toplevel's own `address`. Falls back to the first toplevel if that
    // address is stale/unmatched (e.g. the window closed since the last
    // refresh()) rather than returning nothing.
    function _representativeToplevel(id) {
        const ws = root.workspaces.find(w => w.id === id);
        if (!ws || ws.toplevels.values.length === 0)
            return null;

        const lastAddr = ws.lastIpcObject?.lastwindow;
        if (lastAddr) {
            const match = ws.toplevels.values.find(t => t.address === lastAddr);
            if (match)
                return match;
        }
        return ws.toplevels.values[0];
    }

    function selectedWindowFor(id) {
        const t = root._representativeToplevel(id);
        return t ? {
            title: t.title,
            iconName: t.wayland?.appId ?? ""
        } : null;
    }

    // Toplevel handle for ScreencopyView.captureSource — works even for a
    // workspace not currently on screen, since hyprland-toplevel-export-v1
    // renders off-screen windows on request. null if the workspace has no
    // windows.
    function thumbnailSourceFor(id) {
        const t = root._representativeToplevel(id);
        return t ? t.wayland : null;
    }
}
