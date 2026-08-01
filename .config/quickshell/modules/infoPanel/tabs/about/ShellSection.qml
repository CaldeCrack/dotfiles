import QtQuick
import qs.config
import qs.widgets

// Shell info section of the About tab: placeholder logo, name, website
// link, and docs/github chips. All data is hardcoded for now. LinkChip is
// a neighboring file in this same folder, auto-imported by QML.
Item {
    id: root

    // ---- Shell info (hardcoded) -------------------------------------------
    // All links point at the same repo for now since docs don't exist yet —
    // update shellDocsUrl once there's somewhere real for it to point.

    readonly property string shellName: "CaldeShell"
    readonly property string shellWebsite: "https://github.com/CaldeCrack/CaldeShell"
    readonly property string shellDocsUrl: "https://github.com/CaldeCrack/CaldeShell"
    readonly property string shellGithubUrl: "https://github.com/CaldeCrack/CaldeShell"

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Colors.md3.surface_container
        border.color: Colors.md3.primary
    }

    Row {
        id: contentRow
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Placeholder logo — plain circle until there's an actual
        // project logo to drop in.
        Rectangle {
            id: shellLogoPlaceholder
            anchors.verticalCenter: parent.verticalCenter
            width: 160
            height: 160
            radius: width / 2
            color: Colors.md3.tertiary
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - shellLogoPlaceholder.width - parent.spacing
            spacing: 36

            Text {
                text: root.shellName
                color: Colors.md3.on_surface
                font.pixelSize: 24
                font.bold: true
            }

            Column {
                width: parent.width
                spacing: 10

                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: root.shellWebsite
                    color: Colors.md3.primary
                    font.pixelSize: 14
                    font.underline: shellWebsiteMouse.containsMouse

                    MouseArea {
                        id: shellWebsiteMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally(root.shellWebsite)
                    }
                }

                Row {
                    spacing: 4

                    LinkChip {
                        label: "   Docs"
                        url: root.shellDocsUrl
                    }

                    LinkChip {
                        label: "   GitHub"
                        url: root.shellGithubUrl
                    }
                }
            }
        }
    }
}
