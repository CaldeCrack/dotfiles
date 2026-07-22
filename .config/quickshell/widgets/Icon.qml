import QtQuick
import QtQuick.Effects
import Quickshell

import qs.config as Config

// Icon
// ----
// Two independent modes — set only one:
//
// - `name`: a bundled icon from assets/icons/<name>.svg, resolved
//   relative to the shell's own root directory (Quickshell.shellDir).
//   Recolored to `color` via colorization, since these are OUR OWN
//   monochrome icons (bar glyphs, weather symbols, cpu/ram/battery,
//   power, etc.) meant to follow the generated theme.
//
// - `systemIcon`: a freedesktop icon-theme name, resolved through
//   Quickshell's built-in icon lookup (Quickshell.iconPath). This is
//   for icons that AREN'T ours to recolor — Tray items, Launcher
//   entries — so this mode skips the `color` tint entirely; showing an
//   app's actual icon colors is the whole point there.
//
// Usage (bundled, themed):
//   Icon { name: "cpu"; size: 16 }
//
// Usage (system/app icon — Tray, Launcher):
//   Icon { systemIcon: trayItem.icon; size: 20 }
//   Icon { systemIcon: appEntry.icon; systemIconFallback: "application-x-executable" }
//
// Note: assets/icons/ doesn't have any real SVGs in it yet at this stage
// of the project — `name` will just render blank (nothing crashes) until
// actual files exist there. Nothing to fix on your end; just don't be
// surprised the bundled-icon path shows nothing during early testing.

Item {
    id: root

    property string name: ""
    property string systemIcon: ""
    // Only used with systemIcon — passed straight to Quickshell.iconPath's
    // fallback parameter, a second icon name to try if the first isn't
    // found in the current icon theme (e.g. a generic exec icon).
    property string systemIconFallback: ""

    property real size: 20
    property color color: Config.Colors.md3.on_surface

    implicitWidth: size
    implicitHeight: size

    readonly property bool isSystemIcon: systemIcon.length > 0
    readonly property bool isBundledIcon: !isSystemIcon && name.length > 0

    Image {
        id: image
        anchors.fill: parent
        visible: status === Image.Ready

        source: {
            if (root.isSystemIcon) {
                return root.systemIconFallback.length > 0 ? Quickshell.iconPath(root.systemIcon, root.systemIconFallback) : Quickshell.iconPath(root.systemIcon);
            }
            if (root.isBundledIcon)
                return "file://" + Quickshell.shellDir + "/assets/icons/" + root.name + ".svg";

            return "";
        }

        sourceSize.width: root.width * 2
        sourceSize.height: root.height * 2
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true

        // Only recolor bundled icons — a system/app icon keeps its real
        // colors, that's the entire reason systemIcon mode exists.
        layer.enabled: root.isBundledIcon
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: root.color
        }
    }
}
