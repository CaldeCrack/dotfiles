import QtQuick
import qs.config
import qs.widgets

// LauncherGridEntry
// -------------------
// Grid counterpart to LauncherEntry: same unified entry shape, same
// keys-presence branch for label-vs-Keybind, but centered layout and no
// room for an inline description — that goes into a Tooltip instead, per
// spec ("at least rofi displays a description for some apps").
//
// required modelData/index for the same reason as LauncherEntry: this is
// an externally-defined delegate root, and Qt 6's compiled delegate model
// only auto-injects these into a delegate that declares them itself.

Item {
    id: root

    required property var modelData
    required property int index

    readonly property var entryData: modelData
    readonly property bool selected: GridView.isCurrentItem
    // Tooltip requires its target to expose a `hovered` bool — this is
    // that, same contract BarButtonBase already satisfies for the bar.
    readonly property bool hovered: mouseArea.containsMouse

    signal activated

    implicitWidth: 96
    implicitHeight: 96

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: 16
        color: (root.selected || root.hovered) ? Colors.md3.secondary_container : "transparent"
    }

    Column {
        anchors.centerIn: parent
        spacing: 6
        width: parent.width - 12

        Loader {
            width: parent.width
            sourceComponent: root.entryData.icon.systemIcon ? systemIconComp : namedIconComp
        }

        Loader {
            width: parent.width
            sourceComponent: root.entryData.keys ? keybindLabelComp : textLabelComp
        }
    }

    Component {
        id: systemIconComp
        Item {
            width: parent ? parent.width : 32
            implicitHeight: icon.implicitHeight
            Icon {
                id: icon
                anchors.horizontalCenter: parent.horizontalCenter
                systemIcon: root.entryData.icon.systemIcon
                systemIconFallback: root.entryData.icon.systemIconFallback || "application-x-executable"
                size: 32
            }
        }
    }

    Component {
        id: namedIconComp
        Item {
            width: parent ? parent.width : 32
            implicitHeight: icon.implicitHeight
            Icon {
                id: icon
                anchors.horizontalCenter: parent.horizontalCenter
                name: root.entryData.icon.name || ""
                size: 32
            }
        }
    }

    Component {
        id: textLabelComp
        Text {
            width: parent ? parent.width : 0
            text: root.entryData.label || ""
            color: Colors.md3.on_surface
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            // Wrap across up to 2 lines rather than eliding to a single
            // truncated one — grid cells are narrow enough that eliding
            // cut off most app names to something unreadable. Still elide
            // (with "…") past 2 lines so a genuinely long name doesn't
            // blow out the fixed cell height.
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
        }
    }

    Component {
        id: keybindLabelComp
        Item {
            width: parent ? parent.width : 0
            implicitHeight: kb.implicitHeight
            Keybind {
                id: kb
                anchors.horizontalCenter: parent.horizontalCenter
                keys: root.entryData.keys
            }
        }
    }

    // Only instantiated when there's something to show — Tooltip is a
    // real PopupWindow with per-instance cost, not worth creating one for
    // every grid cell regardless of whether it'll ever be used.
    Loader {
        active: !!root.entryData.description
        sourceComponent: Tooltip {
            target: root
            text: root.entryData.description || ""
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.entryData.activatable !== false ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            if (root.entryData.activatable !== false) {
                root.activated();
            }
        }
    }
}
