pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice device: UPower.displayDevice

    // Desktops without a battery still get a displayDevice from UPower,
    // so gate everything on isLaptopBattery rather than just null-checking.
    readonly property bool available: device !== null && device.isLaptopBattery

    readonly property real percentage: available ? device.percentage * 100 : 0
    readonly property bool charging: available && device.state === UPowerDeviceState.Charging
    readonly property bool plugged: available && device.state !== UPowerDeviceState.Discharging

    readonly property string iconName: {
        if (!available)
            return "battery/vertical-off";

        if (percentage >= 100)
            return "battery/vertical-4";
        if (charging)
            return "battery/vertical-charging";
        if (percentage >= 80)
            return "battery/vertical-4";
        if (percentage >= 60)
            return "battery/vertical-3";
        if (percentage >= 40)
            return "battery/vertical-2";
        if (percentage >= 20)
            return "battery/vertical-1";
        if (percentage >= 1)
            return "battery/exclamation";
        return "battery/vertical-off";
    }
}
