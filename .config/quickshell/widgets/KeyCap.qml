import QtQuick

Item {
    id: root

    required property string key

    implicitWidth: Math.max(label.implicitWidth + 10, 22)
    implicitHeight: 22

    // Base (the part that sticks out)
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: parent.height
        radius: 6
        color: "#ffffff"
    }

    // Top face
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            bottomMargin: 2
        }

        radius: 6
        color: "#2f2f2f"
        border.color: "#ffffff"

        Text {
            id: label
            anchors.centerIn: parent

            text: KeyIcons.display(root.key)
            font.family: KeyIcons.isSpecial(root.key) ? "Symbols Nerd Font" : "Noto Sans Mono CJK TC"
            color: "#ffffff"
        }
    }
}
