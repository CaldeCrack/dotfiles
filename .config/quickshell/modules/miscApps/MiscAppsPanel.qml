pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.widgets
import qs.config
import qs.services
import "actions"

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
    // action itself by a real wall-clock amount sidesteps that
    // uncertainty, rather than trying to force this window to hide
    // synchronously.
    function runAfterDismiss(action) {
        dismissRequested();
        dismissDelay.action = action;
        dismissDelay.restart();
    }

    Item {
        Timer {
            id: dismissDelay
            interval: 400
            repeat: false
            property var action: null
            onTriggered: {
                if (action)
                    action();
                action = null;
            }
        }
    }

    readonly property string _ocrScript: Quickshell.shellDir + "/services/scripts/run-ocr.sh"

    // Jumps straight to a sub-view, bypassing the home grid — used by the
    // IPC handler below (a compositor keybind has already picked which
    // utility it wants, so there's no reason to show the grid first and
    // make the user click again). nav.reset() first so this always lands
    // cleanly on the requested view: if the popup was already open on
    // some other view, "back" from here should lead to home, not to
    // whatever was open before.
    //
    // Setting `open` here directly is safe specifically because
    // MiscAppsButton.qml only ever assigns it imperatively
    // (`popup.open = !popup.open`), never binds it live (`open:
    // someCondition`) — see DismissablePopup's own header comment on why
    // writing to `open` from outside would be unsafe if it did.
    function openView(component, title) {
        open = true;
        nav.reset();
        nav.push(component, title);
    }

    // Compositor keybinds call these via:
    //   qs ipc call miscApps clipboard
    //   qs ipc call miscApps emoji
    //   qs ipc call miscApps glyphs
    // (`qs ipc show` lists them). Only meaningful with a single bar
    // instance — if this shell ever runs a MiscAppsButton/MiscAppsPanel
    // per monitor, every instance would try to register the same
    // "miscApps" target and collide. Fine for now per your "just open it
    // like the nav stack GUI would" ask; flag if multi-monitor bars ever
    // become a thing.
    Item {
        IpcHandler {
            target: "miscApps"

            function clipboard(): void {
                root.openView(clipboardView, "Clipboard");
            }

            function emoji(): void {
                root.openView(emojiView, "Emoji");
            }

            function glyphs(): void {
                root.openView(nerdFontView, "Glyphs");
            }
        }
    }

    NavStack {
        id: nav

        Column {
            spacing: 4

            Row {
                spacing: 4

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
                spacing: 4

                UtilityButton {
                    iconName: "media/colorpicker"
                    label: "Color Picker"
                    // No sub-view for this one — just fire the picker and
                    // close, same as clicking outside the popup would.
                    onClicked: root.runAfterDismiss(() => Quickshell.execDetached(["hyprpicker", "-a", "-q"]))
                }

                UtilityButton {
                    iconName: "common/clipboard"
                    label: "Clipboard"
                    onClicked: nav.push(clipboardView, "Clipboard")
                }
            }

            Row {
                spacing: 4

                UtilityButton {
                    iconName: "common/emoji"
                    label: "Emojis"
                    onClicked: nav.push(emojiView, "Emoji Picker")
                }

                UtilityButton {
                    iconName: "common/nerdfont"
                    label: "Glyphs"
                    onClicked: nav.push(nerdFontView, "Nerd Font Glyphs")
                }
            }

            Row {
                spacing: 4

                UtilityButton {
                    iconName: "media/ocr"
                    label: "OCR"
                    // execDetached, not a tracked Process — a tracked
                    // Process reliably failed to actually launch slurp
                    // here until something else (e.g. a config reload)
                    // kicked the QML engine, while execDetached launches
                    // it immediately and consistently. Feedback happens
                    // inside run-ocr.sh itself (notify-send) as a result,
                    // since execDetached gives QML no way to see the
                    // exit code.
                    onClicked: root.runAfterDismiss(() => Quickshell.execDetached(["bash", root._ocrScript]))
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

            ScreenshotOptions {
                onOptionSelected: command => root.runAfterDismiss(() => Quickshell.execDetached(["sh", "-c", command]))
            }
        }

        Component {
            id: recordView

            RecordOptions {
                // Recording.start() itself is the delayed action here —
                // same reasoning as the screenshot/color-picker commands,
                // just going through the service instead of execDetached.
                onRecordRequested: mode => root.runAfterDismiss(() => Recording.start(mode))
            }
        }

        Component {
            id: clipboardView

            ClipboardOptions {
                // Plain dismiss, no delayed action — copying to the
                // clipboard has no visible-in-capture race to work around
                // like the color picker/screenshot/record actions do.
                onEntrySelected: root.dismissRequested()
                onEscapePressed: root.dismissRequested()
            }
        }

        Component {
            id: emojiView

            EmojiOptions {
                onEntrySelected: root.dismissRequested()
                onEscapePressed: root.dismissRequested()
            }
        }

        Component {
            id: nerdFontView

            NerdFontOptions {
                onEntrySelected: root.dismissRequested()
                onEscapePressed: root.dismissRequested()
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

        implicitWidth: 76
        implicitHeight: 76

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: utilityButton.pressed ? Colors.md3.surface_container_highest : utilityButton.hovered ? Colors.md3.surface_container_high : Colors.md3.surface_container

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
                size: 30
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: utilityButton.label
                color: Colors.md3.on_surface
                font.pixelSize: 12
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
