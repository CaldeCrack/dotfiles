pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

// Thin wrapper around Quickshell's Bluetooth module (BlueZ backend).
// Mirrors Network.qml's shape: default adapter, overall status icon,
// active connection, and the full known-device list (paired, bonded,
// or currently visible while scanning — not just connected ones).
//
// Single-adapter assumption, same as Network.qml's single-wifi-device
// one. Bluetooth.defaultAdapter already picks "the" adapter for us, so
// there's less to do here than Network.qml needed.
Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter

    // Read directly off the adapter rather than mirroring into a local
    // property — a local property with a two-way sync (bind in, write
    // back on change) breaks its own binding the moment something here
    // assigns to it, so external changes (toggling bluetooth from a
    // system tray applet, etc.) would stop showing up. Readonly +
    // always-live avoids that entirely.
    readonly property bool bluetoothEnabled: adapter?.enabled ?? false
    readonly property bool scanning: adapter?.discovering ?? false

    readonly property var devices: adapter ? [...adapter.devices.values] : []
    readonly property var connectedDevice: devices.find(d => d.connected) ?? null

    // Connected first, then paired-but-not-connected, then everything
    // else — not something you asked for explicitly, but matches how
    // most system Bluetooth panels order their list. Swap for
    // alphabetical or discovery order if you'd rather.
    readonly property var sortedDevices: {
        const rank = d => d.connected ? 0 : d.paired ? 1 : 2;
        return [...devices].sort((a, b) => rank(a) - rank(b));
    }

    function toggleBluetoothEnabled() {
        if (adapter)
            adapter.enabled = !adapter.enabled;
    }

    function setScanning(enabled) {
        if (adapter)
            adapter.discovering = enabled;
    }

    // Same off-then-on trick as Network.qml's rescan() — discovering is
    // a bool, not a one-shot action, so toggling it is the closest
    // equivalent to a manual refresh.
    function rescan() {
        if (!adapter)
            return;
        adapter.discovering = false;
        rescanTimer.restart();
    }

    Timer {
        id: rescanTimer
        interval: 150
        onTriggered: if (root.adapter)
            root.adapter.discovering = true
    }

    // --- icon selection --------------------------------------------------
    //
    // Overall status icon for the section header / eventual bar button.
    // Per-device type icons come straight from BlueZ (BluetoothDevice.icon)
    // instead, handled directly in BluetoothSection via systemIcon.
    readonly property string currentIcon: {
        if (!bluetoothEnabled)
            return "bluetooth/off";
        if (connectedDevice)
            return "bluetooth/connected";
        return "bluetooth/on";
    }

    // Per-entry connection-state icon (right end of each dropdown row).
    // BlueZ exposes connected/paired/bonded as separate booleans rather
    // than a single tri-state enum, so this is a manual ladder rather
    // than a switch on some `state` value.
    function statusIconForDevice(device) {
        if (device.connected)
            return "bluetooth/state-connected";
        if (device.paired)
            return "bluetooth/state-paired";
        return "bluetooth/state-unpaired";
    }

    function deviceIcon(device) {
        return device.icon;
    }
}
