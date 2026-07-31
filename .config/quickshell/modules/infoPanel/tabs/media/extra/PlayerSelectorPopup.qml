import QtQuick
import qs.config as Config
import qs.services as Services
import qs.widgets as Widgets

// "Status" here means whether this entry is our own app-level selected
// player (Media.activePlayer) — not raw MPRIS playback state (playing/
// paused/stopped). That's what "active" actually refers to for the
// purpose of this list: which player our shell is currently reading
// metadata from and sending controls to.
Widgets.AnchoredPopup {
    id: root

    property real popupContentWidth: 240

    Column {
        width: root.popupContentWidth
        spacing: 4
        topPadding: 12
        bottomPadding: 8
        leftPadding: 12
        rightPadding: 12

        Text {
            width: parent.width - parent.leftPadding - parent.rightPadding
            text: "Players (" + Services.Media.players.values.length + ")"
            font.bold: true
            font.pixelSize: 13
            color: Config.Colors.md3.on_surface
            bottomPadding: 4
        }

        // Repeater over `.values` rather than the ObjectModel directly —
        // per Quickshell's own docs, indexing/iterating the ObjectModel
        // itself doesn't update reactively; `.values` is the documented
        // way to view it as a live-updating plain list.
        Repeater {
            model: Services.Media.players.values

            delegate: Item {
                id: entry
                required property var modelData

                width: root.popupContentWidth - 24 // account for Column's left/right padding
                height: 44

                readonly property bool isActive: modelData === Services.Media.activePlayer
                readonly property bool isMpd: modelData.dbusName === Services.Media.mpdBusName
                readonly property string resolvedIcon: Services.Media.resolveIconName(modelData.desktopEntry)

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: mouseArea.containsMouse ? Config.Colors.md3.surface_container_high : "transparent"
                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                // 1. Real resolved icon, when one was actually found —
                //    applies to any player, MPD included.
                Widgets.Icon {
                    id: resolvedPlayerIcon
                    anchors {
                        left: parent.left
                        leftMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    visible: entry.resolvedIcon.length > 0
                    systemIcon: entry.resolvedIcon
                    size: 22
                }

                // 2. MPD-specific bundled fallback — MPD isn't really a
                //    GUI app, so it's unlikely to have its own resolvable
                //    desktop-entry icon; media/music reads better than a
                //    generic fallback here.
                Widgets.Icon {
                    anchors {
                        left: parent.left
                        leftMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    visible: entry.isMpd && entry.resolvedIcon.length === 0
                    name: "media/music"
                    size: 22
                }

                // 3. Generic system fallback for any other player with
                //    nothing resolved — an unusual/incomplete .desktop
                //    file is more likely here than it not being a real
                //    app, so a generic app icon fits better than assuming
                //    it's music-related.
                Widgets.Icon {
                    id: genericFallbackIcon
                    anchors {
                        left: parent.left
                        leftMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    visible: !entry.isMpd && entry.resolvedIcon.length === 0
                    systemIcon: "application-x-executable"
                    size: 22
                }

                Column {
                    anchors {
                        left: resolvedPlayerIcon.right
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 1

                    Text {
                        width: parent.width
                        text: entry.modelData.identity || entry.modelData.dbusName
                        color: Config.Colors.md3.on_surface
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        text: entry.isActive ? "Active" : "Available"
                        color: entry.isActive ? Config.Colors.md3.primary : Config.Colors.md3.on_surface_variant
                        font.pixelSize: 11
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Services.Media.setActivePlayer(entry.modelData)
                }
            }
        }
    }
}
