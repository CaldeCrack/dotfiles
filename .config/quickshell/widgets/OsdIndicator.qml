import QtQuick
import qs.config

// OSD card — two layouts depending on `mode`:
//   "level"   — icon, percentage, and a rounded progress bar (volume,
//               brightness)
//   "boolean" — a label and a rounded bar that's primary-colored when
//               active, grayed out when not (caps lock, num lock)
//
// Purely a display — no MouseArea, no hover states, nothing clickable
// anywhere in this file. Matches "no interaction from the user from any
// OSD."
//
// Deliberately takes plain primitives rather than reaching into
// Audio/Brightness/InputLocks itself — same discipline as
// NotificationItem not knowing Notifications exists. The caller (in
// practice, Osd.current's payload — see Osd.qml) decides what the
// values are; this only decides how to lay them out.
//
// Usage:
//
//   // level mode — volume/brightness
//   OsdIndicator {
//       mode: "level"
//       iconName: Osd.current.iconName
//       value: Osd.current.value
//   }
//
//   // boolean mode — caps/num lock
//   OsdIndicator {
//       mode: "boolean"
//       label: Osd.current.label
//       active: Osd.current.active
//   }
Item {
    id: root

    property string mode: "level" // "level" | "boolean"

    // level mode
    property string iconName: ""
    property real value: 0 // 0-100

    // boolean mode
    property string label: ""
    property bool active: false

    property int cardWidth: 200

    readonly property int _padding: 12
    readonly property int _barHeight: 6

    implicitWidth: cardWidth
    implicitHeight: card.height
    // Plain Item doesn't bind width/height to implicit* automatically —
    // same fix as NotificationItem needed for the same reason.
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        id: card
        width: root.cardWidth
        implicitHeight: content.implicitHeight + root._padding * 2
        height: implicitHeight
        radius: 16
        color: Colors.md3.surface_container
        border.width: 1
        border.color: Colors.md3.outline_variant

        Column {
            id: content
            x: root._padding
            y: root._padding
            width: parent.width - root._padding * 2
            spacing: 10

            // ---- level: icon, percentage, and bar all on one line ----
            // Not a Row — the bar needs to fill whatever width is left
            // after the icon+percentage, and Row has no "fill remaining
            // space" concept without pulling in QtQuick.Layouts. Anchors
            // give the same effect directly.
            Item {
                id: levelLine
                visible: root.mode === "level"
                width: parent.width
                height: Math.max(levelIcon.height, percentText.implicitHeight, root._barHeight)

                Icon {
                    id: levelIcon
                    name: root.iconName
                    size: 20
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: percentText
                    text: Math.round(root.value) + "%"
                    color: Colors.md3.on_surface
                    font.pixelSize: 14
                    anchors.left: levelIcon.right
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    anchors.left: percentText.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: root._barHeight

                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: Colors.md3.surface_container_high
                    }

                    Rectangle {
                        width: parent.width * Math.max(0, Math.min(100, root.value)) / 100
                        height: parent.height
                        radius: height / 2
                        color: Colors.md3.primary
                    }
                }
            }

            // ---- boolean: label ----
            Row {
                visible: root.mode === "boolean"
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                Text {
                    text: root.label
                    color: Colors.md3.on_surface
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                }

                Icon {
                    name: root.active ? "common/lock" : "common/lock-open"
                    size: 16
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // ---- boolean: solid on/off state bar (not a fill level —
            // there's nothing to fill for a boolean, the whole bar just
            // switches color) ----
            Rectangle {
                visible: root.mode === "boolean"
                width: parent.width
                height: root._barHeight
                radius: height / 2
                color: root.active ? Colors.md3.primary : Colors.md3.surface_container_high
            }
        }
    }
}
