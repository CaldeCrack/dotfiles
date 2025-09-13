import app from "ags/gtk4/app"
import { Astal } from "ags/gtk4"
import style from "./style.scss"
import Bar from "./widget/Bar"
import { For, This, createBinding } from "ags"

function main() {
  const monitors = createBinding(app, "monitors")
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <For each={monitors}>
      {(monitor) => (
        <This this={app}>
          <window
            visible
            namespace="Bar"
            class="Bar"
            gdkmonitor={monitor}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            $={(self) => () => self.destroy()}
          >
            <Bar />
          </window>
        </This>
      )}
    </For>
  )
}

app.start({
  css: style,
  main
})
