import QtQuick
import qs.services
import qs.widgets
import qs.config

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

        MarqueeText {
            width: parent.width
            text: Media.available ? (Media.title || "Unknown title") : "Nothing playing"
            color: Colors.md3.on_surface
            font.pixelSize: 18
            font.bold: true
        }

        MarqueeText {
            width: parent.width
            visible: Media.available
            text: Media.artist || "Unknown artist"
            color: Colors.md3.on_surface_variant
            font.pixelSize: 16
        }

        MarqueeText {
            width: parent.width
            visible: Media.available
            text: Media.album || ""
            color: Colors.md3.on_surface_variant
            font.pixelSize: 14
        }
    }
}
