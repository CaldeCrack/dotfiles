import { createPoll } from "ags/time"
import { Gtk } from "ags/gtk4"

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
