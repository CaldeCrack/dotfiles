import QtQuick

Row {
    id: root

    required property var keys
    readonly property int keycapHeight: 20

    spacing: 3

    Repeater {
        model: root.keys.length

        delegate: Row {
            spacing: 3

            Item {
                visible: index === root.keys.length - 1 && root.keys.length > 1

                width: plus.implicitWidth
                height: root.keycapHeight

                Text {
                    id: plus
                    anchors.centerIn: parent
                    text: "+"
                    color: "#ffffff"
                }
            }

            KeyCap {
                key: root.keys[index]
            }
        }
    }
}
