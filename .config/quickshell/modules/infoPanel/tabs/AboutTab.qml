import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.widgets as Widgets
import qs.config as Config

// About tab content: left section (profile/system info) takes half the
// width; the other half is split into two stacked sections (distro info on
// top, shell info below).
Item {
    id: root

    // Instantiated via Loader's sourceComponent from InfoPanel — this fills
    // whatever size the Loader (and in turn the fixed content area) gives it.
    anchors.fill: parent

    readonly property int sectionSpacing: 8
    // Width available for the 2 top-level sections (left / right column)
    // once the 1 gap between them is accounted for.
    readonly property real usableWidth: width - sectionSpacing
    readonly property real proportion: 0.38

    // ---- Uptime (`uptime -p`) -------------------------------------------
    // Runs once per tab instantiation (this Item is destroyed/recreated each
    // time the tab is left/reopened, since it sits behind a Loader with
    // active tied to the selected tab — see InfoPanel.qml).

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

    // ---- Shell info (hardcoded) -------------------------------------------
    // All links point at the same repo for now since docs don't exist yet —
    // update shellDocsUrl once there's somewhere real for it to point.

    readonly property string shellName: "CaldeShell"
    readonly property string shellWebsite: "https://github.com/CaldeCrack/CaldeShell"
    readonly property string shellDocsUrl: "https://github.com/CaldeCrack/CaldeShell"
    readonly property string shellGithubUrl: "https://github.com/CaldeCrack/CaldeShell"

    // Small pill-shaped clickable label, used for the docs/github links.
    // Declared inline the same way Colors.qml declares its Md3/Palette/Base16
    // components — a component nested inside this file's root object.
    component LinkChip: Rectangle {
        id: chip

        property string label
        property string url

        implicitWidth: chipText.implicitWidth + 20
        implicitHeight: chipText.implicitHeight + 10
        radius: height / 2
        border.color: Config.Colors.md3.primary
        color: chipMouse.containsMouse ? Config.Colors.md3.secondary_container : Config.Colors.md3.surface_container_high

        Text {
            id: chipText
            anchors.centerIn: parent
            text: chip.label
            color: Config.Colors.md3.on_secondary_container
            font.pixelSize: 12
        }

        MouseArea {
            id: chipMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Qt.openUrlExternally(chip.url)
        }
    }

    Row {
        anchors.fill: parent
        spacing: root.sectionSpacing

        // ---- Left: profile / system info (50%) ---------------------------

        Item {
            id: leftSection

            width: root.usableWidth * root.proportion
            height: parent.height

            Rectangle {
                anchors.fill: parent
                radius: 12
                color: Config.Colors.md3.surface_container
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
                        source: root.resolvePath(Config.Settings.general.profilePicture)
                        fillMode: Image.PreserveAspectCrop
                        visible: false // excluded from normal compositing, used only as the mask's source texture
                    }

                    // Hidden circular shape whose alpha channel defines the
                    // mask. layer.enabled is required here — MultiEffect
                    // reads maskSource's alpha from a rendered texture, and
                    // a plain Rectangle has no texture of its own until it's
                    // explicitly layered. Without this the mask silently did
                    // nothing, which is why only the raw square image showed.
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
                    color: Config.Colors.md3.on_surface
                    font.pixelSize: 28
                    font.bold: true
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6

                    Widgets.Icon {
                        id: uptimeIcon
                        anchors.verticalCenter: parent.verticalCenter
                        name: "clock"
                        size: 14
                        color: Config.Colors.md3.on_surface_variant
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.uptimeText
                        color: Config.Colors.md3.on_surface_variant
                        font.pixelSize: 14
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6

                    Widgets.Icon {
                        id: wmIcon
                        anchors.verticalCenter: parent.verticalCenter
                        name: "wm"
                        size: 14
                        color: Config.Colors.md3.on_surface_variant
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "WM: " + Quickshell.env("XDG_CURRENT_DESKTOP")
                        color: Config.Colors.md3.on_surface_variant
                        font.pixelSize: 14
                    }
                }
            }
        }

        // ---- Right column: distro info (top) + shell info (bottom) ------

        Item {
            id: rightColumn

            width: root.usableWidth * (1 - root.proportion)
            height: parent.height

            Column {
                anchors.fill: parent
                spacing: root.sectionSpacing

                // ---- Distro info (50% of the right column's height) -----

                Item {
                    id: distroSection

                    width: parent.width
                    height: (parent.height - root.sectionSpacing) / 2

                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: Config.Colors.md3.surface_container
                    }

                    Row {
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

                        // Wider gap between the title and the link/chips
                        // group below it, so the latter two read as one
                        // grouped unit rather than three evenly-spaced rows.
                        //
                        // Width is explicitly bound to whatever's left after
                        // the logo + row spacing, so the long homepage URL
                        // below has something concrete to wrap against —
                        // Text.wrapMode does nothing without a bounded width.
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

                            // Tight spacing within this group — homepage
                            // link and chips belong together.
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

                                Row {
                                    spacing: 4

                                    LinkChip {
                                        label: "Docs"
                                        url: root.distroDocsUrl
                                    }

                                    LinkChip {
                                        label: "GitHub"
                                        url: root.distroGithubUrl
                                    }

                                    LinkChip {
                                        label: "Forums"
                                        url: root.distroForumsUrl
                                    }
                                }
                            }
                        }
                    }
                }

                // ---- Shell info (50% of the right column's height) ------

                Item {
                    id: shellSection

                    width: parent.width
                    height: (parent.height - root.sectionSpacing) / 2

                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: Config.Colors.md3.surface_container
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16

                        // Placeholder logo — plain circle until
                        // there's an actual project logo to drop in.
                        Rectangle {
                            id: shellLogoPlaceholder
                            anchors.verticalCenter: parent.verticalCenter
                            width: 160
                            height: 160
                            radius: width / 2
                            color: Config.Colors.md3.tertiary
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - shellLogoPlaceholder.width - parent.spacing
                            spacing: 36

                            Text {
                                text: root.shellName
                                color: Config.Colors.md3.on_surface
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
                                    color: Config.Colors.md3.primary
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
                                        label: "Docs"
                                        url: root.shellDocsUrl
                                    }

                                    LinkChip {
                                        label: "GitHub"
                                        url: root.shellGithubUrl
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
