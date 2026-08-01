pragma Singleton

import Quickshell
import QtQml
import "components"

// Central registry mapping button id -> Component. Every bar section reads
// from this single map, so a button is defined once here and becomes
// available to ANY section (left/middle/right) just by adding its id to
// that section's list in Bar.qml — no per-section wiring needed.
//
// Uncomment a Component + map entry pair the moment its corresponding file
// lands in components/. Ids with no entry here fall back to a placeholder
// pill in the section that requested them, so leaving most of these
// commented out is safe and throws no errors.
Singleton {
    id: root

    Component {
        id: distroButton
        DistroButton {}
    }
    Component {
        id: workspaces
        Workspaces {}
    }
    Component {
        id: systemStats
        SystemStatsButton {}
    }
    // Component { id: media; MediaButton {} }
    Component {
        id: about
        AboutButton {}
    }
    Component {
        id: time
        TimeButton {}
    }
    Component {
        id: weather
        WeatherButton {}
    }
    Component {
        id: wallpaper
        WallpaperButton {}
    }
    // Component { id: tray; Tray {} }
    // Component { id: miscApps; MiscAppsButton {} }
    // Component { id: controlPanel; ControlPanelButton {} }
    // Component { id: notifications; NotificationsButton {} }
    // Component { id: power; PowerButton {} }

    readonly property var componentMap: ({
            distro: distroButton,
            workspaces: workspaces,
            systemStats: systemStats,
            // media: media,
            about: about,
            time: time,
            weather: weather,
            wallpaper: wallpaper
        // tray: tray,
        // miscApps: miscApps,
        // controlPanel: controlPanel,
        // notifications: notifications,
        // power: power
        })
}
