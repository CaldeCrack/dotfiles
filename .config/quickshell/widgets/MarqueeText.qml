import QtQuick

Item {
    id: root

    property alias text: label1.text
    property alias color: label1.color
    property alias font: label1.font
    property alias verticalAlignment: label1.verticalAlignment
    property alias horizontalAlignment: label1.horizontalAlignment
    property alias lineHeight: label1.lineHeight
    property alias lineHeightMode: label1.lineHeightMode

    property int gap: 48
    property real speed: 40 // pixels/sec
    property int pause: 1200

    implicitHeight: label1.implicitHeight
    clip: true

    readonly property bool overflowing: label1.contentWidth > root.width

    Item {
        id: content

        x: 0
        height: parent.height

        Text {
            id: label1
            anchors.verticalCenter: parent.verticalCenter

            wrapMode: Text.NoWrap
            elide: Text.ElideNone
            clip: false
        }

        Text {
            id: label2
            anchors.verticalCenter: parent.verticalCenter
            x: label1.contentWidth + root.gap
            text: label1.text
            color: label1.color
            font: label1.font

            lineHeight: label1.lineHeight
            lineHeightMode: label1.lineHeightMode
            horizontalAlignment: label1.horizontalAlignment
            verticalAlignment: label1.verticalAlignment

            visible: root.overflowing
        }

        width: root.overflowing ? label1.contentWidth * 2 + root.gap : label1.contentWidth
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
