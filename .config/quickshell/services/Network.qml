pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

// Thin wrapper around Quickshell's Networking module (NetworkManager
// backend). Finds the first Wifi-type device and exposes it, plus the
// bits ControlPanel's Wifi slice needs: an overall status icon, the
// active connection (if any), and the available-network list sorted by
// signal strength.
//
// Only handles a single wifi adapter — same single-device assumption as
// Brightness.qml's backlight detection. If you have more than one wifi
// card, `device` just picks the first one Networking reports.
Singleton {
    id: root

    readonly property bool wifiHardwareEnabled: Networking.wifiHardwareEnabled

    property bool wifiEnabled: Networking.wifiEnabled
    onWifiEnabledChanged: Networking.wifiEnabled = wifiEnabled

    readonly property var device: {
        const wifiDevices = Networking.devices.values.filter(d => d.type === DeviceType.Wifi);
        return wifiDevices.length > 0 ? wifiDevices[0] : null;
    }

    // Sorted strongest-first. .values is required for the same reason
    // Audio.qml's availableSinks needs it — networks is an ObjectModel,
    // not a plain array, and .values is Quickshell's reactive view of
    // one as a real list.
    readonly property var sortedNetworks: {
        if (!device)
            return [];
        return [...device.networks.values].sort((a, b) => b.signalStrength - a.signalStrength);
    }

    readonly property var connectedNetwork: sortedNetworks.find(n => n.connected) ?? null

    // --- toggling wifi on/off -------------------------------------------
    //
    // No-ops if the hardware kill switch is engaged — the software
    // toggle can't override that regardless, so flipping it would just
    // be a lie to the UI.
    function toggleWifiEnabled() {
        if (!wifiHardwareEnabled)
            return;
        wifiEnabled = !wifiEnabled;
    }

    // Scanning burns a bit of power and isn't needed unless something is
    // actually showing the network list — caller (WifiSection) turns
    // this on/off as its dropdown expands/collapses.
    function setScanning(enabled) {
        if (device)
            device.scannerEnabled = enabled;
    }

    // WifiDevice only exposes scannerEnabled as a bool, not a one-shot
    // "scan now" action. Toggling off then back on is the closest
    // equivalent to a manual refresh.
    function rescan() {
        if (!device)
            return;
        device.scannerEnabled = false;
        rescanTimer.restart();
    }

    Timer {
        id: rescanTimer
        interval: 150
        onTriggered: if (root.device)
            root.device.scannerEnabled = true
    }

    function connectToNetwork(network) {
        network.connect();
    }

    // --- icon selection --------------------------------------------------
    //
    // Single overall-status icon for the bar button / section header.
    // Per-entry icons in the dropdown list are computed separately since
    // they reflect each network's own signal, not the active connection.
    function iconForSignal(strength) {
        if (strength < 0.25)
            return "network/wifi-0";
        if (strength < 0.5)
            return "network/wifi-1";
        if (strength < 0.75)
            return "network/wifi-2";
        return "network/wifi";
    }

    readonly property string currentIcon: {
        if (!wifiHardwareEnabled || !wifiEnabled)
            return "network/wifi-off";
        if (connectedNetwork)
            return iconForSignal(connectedNetwork.signalStrength);
        return "network/wifi";
    }

    // Owe (opportunistic wireless encryption) technically encrypts the
    // link without requiring a password from the user — treating it as
    // "protected" here is a simplification for the lock icon; adjust if
    // you'd rather distinguish "has a password prompt" from "is
    // encrypted at all".
    function isSecured(network) {
        return network.security !== WifiSecurityType.Open;
    }
}
