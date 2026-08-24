import QtQuick

import qs.config

// Dropdown
// --------
// Generic single-select dropdown. No popup/overlay involved — the
// option list expands inline below the header and pushes whatever's
// below it down, same mechanism WifiSection/BluetoothSection already
// use for their network/device lists. Chosen over nesting another
// DismissablePopup (a second full-screen overlay window stacked on top
// of one that's already open) since that gets complicated fast for
// what's fundamentally a small in-form control.
//
// One-way contract, same as Slider: never writes `value` itself, only
// emits `selected(newValue)` — the caller decides what to do with it.
//
// Usage:
//   Dropdown {
//       options: [
//           { value: "low", label: "Low" },
//           { value: "normal", label: "Normal" },
//           { value: "critical", label: "Critical" }
//       ]
//       value: "low"
//       onSelected: newValue => urgency = newValue
//   }

Item {
    id: root

    property var options: [] // [{ value, label }]
    property var value: null
    property real headerHeight: 34
    property real rowHeight: 30

    signal selected(var newValue)

    property bool expanded: false

    readonly property var selectedOption: options.find(o => o.value === root.value) ?? null

    implicitHeight: headerHeight + (expanded ? options.length * rowHeight : 0)
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.headerHeight

        topLeftRadius: 8
        topRightRadius: 8
        bottomLeftRadius: root.expanded ? 0 : 8
        bottomRightRadius: root.expanded ? 0 : 8

        color: Colors.md3.surface_container_high
        border.color: Colors.md3.outline_variant
        border.width: 1

        Text {
            font.pixelSize: 12
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.md3.on_surface
            text: root.selectedOption ? root.selectedOption.label : ""
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 13
            color: Colors.md3.on_surface_variant
            text: root.expanded ? "\uf107" : "\uf105"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expanded = !root.expanded
        }
    }

    Item {
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.expanded ? options.length * root.rowHeight : 0
        clip: true

        Column {
            width: parent.width

            Repeater {
                model: root.options

                delegate: Rectangle {
                    id: optionRow
                    required property var modelData
                    required property int index
                    width: parent.width
                    height: root.rowHeight

                    topLeftRadius: 0
                    topRightRadius: 0
                    bottomLeftRadius: index === root.options.length - 1 ? 8 : 0
                    bottomRightRadius: index === root.options.length - 1 ? 8 : 0

                    color: optionRow.modelData.value === root.value ? Colors.md3.surface_container_highest : optionMouse.containsMouse ? Colors.md3.surface_container_high : Colors.md3.surface_container

                    Text {
                        font.pixelSize: 12
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        color: Colors.md3.on_surface
                        text: optionRow.modelData.label
                    }

                    MouseArea {
                        id: optionMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.value = optionRow.modelData.value;
                            root.selected(optionRow.modelData.value);
                            root.expanded = false;
                        }
                    }

                    // Separator below every option except the last one.
                    Rectangle {
                        visible: optionRow.index < root.options.length - 1

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        height: 1
                        color: Colors.md3.outline_variant
                    }
                }
            }
        }
    }
}
