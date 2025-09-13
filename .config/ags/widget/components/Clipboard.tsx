import { Gtk } from "ags/gtk4"
import { With, createState } from "ags"
import { execAsync } from "ags/process"


function Clipboard() {
  const [history, setHistory] = createState<string[]>([])

  const checkClipboard = async () => {
    try {
      const text = (await execAsync("cliphist list"))
        .split('\n')
      setHistory(text)
    } catch (err) {
      print("Clipboard check failed:", err)
    }
  }

  checkClipboard()

  const copyToClipboard = async (text: string) => {
    await execAsync(["bash", "-c", `echo -n "${text}" | cliphist decode | wl-copy`]).catch(print)
    checkClipboard()
  }

  return (
    <menubutton>
      <box>
        <Gtk.GestureClick onPressed={() => checkClipboard()} />
        <image iconName="edit-paste-symbolic" />
      </box>
      <popover>
        <With value={history}>
          {items => items.length > 0 ? (
            <scrolledwindow
              heightRequest={400}
              propagateNaturalWidth
            >
              <box orientation={Gtk.Orientation.VERTICAL}>
                {items.map((entry) => (
                  <button onClicked={() => copyToClipboard(entry)}>
                    <label xalign={0} label={entry.length > 40 ? entry.slice(0, 40) + "…" : entry} />
                  </button>
                ))}
              </box>
            </scrolledwindow>
          ) : (<label label="Clipboard empty" />)
          }
        </With>
      </popover>
    </menubutton>
  )
}

export default Clipboard
