import Quickshell.Io

import qs.widgets
import qs.modules.powerMenu

// Bar entry point for the power menu. Owns its PowerOverlay instance
// directly, same self-contained wiring as ControlPanelButton owning its
// sidebar — the button doesn't need to reach out anywhere else to find it.
BarButtonBase {
    id: root

    checked: overlay.overlayOpen
    tooltipText: "Power menu"

    onClicked: overlay.toggle()

    IpcHandler {
        target: "power"

        function toggle(): void {
            overlay.toggle();
        }
    }

    Icon {
        name: "power/shutdown"
        size: 16
    }

    PowerOverlay {
        id: overlay
    }
}
