import QtQuick
import qs.config

// Small pill-shaped clickable label, used for the docs/github/website/etc
// links in DistroSection and ShellSection. Lives alongside them in about/
// so QML's directory-based auto-import (any neighboring file whose name
// starts with an uppercase letter) makes it usable without an explicit
// import — same convention as Colors.qml's nested singleton components.
Rectangle {
    id: chip

    property string label
    property string url

    implicitWidth: chipText.implicitWidth + 20
    implicitHeight: chipText.implicitHeight + 4
    radius: height / 2
    border.color: Colors.md3.primary
    color: chipMouse.containsMouse ? Colors.md3.secondary_container : Colors.md3.surface_container_high

    Text {
        id: chipText
        anchors.centerIn: parent
        text: chip.label
        color: Colors.md3.on_secondary_container
        font.pixelSize: 14
    }

    MouseArea {
        id: chipMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Qt.openUrlExternally(chip.url)
    }
}
