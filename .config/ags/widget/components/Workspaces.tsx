import { For, With, createBinding } from "ags"
import { exec } from "ags/process"

// @ts-ignore
import Hyprland from "gi://AstalHyprland"

function Workspaces() {
  const hyprland = Hyprland.get_default()
  const focusedWorkspace = createBinding(hyprland, "focusedWorkspace")(ws => ws.id)
  const workspaces = createBinding(hyprland, "workspaces")(ws =>
    ws
      .filter((a: Hyprland.Workspace) => a.id !== 0)
      .sort((a: Hyprland.Workspace, b: Hyprland.Workspace) => a.id - b.id)
  )

  const switchWorkspace = (id: number) => exec(["hyprctl", "dispatch", "workspace", `${id}`])

  return (
    <With value={focusedWorkspace}>
      {(focusedWorkspace) => Boolean(focusedWorkspace) &&
        <box>
          <For each={workspaces}>
            {workspace => (
              <button
                class={focusedWorkspace === workspace!.id ? "active" : ""}
                onClicked={() => switchWorkspace(workspace!.id)}
                css="padding-top: 4px; padding-bottom: 0px;"
              >
                {workspace!.id}
              </button>
            )}
          </For>
        </box>
      }
    </With>
  )
}

export default Workspaces
