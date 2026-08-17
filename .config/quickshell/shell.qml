//@ pragma UseQApplication

import Quickshell
import qs.modules.bar
import qs.modules.notifications
import qs.modules.infoPanel
import qs.modules.osd
import qs.modules.launcher

ShellRoot {
    id: shell

    Bar {}
    NotificationToasts {}
    NotificationsSidebar {}
    OsdWindow {}
    Launcher {}
    readonly property var _forceInfoPanelInit: InfoPanel
}
