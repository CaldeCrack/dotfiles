import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.config as Config
import qs.services as Services

// Big section (right side) of the Time tab — a month calendar.
//
// As of Qt 6.6, MonthGrid/DayOfWeekRow/Calendar graduated out of the old
// Qt.labs.calendar incubation module straight into QtQuick.Controls, so
// there's no hand-rolled grid math needed here — just a custom delegate to
// match the shell's own color scheme instead of the default Controls style.
Item {
    id: root

    // Small circular hover button used for month/year navigation, both in
    // the header and inside the picker popup — background tints on hover
    // rather than the glyph itself, and the hit target is the full circle
    // rather than just the glyph's tight text bounds.
    component ArrowButton: Item {
        id: arrowButton

        property string glyph
        signal clicked

        implicitWidth: 32
        implicitHeight: 32

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: arrowMouse.containsMouse ? Config.Colors.md3.surface_container_highest : "transparent"
        }

        Text {
            anchors.centerIn: parent
            text: arrowButton.glyph
            font.pixelSize: 20
            color: Config.Colors.md3.on_surface_variant
        }

        MouseArea {
            id: arrowMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: arrowButton.clicked()
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Config.Colors.md3.surface_container
        border.color: Config.Colors.md3.primary
    }

    // Bound reactively to the real current month/year until the user
    // navigates away — the first manual assignment converts this from a
    // live binding into a static value (same one-way-binding behavior
    // noted elsewhere in this project, e.g. DismissablePopup's `open`),
    // which is exactly what's wanted here: it tracks "now" until you
    // deliberately look at a different month.
    property int displayMonth: Services.Time.dateTime.getMonth()
    property int displayYear: Services.Time.dateTime.getFullYear()

    // Pure data mutation, no animation/side effects — callers wrap these
    // (or an equivalent inline function) with gridContainer.animatedNavigate
    // for the slide transition.
    function goToPreviousMonth() {
        if (displayMonth === 0) {
            displayMonth = 11;
            displayYear -= 1;
        } else {
            displayMonth -= 1;
        }
    }

    function goToNextMonth() {
        if (displayMonth === 11) {
            displayMonth = 0;
            displayYear += 1;
        } else {
            displayMonth += 1;
        }
    }

    // ---- Month/year picker popup -----------------------------------------

    Popup {
        id: monthYearPicker

        parent: root
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        // Year being browsed within the popup — independent from
        // root.displayYear until a month is actually picked, so browsing
        // years in the popup doesn't affect the calendar behind it.
        property int pickerYear: root.displayYear

        onOpened: pickerYear = root.displayYear

        background: Rectangle {
            radius: 12
            color: Config.Colors.md3.surface_container_high
            border.color: Config.Colors.md3.outline_variant
        }

        contentItem: ColumnLayout {
            spacing: 12

            RowLayout {
                Layout.fillWidth: true

                ArrowButton {
                    glyph: ""
                    onClicked: monthYearPicker.pickerYear -= 1
                }

                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: monthYearPicker.pickerYear
                    color: Config.Colors.md3.on_surface
                    font.pixelSize: 16
                    font.bold: true
                }

                ArrowButton {
                    glyph: ""
                    onClicked: monthYearPicker.pickerYear += 1
                }
            }

            GridLayout {
                columns: 3
                rowSpacing: 8
                columnSpacing: 8

                Repeater {
                    model: 12

                    delegate: Rectangle {
                        id: monthCell

                        required property int index

                        readonly property bool isSelected: index === root.displayMonth && monthYearPicker.pickerYear === root.displayYear

                        implicitWidth: 64
                        implicitHeight: 36
                        radius: 8
                        color: isSelected ? Config.Colors.md3.primary : (monthCellMouse.containsMouse ? Config.Colors.md3.surface_container_highest : "transparent")

                        Text {
                            anchors.centerIn: parent
                            text: Qt.locale().standaloneMonthName(monthCell.index, Locale.ShortFormat)
                            color: monthCell.isSelected ? Config.Colors.md3.on_primary : Config.Colors.md3.on_surface
                        }

                        MouseArea {
                            id: monthCellMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                const targetMonth = monthCell.index;
                                const targetYear = monthYearPicker.pickerYear;
                                const currentTotal = root.displayYear * 12 + root.displayMonth;
                                const targetTotal = targetYear * 12 + targetMonth;
                                const direction = targetTotal === currentTotal ? 0 : (targetTotal > currentTotal ? 1 : -1);

                                monthYearPicker.close();

                                if (direction === 0)
                                    return; // already viewing this month

                                gridContainer.animatedNavigate(direction, function () {
                                    root.displayMonth = targetMonth;
                                    root.displayYear = targetYear;
                                });
                            }
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        // ---- Header: prev arrow / month-year title / next arrow ---------
        // The title is flanked by two Layout.fillWidth spacers rather than
        // filling the row itself, so it only takes the width its own text
        // actually needs while staying centered between the two arrows.

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ArrowButton {
                glyph: ""
                onClicked: gridContainer.animatedNavigate(-1, root.goToPreviousMonth)
            }

            Item {
                Layout.fillWidth: true
            }

            Item {
                id: titlePill

                implicitWidth: titleText.implicitWidth + 24
                implicitHeight: titleText.implicitHeight + 10

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: titleMouse.containsMouse ? Config.Colors.md3.surface_container_highest : "transparent"
                }

                Text {
                    id: titleText
                    anchors.centerIn: parent
                    text: Qt.locale().monthName(root.displayMonth) + " " + root.displayYear
                    color: Config.Colors.md3.on_surface
                    font.pixelSize: 18
                    font.bold: true
                }

                MouseArea {
                    id: titleMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: monthYearPicker.open()
                }
            }

            Item {
                Layout.fillWidth: true
            }

            ArrowButton {
                glyph: ""
                onClicked: gridContainer.animatedNavigate(1, root.goToNextMonth)
            }
        }

        // ---- Weekday header ------------------------------------------------

        DayOfWeekRow {
            id: dayOfWeekRow

            Layout.fillWidth: true
            locale: monthGrid.locale

            delegate: Text {
                required property string shortName

                text: shortName
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Config.Colors.md3.on_surface_variant
                font.pixelSize: 12
            }
        }

        // ---- Month grid, with slide transition on navigation --------------

        Item {
            id: gridContainer

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            property bool transitioning: false

            // MonthGrid has no "old"/"new" state of its own to animate
            // between — it just redraws instantly when month/year change.
            // So the outgoing frame is captured as a still image (ghost)
            // right before the change, the real grid is updated and parked
            // off-screen on the incoming side, then both are animated
            // simultaneously: ghost slides out, the real grid slides in.
            //
            // direction: -1 = previous (content slides right), 1 = next
            // (content slides left). changeFn actually mutates
            // root.displayMonth/displayYear. Used by both the header arrows
            // and the picker popup's month selection.
            function animatedNavigate(direction, changeFn) {
                if (transitioning)
                    return;

                transitioning = true;

                monthGrid.grabToImage(function (result) {
                    ghost.source = result.url;
                    ghost.x = 0;
                    ghost.visible = true;

                    changeFn(); // monthGrid redraws now, hidden behind ghost

                    monthGrid.x = direction * gridContainer.width;

                    ghostSlideAnim.from = 0;
                    ghostSlideAnim.to = -direction * gridContainer.width;
                    ghostSlideAnim.restart();

                    gridSlideAnim.from = direction * gridContainer.width;
                    gridSlideAnim.to = 0;
                    gridSlideAnim.restart();
                });
            }

            MonthGrid {
                id: monthGrid

                width: parent.width
                height: parent.height

                month: root.displayMonth
                year: root.displayYear
                locale: Qt.locale()

                delegate: Item {
                    id: dayDelegate

                    required property var model

                    opacity: dayDelegate.model.month === monthGrid.month ? 1 : 0.35

                    Rectangle {
                        anchors.centerIn: parent
                        width: 28
                        height: 28
                        radius: width / 2
                        color: dayDelegate.model.today ? Config.Colors.md3.primary : "transparent"
                    }

                    Text {
                        anchors.centerIn: parent
                        text: dayDelegate.model.day
                        color: dayDelegate.model.today ? Config.Colors.md3.on_primary : Config.Colors.md3.on_surface
                        font.pixelSize: 13
                    }
                }
            }

            Image {
                id: ghost

                width: gridContainer.width
                height: gridContainer.height
                visible: false
                cache: false
                asynchronous: false
            }

            NumberAnimation {
                id: ghostSlideAnim
                target: ghost
                property: "x"
                duration: 220
                easing.type: Easing.OutCubic
                onStopped: {
                    ghost.visible = false;
                    gridContainer.transitioning = false;
                }
            }

            NumberAnimation {
                id: gridSlideAnim
                target: monthGrid
                property: "x"
                duration: 220
                easing.type: Easing.OutCubic
            }
        }
    }
}
