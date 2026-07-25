pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias adapter: adapter

    FileView {
        id: fileView

        path: Qt.resolvedUrl("config.json")
        watchChanges: true

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        // If config.json doesn't exist yet (fresh install), write out the defaults below
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: adapter

            property JsonObject bar: JsonObject {
                property int height: 30
                property int margin: 0
                property int spacing: 4
                property int radius: 8
            }

            property JsonObject shortcutsWindow: JsonObject {
                property int horizontalMargin: 24
                property int verticalMargin: 24
            }

            property JsonObject weather: JsonObject {
                property string location: "Santiago"
                property string units: "metric"
            }

            property JsonObject general: JsonObject {
                property string wallpaperDir: "~/Pictures/Wallpapers"
                property string profilePicture: "~/.face"
            }
        }
    }
}
