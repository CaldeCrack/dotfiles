import { Gtk } from "ags/gtk4"
import { execAsync } from "ags/process"

function Screenshot() {
  const runShot = async (mode: string) => {
    try {
      await execAsync(`hyprshot -m ${mode}`)
    } catch (err) {
      print("Screenshot failed:", err)
    }
  }

  return (
    <box>
      <menubutton>
        <image iconName="camera-photo-symbolic" />
        <popover>
          <box
            orientation={Gtk.Orientation.VERTICAL}
            halign={Gtk.Align.START}
          >
            <button onClicked={() => runShot("output")}>
              <box>
                <image iconName="view-fullscreen-symbolic" />
                <label label=" Screen" />
              </box>
            </button>
            <button onClicked={() => runShot("window")}>
              <box>
                <image iconName="window-symbolic" />
                <label label=" Window" />
              </box>
            </button>
            <button onClicked={() => runShot("region")}>
              <box>
                <image iconName="image-crop-symbolic" />
                <label label=" Region" />
              </box>
            </button>
          </box>
        </popover>
      </menubutton>
    </box>
  )
}

export default Screenshot
