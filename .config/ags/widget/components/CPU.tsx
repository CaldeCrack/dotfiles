import { Gtk } from "ags/gtk4"
import { With, createState } from "ags"
import { execAsync } from "ags/process"

function CPU() {
  const [usage, setUsage] = createState({ total: 0, cores: [] as number[] })
  let lastStats: number[][] | null = null

  const readCPUStats = async (): Promise<number[][]> => {
    const out = await execAsync("cat /proc/stat")
    return out.split("\n")
      .filter((line: string) => line.startsWith("cpu"))
      .map((line: string) => line.trim().split(/\s+/).slice(1).map(Number))
  }

  const updateUsage = async () => {
    const stats = await readCPUStats()
    if (lastStats) {
      const usages = stats.map((curr, i) => {
        const prev = lastStats![i]
        const idleDiff = curr[3] - prev[3]
        const totalDiff = curr.reduce((a, b) => a + b, 0) -
          prev.reduce((a, b) => a + b, 0)
        return totalDiff > 0 ? (1 - idleDiff / totalDiff) * 100 : 0
      })
      setUsage({ total: usages[0], cores: usages.slice(1) })
    }
    lastStats = stats
  }

  const init = async () => {
    lastStats = await readCPUStats()
    updateUsage()
    setInterval(updateUsage, 3000)
  }
  init()

  return (
    <box>
      <menubutton>
        <With value={usage}>
          {({ total }) =>
            <box>
              <image iconName="cpu-symbolic" />
              <label label={` ${total.toFixed(0).padStart(2, " ")}%`} />
            </box>
          }
        </With>
        <popover>
          <With value={usage}>
            {({ cores }) =>
              <box orientation={Gtk.Orientation.VERTICAL} halign={Gtk.Align.START}>
                {cores.map((c, i) =>
                  <box halign={Gtk.Align.START}>
                    <label
                      widthRequest={51}
                      xalign={0}
                      label={`Core ${i}: `}
                    />
                    <overlay>
                      <levelbar
                        widthRequest={100}
                        value={c / 100}
                      />
                      <label
                        $type="overlay"
                        css="color: #000000;"
                        label={`${c.toFixed(0)}%`}
                      />
                    </overlay>
                  </box>
                )}
              </box>
            }
          </With>
        </popover>
      </menubutton>
    </box>
  )
}

export default CPU
