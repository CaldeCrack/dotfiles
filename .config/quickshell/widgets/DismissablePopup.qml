import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.widgets as Widgets

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
// Usage:
//   DismissablePopup {
//       open: someButton.checked
//       onDismissRequested: someButton.checked = false
//
//       // position the card within the full-screen window; there's no
//       // "edge" to anchor to internally since the window already spans
//       // the whole screen
//       contentX: width - panel.implicitWidth - 8
//       contentY: Config.Settings.bar.height + 8
//
//       Text { text: "popup content" }
//   }

PanelWindow {
    id: root

    default property alias content: panel.contentChildren
    readonly property alias panel: panel

    // Position of the visible card within the full-screen window. Plain
    // x/y, not anchors — there's no "edge" to anchor to internally since
    // the window itself already spans the whole screen.
    property alias contentX: panel.x
    property alias contentY: panel.y

    property bool open: false
    // Stays true slightly longer than `open` so the close animation has
    // time to finish before the window itself disappears — same
    // visible-vs-open split PanelBase/SidebarBase's own host windows use
    // elsewhere in this shell.
    property bool shown: false
    onOpenChanged: if (open)
        shown = true

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

    Widgets.PanelBase {
        id: panel
        panelOpen: root.open
        onClosed: root.shown = false
    }
}
