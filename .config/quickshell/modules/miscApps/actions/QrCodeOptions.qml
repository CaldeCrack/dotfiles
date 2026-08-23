pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.config

Column {
    id: root

    // Scanning needs slurp's full-screen overlay, same as the color
    // picker/OCR — the popup has to actually be gone first, and that
    // delay-then-execDetached orchestration lives in MiscAppsPanel.qml
    // (runAfterDismiss), not here. This view just reports the request.
    signal scanRequested(string command)
    signal escapePressed

    readonly property string _generateScript: Quickshell.shellDir + "/services/scripts/generate-qr.sh"
    readonly property string _scanQrScript: Quickshell.shellDir + "/services/scripts/scan-qr.sh"
    // Mirrors generate-qr.sh's own default — only diverges if you set
    // QR_SAVE_DIR for the script without updating this too.
    readonly property string _saveDir: Quickshell.env("HOME") + "/Pictures/QRCodes"

    // Path of the most recently generated code this session — populated
    // by _generate() itself (not read back from the script, since
    // execDetached gives no way to do that), so "Open file" only appears
    // once there's actually something to open.
    property string _lastGeneratedPath: ""

    // Separate from _lastGeneratedPath on purpose: dismissing the inline
    // preview (the X button) should only hide the thumbnail, not affect
    // "Open Generated File" — that button should keep working regardless
    // of whether the visual preview was closed.
    property string _previewPath: ""
    property bool _previewDismissed: false

    width: 260
    spacing: 8

    function _shellQuote(str) {
        return "'" + String(str).replace(/'/g, "'\\''") + "'";
    }

    // Same timestamp format Recording.qml already uses for its own
    // filenames — kept consistent rather than inventing a second format.
    function _timestamp() {
        const d = new Date();
        const pad = n => (n < 10 ? "0" : "") + n;
        return d.getFullYear() + "-" + pad(d.getMonth() + 1) + "-" + pad(d.getDate()) + "_" + pad(d.getHours()) + "-" + pad(d.getMinutes()) + "-" + pad(d.getSeconds());
    }

    // Unlike Scan, Generate has no slurp/screen-capture race to work
    // around — qrencode runs headlessly — so this fires immediately and
    // doesn't dismiss the popup, letting you generate several codes in a
    // row without reopening it each time.
    function _generate() {
        const text = textArea.text;
        if (text.trim().length === 0)
            return;

        const timestamp = _timestamp();
        root._lastGeneratedPath = root._saveDir + "/qr_" + timestamp + ".png";

        Quickshell.execDetached(["sh", "-c", "printf '%s' " + _shellQuote(text) + " | bash " + _shellQuote(_generateScript) + " " + _shellQuote(timestamp)]);

        // Hide any previous preview immediately, then point the Image at
        // the new file only after a short delay — execDetached is
        // fire-and-forget, so there's no way to know exactly when
        // qrencode finishes writing it, and Image won't retry a source
        // that failed to load the instant it was set. Same fixed-delay
        // reasoning as the dismiss-then-act pattern elsewhere in this
        // shell, just local to this view rather than routed through
        // MiscAppsPanel.qml's runAfterDismiss (nothing here needs the
        // popup dismissed first).
        root._previewPath = "";
        previewLoadDelay.restart();
    }

    Timer {
        id: previewLoadDelay
        interval: 500
        repeat: false
        onTriggered: {
            root._previewPath = root._lastGeneratedPath;
            root._previewDismissed = false;
        }
    }

    // --- scan --------------------------------------------------------------
    ActionButton {
        width: root.width
        label: "Scan QR Code"
        onClicked: root.scanRequested(root._scanQrScript)
    }

    Text {
        width: root.width
        text: "Or enter text to generate a QR code"
        color: Colors.md3.on_surface_variant
        font.pixelSize: 11
    }

    // --- generate ------------------------------------------------------------
    // Fixed-size multi-line box — TextEdit has no drag-resize handle to
    // begin with, so "textarea without the resizing" just means this:
    // wraps and scrolls internally, doesn't grow.
    Item {
        id: textAreaWrap
        width: root.width
        height: 96

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: Colors.md3.surface_container
        }

        Text {
            id: placeholderText
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 8
            text: "Text to encode..."
            color: Colors.md3.on_surface_variant
            font.pixelSize: 12
            visible: textArea.text.length === 0
        }

        Flickable {
            anchors.fill: parent
            anchors.margins: 8
            clip: true
            contentWidth: width
            contentHeight: textArea.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            TextEdit {
                id: textArea
                width: parent.width
                wrapMode: TextEdit.Wrap
                color: Colors.md3.on_surface
                font.pixelSize: 12
                selectByMouse: true

                // Full-area I-beam + native click/focus/cursor-position
                // handling — only meaningful once there's real text to
                // click into. While empty, emptyGuard below takes over
                // instead, so hovering/clicking blank space in the box
                // doesn't act like part of the input.
                HoverHandler {
                    cursorShape: Qt.IBeamCursor
                    enabled: textArea.text.length > 0
                }

                // Same explicit-forward pattern as ClipboardOptions.qml's
                // search field — Escape isn't guaranteed to bubble back
                // up through NavStack's Loader to DismissablePopup's own
                // handler once this has active focus.
                Keys.onEscapePressed: root.escapePressed()
            }
        }

        MouseArea {
            id: emptyGuard
            anchors.fill: parent
            visible: textArea.text.length === 0
            enabled: visible
            hoverEnabled: true
            cursorShape: Qt.IBeamCursor
            onClicked: textArea.forceActiveFocus()
        }
    }

    Row {
        width: root.width
        spacing: 8

        ActionButton {
            width: root.width - 32 - 8
            label: "Generate"
            onClicked: root._generate()
        }

        IconButton {
            iconName: "common/folder-open"
            tooltipText: "Open save folder"
            onClicked: Quickshell.execDetached(["xdg-open", root._saveDir])
        }
    }

    // --- preview -----------------------------------------------------------
    // Fixed square, not full-width like ClipboardOptions.qml's image rows
    // — those are arbitrary-aspect clipboard images where full-width
    // made sense; a QR code is always square, so stretching it to 260
    // wide would just look wrong.
    Item {
        id: previewOuter
        width: root.width
        height: 160
        visible: root._previewPath !== "" && !root._previewDismissed

        Item {
            id: previewBox
            anchors.centerIn: parent
            width: 160
            height: 160

            readonly property bool hovered: previewHover.hovered

            HoverHandler {
                id: previewHover
            }

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                source: root._previewPath !== "" ? Qt.resolvedUrl(root._previewPath) : ""
            }

            IconButton {
                visible: previewBox.hovered
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 4
                iconName: "common/x"
                tooltipText: "Dismiss preview"
                onClicked: root._previewDismissed = true
            }
        }
    }

    ActionButton {
        width: root.width
        label: "Open QR Image"
        visible: root._lastGeneratedPath !== ""
        onClicked: Quickshell.execDetached(["xdg-open", root._lastGeneratedPath])
    }

    // Shared by the full-width text buttons above — nothing else here
    // needs its own variant, so this stays a single local component
    // rather than several near-identical ones.
    component ActionButton: Item {
        id: button

        property string label: ""
        signal clicked

        implicitHeight: 32
        readonly property bool hovered: mouseArea.containsMouse

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: button.hovered ? Colors.md3.surface_container_high : Colors.md3.surface_container

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: button.label
            color: Colors.md3.on_surface
            font.pixelSize: 12
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }

    // Icon-only square button — the folder-open button next to Generate.
    component IconButton: Item {
        id: iconButton

        property string iconName: ""
        property string tooltipText: ""
        signal clicked

        readonly property bool hovered: mouseArea.containsMouse

        implicitWidth: 32
        implicitHeight: 32

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: iconButton.hovered ? Colors.md3.surface_container_high : Colors.md3.surface_container

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Icon {
            anchors.centerIn: parent
            name: iconButton.iconName
            size: 16
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: iconButton.clicked()
        }

        Tooltip {
            target: iconButton
            text: iconButton.tooltipText
        }
    }
}
