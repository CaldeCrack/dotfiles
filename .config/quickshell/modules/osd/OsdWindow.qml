import QtQuick
import Quickshell
import qs.config
import qs.services
import qs.widgets

// OSD host — bottom-center of the screen, one card at a time.
//
// Unlike the toast stack, this never needs to worry about the
// per-frame-resize-causing-lag problem that motivated the toast stack's
// fixed-geometry + mask approach: only one card is ever shown, its width
// is always the same (OsdIndicator.cardWidth), and its height only
// differs between the two *discrete* layouts (level vs boolean) — that's
// an occasional one-off resize when switching OSD kinds, not something
// animating every frame, so binding implicitWidth/Height straight to the
// indicator's own size is fine here.
//
// Show/hide is fade + scale on the indicator itself, not on the window.
// PanelWindow is a Window, not an Item — Window types don't support
// scale/transform (see Tooltip.qml's own note on this) — so the window's
// `visible` just tracks whether the animation is currently playing:
// shown eagerly the instant there's something to display, hidden only
// once the fade-out has actually finished. Same eager-show/late-hide
// shape used for the notification sidebar, for the same reason (cutting
// `visible` off immediately would clip the animation).
//
// Horizontal centering: anchoring only `bottom` (no left/right) is
// assumed to center a layer-shell surface by default — worth confirming
// on your compositor; if it doesn't, anchor bottom + left + right instead
// and center `indicator` within that via anchors.horizontalCenter.
PanelWindow {
    id: osdWindow

    anchors {
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore
    margins.bottom: 16

    color: "transparent"
    visible: false

    implicitWidth: indicator.implicitWidth
    implicitHeight: indicator.implicitHeight

    OsdIndicator {
        id: indicator
        anchors.centerIn: parent
        transformOrigin: Item.Center

        // Purely animation-driven, not binding-driven (no `opacity:
        // Osd.current !== null ? 1 : 0` expression) — _showAnim/_hideAnim
        // below own these properties directly. Mixing a live binding with
        // direct animation targeting on the same property is the trap:
        // the first animation run silently and permanently breaks the
        // binding. Starting values here only apply once, at creation.
        opacity: 0
        scale: 0.92

        // Bound to _lastPayload, NOT Osd.current directly. Osd.current
        // becomes null the instant a hide starts (that's the signal that
        // triggers _hideAnim below) — binding straight to it meant the
        // card's content reset to its fallback defaults (0%, no icon)
        // immediately, before the fade had even begun, so the fade-out
        // was visibly fading toward blank content instead of the real
        // last value. _lastPayload only ever updates on a genuine show,
        // so it keeps holding the real values for the whole fade.
        mode: osdWindow._lastPayload?.mode ?? "level"
        iconName: osdWindow._lastPayload?.iconName ?? ""
        value: osdWindow._lastPayload?.value ?? 0
        label: osdWindow._lastPayload?.label ?? ""
        active: osdWindow._lastPayload?.active ?? false
    }

    property var _lastPayload: null

    Connections {
        target: Osd
        function onCurrentChanged() {
          if (Osd.current !== null) {
                osdWindow._lastPayload = Osd.current
                _hideAnim.stop()
                osdWindow.visible = true
                _showAnim.start()
            } else {
                _showAnim.stop()
                _hideAnim.start()
            }
        }
    }

    ParallelAnimation {
        id: _showAnim
        NumberAnimation { target: indicator; property: "opacity"; to: 1; duration: 150; easing.type: Easing.OutCubic }
        NumberAnimation { target: indicator; property: "scale"; to: 1; duration: 150; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: _hideAnim
        ParallelAnimation {
            NumberAnimation { target: indicator; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InCubic }
            NumberAnimation { target: indicator; property: "scale"; to: 0.92; duration: 150; easing.type: Easing.InCubic }
        }
        ScriptAction { script: osdWindow.visible = false }
    }
}
