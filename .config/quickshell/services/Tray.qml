pragma Singleton

import Quickshell
import Quickshell.Services.SystemTray

Singleton {
    readonly property var items: SystemTray.items
    readonly property int count: SystemTray.items.values.length
}
