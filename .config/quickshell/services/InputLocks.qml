pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Caps Lock / Num Lock state via the kernel's input-LED sysfs nodes
// (/sys/class/leds/input*::capslock, .../numlock) rather than any
// compositor API. These reflect the actual keyboard LED state regardless
// of what changed it — the physical key, a script, anything — and work
// identically across compositors/display servers since they're a kernel
// input-subsystem interface, not a Wayland/X11 concept.
//
// Same "watch the resulting state, not the keypress" approach as
// Audio/Brightness: nothing here listens for the Caps/Num Lock keys
// themselves, so there's nothing to wire up compositor-side for this one
// at all.
//
// Assumption: picks whichever input*::capslock / input*::numlock node
// the startup glob finds first — same "pick the first match, revisit
// only if it matters" stance as Brightness.qml's backlight
// auto-detection. A genuinely multi-keyboard setup could have more than
// one such node; not handled here.
Singleton {
    id: root

    readonly property bool ready: _capsPath !== "" && _numPath !== "" && _scrollPath !== ""

    property string _capsPath: ""
    property string _numPath: ""
    property string _scrollPath: ""

    property bool capsLockOn: false
    property bool numLockOn: false
    property bool scrollLockOn: false

    Timer {
        interval: 100
        running: root.ready
        repeat: true

        onTriggered: {
            capsProcess.running = true;
            numProcess.running = true;
            scrollProcess.running = true;
        }
    }

    Process {
        id: capsProcess
        command: ["cat", root._capsPath]

        stdout: SplitParser {
            onRead: line => root.capsLockOn = line.trim() === "1"
        }
    }

    Process {
        id: numProcess
        command: ["cat", root._numPath]

        stdout: SplitParser {
            onRead: line => root.numLockOn = line.trim() === "1"
        }
    }

    Process {
        id: scrollProcess
        command: ["cat", root._scrollPath]

        stdout: SplitParser {
            onRead: line => root.scrollLockOn = line.trim() === "1"
        }
    }

    // One-shot path resolution at startup, same pattern as Brightness.qml's
    // device detection. Globbing (ls -d) rather than a fixed path since the
    // inputN number isn't predictable in advance — it depends on udev
    // enumeration order, and differs across machines/reboots.
    Process {
        running: true
        command: ["sh", "-c", "ls -d /sys/class/leds/*::capslock 2>/dev/null | head -n1"]
        stdout: SplitParser {
            onRead: line => {
                // The glob finds the LED's directory, not a readable file —
                // the actual state lives in a brightness attribute inside
                // it (0 or 1), same shape as backlight's own
                // /sys/class/backlight/<device>/brightness, just one
                // level deeper.
                if (line && !root._capsPath)
                    root._capsPath = line.trim() + "/brightness";
            }
        }
    }

    Process {
        running: true
        command: ["sh", "-c", "ls -d /sys/class/leds/*::numlock 2>/dev/null | head -n1"]
        stdout: SplitParser {
            onRead: line => {
                if (line && !root._numPath)
                    root._numPath = line.trim() + "/brightness";
            }
        }
    }

    Process {
        running: true
        command: ["sh", "-c", "ls -d /sys/class/leds/*::scrolllock 2>/dev/null | head -n1"]
        stdout: SplitParser {
            onRead: line => {
                if (line && !root._scrollPath)
                    root._scrollPath = line.trim() + "/brightness";
            }
        }
    }
}
