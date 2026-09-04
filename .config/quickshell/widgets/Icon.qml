import QtQuick
import QtQuick.Controls.impl
import Quickshell

import qs.config

// Icon
// ----
// Three independent modes — set only one:
//
// - `name`: a bundled icon from assets/icons/<name>.svg, resolved
//   relative to the shell's own root directory (Quickshell.shellDir).
//   Recolored to `color` via colorization, since these are OUR OWN
//   monochrome icons (bar glyphs, weather symbols, cpu/ram/battery,
//   power, etc.) meant to follow the generated theme.
//
// - `systemIcon`: an ALREADY-RESOLVED freedesktop icon-theme name (or
//   path), passed straight to Quickshell.iconPath with no further
//   lookup. For sources that hand you a real icon name/path directly —
//   Tray items, a DesktopEntry's own `.icon` field. Skips the `color`
//   tint entirely; showing an app's actual icon colors is the point.
//
// - `appId`: an application/desktop IDENTIFIER that is NOT guaranteed
//   to already be a valid icon-theme name — an MPRIS `desktopEntry`, a
//   Wayland toplevel's `appId`, an i3/sway `app_id`/window class. These
//   often don't match their real icon name 1:1 (e.g. Zen's desktop id
//   is "zen" but its icon is "zen-browser"), so this mode looks the id
//   up against Quickshell's desktop-entry index first — exact match via
//   byId(), then a fuzzier heuristicLookup() — and only then resolves
//   the icon it finds through Quickshell.iconPath. Deliberately does
//   NOT fall back to treating the raw id as an icon name if lookup
//   fails; a guessed name is more likely to silently resolve to the
//   wrong icon than to just not resolve. If lookup fails, only an
//   explicit `systemIconFallback` renders — otherwise nothing does.
//
// Usage (bundled, themed):
//   Icon { name: "cpu"; size: 16 }
//
// Usage (system/app icon, already resolved — Tray, Launcher):
//   Icon { systemIcon: trayItem.icon; size: 20 }
//   Icon { systemIcon: appEntry.icon; systemIconFallback: "application-x-executable" }
//
// Usage (app identifier needing resolution — Media, Workspaces preview):
//   Icon { appId: Media.activePlayer.desktopEntry; systemIconFallback: "multimedia-player" }
//   Icon { appId: toplevel.appId; systemIconFallback: "application-x-executable" }
//
// Note: assets/icons/ doesn't have any real SVGs in it yet at this stage
// of the project — `name` will just render blank (nothing crashes) until
// actual files exist there. Nothing to fix on your end; just don't be
// surprised the bundled-icon path shows nothing during early testing.

Item {
    id: root

    property string name: ""
    property string systemIcon: ""
    property string appId: ""
    // Used with systemIcon OR appId — passed straight to
    // Quickshell.iconPath's fallback parameter (systemIcon), or used as
    // the sole source if appId resolution fails (appId).
    property string systemIconFallback: ""

    property real size: 20
    property bool tint: true
    property color color: Colors.md3.on_surface

    implicitWidth: size
    implicitHeight: size

    readonly property bool isSystemIcon: systemIcon.length > 0
    readonly property bool isAppIcon: !isSystemIcon && appId.length > 0
    readonly property bool isBundledIcon: !isSystemIcon && !isAppIcon && name.length > 0

    // Exact match first, fuzzier fallback second — see the appId mode note
    // above for why this doesn't ever guess by returning the raw id back.
    function _resolveAppIconName(id) {
        if (!id)
            return "";
        const entry = DesktopEntries.byId(id) || DesktopEntries.heuristicLookup(id);
        return entry?.icon || "";
    }

    IconImage {
        id: image
        anchors.fill: parent
        visible: status === Image.Ready

        source: {
            if (root.isSystemIcon) {
                return root.systemIconFallback.length > 0 ? Quickshell.iconPath(root.systemIcon, root.systemIconFallback) : Quickshell.iconPath(root.systemIcon);
            }

            if (root.isAppIcon) {
                const resolved = root._resolveAppIconName(root.appId);
                if (resolved)
                    return Quickshell.iconPath(resolved);
                // Resolution failed — only an explicit fallback renders,
                // never a guess at the raw appId as an icon name.
                return root.systemIconFallback.length > 0 ? Quickshell.iconPath(root.systemIconFallback) : "";
            }

            if (root.isBundledIcon)
                return "file://" + Quickshell.shellDir + "/assets/icons/" + root.name + ".svg";

            return "";
        }

        sourceSize.width: width * 2
        sourceSize.height: height * 2
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true
        color: root.tint && root.isBundledIcon ? root.color : "transparent"
    }
}
