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

    // Read directly, don't mirror into a local property — a local
    // property with a two-way sync (bind in, write back on change)
    // breaks its own binding the moment toggleWifiEnabled() assigns to
    // it, so external wifi-state changes (toggled via nmcli, a kill
    // switch, etc.) would stop showing up here after the first local
    // toggle. Same reasoning Bluetooth.qml's bluetoothEnabled already
    // uses — this should have matched that from the start.
    readonly property bool wifiEnabled: Networking.wifiEnabled

    readonly property var device: {
        const wifiDevices = Networking.devices.values.filter(d => d.type === DeviceType.Wifi);
        return wifiDevices.length > 0 ? wifiDevices[0] : null;
    }

    // Sorted strongest-first. .values is required for the same reason
    // Audio.qml's availableSinks needs it — networks is an ObjectModel,
    // not a plain array, and .values is Quickshell's reactive view of
    // one as a real list.
    //
    // Also explicitly reads device.state, otherwise unused here — forces
    // a re-sort whenever the device's own connection state changes,
    // rather than relying solely on nested reactivity through each
    // network's own properties, which is the suspected source of the
    // "connected network doesn't update until restart" staleness.
    readonly property var sortedNetworks: {
        if (!device)
            return [];
        const _stateDependency = device.state;
        return [...device.networks.values].sort((a, b) => b.signalStrength - a.signalStrength);
    }

    // Same explicit device.state read here too — connectedNetwork should
    // already reactively depend on each network's .connected via the
    // .find() below, but that depends on property-change notifications
    // propagating correctly through networks.values -> sort -> find, a
    // chain that's a few layers deeper than a plain property binding.
    // This is a belt-and-suspenders forced dependency on top of that,
    // not a replacement for figuring out if the deeper chain is actually
    // the gap — worth removing once confirmed one way or the other.
    readonly property var connectedNetwork: {
        const _stateDependency = device?.state;
        return sortedNetworks.find(n => n.connected) ?? null;
    }

    // --- toggling wifi on/off -------------------------------------------
    //
    // No-ops if the hardware kill switch is engaged — the software
    // toggle can't override that regardless, so flipping it would just
    // be a lie to the UI.
    function toggleWifiEnabled() {
        if (!wifiHardwareEnabled)
            return;
        Networking.wifiEnabled = !Networking.wifiEnabled;
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
