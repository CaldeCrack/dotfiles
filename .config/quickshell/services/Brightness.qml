pragma Singleton

import Quickshell
import Quickshell.Io

// Thin wrapper around laptop-panel backlight control. Reads live state
// via sysfs (FileView + watchChanges, same pattern Colors.qml uses for
// the matugen output) so external changes — hardware brightness keys,
// another client, whatever — show up here too, not just changes made
// through this shell's own slider. Writes go through brightnessctl
// rather than writing sysfs directly, since it already handles the
// permissions/udev-rule side of this correctly.
//
// Assumption: a single backlight device (typical laptop panel). If you
// have more than one (e.g. dual-GPU), set `device` explicitly to
// override the auto-detected one — auto-detection just grabs the first
// entry under /sys/class/backlight.
Singleton {
    id: root

    property string device: ""

    readonly property int max: parseInt(maxFile.text()) || 0
    readonly property int current: parseInt(currentFile.text()) || 0
    readonly property real brightness: max > 0 ? (current / max) * 100 : 0
    readonly property bool ready: device !== "" && max > 0

    FileView {
        id: maxFile
        path: root.device ? `/sys/class/backlight/${root.device}/max_brightness` : ""
    }

    FileView {
        id: currentFile
        path: root.device ? `/sys/class/backlight/${root.device}/brightness` : ""
        watchChanges: true
        onFileChanged: reload()
    }

    // One-shot device detection at startup — grabs whatever
    // /sys/class/backlight lists first. Only runs while `device` is
    // still unset, so an explicit override placed before this fires
    // (or a manual reassignment later) always wins.
    Process {
        running: true
        command: ["sh", "-c", "ls /sys/class/backlight | head -n1"]
        stdout: SplitParser {
            onRead: line => {
                if (line && !root.device)
                    root.device = line.trim();
            }
        }
    }

    function setBrightness(percent) {
        if (!ready)
            return;
        const clamped = Math.max(0, Math.min(100, percent));
        Quickshell.execDetached(["brightnessctl", "set", `${Math.round(clamped)}%`]);
    }
}
