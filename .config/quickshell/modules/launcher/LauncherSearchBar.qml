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
    signal submitted      // Enter — caller activates the top result
    signal escapePressed  // Escape — caller closes the launcher

    implicitHeight: 44

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: Colors.md3.surface_container_high
    }

    Icon {
        id: searchIcon
        name: "search/search"
        size: 18
        color: Colors.md3.on_surface_variant
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    // List/grid toggle — pinned to the far right per spec.
    Item {
        id: toggleWrap
        width: 22
        height: 22
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter

        Icon {
            anchors.fill: parent
            // Shows the icon for the CURRENTLY ACTIVE mode, not the one
            // you'd switch to — consistent with how a toggle usually
            // communicates state rather than the destination action.
            name: root.layoutMode === "list" ? "search/layout-list" : "search/layout-grid"
            color: Colors.md3.on_surface_variant
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.layoutMode = root.layoutMode === "list" ? "grid" : "list";
            }
        }
    }

    // Clear ("x") button — only takes up space once there's text to
    // clear, animated so the input's right edge doesn't jump when it
    // appears/disappears.
    Item {
        id: clearWrap
        width: input.text.length > 0 ? 18 : 0
        height: 18
        anchors.right: toggleWrap.left
        anchors.rightMargin: input.text.length > 0 ? 10 : 0
        anchors.verticalCenter: parent.verticalCenter
        clip: true
        visible: width > 0

        Icon {
            anchors.fill: parent
            name: "common/x"
            color: Colors.md3.on_surface_variant
        }

        MouseArea {
            anchors.fill: parent
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

        onTextChanged: root.queryChanged(text)
        onAccepted: root.submitted()

        Keys.onEscapePressed: root.escapePressed()

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
