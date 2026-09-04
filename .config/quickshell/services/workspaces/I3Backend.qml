import QtQml
import Quickshell.Io

// Shared by both i3 and sway, since sway implements the i3 IPC protocol.
// The facade sets toolCmd ("i3-msg" or "swaymsg") right after loading this,
// then calls start() — process children are NOT auto-run at declaration,
// because that would fire with the default toolCmd before the facade has
// had a chance to set the real one.
QtObject {
    id: root

    property string toolCmd: "i3-msg"

    property var workspaces: []
    property int activeId: -1

    // { workspaceId: [{ title, iconName }] } — populated from get_tree.
    property var _windowsByWorkspace: ({})

    function start() {
        refresh();
        subscribeProcess.running = true;
    }

    function refresh() {
        queryProcess.running = true;
        treeProcess.running = true;
    }

    // v1 preview data: [{ title, iconName }] for the windows on workspace `id`.
    function windowsFor(id) {
        return root._windowsByWorkspace[id] ?? [];
    }

    function focus(id) {
        focusProcess.command = [root.toolCmd, "workspace", "number", String(id)];
        focusProcess.running = true;
    }

    function _applyWorkspaces(jsonText) {
        let data;
        try {
            data = JSON.parse(jsonText);
        } catch (e) {
            console.warn("Workspaces(i3): failed to parse get_workspaces output:", e);
            return;
        }

        let ws = [];
        for (const w of data) {
            // "num" is -1 for name-only workspaces (e.g. a workspace named
            // "www" with no leading number) — same filter idea as the
            // Hyprland backend's `id >= 0`.
            if (w.num >= 0)
                ws.push({
                    id: w.num,
                    name: w.name,
                    focused: w.focused,
                    urgent: w.urgent
                });
        }
        ws.sort((a, b) => a.id - b.id);
        root.workspaces = ws;

        const active = ws.find(w => w.focused);
        root.activeId = active ? active.id : -1;
    }

    // Recursively collects every window (native Wayland or XWayland) nested
    // under a node — windows can sit behind splits/tabs/stacks, not just as
    // direct children, so this walks the whole subtree rather than one level.
    function _collectWindows(node, out) {
        const kids = (node.nodes ?? []).concat(node.floating_nodes ?? []);
        for (const child of kids) {
            const iconName = child.app_id ?? child.window_properties?.class ?? "";
            const isWindow = !!iconName || child.window !== undefined;
            if (isWindow)
                out.push({
                    title: child.name ?? "",
                    iconName: iconName
                });

            root._collectWindows(child, out);
        }
    }

    function _applyTree(jsonText) {
        let data;
        try {
            data = JSON.parse(jsonText);
        } catch (e) {
            console.warn("Workspaces(i3): failed to parse get_tree output:", e);
            return;
        }

        let map = {};

        // Scratchpad and any other negative-id workspace are deliberately
        // excluded — same filter as the button list itself, so preview data
        // never exists for a workspace the bar doesn't show.
        function walk(node) {
            const kids = (node.nodes ?? []).concat(node.floating_nodes ?? []);
            for (const child of kids) {
                if (child.type === "workspace") {
                    if (child.num >= 0) {
                        let windows = [];
                        root._collectWindows(child, windows);
                        map[child.num] = windows;
                    }
                } else {
                    walk(child);
                }
            }
        }
        walk(data);

        root._windowsByWorkspace = map;
    }

    // One-shot: current workspace list/state
    property Process queryProcess: Process {
        command: [root.toolCmd, "-t", "get_workspaces"]
        stdout: StdioCollector {
            onStreamFinished: root._applyWorkspaces(this.text)
        }
    }

    // One-shot: window tree, used to derive per-workspace window lists
    property Process treeProcess: Process {
        command: [root.toolCmd, "-t", "get_tree"]
        stdout: StdioCollector {
            onStreamFinished: root._applyTree(this.text)
        }
    }

    // Long-lived: fires on every workspace change (focus, create, destroy,
    // rename, move) AND every window change (open, close, move between
    // workspaces) — windowsFor() depends on the latter too, not just the
    // workspace list. The event payload itself isn't parsed — any event on
    // either channel means state may have changed, so just re-query for the
    // full current state rather than trying to apply a partial diff.
    property Process subscribeProcess: Process {
        command: [root.toolCmd, "-m", "-t", "subscribe", "[\"workspace\", \"window\"]"]
        stdout: SplitParser {
            onRead: data => root.refresh()
        }
    }

    // Command is set per-call in focus(); not run at declaration.
    property Process focusProcess: Process {}
}
