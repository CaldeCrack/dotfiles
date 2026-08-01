import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.widgets
import qs.config

// Left section of the About tab: circular profile picture, username,
// uptime, and window manager. Fills whatever size AboutTab gives it.
Item {
    id: root

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Colors.md3.surface_container
        border.color: Colors.md3.primary
    }

    // ---- Uptime (`uptime -p`) -------------------------------------------
    // Runs once per instantiation — this component is destroyed/recreated
    // each time the About tab is left/reopened, since InfoPanel loads it
    // behind a Loader tied to the selected tab.

    property string uptimeText: "…"

    Process {
        id: uptimeProc
        command: ["uptime", "-p"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.uptimeText = text.trim()
        }
    }

    // ---- Profile picture path ---------------------------------------------
    // User-defined path from config (e.g. "~/.face" or an absolute path).
    // Image.source needs a proper file:// URL, and QML doesn't expand "~",
    // so both are handled here.

    function resolvePath(path) {
        const expanded = path.startsWith("~") ? Quickshell.env("HOME") + path.slice(1) : path;
        return "file://" + expanded;
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Item {
            id: avatarContainer

            width: 180
            height: 180
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: avatarImage
                anchors.fill: parent
                source: root.resolvePath(Settings.general.profilePicture)
                fillMode: Image.PreserveAspectCrop
                visible: false // excluded from normal compositing, used only as the mask's source texture
            }

            // Hidden circular shape whose alpha channel defines the mask.
            // layer.enabled is required here — MultiEffect reads
            // maskSource's alpha from a rendered texture, and a plain
            // Rectangle has no texture of its own until it's explicitly
            // layered.
            Rectangle {
                id: avatarMask
                anchors.fill: parent
                radius: width / 2
                visible: false
                layer.enabled: true
            }

            MultiEffect {
                anchors.fill: parent
                source: avatarImage
                maskEnabled: true
                maskSource: avatarMask
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Quickshell.env("USER")
            color: Colors.md3.on_surface
            font.pixelSize: 28
            font.bold: true
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Icon {
                id: uptimeIcon
                anchors.verticalCenter: parent.verticalCenter
                name: "common/clock"
                size: 14
                color: Colors.md3.on_surface_variant
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.uptimeText
                color: Colors.md3.on_surface_variant
                font.pixelSize: 14
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Icon {
                id: wmIcon
                anchors.verticalCenter: parent.verticalCenter
                name: "common/wm"
                size: 14
                color: Colors.md3.on_surface_variant
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "WM: " + Quickshell.env("XDG_CURRENT_DESKTOP")
                color: Colors.md3.on_surface_variant
                font.pixelSize: 14
            }
        }
    }
}
