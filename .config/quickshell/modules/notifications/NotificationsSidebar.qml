import QtQuick
import Quickshell
import qs.config
import qs.services
import qs.widgets

// The notification center. No title/header section by design — the
// footer (count, silent toggle, clear) is the only chrome; the body is
// either the empty state or the grouped history list.
PanelWindow {
    id: hostWindow

    anchors {
        top: true
        right: true
    }
    implicitHeight: 400
    exclusionMode: ExclusionMode.Ignore
    margins.top: Settings.bar.height
    color: "transparent"

    // SidebarBase's `closed` signal fires only after the close animation
    // finishes (per Widgets_reference.md), so visibility can't just be
    // `visible: Notifications.centerOpen` — that would cut the close
    // animation off instantly. Instead: show eagerly the moment centerOpen
    // flips true (so the open animation has something visible to animate
    // into), and only hide once the animation genuinely completes.
    visible: false
    Connections {
        target: Notifications
        function onCenterOpenChanged() {
            if (Notifications.centerOpen)
                hostWindow.visible = true;
        }
    }

    implicitWidth: sidebar.implicitWidth

    // Groups Notifications.history by appName, preserving first-seen order
    // — since history is newest-first, the group containing the most
    // recent notification naturally ends up first too.
    function _groupByApp(history) {
        const groups = [];
        const byName = {};
        for (const n of history) {
            if (!byName[n.appName]) {
                byName[n.appName] = {
                    appName: n.appName,
                    appIcon: n.appIcon,
                    notifications: []
                };
                groups.push(byName[n.appName]);
            }
            byName[n.appName].notifications.push(n);
        }
        return groups;
    }
    readonly property var _groups: hostWindow._groupByApp(Notifications.history)

    SidebarBase {
        id: sidebar
        anchors.fill: parent
        edge: Qt.RightEdge
        panelOpen: Notifications.centerOpen
        onClosed: hostWindow.visible = false

        Item {
            anchors.fill: parent

            // ---- body: empty state or grouped history ----
            Item {
                id: body
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: footer.top

                Column {
                    anchors.centerIn: parent
                    visible: Notifications.history.length === 0
                    spacing: 8

                    Icon {
                        name: "notifications/bell"
                        size: 40
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Colors.md3.outline
                    }

                    Text {
                        text: "Nothing to see here"
                        color: Colors.md3.on_surface_variant
                        font.pixelSize: 13
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                ListView {
                    id: groupList
                    anchors.fill: parent
                    anchors.margins: 4
                    visible: Notifications.history.length > 0
                    clip: true
                    spacing: 8

                    model: ScriptModel {
                        values: hostWindow._groups
                        objectProp: "appName"
                    }

                    delegate: NotificationGroup {
                        width: groupList.width
                    }
                }
            }

            // ---- footer: count (left), silent + clear (right) ----
            Item {
                id: footer
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                implicitHeight: contentRow.implicitHeight

                Rectangle {
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 8
                    width: parent.width
                    height: 1
                    color: Colors.md3.outline_variant
                }

                Text {
                    text: {
                        const n = Notifications.history.length;
                        return n + (n === 1 ? " notification" : " notifications");
                    }
                    color: Colors.md3.on_surface_variant
                    font.pixelSize: 12
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                }

                Row {
                    id: contentRow
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    FooterButton {
                        iconName: "notifications/zzz"
                        label: "Silent"
                        active: Notifications.silentMode
                        onClicked: Notifications.toggleSilent()
                    }

                    FooterButton {
                        iconName: "notifications/clear"
                        label: "Clear"
                        buttonEnabled: Notifications.history.length > 0
                        onClicked: Notifications.clearAll()
                    }
                }
            }
        }
    }

    // Small local component — just the pill-shaped icon+label footer
    // button, shared by Silent and Clear so the active/hover/disabled
    // styling only lives in one place.
    component FooterButton: Rectangle {
        id: btn

        property string iconName: ""
        property string label: ""
        property bool active: false
        property bool buttonEnabled: true
        signal clicked

        implicitWidth: contentRow.implicitWidth + 24
        implicitHeight: 24
        radius: 16
        opacity: buttonEnabled ? 1 : 0.5
        color: active ? Colors.md3.primary : (hoverArea.containsMouse ? Colors.md3.surface_container_high : "transparent")
        border.width: active ? 0 : 1
        border.color: Colors.md3.outline_variant

        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: 6

            Icon {
                name: btn.iconName
                size: 14
                color: btn.active ? Colors.md3.on_primary : Colors.md3.on_surface
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: btn.label
                font.pixelSize: 12
                color: btn.active ? Colors.md3.on_primary : Colors.md3.on_surface
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            enabled: btn.buttonEnabled
            cursorShape: btn.buttonEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: btn.clicked()
        }
    }
}
