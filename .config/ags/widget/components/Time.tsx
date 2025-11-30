import { createPoll } from "ags/time"
import Gtk from "gi://Gtk?version=4.0";


function Time() {
  return (
    <menubutton>
      <box>
        <label label={createPoll("", 1000, "date +'%H:%M - %A %d'")} />
      </box>
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  )
}

export default Time
