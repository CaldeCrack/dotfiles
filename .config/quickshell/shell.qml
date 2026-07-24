import Quickshell
import qs.modules.bar as Bar
import qs.modules.infoPanel as InfoPanel

ShellRoot {
    id: shell

    Bar.Bar {}
    readonly property var _forceInfoPanelInit: InfoPanel
}
