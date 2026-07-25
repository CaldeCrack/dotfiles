import QtQuick
import qs.config as Config
import qs.widgets as Widgets
import qs.modules.shortcutsWindow as ShortcutsWindow

// ArchButton
// ----------
// Bar entry point for the keybind cheat sheet. Owns its ShortcutsWindow
// instance directly, the same "just nest it" pattern BarButtonBase itself
// uses for its Tooltip — nothing else needs to open this panel, so a
// shared singleton/service would just be indirection with no payoff.
Widgets.BarButtonBase {
    id: root

    tooltipText: "I use Arch btw"
    checked: shortcuts.visible
    onClicked: shortcuts.toggle()

    Text {
        text: "󰣇"
        font.bold: true
        font.pixelSize: root.height * 0.5
        color: Config.Colors.md3.on_surface
    }

    ShortcutsWindow.ShortcutsWindow {
        id: shortcuts
    }
}
