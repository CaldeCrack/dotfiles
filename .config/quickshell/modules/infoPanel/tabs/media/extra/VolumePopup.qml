import QtQuick
import Quickshell
import qs.config as Config
import qs.widgets as Widgets

// Wrapped in DismissablePopup for click-outside/Escape-to-close — same
// popup pattern used for bar dropdowns, just triggered from inside the
// music tab instead of the bar itself.
//
// Volume state is passed in from the caller (ExtraActionsColumn, backed by
// the real Audio service). This popup only ever reports what the user did
// via volumeChangeRequested; it doesn't own the real value itself.
Widgets.DismissablePopup {
    id: root

    property real volume: 50
    property bool muted: false
    property Item anchorItem: null

    signal volumeChangeRequested(real newVolume)

    property real popupContentWidth: 50

    // Cached rather than computed inline in contentX/contentY — only
    // updated when the popup actually opens, via onOpenChanged below.
    // Recomputing live off `root.open` (returning 0 whenever it's false,
    // as a guard) meant that the instant Escape/dismiss flipped `open` to
    // false, position snapped to (0,0) immediately — while PanelBase's
    // fade-out animation was still playing the close transition, so it
    // visibly flashed in the corner mid-close. Holding the last valid
    // position steady during close (by simply not recomputing) fixes that.
    property real cachedContentX: 0
    property real cachedContentY: 0

    onOpenChanged: {
        if (!open || !anchorItem)
            return;
        const mappedX = panel.QsWindow.mapFromItem(anchorItem, anchorItem.width, anchorItem.height / 2);
        cachedContentX = mappedX.x + 8;
        const mappedY = panel.QsWindow.mapFromItem(anchorItem, 0, anchorItem.height / 2);
        cachedContentY = mappedY.y - panel.implicitHeight / 2;
    }

    contentX: cachedContentX
    contentY: cachedContentY

    Column {
        width: root.popupContentWidth
        spacing: 8
        topPadding: 12
        bottomPadding: 6
        leftPadding: 16
        rightPadding: 16

        Widgets.VerticalSlider {
            id: slider
            anchors.horizontalCenter: parent.horizontalCenter
            length: 120
            onMoved: newValue => root.volumeChangeRequested(newValue)
        }

        // Keeps the slider synced to the real external volume whenever the
        // user isn't actively dragging it — see VerticalSlider's own
        // comment for why this has to be a Binding{} with `when` rather
        // than a plain `value: root.volume` on the slider itself.
        Binding {
            target: slider
            property: "value"
            value: root.volume
            when: !slider.dragging
        }

        Text {
            width: parent.width - parent.leftPadding - parent.rightPadding
            horizontalAlignment: Text.AlignHCenter
            text: Math.round(root.volume) + "%"
            color: Config.Colors.md3.on_surface
            font.pixelSize: 12
        }
    }
}
