local cfg = require("config.programs")

-- Core window management
hl.bind(cfg.mainMod .. " + C", hl.dsp.window.close())
hl.bind(cfg.mainMod .. " + K", hl.dsp.window.kill())
hl.bind(cfg.mainMod .. " + ALT + SPACE", hl.dsp.window.float())
hl.bind(cfg.mainMod .. " + P", function()
	hl.dispatch(hl.dsp.window.float())
	hl.dispatch(hl.dsp.window.pin())
end)
hl.bind(cfg.mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(cfg.mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen_state({ action = "toggle", internal = 2, client = 0 }))
hl.bind(cfg.mainMod .. " + M", function()
	hl.dispatch(hl.dsp.layout("colresize +conf"))
	hl.dispatch(hl.dsp.layout("focus r"))
	hl.dispatch(hl.dsp.layout("focus l"))
end)

-- Move focus with mainMod + arrow keys
hl.bind(cfg.mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(cfg.mainMod .. " + right", hl.dsp.focus({ direction = "right" }))

-- Swap windows with mainMod + SHIFT + arrow keys
hl.bind(cfg.mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(cfg.mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(cfg.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(cfg.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize windows with mainMod + ALT + arrow keys
hl.bind(cfg.mainMod .. " + ALT + left", hl.dsp.layout("colresize -0.1"))
hl.bind(cfg.mainMod .. " + ALT + right", hl.dsp.layout("colresize +0.1"))

-- Move active window to adjacent workspace with mainMod + SHIFT + arrow keys
hl.bind(cfg.mainMod .. " + SHIFT + up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(cfg.mainMod .. " + SHIFT + down", hl.dsp.window.move({ workspace = "e+1" }))

-- Move windows to workspaces 1–10
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(cfg.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
