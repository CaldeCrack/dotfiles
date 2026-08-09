import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services
import qs.widgets

// Full-screen power menu, wlogout-style: 4 hoverable columns over a
// blurred, dimmed freeze-frame of the desktop.
//
// This does NOT reuse PanelBase/DismissablePopup — both auto-size to their
// content, and this window IS the full screen. It borrows their contract
// where it still applies (closed-after-animation timing, exclusive
// keyboard focus for Escape) but is otherwise a standalone implementation.
//
// API assumptions flagged inline below (screen targeting, WlrLayer choice)
// since they depend on the exact Quickshell/Qt versions in use — check
// these first if something doesn't compile.
PanelWindow {
    id: root

    // --- public API -----------------------------------------------------
    function show() {
        currentIndex = 0;
        overlayOpen = true;
    }

    function hide() {
        overlayOpen = false;
    }

    function toggle() {
        if (overlayOpen)
            hide();
        else
            show();
    }

    // --- state ------------------------------------------------------------
    property bool overlayOpen: false
    property int currentIndex: 0

    readonly property var options: [
        {
            icon: "power/shutdown",
            label: "Shutdown",
            action: () => Power.shutdown()
        },
        {
            icon: "power/reboot",
            label: "Reboot",
            action: () => Power.reboot()
        },
        {
            icon: "power/suspend",
            label: "Suspend",
            action: () => Power.suspend()
        },
        {
            icon: "power/lock",
            label: "Lock",
            action: () => Power.lock()
        }
    ]

    function activate(index) {
        options[index].action();
        hide();
    }

    // --- window setup -------------------------------------------------
    visible: false
    color: "transparent"

    // Explicit rather than left to default — the capture below needs a
    // resolved ShellScreen *before* this window is ever mapped, and an
    // unset `screen` is what may only resolve once the compositor has
    // actually placed the window on a display. Quickshell.screens is a
    // global list, available immediately regardless of our own mapping.
    // ASSUMPTION: single-monitor target (first screen). For multi-monitor,
    // this should instead take the screen the triggering bar instance is
    // on, passed down from PowerButton.
    screen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // Overlay, not a reserved-space panel — same reasoning as every other
    // popup/sidebar in this shell (see Widgets_reference.md cross-cutting
    // notes on ExclusionMode).
    exclusionMode: ExclusionMode.Ignore

    // Sits above the bar and any other panel/sidebar, same category as a
    // lock screen. Swap for WlrLayer.Top if Overlay causes issues with
    // your compositor.
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "powerMenu"

    // Exclusive only while open — same "screen-covering surface with
    // exclusive keyboard focus" reasoning DismissablePopup already
    // documents for Escape/click-outside to work reliably.
    WlrLayershell.keyboardFocus: overlayOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    onOverlayOpenChanged: {
        if (overlayOpen) {
            // Deliberately NOT setting visible = true here. Screencopy
            // captures whatever the compositor has already composited —
            // if our own (black) overlay is on screen first, that's what
            // gets captured instead of the real desktop behind it. So:
            // stay invisible, request the frame, and only reveal the
            // window once a real frame has actually landed (or we give up
            // waiting for one — see captureRetryTimer).
            captureRetryTimer.attempts = 0;
            captureRetryTimer.restart();
            capture.captureFrame();
        } else {
            captureRetryTimer.stop();
            hideTimer.restart();
        }
    }

    function revealNow() {
        if (!overlayOpen || visible)
            return;
        visible = true;
        content.forceActiveFocus();
    }

    Timer {
        id: hideTimer
        interval: 150
        onTriggered: root.visible = false
    }

    // Retries captureFrame() until a frame actually lands (capture.hasContent),
    // since the very first request can miss if captureSource wasn't fully
    // resolved yet. Reveals the window as soon as content arrives; if
    // nothing arrives within ~1s (20 * 50ms) — e.g. the compositor doesn't
    // support the screencopy protocols this needs — reveals anyway so the
    // overlay is still usable, just without the blurred backdrop.
    Timer {
        id: captureRetryTimer
        interval: 50
        repeat: true
        property int attempts: 0
        onTriggered: {
            if (capture.hasContent) {
                stop();
                root.revealNow();
                return;
            }
            if (attempts >= 20) {
                stop();
                root.revealNow();
                return;
            }
            attempts += 1;
            capture.captureFrame();
        }
    }

    // Windows (PanelWindow included) don't have an `opacity` property in
    // QML — that's an Item thing. This wraps every visible piece so the
    // open/close fade has something to actually animate.
    Item {
        id: fade
        anchors.fill: parent
        opacity: root.overlayOpen ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        // --- blurred, dimmed backdrop --------------------------------------
        ScreencopyView {
            id: capture
            anchors.fill: parent
            captureSource: root.screen
            live: false
            paintCursor: false
            visible: false
        }

        MultiEffect {
            anchors.fill: parent
            source: capture
            autoPaddingEnabled: false

            visible: capture.hasContent

            blurEnabled: true
            blur: 0.6
            blurMax: 64
            blurMultiplier: 1.0
        }

        // Extra flat dimming on top of the brightness pass above — gives a
        // bit more contrast depth than brightness alone, closer to wlogout's
        // look. Drop this if -0.35 brightness alone reads dark enough.
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }

        // Swallow clicks on empty backdrop to dismiss — sits as a sibling
        // before `content`, same swallow-click pattern DismissablePopup uses,
        // so real interactive content (the 4 options) still gets first pick.
        MouseArea {
            anchors.fill: parent
            onClicked: root.hide()
        }

        // --- content: 4 options + keyboard nav -----------------------------
        Item {
            id: content
            anchors.fill: parent
            focus: true

            Keys.onEscapePressed: root.hide()
            Keys.onLeftPressed: root.currentIndex = (root.currentIndex + root.options.length - 1) % root.options.length
            Keys.onRightPressed: root.currentIndex = (root.currentIndex + 1) % root.options.length
            Keys.onReturnPressed: root.activate(root.currentIndex)
            Keys.onEnterPressed: root.activate(root.currentIndex)

            Row {
                anchors.centerIn: parent
                spacing: 32

                Repeater {
                    model: root.options

                    PowerOption {
                        required property var modelData
                        required property int index

                        iconName: modelData.icon
                        label: modelData.label
                        focused: root.currentIndex === index

                        // Mouse hover keeps keyboard nav in sync — hovering an
                        // option moves currentIndex, so a follow-up Enter
                        // activates whatever was just hovered instead of
                        // whatever arrow keys left it on.
                        onHoveredChanged: if (hovered)
                            root.currentIndex = index

                        onClicked: root.activate(index)
                    }
                }
            }
        }
    } // fade
}
