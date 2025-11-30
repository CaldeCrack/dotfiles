// --- Components ---
import Clipboard from "./Clipboard"
import Screenshot from "./Screenshot"
import ColorPicker from "./ColorPicker"
import Wifi from "./Wifi"
import Time from "./Time"
import SystemControls from "./SystemControls"

function RightBar() {
  return (
    <box $type="end">
      <Clipboard />
      <Screenshot />
      <ColorPicker />
      <Wifi />
      <SystemControls />
      <Time />
    </box>
  )
}

export default RightBar
