import QtQuick
import qs.config
import qs.modules.bar as Bar

// Center section of the bar. See LeftSection.qml for the registry lookup /
// placeholder fallback pattern this shares.
//
// `centerOn` (optional) is the id of one button within `model` — when set,
// the Row positions itself so THAT button's center lands on the parent's
// horizontal center, rather than centering the row as a whole. Useful when
// the middle section holds more than one button of visibly different width
// (e.g. ["weather", "time"]) and you want one specific one (say the clock)
// to be the true visual anchor, regardless of what its neighbor's width
// does to the row's overall midpoint.
//
// If `centerOn` is empty, or doesn't match any id in `model`, this falls
// back to centering the row as a whole — same behavior as before this
// property existed. Positioning is done via explicit `x` (not
// anchors.horizontalCenter) so the caller in Bar.qml only needs
// anchors.verticalCenter, and this component owns its own horizontal
// placement entirely.
Row {
    id: root

    property var model: []
    property string centerOn: ""
    readonly property real slotSize: Settings.bar.height - 4

    spacing: Settings.bar.spacing

    readonly property int centerIndex: model.indexOf(centerOn)

    // Offset (in Row-local coordinates) of the center of the button we're
    // anchoring on. Falls back to the row's own midpoint when centerOn
    // isn't set or isn't found in model, so behavior degrades gracefully
    // to "center the whole row" rather than erroring.
    readonly property real centerOffset: {
        if (centerIndex === -1) {
            return width / 2;
        }
        const item = buttonRepeater.itemAt(centerIndex);
        return item ? item.x + item.width / 2 : width / 2;
    }

    // parent here is whatever Item in Bar.qml positions this component
    // (see Bar.qml's use of MiddleSection) — its width is the full bar
    // width, so parent.width / 2 is the bar's true horizontal center.
    x: parent ? parent.width / 2 - centerOffset : 0

    Repeater {
        id: buttonRepeater
        model: root.model

        delegate: Item {
            id: wrapper
            required property string modelData

            implicitWidth: buttonComponent !== undefined ? loader.implicitWidth : root.slotSize
            implicitHeight: buttonComponent !== undefined ? loader.implicitHeight : root.slotSize

            readonly property var buttonComponent: Bar.ButtonRegistry.componentMap[modelData]

            Loader {
                id: loader
                anchors.fill: parent
                active: wrapper.buttonComponent !== undefined
                sourceComponent: wrapper.buttonComponent
            }

            Rectangle {
                anchors.fill: parent
                visible: wrapper.buttonComponent === undefined
                radius: width / 2
                color: Colors.md3.surface_container_high

                Text {
                    anchors.centerIn: parent
                    text: wrapper.modelData.charAt(0).toUpperCase()
                    color: Colors.md3.on_surface
                    font.pixelSize: parent.height * 0.5
                }
            }
        }
    }
}
