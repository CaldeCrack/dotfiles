import QtQuick
import qs.config as Config
import qs.widgets as Widgets

// Volume state is passed in from the caller (ExtraActionsColumn, backed by
// the real Audio service). This popup only ever reports what the user did
// via volumeChangeRequested; it doesn't own the real value itself.
Widgets.AnchoredPopup {
    id: root

    property real volume: 50
    property bool muted: false
    property real popupContentWidth: 50

    signal volumeChangeRequested(real newVolume)

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
