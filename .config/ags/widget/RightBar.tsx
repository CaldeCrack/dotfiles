// --- Components ---
import Clipboard from "./components/Clipboard"
import Screenshot from "./components/Screenshot"
import ColorPicker from "./components/ColorPicker"
import Wifi from "./components/Wifi"
import Time from "./components/Time"
import SystemControls from "./components/SystemControls"

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
