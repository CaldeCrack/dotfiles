pragma Singleton

import Quickshell
import Quickshell.Io

// KeybindsLoader
// --------------
// Reads config/keybinds.json and exposes it parsed as `categories`: a list
// of { category, shortcuts: [{ keybind, description }] } objects, in file
// order. keybinds.json is a top-level JSON array, not an object, so it
// can't bind through JsonAdapter the way config.json does in ConfigLoader —
// instead this reads the raw file text and JSON.parses it by hand.
// Read-only from the shell's side: this file is meant to be hand-edited,
// not written back like config.json is.
Singleton {
    id: root

    readonly property var categories: {
        if (!fileView.text()) {
            return [];
        }

        try {
            const parsed = JSON.parse(fileView.text());
            return Array.isArray(parsed) ? parsed : [];
        } catch (e) {
            console.warn("KeybindsLoader: failed to parse keybinds.json —", e);
            return [];
        }
    }

    FileView {
        id: fileView
        path: Qt.resolvedUrl("keybinds.json")
        watchChanges: true
        onFileChanged: reload()
    }
}
