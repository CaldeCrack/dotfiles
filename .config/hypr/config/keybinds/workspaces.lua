local cfg = require("config.programs")

-- Switch workspaces 1–10 and move windows to workspaces 1–10
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(cfg.mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(cfg.mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Switch workspaces with mainMod + CTRL + arrow keys
hl.bind(cfg.mainMod .. " + CTRL + up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(cfg.mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "e+1" }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(cfg.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(cfg.mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
