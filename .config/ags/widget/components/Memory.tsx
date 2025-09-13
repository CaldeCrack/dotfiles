import { Gtk } from "ags/gtk4"
import { With, createState } from "ags"
import { execAsync } from "ags/process"

function Memory() {
  const [usage, setUsage] = createState({ percent: 0, used: 0, total: 0 })

  const readMeminfo = async () => {
    const out = await execAsync("cat /proc/meminfo")
    const lines = Object.fromEntries(
      out.split("\n")
        .filter(Boolean)
        .map(l => {
          const [key, val] = l.split(":")
          return [key.trim(), parseInt(val)]
        })
    )

    const total = lines["MemTotal"]
    const free = lines["MemFree"] + lines["Buffers"] + lines["Cached"]
    const used = total - free
    const percent = (used / total) * 100

    setUsage({ percent, used, total })
  }

  setInterval(readMeminfo, 3000)
  readMeminfo()

  return (
    <box>
      <menubutton>
        <With value={usage}>
          {({ percent }) =>
            <box>
              <image iconName="drive-harddisk-symbolic" />
              <label label={` ${percent.toFixed(0).padStart(2, " ")}%`} />
            </box>
          }
        </With>
        <popover>
          <With value={usage}>
            {({ percent, used, total }) => {
              const usedGB = (used / 1024 / 1024).toFixed(1)
              const totalGB = (total / 1024 / 1024).toFixed(1)
              return (
                <box orientation={Gtk.Orientation.VERTICAL} halign={Gtk.Align.START}>
                  <box halign={Gtk.Align.START}>
                    <label
                      xalign={0}
                      label="RAM: "
                    />
                    <overlay>
                      <levelbar
                        widthRequest={100}
                        value={percent / 100}
                      />
                      <label
                        $type="overlay"
                        css="color: #000000;"
                        label={`${percent.toFixed(0)}%`}
                      />
                    </overlay>
                  </box>
                  <label label={`${usedGB} GB / ${totalGB} GB`} xalign={0} />
                </box>
              )
            }}
          </With>
        </popover>
      </menubutton>
    </box>
  )
}

export default Memory
