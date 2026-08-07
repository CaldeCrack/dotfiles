import qs.widgets
import qs.services

PickerGrid {
    source: NerdFont
    placeholderText: "Search glyphs..."
    // Swap for whatever Nerd Font family is actually installed — see the
    // note in services/NerdFont.qml about checking KeyIcons.qml/
    // Keybind.qml for the family string already used elsewhere in this
    // shell, so glyphs render consistently rather than a third divergent
    // way of doing the same substitution.
    fontFamily: "FiraCode"
}
