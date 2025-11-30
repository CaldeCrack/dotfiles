import { createState } from "ags"
import Gtk from "gi://Gtk?version=4.0";

interface Props {
  boxWidget: any;
  popoverContent: any;
}

function MenuRevealer({
  boxWidget,
  popoverContent
}: Props) {
  const [reveal, setReveal] = createState(false)

  return (
    <menubutton>
      {boxWidget}
      <popover onShow={() => setReveal(true)} onHide={() => setReveal(false)}>
        <revealer
          transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
          transitionDuration={250}
          revealChild={reveal}
        >
          {popoverContent}
        </revealer>
      </popover>
    </menubutton>
  )
}

export default MenuRevealer
