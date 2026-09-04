import QtQuick
import qs.widgets
import qs.services
import qs.config

BarButtonBase {
    id: root

    horizontalPadding: 4
    hoverOpacity: 0

    // Which workspace's segment is currently hovered, -1 for none. Owned
    // here (not per-segment) because the preview popup below is a single
    // shared instance, not one per segment.
    property int hoveredWsId: -1

    // This button has no single click target of its own — each segment
    // handles its own click — so leave onClicked/onRightClicked unset.

    Row {
        id: row
        spacing: 1

        Repeater {
            id: repeater
            model: Workspaces.workspaces

            delegate: Item {
                id: segment

                required property var modelData
                required property int index
                readonly property int wsId: modelData.id
                readonly property bool active: wsId === Workspaces.activeId
                readonly property bool hovered: hoverArea.containsMouse
                readonly property real activeWidthMultiplier: segment.active ? 1.6 : 1

                width: (Settings.bar.height - 8) * activeWidthMultiplier
                height: Settings.bar.height - 8

                Rectangle {
                    id: highlight
                    anchors.fill: parent
                    radius: height / 2
                    color: segment.active ? Colors.md3.primary : Colors.md3.on_surface
                    opacity: segment.active ? 1 : (segment.hovered ? 0.12 : 0)

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: segment.wsId
                    color: segment.active ? Colors.md3.on_primary : Colors.md3.on_surface
                    font.pixelSize: 12
                }

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Workspaces.focus(segment.wsId)

                    onEntered: {
                        previewDebounce.pendingWsId = segment.wsId;
                        previewDebounce.pendingTarget = segment;
                        previewDebounce.restart();
                    }
                    onExited: {
                        previewDebounce.stop();
                        // Only clear if this segment was the one showing —
                        // avoids a fast-moving cursor clobbering the next
                        // segment's just-set hoveredWsId.
                        if (root.hoveredWsId === segment.wsId)
                            root.hoveredWsId = -1;
                    }
                }
            }
        }
    }

    // Debounces the *appearing* edge only — moving across several segments
    // to reach one further along the pill shouldn't flicker a popup open
    // for each one passed over. Hiding (onExited above) is instant.
    Timer {
        id: previewDebounce
        interval: 200
        property int pendingWsId: -1
        property Item pendingTarget: null
        onTriggered: {
            root.hoveredWsId = pendingWsId;
            previewPopup.target = pendingTarget;
        }
    }

    PreviewPopup {
        id: previewPopup
        open: root.hoveredWsId !== -1

        Column {
            spacing: 4

            Repeater {
                model: root.hoveredWsId !== -1 ? Workspaces.windowsFor(root.hoveredWsId) : []

                delegate: Row {
                    required property var modelData
                    spacing: 6

                    Icon {
                        appId: modelData.iconName
                        systemIconFallback: "application-x-executable"
                        size: 16
                    }

                    MarqueeText {
                        text: modelData.title
                        color: Colors.md3.on_surface
                        font.pixelSize: 12
                        width: Math.min(implicitWidth, 220)
                    }
                }
            }
        }
    }
}
