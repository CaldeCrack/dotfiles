import QtQuick
import Quickshell

import qs.config

// Same PopupWindow + anchor.item mechanics as Tooltip.qml, but a generic
// content container instead of a fixed `text` property — for hover popups
// richer than a one-line label (e.g. the workspace window-list preview).
//
// Like Tooltip: target must expose a `hovered` bool. Position is computed
// once, right before the popup becomes visible — it does not live-track
// the target moving while already open.
PopupWindow {
    id: root

    // Not required: the container assigns this once something is actually
    // hovered, rather than at instantiation time.
    property Item target: null
    property int padding: 8

    // Driven by the caller (e.g. a debounce timer), not target.hovered
    // directly — this widget doesn't own the show/hide timing, only the
    // rendering and positioning once told to show.
    property bool open: false

    default property alias content: contentContainer.data

    color: "transparent"

    anchor.item: target
    anchor.rect.x: target ? (target.width - implicitWidth) / 2 : 0
    anchor.rect.y: target ? target.height + 4 : 0

    implicitWidth: contentContainer.childrenRect.width + padding * 2
    implicitHeight: contentContainer.childrenRect.height + padding * 2

    visible: open && target !== null

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: Colors.md3.surface_container
        border.color: Colors.md3.outline_variant
        border.width: 1
    }

    Item {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: root.padding
    }
}
