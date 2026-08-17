local cfg = require("config.programs")

-- Common apps
hl.bind(cfg.mainMod .. " + T", hl.dsp.exec_cmd(cfg.terminal))
hl.bind(cfg.mainMod .. " + E", hl.dsp.exec_cmd(cfg.fileManager))
hl.bind(cfg.mainMod .. " + Z", hl.dsp.exec_cmd(cfg.browser))
hl.bind(cfg.mainMod .. " + D", hl.dsp.exec_cmd(cfg.discord))
hl.bind(cfg.mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(cfg.office))
hl.bind(cfg.mainMod .. " + CTRL + V", hl.dsp.exec_cmd(cfg.volumeMixer))
hl.bind(cfg.mainMod .. " + CTRL + W", hl.dsp.exec_cmd(cfg.wifi))
hl.bind(
	cfg.mainMod .. " + K",
	hl.dsp.exec_cmd(
		"busctl --user get-property sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible -j | jq -r '.data' | grep -q 'true' && busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false || busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true"
	)
)

-- Hyprpicker
hl.bind(cfg.mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a -q"))

-- Quickshell shortcuts
hl.bind(cfg.mainMod .. " + B", hl.dsp.exec_cmd(cfg.bar))
hl.bind(cfg.mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(cfg.closeBar))

-- Quickshell ipc calls
hl.bind(cfg.mainMod .. " + RETURN", hl.dsp.exec_cmd("qs ipc call shortcuts toggle"))
hl.bind(cfg.mainMod .. " + V", hl.dsp.exec_cmd("qs ipc call miscApps clipboard"))
hl.bind(cfg.mainMod .. " + PERIOD", hl.dsp.exec_cmd("qs ipc call miscApps emoji"))
hl.bind(cfg.mainMod .. " + SHIFT + PERIOD", hl.dsp.exec_cmd("qs ipc call miscApps glyphs"))
hl.bind(cfg.mainMod .. " + R", hl.dsp.exec_cmd("qs ipc call recording toggleScreen"))
hl.bind(cfg.mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("qs ipc call recording toggleRegion"))
hl.bind(cfg.mainMod .. " + escape", hl.dsp.exec_cmd("qs ipc call power toggle"))
hl.bind(cfg.mainMod .. " + W", hl.dsp.exec_cmd("qs ipc call infoPanel open 'Wallpaper'"))
hl.bind(cfg.mainMod .. " + M", hl.dsp.exec_cmd("qs ipc call infoPanel open 'Media'"))
hl.bind(cfg.mainMod .. " + N", hl.dsp.exec_cmd("qs ipc call notifications toggleCenter"))
hl.bind(cfg.mainMod .. " + SPACE", hl.dsp.exec_cmd("qs ipc call launcher toggle"))
