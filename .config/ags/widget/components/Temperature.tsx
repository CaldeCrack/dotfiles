import { Gtk } from "ags/gtk4"
import { With, createState } from "ags"
import { execAsync } from "ags/process"

function Temperature() {
  const [temperature, setTemp] = createState("0")

  const updateTemp = async () => {
    const out = await execAsync("cat /sys/class/thermal/thermal_zone0/temp")
    setTemp(out.substring(0, 2))
  }

  const toFahrenheit = (temp: String) => Math.round(Number(temp) * 9 / 5 + 32)
  const toKelvin = (temp: String) => Number(temp) + 273

  const getIcon = (temp: string) => {
    const t = Number(temp)
    if (t < 30) return "temperature-cold-symbolic"
    if (t < 60) return "temperature-normal-symbolic"
    return "temperature-warm-symbolic"
  }

  setInterval(updateTemp, 5000)
  updateTemp()

  return (
    <menubutton>
      <With value={temperature}>
        {(temp) => temp &&
          <box>
            <image iconName={getIcon(temp)} />
            <label label={`${temp}°C`} />
          </box>
        }
      </With>
      <popover>
        <With value={temperature}>
          {(temp) => temp &&
            <box orientation={Gtk.Orientation.VERTICAL}>
              <label label={`${toFahrenheit(temp)}°F`} />
              <label label={`${toKelvin(temp)}K`} />
            </box>
          }
        </With>
      </popover>
    </menubutton>
  )
}

export default Temperature
