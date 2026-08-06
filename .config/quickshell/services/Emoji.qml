pragma Singleton

import Quickshell

// Emoji.entries / Emoji.searchQuery / Emoji.select(char) / Emoji.fetch() —
// see DataPicker.qml for what each does. Same DataPicker.qml is also the
// entire generic layer NerdFont.qml wraps for its own data.
DataPicker {
    dataPath: Quickshell.shellDir + "/assets/data/emojis.json"
    fetchScript: Quickshell.shellDir + "/services/scripts/fetch-emoji-data.sh"
    searchFields: ["name", "keywords", "category"]
}
