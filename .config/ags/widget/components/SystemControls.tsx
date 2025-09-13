import { With, createBinding } from "ags"
import { Gtk } from "ags/gtk4"

// --- Audio ---
// @ts-ignore
import WirePlumber from "gi://AstalWp"
// @ts-ignore
import Battery from "gi://AstalBattery"
const battery = Battery.get_default()

// --- Services ---
// @ts-ignore
import brightness from "../../services/brightness.js"


// AUDIO WIDGETS
function AudioIcon() {
  const { defaultSpeaker: speaker } = WirePlumber.get_default()!
  const volumeBinding = createBinding(speaker, "volume")
  const device = createBinding(speaker, "device")

  const volumeIcon = (formFactor: string) => volumeBinding(v => {
    const headphones = formFactor === "internal" ? "" : "-headphones"
    if (v === 0) return `audio-volume-muted${headphones}-symbolic`
    if (formFactor !== "internal") return `audio-headset-symbolic`
    if (v <= 0.33) return "audio-volume-low-symbolic"
    if (v <= 0.66) return "audio-volume-medium-symbolic"
    return "audio-volume-high-symbolic"
  })

  return (
    <With value={device}>
      {device => device && <image iconName={volumeIcon(device.formFactor)} />}
    </With>
  )
}

function AudioSlider() {
  const { defaultSpeaker: speaker } = WirePlumber.get_default()!
  const volumeBinding = createBinding(speaker, "volume")
  return (
    <box>
      <image iconName="audio-volume-high-symbolic" />
      <slider
        widthRequest={100}
        value={volumeBinding}
        onChangeValue={({ value }) => speaker.set_volume(value)}
      />
      <With value={volumeBinding}>
        {v => <label xalign={0} label={` ${Math.round(v * 100)}%`} />}
      </With>
    </box>
  )
}

// BRIGHTNESS WIDGETS
function BrightnessIcon() {
  const backlight = createBinding(brightness, "screen-value")
  const getIconName = (percent: number) => {
    if (percent <= 0.05) return "display-brightness-off-symbolic"
    if (percent <= 0.33) return "display-brightness-low-symbolic"
    if (percent <= 0.66) return "display-brightness-medium-symbolic"
    return "display-brightness-high-symbolic"
  }

  return (
    <With value={backlight}>
      {bright => bright && <image iconName={getIconName(bright)} />}
    </With>
  )
}

function BrightnessSlider() {
  const backlight = createBinding(brightness, "screen-value")
  return (
    <box>
      <image iconName="display-brightness-high-symbolic" />
      <slider
        widthRequest={100}
        value={backlight}
        min={0.01}
        max={1.00}
        step={0.01}
        onChangeValue={({ value }) => {
          if (Math.abs(brightness.screen_value - value) > 0.005) {
            brightness.screen_value = value
          }
        }}
      />
      <With value={backlight}>
        {v => <label xalign={0} label={` ${Math.round(v * 100)}%`} />}
      </With>
    </box>
  )
}

// BATTERY WIDGETS
function BatteryIcon() {
  const batteryState = createBinding(
    battery,
    "state"
  )((p) => getBatteryState(p))

  const getBatteryState = (state: Battery.State) => {
    switch (state) {
      case Battery.State.CHARGING:
        return "Charging"
      case Battery.State.DISCHARGING:
        return "Discharging"
      case Battery.State.EMPTY:
        return "Empty"
      case Battery.State.FULLY_CHARGED:
        return "Full"
      case Battery.State.PENDING_CHARGE:
        return "Pending charge"
      case Battery.State.PENDING_DISCHARGE:
        return "Pending discharge"
      default:
        return "Unknown"
    }
  }

  const getIconName = (state: string) => createBinding(battery, "percentage")(p => {
    const level = Math.min(100, Math.max(0, Math.round(p * 100)))
    const rounded = Math.floor(level / 10) * 10
    const padded = String(rounded).padStart(3, "0")

    let suffix = ""
    if (state === "Charging")
      suffix = "-charging"

    return `battery-${padded}${suffix}-symbolic`
  })

  return (
    <With value={batteryState}>
      {state => <image iconName={getIconName(state)} />}
    </With>
  )
}

function BatterySlider() {
  const percentBinding = createBinding(battery, "percentage")

  return (
    <box>
      <image iconName="battery-100-symbolic" />
      <With value={percentBinding}>
        {p => (
          <levelbar
            css="padding: 3px 4px;"
            widthRequest={100}
            minValue={0}
            maxValue={1}
            value={p}
          />
        )}
      </With>
      <With value={percentBinding}>
        {p => <label xalign={0} label={` ${Math.round(p * 100)}%`} />}
      </With>
    </box>
  )
}

function SystemControls() {
  return (
    <menubutton>
      <box spacing={8}>
        <box>
          <AudioIcon />
        </box>
        <box>
          <BrightnessIcon />
        </box>
        <box>
          <BatteryIcon />
        </box>
      </box>

      <popover>
        <box orientation={Gtk.Orientation.VERTICAL}>
          <box css="margin-bottom: -7px;">
            <AudioSlider />
          </box>
          <box>
            <BrightnessSlider />
          </box>
          <box>
            <BatterySlider />
          </box>
        </box>
      </popover>
    </menubutton>
  )
}

export default SystemControls
