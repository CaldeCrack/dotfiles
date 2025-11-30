import { createPoll } from "ags/time"
import Gtk from "gi://Gtk?version=4.0"
import MenuRevealer from "../../widgets/MenuRevealer"


function Time() {
  return (
    <MenuRevealer
      boxWidget={
        <box>
          <label label={createPoll("", 1000, "date +'%H:%M - %A %d'")} />
        </box>
      }
      popoverContent={<Gtk.Calendar />}
    />
  )
}

export default Time
