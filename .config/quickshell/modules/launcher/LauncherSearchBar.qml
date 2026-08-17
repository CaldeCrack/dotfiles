import QtQuick
import qs.config
import qs.widgets

// LauncherSearchBar
// ------------------
// Search icon (left) — text input — clear button — list/grid toggle
// (right). Anchors-based rather than a Row: the input needs to flex to
// fill whatever space is left after the fixed-width icon/clear/toggle
// elements, which a plain Row can't express, and Widgets_reference
// already flags Row + childrenRect as unreliable for anything beyond
// a single plain child — anchoring the TextInput between two fixed
// siblings sidesteps that class of problem entirely.
//
// Query-prefix mode detection ("=" for calc, "/" for keybinds) is left
// to the caller (Launcher.qml) via queryChanged — this component only
// owns the bar's look and raw text, same "widgets own look, caller owns
// behavior" split the rest of widgets/ follows.

Item {
    id: root

    property alias text: input.text
    // TODO: once a `launcher` block exists in config.json, seed this
    // from Settings.launcher.defaultLayoutMode instead of hardcoding,
    // and persist changes back the same way ConfigLoader does elsewhere.
    property string layoutMode: "list" // "list" | "grid"

    signal queryChanged(string query)
    // No custom layoutModeChanged signal — QML already auto-generates one
    // for the `layoutMode` property declaration above; declaring a second
    // one with the same name is a duplicate-signal error. Callers should
    // just bind to `searchBar.layoutMode` directly (LauncherResults
    // already does).
    signal submitted      // Enter — caller activates the current selection
    signal escapePressed  // Escape — caller closes the launcher
    signal navigateUp
    signal navigateDown
    signal navigateLeft   // only forwarded while layoutMode is "grid"
    signal navigateRight  // only forwarded while layoutMode is "grid"

    implicitHeight: 44

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Colors.md3.surface_container
    }

    Icon {
        id: searchIcon
        name: "search/search"
        size: 24
        color: Colors.md3.on_surface_variant
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    // List/grid toggle — pinned to the far right per spec.
    Item {
        id: toggleWrap
        width: 36
        height: 36
        implicitWidth: width
        implicitHeight: height
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter

        property bool hovered: toggleHover.containsMouse

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: toggleHover.containsMouse ? Colors.md3.surface_container_highest : "transparent"
        }

        Icon {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            name: root.layoutMode === "list" ? "search/layout-list" : "search/layout-grid"
            color: Colors.md3.on_surface_variant
            size: 24
        }

        MouseArea {
            id: toggleHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.layoutMode = root.layoutMode === "list" ? "grid" : "list";
            }
        }
    }

    Tooltip {
        text: root.layoutMode === "list" ? "List layout" : "Grid layout"
        target: toggleWrap
    }

    // Clear ("x") button — only takes up space once there's text to
    // clear, animated so the input's right edge doesn't jump when it
    // appears/disappears.
    Item {
        id: clearWrap
        width: input.text.length > 0 ? 36 : 0
        height: 36
        implicitWidth: width
        implicitHeight: height
        anchors.right: toggleWrap.left
        anchors.rightMargin: input.text.length > 0 ? 4 : 0
        anchors.verticalCenter: parent.verticalCenter
        clip: true
        visible: width > 0

        property bool hovered: clearHover.containsMouse

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: clearHover.containsMouse ? Colors.md3.surface_container_highest : "transparent"
        }

        Icon {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            name: "common/x"
            color: Colors.md3.on_surface_variant
            size: 24
        }

        MouseArea {
            id: clearHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                input.text = "";
                input.forceActiveFocus();
            }
        }

        Behavior on width {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
    }

    Tooltip {
        text: "Clear"
        target: clearWrap
    }

    TextInput {
        id: input
        anchors.left: searchIcon.right
        anchors.leftMargin: 10
        anchors.right: clearWrap.left
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        color: Colors.md3.on_surface
        font.pixelSize: 16
        clip: true
        selectByMouse: true

        HoverHandler {
            cursorShape: Qt.IBeamCursor
        }

        onTextChanged: root.queryChanged(text)
        onAccepted: root.submitted()

        Keys.onEscapePressed: root.escapePressed()

        // Up/down always mean "move selection" — plain TextInput is
        // single-line and never does anything with them itself, so
        // there's no native behavior to preserve.
        Keys.onUpPressed: function (event) {
            root.navigateUp();
            event.accepted = true;
        }
        Keys.onDownPressed: function (event) {
            root.navigateDown();
            event.accepted = true;
        }
        // Left/right are different: TextInput uses them natively to move
        // the text cursor, which matters while actually typing a query.
        // Only steal them in grid mode, where left/right selection is the
        // whole point — event.accepted = false in list mode lets the
        // keypress fall through to TextInput's own cursor handling
        // exactly as if this handler weren't here.
        Keys.onLeftPressed: function (event) {
            if (root.layoutMode === "grid") {
                root.navigateLeft();
                event.accepted = true;
            } else {
                event.accepted = false;
            }
        }
        Keys.onRightPressed: function (event) {
            if (root.layoutMode === "grid") {
                root.navigateRight();
                event.accepted = true;
            } else {
                event.accepted = false;
            }
        }

        // Placeholder — plain TextInput has no built-in placeholderText,
        // unlike QtQuick.Controls' TextField. Shown whenever the field is
        // empty, focused or not: the launcher force-focuses the input the
        // moment it opens, so gating this on !activeFocus meant it could
        // never actually be seen.
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "Search apps, = to calculate, / for keybinds"
            color: Colors.md3.on_surface_variant
            visible: input.text.length === 0
        }
    }

    function forceActiveFocus() {
        input.forceActiveFocus();
    }
}
