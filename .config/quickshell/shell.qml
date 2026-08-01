import Quickshell
import qs.modules.bar
import qs.modules.infoPanel

ShellRoot {
    id: shell

    Bar {}
    readonly property var _forceInfoPanelInit: InfoPanel
}
