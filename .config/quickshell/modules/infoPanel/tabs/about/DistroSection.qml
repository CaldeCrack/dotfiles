import QtQuick
import qs.config as Config
import qs.widgets as Widgets

// Distro info section of the About tab: logo, name, homepage link, and
// docs/github/forums chips. All data is hardcoded for now. LinkChip is a
// neighboring file in this same folder, auto-imported by QML.
Item {
    id: root

    // ---- Distro info (hardcoded) -----------------------------------------
    // Assumed Arch Linux since ArchButton.qml already exists in the project.
    // The pixmap filename varies by distro/installation — verify this path
    // actually exists on your system (`ls /usr/share/pixmaps/ | grep -i arch`)
    // and adjust distroLogoPath if it's named differently.

    readonly property string distroName: "Arch Linux"
    readonly property string distroLogoPath: "/usr/share/pixmaps/archlinux-logo.svg"
    readonly property string distroHomepage: "https://archlinux.org"
    readonly property string distroDocsUrl: "https://wiki.archlinux.org"
    readonly property string distroGithubUrl: "https://github.com/archlinux"
    readonly property string distroForumsUrl: "https://bbs.archlinux.org/"

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Config.Colors.md3.surface_container
        border.color: Config.Colors.md3.primary
    }

    Row {
        id: contentRow
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Image {
            id: distroLogo
            anchors.verticalCenter: parent.verticalCenter
            source: "file://" + root.distroLogoPath
            width: 160
            height: 160
            fillMode: Image.PreserveAspectFit
        }

        // Wider gap between the title and the link/chips group below it,
        // so the latter two read as one grouped unit rather than three
        // evenly-spaced rows.
        //
        // Width is explicitly bound to whatever's left after the logo +
        // row spacing, so the homepage URL below has something concrete
        // to wrap against — Text.wrapMode does nothing without a bounded
        // width.
        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - distroLogo.width - parent.spacing
            spacing: 36

            Text {
                text: root.distroName
                color: Config.Colors.md3.on_surface
                font.pixelSize: 24
                font.bold: true
            }

            // Tight spacing within this group — homepage link and chips
            // belong together.
            Column {
                width: parent.width
                spacing: 10

                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: root.distroHomepage
                    color: Config.Colors.md3.primary
                    font.pixelSize: 14
                    font.underline: distroHomepageMouse.containsMouse

                    MouseArea {
                        id: distroHomepageMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally(root.distroHomepage)
                    }
                }

                Column {
                    spacing: 4

                    Row {
                        spacing: 4

                        Widgets.LinkChip {
                            label: "   Docs"
                            url: root.distroDocsUrl
                        }

                        Widgets.LinkChip {
                            label: "   GitHub"
                            url: root.distroGithubUrl
                        }
                    }
                    Row {
                        Widgets.LinkChip {
                            label: "󱜸   Forums"
                            url: root.distroForumsUrl
                        }
                    }
                }
            }
        }
    }
}
