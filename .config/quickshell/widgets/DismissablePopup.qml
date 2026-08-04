import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.widgets

// DismissablePopup
// -----------------
// A reusable wrapper around PanelBase that adds click-outside-to-close
// and Escape-to-close — the two things almost every bar dropdown/popup
// wants, but that PanelBase itself deliberately doesn't own (PanelBase
// is just visual chrome with no window or input awareness — see its own
// header comment).
//
// Unlike PanelBase and the other widgets/ components, THIS ONE IS a
// window (a PanelWindow) — unavoidable here. Click-outside detection
// needs a surface covering the whole screen to catch clicks landing
// anywhere else, and Escape needs real keyboard focus, which a small
// popup-sized layer-shell surface often can't reliably get no matter
// what's set on it. A screen-covering surface with EXCLUSIVE keyboard
// focus can, consistently, across compositors — that's the whole reason
// this is shaped the way it is.
//
// Like PanelBase/SidebarBase, this NEVER writes back to `open` itself —
// it only emits `dismissRequested()` (Escape or an outside click). The
// caller owns `open` and must flip it in response, same discipline as
// PanelBase's own onClosed contract. Writing to `open` internally here
// would silently break a one-way binding like `open: someButton.checked`
// — QML converts that into a static value the instant anything other
// than the original binding source assigns to it.
//
// POSITIONING: two ways to position the card —
//
// 1. `target` (recommended for bar dropdowns): set target to the button
//    that opens this popup, and the card auto-positions itself relative
//    to it (edge + edgeMargin control which side / how far). Position is
//    computed ONCE, imperatively, at the moment `open` flips true — NOT
//    as a persistent binding. This is deliberate: target.mapToGlobal()
//    reads the target's position through a plain C++ function call, and
//    QML's automatic dependency tracking can't see through that the way
//    it can a direct property read, so a binding built on it would only
//    ever evaluate once, at whatever moment it first gets installed —
//    typically before the bar's own Row has finished laying out, giving
//    a stale/wrong position. Computing it imperatively at open-time
//    sidesteps that: by the time a user actually clicks a real,
//    already-rendered button to open this, that button's layout is
//    already final. This is the same accepted limitation Tooltip
//    already documents (calculated once right before becoming visible,
//    does not live-track target moving while already open) — fine for
//    static bar buttons, consistent with that established pattern.
//
// 2. `contentX`/`contentY` directly, if you need a fixed or custom
//    position instead of relative-to-target. Setting these overrides
//    whatever `target` would have computed.
//
// Usage (target-based, typical bar dropdown):
//   DismissablePopup {
//       target: someBarButton
//       edge: Qt.BottomEdge
//       onDismissRequested: someBarButton.checked = false
//
//       open: someBarButton.checked
//       Text { text: "popup content" }
//   }
//
// Usage (manual position):
//   DismissablePopup {
//       open: someButton.checked
//       onDismissRequested: someButton.checked = false
//       contentX: width - panel.implicitWidth - 8
//       contentY: Settings.bar.height + 8
//       Text { text: "popup content" }
//   }

PanelWindow {
    id: root

    default property alias content: panel.contentChildren
    readonly property alias panel: panel

    // --- target-relative positioning ------------------------------------------------------
    // The item this popup should appear relative to (typically the bar
    // button that opens it). Optional — leave unset and drive
    // contentX/contentY directly instead if you need custom placement.
    property Item target: null
    property int edge: Qt.BottomEdge // Qt.TopEdge | Qt.BottomEdge | Qt.LeftEdge | Qt.RightEdge
    property real edgeMargin: 2
    // Minimum gap kept between the card and the screen edge when clamping.
    property real screenMargin: 4

    function repositionToTarget() {
        if (!target)
            return;
        var pos = target.mapToGlobal(0, 0);
        var tw = target.width;
        var th = target.height;
        var pw = panel.implicitWidth;
        var ph = panel.implicitHeight;
        var x, y;

        switch (edge) {
        case Qt.TopEdge:
            x = pos.x + (tw - pw) / 2;
            y = pos.y - ph - edgeMargin;
            break;
        case Qt.LeftEdge:
            x = pos.x - pw - edgeMargin;
            y = pos.y + (th - ph) / 2;
            break;
        case Qt.RightEdge:
            x = pos.x + tw + edgeMargin;
            y = pos.y + (th - ph) / 2;
            break;
        case Qt.BottomEdge:
        default:
            x = pos.x + (tw - pw) / 2;
            y = pos.y + th + edgeMargin;
            break;
        }

        // Clamp so the card can't overflow off-screen. Deliberately using
        // root.screen.width/height here, NOT root.width/height — this
        // window's own width/height only reach their real anchor-forced
        // value after an async compositor "configure" round-trip
        // following visible becoming true, and repositionToTarget() runs
        // synchronously in the same tick as that, before that round-trip
        // completes (root.width reads back as Qt Quick's default window
        // size, ~500, until then). root.screen is populated from real
        // monitor/output info independent of this window's own configure
        // cycle, so it's reliable immediately.
        contentX = Math.max(screenMargin, Math.min(x, root.screen.width - pw - screenMargin));
        contentY = Math.max(screenMargin, Math.min(y, root.screen.height - ph - screenMargin));
    }

    // Position of the visible card within the full-screen window. Plain
    // x/y, not anchors — there's no "edge" to anchor to internally since
    // the window itself already spans the whole screen. Set directly for
    // manual placement, or left to repositionToTarget() when `target` is
    // used.
    property alias contentX: panel.x
    property alias contentY: panel.y

    property bool open: false
    // Stays true slightly longer than `open` so the close animation has
    // time to finish before the window itself disappears — same
    // visible-vs-open split PanelBase/SidebarBase's own host windows use
    // elsewhere in this shell.
    property bool shown: false
    onOpenChanged: {
        if (open) {
            shown = true;
            // Computed here, imperatively, on the transition to open —
            // see file header for why this can't be a persistent binding.
            // By this point the target (a real button the user just
            // clicked) is guaranteed to be fully laid out.
            repositionToTarget();
        }
    }

    signal dismissRequested

    visible: shown
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    // Exclusive, not OnDemand — see file header for why. Only grabbed
    // while actually open, so it doesn't steal focus from everything
    // else while hidden.
    WlrLayershell.keyboardFocus: root.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    onShownChanged: if (shown)
        focusScope.forceActiveFocus()

    Item {
        id: focusScope
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.dismissRequested()
    }

    // Catches any click that isn't on the card itself.
    MouseArea {
        anchors.fill: parent
        onClicked: root.dismissRequested()
    }

    // Swallows clicks landing on the card's own empty background so they
    // don't fall through to the full-screen catcher above and trigger a
    // false dismiss. Sits BENEATH panel (declared first, paints
    // underneath) — the caller's real interactive content, living inside
    // panel's own content area, still gets first pick of any click since
    // it renders on top of everything. Deliberately NOT placed inside
    // panel's own content — PanelBase auto-sizes from its content's
    // childrenRect, and a MouseArea filling that exact area would create
    // a circular sizing dependency.
    MouseArea {
        anchors.fill: panel
    }

    PanelBase {
        id: panel
        panelOpen: root.open
        onClosed: root.shown = false

        // If content size changes while open (e.g. async-loaded content
        // growing panel.implicitWidth/Height), keep it anchored to target
        // rather than drifting from its original computed position.
        onImplicitWidthChanged: if (root.open && root.target)
            root.repositionToTarget()
        onImplicitHeightChanged: if (root.open && root.target)
            root.repositionToTarget()
    }
}
