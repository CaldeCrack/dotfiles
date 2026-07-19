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
}
