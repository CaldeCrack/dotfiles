import QtQuick

Item {
    id: root

    property alias text: label1.text
    property alias color: label1.color
    property alias font: label1.font

    property int gap: 48
    property real speed: 40 // pixels/sec
    property int pause: 1200

    implicitHeight: label1.implicitHeight
    clip: true

    readonly property bool overflowing: label1.implicitWidth > root.width

    Item {
        id: content

        x: 0
        height: parent.height

        Text {
            id: label1

            wrapMode: Text.NoWrap
            elide: Text.ElideNone
            clip: false
        }

        Text {
            id: label2
            anchors.verticalCenter: parent.verticalCenter
            x: label1.implicitWidth + root.gap
            text: label1.text
            color: label1.color
            font: label1.font
            visible: root.overflowing
        }

        width: root.overflowing ? label1.implicitWidth * 2 + root.gap : label1.implicitWidth
    }

    SequentialAnimation {
        id: marquee
        running: false
        loops: Animation.Infinite

        PauseAnimation {
            duration: root.pause
        }

        NumberAnimation {
            target: content
            property: "x"
            from: 0
            to: -(label1.contentWidth + root.gap)
            duration: ((label1.contentWidth + root.gap) / root.speed) * 1000
            easing.type: Easing.Linear
        }

        ScriptAction {
            script: content.x = 0
        }
    }

    onWidthChanged: {
        if (!overflowing)
            content.x = 0;
    }

    onOverflowingChanged: {
        content.x = 0;

        if (overflowing)
            marquee.restart();
        else
            marquee.stop();
    }

    onTextChanged: Qt.callLater(() => {
        content.x = 0;
        if (overflowing)
            marquee.restart();
    })
}
