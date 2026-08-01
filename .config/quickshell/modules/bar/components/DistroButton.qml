import QtQuick
import qs.config
import qs.widgets
import qs.modules.shortcutsWindow

// ArchButton
// ----------
// Bar entry point for the keybind cheat sheet. Owns its ShortcutsWindow
// instance directly, the same "just nest it" pattern BarButtonBase itself
// uses for its Tooltip — nothing else needs to open this panel, so a
// shared singleton/service would just be indirection with no payoff.
BarButtonBase {
    id: root

    tooltipText: "I use Arch btw"
    checked: shortcuts.visible
    onClicked: shortcuts.toggle()

    Text {
        text: "󰣇"
        font.bold: true
        font.pixelSize: root.height * 0.5
        color: Colors.md3.on_surface
    }

    ShortcutsWindow {
        id: shortcuts
    }
}
