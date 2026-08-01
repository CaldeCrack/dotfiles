pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

// No UI — scans the configured wallpaper directory and exposes the current
// wallpaper (sourced from Colors.qml/matugen). Applying a new one shells
// out to scripts/apply-wallpaper.sh; matugen regen + hyprpaper happen
// there, not here — this singleton just triggers it and gets out of the
// way. Colors.qml's own FileView watch picks up the resulting colors.json
// change on its own, so no signal/callback is needed from applyWallpaper().
Singleton {
    id: root

    readonly property string directory: Settings.general.wallpaperDir.replace("~", Quickshell.env("HOME"))
    readonly property string scriptPath: "~/.local/share/scripts/bg_carousel/bg_carousel.sh".replace("~", Quickshell.env("HOME"))
    readonly property string currentWallpaper: Colors.wallpaper

    // Plain absolute paths, no "file://" prefix — kept consistent with
    // whatever Colors.wallpaper contains so equality checks (selection vs
    // current) just work. Views that need to render these (WallpaperGrid)
    // are responsible for prefixing "file://" themselves for Image.source.
    property var wallpapers: []
    readonly property int count: wallpapers.length

    Component.onCompleted: refresh()
    onDirectoryChanged: refresh()

    // FolderListModel turned out to be the wrong tool here — it's meant to
    // be read by a view's delegate (model.fileURL inside a GridView
    // delegate), not flattened into a plain JS array via get(index, role);
    // that method isn't actually part of its API, which is why it silently
    // returned undefined instead of erroring. Shelling out to `find`
    // sidesteps that entirely. No live fs-watching this way, but there's
    // already a manual refresh() hookup from the UI's "Refresh" button, so
    // nothing is lost.
    function refresh() {
        scanProcess.running = false;
        scanProcess.running = true;
    }

    Process {
        id: scanProcess
        // Passed as discrete argv entries (no shell in between), so no
        // quoting/escaping to worry about even if the directory has spaces
        // — "(" / "-o" / ")" are just literal tokens find understands.
        command: ["find", root.directory, "-maxdepth", "1", "-type", "f", "(", "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", "-o", "-iname", "*.webp", "-o", "-iname", "*.bmp", ")"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                root.wallpapers = text.split("\n").map(line => line.trim()).filter(line => line.length > 0).sort();
            }
        }
    }

    function openFolder() {
        Quickshell.execDetached(["xdg-open", root.directory]);
    }

    function applyWallpaper(path) {
        if (!path)
            return;
        Quickshell.execDetached(["bash", root.scriptPath, "-w", path, "-d", root.directory]);
    }
}
