// --- Components ---
import Arch from "./components/Arch"
import Temperature from "./components/Temperature"
import CPU from "./components/CPU"
import Memory from "./components/Memory"
import Workspaces from "./components/Workspaces"

function LeftBar() {
  return (
    <box $type="start">
      <Arch />
      <Temperature />
      <CPU />
      <Memory />
      <Workspaces />
    </box>
  )
}

export default LeftBar
