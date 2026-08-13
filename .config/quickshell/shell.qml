//@ pragma UseQApplication

import Quickshell
import qs.modules.bar
import qs.modules.notifications
import qs.modules.infoPanel

ShellRoot {
    id: shell

    Bar {}
    NotificationToasts {}
    readonly property var _forceInfoPanelInit: InfoPanel
}
