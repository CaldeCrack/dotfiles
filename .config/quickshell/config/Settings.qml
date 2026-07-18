pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    readonly property JsonObject bar: ConfigLoader.adapter.bar
    readonly property JsonObject weather: ConfigLoader.adapter.weather
    readonly property JsonObject general: ConfigLoader.adapter.general
}
