pragma Singleton

import Quickshell

// No UI, just fire-and-forget system actions — matches services/ convention.
// Each function is a thin wrapper around Quickshell.execDetached so callers
// (PowerOverlay, keybinds, anything else) never touch process management.
//
// Assumptions baked in below — swap these if your setup differs:
//   - shutdown/reboot/suspend/hibernate: systemd (systemctl)
//   - lock: loginctl lock-session, which relies on a session-lock handler
//     (hyprlock, swaylock-plugin, etc.) listening for the logind Lock signal.
//     If you're not running one of those, this call will do nothing visible.
//   - logout: hyprctl dispatch exit — Hyprland-specific, same category of
//     compromise as the Hyprland-only bits already noted elsewhere in this
//     shell (see DismissablePopup's known limitation). Swap for your
//     compositor's equivalent (e.g. `swaymsg exit` on Sway).
Singleton {
    function shutdown() {
        Quickshell.execDetached(["systemctl", "poweroff"]);
    }

    function reboot() {
        Quickshell.execDetached(["systemctl", "reboot"]);
    }

    function suspend() {
        Quickshell.execDetached(["systemctl", "suspend"]);
    }

    function hibernate() {
        Quickshell.execDetached(["systemctl", "hibernate"]);
    }

    function lock() {
        Quickshell.execDetached(["loginctl", "lock-session", Quickshell.env("XDG_SESSION_ID") || ""]);
    }

    function logout() {
        Quickshell.execDetached(["loginctl", "terminate-session", Quickshell.env("XDG_SESSION_ID") || ""]);
    }
}
