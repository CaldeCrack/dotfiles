import QtQuick
import qs.config
import qs.widgets

// LauncherEntry
// --------------
// List-view delegate for the unified entry model. Grid mode (step 4) will
// reuse this same entry shape but needs its own delegate — icon+label
// centered, description moved into a Tooltip instead of an inline
// subtitle — rather than trying to make one delegate serve both layouts.
//
// `entryData.keys` presence is the only branch this component makes:
// keybind entries (step 7) render a Keybind where the label would go,
// everything else renders plain Text. Apps never set `keys`.

Item {
    id: root

    // Declared here, not just referenced from the ListView delegate block
    // in LauncherResults.qml — in Qt 6's compiled delegate model,
    // modelData/index are only auto-injected into a delegate that
    // declares them as `required property` on its own root. LauncherEntry
    // lives in its own file and IS that delegate root, so it has to
    // declare these itself; declaring them one file over (in the inline
    // `LauncherEntry { entryData: modelData }` block) doesn't count and
    // throws "modelData is not defined".
    required property var modelData
    required property int index

    readonly property var entryData: modelData
    // ListView.isCurrentItem, not a manually-passed `selected` prop —
    // that's the standard QML attached property every delegate gets from
    // its view for free, and it sidesteps needing `index` to leak in from
    // the delegate wrapper (see the modelData/index note above).
    readonly property bool selected: ListView.isCurrentItem

    signal activated()

    implicitHeight: 52

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: (root.selected || mouseArea.containsMouse)
            ? Colors.md3.secondary_container
            : "transparent"
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10

        // Icon.qml wants exactly one of name/systemIcon set — using a
        // Loader to pick the right delegate keeps each Icon instance from
        // ever having both bound at once, rather than trying to make one
        // Icon instance conditionally "unset" a property.
        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: root.entryData.icon.systemIcon ? systemIconComp : namedIconComp
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            width: parent.width - 28 - 10 - 10

            Loader {
                width: parent.width
                sourceComponent: root.entryData.keys ? keybindLabelComp : textLabelComp
            }

            Text {
                width: parent.width
                visible: !!root.entryData.description
                text: root.entryData.description || ""
                color: Colors.md3.on_surface_variant
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }
    }

    Component {
        id: systemIconComp
        Icon {
            systemIcon: root.entryData.icon.systemIcon
            systemIconFallback: root.entryData.icon.systemIconFallback || "application-x-executable"
            size: 28
        }
    }

    Component {
        id: namedIconComp
        Icon {
            name: root.entryData.icon.name || ""
            size: 28
        }
    }

    Component {
        id: textLabelComp
        Text {
            text: root.entryData.label || ""
            color: Colors.md3.on_surface
            font.pixelSize: 14
            elide: Text.ElideRight
        }
    }

    Component {
        id: keybindLabelComp
        Keybind {
            keys: root.entryData.keys
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
