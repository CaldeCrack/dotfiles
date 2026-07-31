import QtQuick
import Quickshell
import qs.widgets as Widgets

// Wraps DismissablePopup with the "anchor to a trigger button, positioned
// to its right, vertically centered on it" logic shared by every popup in
// extra/ (volume, player selector, and eventually output device).
// Extracted here once a second popup needed the exact same positioning
// code VolumePopup already had.
//
// Position is cached rather than computed live in contentX/contentY —
// only recalculated in onOpenChanged when actually opening. Recomputing
// live off `open` (with a 0,0 guard when closed) made the popup visibly
// snap to the corner during its own closing fade animation, since
// PanelBase's close transition keeps rendering for a moment after `open`
// flips false.
Widgets.DismissablePopup {
    id: root

    property Item anchorItem: null
    property real horizontalGap: 8

    property real cachedContentX: 0
    property real cachedContentY: 0

    onOpenChanged: {
        if (!open || !anchorItem)
            return;
        const mappedX = panel.QsWindow.mapFromItem(anchorItem, anchorItem.width, anchorItem.height / 2);
        cachedContentX = mappedX.x + horizontalGap;
        const mappedY = panel.QsWindow.mapFromItem(anchorItem, 0, anchorItem.height / 2);
        cachedContentY = mappedY.y - panel.implicitHeight / 2;
    }

    contentX: cachedContentX
    contentY: cachedContentY
}
