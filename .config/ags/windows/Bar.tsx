// --- Components ---
import LeftBar from "./components/LeftBar"
import CenterBar from "./components/CenterBar"
import RightBar from "./components/RightBar"

function Bar() {
  return (
    <centerbox>
      <LeftBar />
      <CenterBar />
      <RightBar />
    </centerbox>
  )
}

export default Bar
