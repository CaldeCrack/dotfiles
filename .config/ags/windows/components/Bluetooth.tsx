import { execAsync } from "ags/process"

function Bluetooth() {
  const bluetui = async () => await execAsync("zsh -c 'kitty bluetui'")

  return (
    <box>
      <button onClicked={bluetui}>
        <image iconName="bluetooth-symbolic" />
      </button>
    </box>
  )
}

export default Bluetooth
