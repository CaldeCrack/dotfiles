import QtQuick

import qs.config as Config
import qs.widgets as Widgets

// BarButtonBase
// --------------
// Shared hover/press/checked styling and click handling for every bar
// button (ClockButton, WeatherButton, SystemStatsButton, PowerButton...).
// Owns the pill-shaped background and its Material-style "state layer"
// (a translucent overlay that darkens/lightens on hover and press), plus
// left/right click signals. Content — icon, text, whatever — is placed
// inside via the default property, same pattern as PanelBase.
//
// Tooltip handling is intentionally NOT built in beyond a single optional
// convenience property (tooltipText), because not every bar button has
// exactly one thing to show a tooltip for. A button like ClockButton has
// one icon, so `tooltipText: "3:45 PM"` is enough. A button like
// SystemStatsButton shows several icons (cpu/gpu/ram/battery) side by
// side, each needing its OWN tooltip — that doesn't fit a single string
// property on the button as a whole. For that case, skip tooltipText
// entirely and nest a widgets/Tooltip.qml per icon inside the button's
// content instead; both approaches use the same Tooltip visual under the
// hood, so they stay consistent.
//
// Usage (simple, single icon):
//   BarButtonBase {
//       tooltipText: "Clock"
//       onClicked: InfoPanel.show(InfoPanel.TimeWeatherTab)
//       Widgets.Icon { name: "clock" }
//   }
//
// Usage (composite, multiple icons/tooltips):
//   BarButtonBase {
//       Row {
//           spacing: 4
//           Widgets.Icon { id: cpuIcon; name: "cpu" }
//           Widgets.Icon { id: ramIcon; name: "ram" }
//       }
//       Widgets.Tooltip { target: cpuIcon; text: cpuUsage + "%" }
//       Widgets.Tooltip { target: ramIcon; text: ramUsage + "%" }
//   }

Item {
    id: root

    // --- content -------------------------------------------------------
    // .data (not .children!) so this accepts both visual Items and
    // non-Item children — specifically Widgets.Tooltip, which is now a
    // PopupWindow, not an Item. As a side benefit, anything landing in
    // .data-but-not-.children (like a Tooltip) is invisible to
    // childrenRect below, so it can't distort this button's auto-sizing.
    default property alias contentChildren: contentRow.data
    readonly property alias contentItem: contentRow

    // --- sizing / appearance ------------------------------------------------------
    property real horizontalPadding: 10
    property real verticalPadding: 6
    property real radius: height / 2

    property color idleColor: Config.Colors.md3.surface
    property color stateLayerColor: checked ? Config.Colors.md3.primary : Config.Colors.md3.on_surface
    property real hoverOpacity: 0.08
    property real pressOpacity: 0.14
    property color checkedBackgroundColor: Config.Colors.md3.primary_container

    // --- state ------------------------------------------------------
    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed
    // For buttons that toggle something open (ControlPanelButton,
    // NotificationsButton...) rather than just firing an action.
    property bool checked: false

    // --- optional single tooltip, see file header for when NOT to use this ------------------------------------------------------
    property string tooltipText: ""

    signal clicked
    signal rightClicked

    // Sizing reads the content's own implicit size directly, rather than
    // going through contentRow.childrenRect — childrenRect turned out not
    // to reliably reflect a Row-wrapped composite child's real size (the
    // single-icon case worked because Icon has its own implicitWidth; a
    // Row wrapping several icons didn't propagate through childrenRect
    // the same way). Icon sets implicitWidth explicitly, and Row computes
    // its own implicitWidth natively as a positioner, so reading straight
    // off whatever's actually in contentRow sidesteps the issue entirely.
    readonly property Item primaryContent: contentRow.children.length > 0 ? contentRow.children[0] : null

    // Square by default (most bar buttons are icon-only) but grows to fit
    // wider content like a clock's text label. Height defaults to the
    // bar's own height so every button lines up regardless of content.
    implicitWidth: Math.max(implicitHeight, (primaryContent ? primaryContent.implicitWidth : 0) + horizontalPadding * 2)
    implicitHeight: Config.Settings.bar.height - 4

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.checked ? root.checkedBackgroundColor : root.idleColor

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    // Material-style state layer: a translucent overlay whose opacity
    // steps up on hover and again on press, independent of the checked
    // background beneath it.
    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.stateLayerColor
        opacity: root.pressed ? root.pressOpacity : (root.hovered ? root.hoverOpacity : 0)

        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                root.rightClicked();
            else
                root.clicked();
        }
    }

    // Declared AFTER mouseArea so content (and any nested per-icon hover
    // areas inside it, for composite buttons) stacks visually on top and
    // gets hover priority. Unaccepted clicks (icon hover areas use
    // acceptedButtons: Qt.NoButton) fall through to mouseArea beneath.
    Item {
        id: contentRow
        anchors.centerIn: parent
        implicitWidth: root.primaryContent ? root.primaryContent.implicitWidth : 0
        implicitHeight: root.primaryContent ? root.primaryContent.implicitHeight : 0
    }

    Widgets.Tooltip {
        target: root
        text: root.tooltipText
    }
}
