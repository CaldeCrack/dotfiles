pragma Singleton

import Quickshell
import QtQml
import qs.modules.bar.components as Buttons

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
        id: archButton
        Buttons.ArchButton {}
    }
    Component {
        id: workspaces
        Buttons.Workspaces {}
    }
    Component {
        id: systemStats
        Buttons.SystemStatsButton {}
    }
    // Component { id: media; Buttons.MediaButton {} }
    // Component { id: profile; Buttons.Profile {} }
    // Component { id: clock; Buttons.ClockButton {} }
    // Component { id: weather; Buttons.WeatherButton {} }
    // Component { id: tray; Buttons.Tray {} }
    // Component { id: miscApps; Buttons.MiscAppsButton {} }
    // Component { id: controlPanel; Buttons.ControlPanelButton {} }
    // Component { id: notifications; Buttons.NotificationsButton {} }
    // Component { id: power; Buttons.PowerButton {} }

    readonly property var componentMap: ({
            arch: archButton,
            workspaces: workspaces,
            systemStats: systemStats
        // media: media,
        // profile: profile,
        // clock: clock,
        // weather: weather,
        // tray: tray,
        // miscApps: miscApps,
        // controlPanel: controlPanel,
        // notifications: notifications,
        // power: power
        })
}
