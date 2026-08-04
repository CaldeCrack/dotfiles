pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.config
import qs.modules.miscApps.actions as Actions

DismissablePopup {
    id: root

    // DismissablePopup has no `closed` signal of its own — the animation-
    // aware signal is internal (PanelBase.closed, consumed by
    // DismissablePopup's own `onClosed: root.shown = false`). `shown` is
    // what's exposed externally, and it only flips false after that same
    // close animation finishes, so this still avoids flashing the home
    // view mid-fade.
    onShownChanged: if (!shown)
        nav.reset()

    // For actions that capture the screen or start recording (color
    // picker, screenshot, record): the popup closing isn't actually the
    // problem — dismissRequested() plays PanelBase's normal fade fine.
    // The issue is hyprpicker/hyprshot/wf-recorder starting almost
    // instantly and grabbing the screen before that fade (or the
    // compositor unmapping the surface) has actually finished, which is
    // timing this QML side can't fully guarantee either way. Delaying the
    // command itself with a real sleep in the spawned shell sidesteps
    // that uncertainty entirely, rather than trying to force this window
    // to hide synchronously.
    function runAfterDismiss(command) {
        dismissRequested();
        Quickshell.execDetached(["sh", "-c", "sleep 0.4 && " + command]);
    }

    NavStack {
        id: nav

        Column {
            spacing: 8

            Row {
                spacing: 8

                UtilityButton {
                    iconName: "media/screenshot"
                    label: "Screenshot"
                    onClicked: nav.push(screenshotView, "Screenshot")
                }

                UtilityButton {
                    iconName: "media/record"
                    label: "Record"
                    onClicked: nav.push(recordView, "Record")
                }
            }

            Row {
                spacing: 8

                UtilityButton {
                    iconName: "media/colorpicker"
                    label: "Color Picker"
                    // No sub-view for this one — just fire the picker and
                    // close, same as clicking outside the popup would.
                    onClicked: root.runAfterDismiss("hyprpicker -a -q")
                }

                UtilityButton {
                    iconName: "common/clipboard"
                    label: "Clipboard"
                    onClicked: nav.push(clipboardView, "Clipboard")
                }
            }
        }
    }

    // Sub-views — each button above swaps the popup content for one of
    // these via NavStack. The back arrow + title in the header come from
    // NavStack for free.
    Item {
        Component {
            id: screenshotView

            Actions.ScreenshotOptions {
                onOptionSelected: command => root.runAfterDismiss(command)
            }
        }

        Component {
            id: recordView

            Actions.RecordOptions {
                onOptionSelected: command => root.runAfterDismiss(command)
            }
        }

        Component {
            id: clipboardView
            Text {
                text: "Clipboard options placeholder"
                color: Colors.md3.on_surface
            }
        }
    }

    // Local to this popup's home view — not promoted to widgets/ since
    // nothing outside misc apps needs this exact tile style.
    component UtilityButton: Item {
        id: utilityButton

        signal clicked

        property string iconName: ""
        property string label: ""

        readonly property bool hovered: mouseArea.containsMouse
        readonly property bool pressed: mouseArea.pressed

        implicitWidth: 88
        implicitHeight: 72

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: utilityButton.pressed ? Colors.md3.surface_container_high : utilityButton.hovered ? Colors.md3.surface_container : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 6

            Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                name: utilityButton.iconName
                size: 20
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: utilityButton.label
                color: Colors.md3.on_surface
                font.pixelSize: 11
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: utilityButton.clicked()
        }
    }
}
