import { execAsync } from "ags/process"

function ColorPicker() {
  const pickColor = async () => await execAsync("hyprpicker -a -q -f hex")

  return (
    <box>
      <button onClicked={pickColor}>
        <image iconName="color-select-symbolic" />
      </button>
    </box>
  )
}

export default ColorPicker
