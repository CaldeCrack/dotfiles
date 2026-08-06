pragma Singleton

import Quickshell

// NerdFont.entries / NerdFont.searchQuery / NerdFont.select(char) /
// NerdFont.fetch() — see DataPicker.qml for what each does.
//
// Rendering these (not this file's concern, but worth flagging for
// whoever builds the view): glyph characters need font.family set to
// whatever Nerd Font is actually installed, or they render as tofu.
// KeyIcons.qml/Keybind.qml already do Nerd Font glyph substitution for
// keycaps elsewhere in this shell — check what font family string that
// uses so both stay consistent.
DataPicker {
    dataPath: Quickshell.shellDir + "/assets/data/nerdfont.json"
    fetchScript: Quickshell.shellDir + "/services/scripts/fetch-nerdfont-data.sh"
    searchFields: ["name", "code"]
}
