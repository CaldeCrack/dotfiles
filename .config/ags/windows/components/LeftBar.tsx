// --- Components ---
import Arch from "./Arch"
import Temperature from "./Temperature"
import CPU from "./CPU"
import Memory from "./Memory"
import Workspaces from "./Workspaces"

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
