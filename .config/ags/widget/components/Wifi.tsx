import { Gtk } from "ags/gtk4"
import { With, createComputed, createBinding } from "ags"
import { execAsync } from "ags/process"
import Network from "gi://AstalNetwork"

function Wifi() {
  const network = Network.get_default()
  const activeAp = createBinding(network.wifi, "activeAccessPoint")

  const wifiData = createComputed([
    createBinding(network, "wifi"),
    createBinding(network.wifi, "accessPoints"),
  ])(() => {
    const wifi = network.wifi
    if (!wifi) return null
    wifi.scan()
    return {
      accessPoints: [...wifi.accessPoints],
      iconName: wifi.iconName,
      activeSsid: wifi.activeAccessPoint?.ssid,
    }
  })

  function getWifiIcon(ap: Network.AccessPoint) {
    const strength = ap.strength || 0
    const encrypted = (ap.flags & 0x1) !== 0
    let level = "none"
    if (strength > 75) level = "excellent"
    else if (strength > 50) level = "good"
    else if (strength > 25) level = "ok"
    else if (strength > 5) level = "weak"

    return `network-wireless-signal-${level}${encrypted && level !== "none" ? "-secure" : ""}-symbolic`
  }

  const sorted = (arr: Array<Network.AccessPoint>) => {
    const seen = new Set()
    return arr
      .filter(ap => !!ap.ssid)
      .sort((a, b) => b.strength - a.strength)
      .filter(ap => {
        const key = ap.ssid.trim().toLowerCase()
        if (seen.has(key)) return false
        seen.add(key)
        return true
      })
      .slice(0, 6)
  }

  function buildOuterBox(ap: Network.AccessPoint) {
    const outerBox = new Gtk.Box()
    const gesture = Gtk.GestureClick.new()
    gesture.set_button(3)
    gesture.connect("released", () => execAsync(["zsh", "-c", "kitty nmtui"]))
    outerBox.add_controller(gesture)

    const img = new Gtk.Image({ icon_name: getWifiIcon(ap) || "network-wireless-signal-none-symbolic" })
    outerBox.append(img)
    return outerBox
  }

  function buildPopover(data: { accessPoints: any; iconName?: string; activeSsid: any }) {
    const box = new Gtk.Box({ orientation: Gtk.Orientation.VERTICAL })
    for (const ap of sorted(data.accessPoints)) {
      const row = new Gtk.Button()
      const hbox = new Gtk.Box()

      hbox.append(new Gtk.Image({ icon_name: getWifiIcon(ap) }))
      hbox.append(new Gtk.Label({ label: ` ${ap.ssid} ` }))
      hbox.append(new Gtk.Image({
        icon_name: "object-select-symbolic",
        visible: ap.ssid === data.activeSsid,
      }))

      row.set_child(hbox)
      box.append(row)

      const rightClick = Gtk.GestureClick.new()
      rightClick.set_button(3)
      rightClick.connect("released", () => console.log("Implement password prompt"))
      row.add_controller(rightClick)
    }

    return box
  }

  return (
    <menubutton>
      <With value={activeAp}>
        {(ap) => ap && buildOuterBox(ap)}
      </With>
      <popover>
        <With value={wifiData}>
          {(data) => data && buildPopover(data)}
        </With>
      </popover>
    </menubutton>
  )
}

export default Wifi
