import QtQuick
import qs.services as Services

// Deliberately plain right now: no styling beyond basic text, no truncation
// handling for very long titles/albums yet, no fade-in on track change.
// Purpose of this version is purely to confirm Media's properties update
// live off the real mpd-mpris bridge before any of that polish gets added.
Item {
    id: root

    implicitHeight: column.implicitHeight

    Column {
        id: column
        width: parent.width
        spacing: 2

        Text {
            width: parent.width
            text: Services.Media.available ? (Services.Media.title || "Unknown title") : "Nothing playing"
            color: "white"
            font.pixelSize: 18
            font.bold: true
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            visible: Services.Media.available
            text: Services.Media.artist || "Unknown artist"
            color: "#cccccc"
            font.pixelSize: 16
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            visible: Services.Media.available && Services.Media.album.length > 0
            text: Services.Media.album
            color: "#999999"
            font.pixelSize: 14
            elide: Text.ElideRight
        }
    }
}
