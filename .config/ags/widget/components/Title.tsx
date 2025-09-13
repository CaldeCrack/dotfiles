import { With, createBinding } from "ags"
import Hyprland from "gi://AstalHyprland"

function Title() {
  const hyprland = Hyprland.get_default()
  const activeClient = createBinding(hyprland, "focusedClient")

  return (
    <box class="title">
      <With value={activeClient}>
        {client => {
          if (!client)
            return <label label="CaldeCrack" />

          const clientTitle = createBinding(client, "title")(
            title => client.initial_title || title || ""
          )

          return <label label={clientTitle} />
        }}
      </With>
    </box>
  )
}

export default Title
