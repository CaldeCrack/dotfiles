import QtQuick

import qs.widgets
import qs.services
import qs.config

BarButtonBase {
    id: root

    visible: Recording.recording
    checked: popup.open
    tooltipText: "Recording"

    onClicked: popup.open = !popup.open
    onRightClicked: Recording.stop()

    Icon {
        name: "media/record"
        size: root.height * 0.5
        color: Colors.md3.error
    }

    DismissablePopup {
        id: popup
        open: false
        onDismissRequested: popup.open = false
        target: root

        Column {
            spacing: 4
            leftPadding: 4
            rightPadding: 4
            topPadding: 4

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    const s = Recording.elapsedSeconds;
                    const pad = n => (n < 10 ? "0" : "") + n;
                    const h = Math.floor(s / 3600);
                    const m = Math.floor((s % 3600) / 60);
                    const sec = s % 60;
                    return pad(h) + ":" + pad(m) + ":" + pad(sec);
                }
                font.pixelSize: 16
                font.bold: true
                color: Colors.md3.on_surface
            }

            Rectangle {
                id: stopButton
                anchors.horizontalCenter: parent.horizontalCenter
                width: stopLabel.implicitWidth + 24
                height: stopLabel.implicitHeight + 12
                radius: height / 2
                color: stopArea.pressed ? Colors.md3.surface_container_highest : (stopArea.containsMouse ? Colors.md3.surface_container_high : Colors.md3.surface_container)

                Text {
                    id: stopLabel
                    anchors.centerIn: parent
                    text: "Stop"
                    color: Colors.md3.on_surface
                    font.bold: true
                }

                MouseArea {
                    id: stopArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Recording.stop();
                        popup.open = false;
                    }
                }
            }
        }
    }
}
