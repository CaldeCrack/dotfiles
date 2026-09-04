//@ pragma UseQApplication

import Quickshell
import qs.modules.bar
import qs.modules.notifications
import qs.modules.infoPanel
import qs.modules.osd
import qs.modules.launcher
import qs.modules.workspaceSelector

ShellRoot {
    id: shell

    Bar {}
    NotificationToasts {}
    NotificationsSidebar {}
    OsdWindow {}
    Launcher {}
    WorkspaceOverlay {}
    readonly property var _forceInfoPanelInit: InfoPanel
}
