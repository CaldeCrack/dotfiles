//@ pragma UseQApplication

import Quickshell
import qs.modules.bar
import qs.modules.notifications
import qs.modules.infoPanel
import qs.modules.osd

ShellRoot {
    id: shell

    Bar {}
    NotificationToasts {}
    NotificationsSidebar {}
    OsdWindow {}
    readonly property var _forceInfoPanelInit: InfoPanel
}
