local cfg = require("config.programs")

-- Core window management
hl.bind(cfg.mainMod .. " + C", hl.dsp.window.close())
hl.bind(cfg.mainMod .. " + K", hl.dsp.window.kill()) -- forcekillactive
hl.bind(cfg.mainMod .. " + M", hl.dsp.exit())
hl.bind(cfg.mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(cfg.mainMod .. " + F", hl.dsp.window.fullscreen())

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

-- Move active window to adjacent workspace with mainMod + CTRL + SHIFT + arrow keys
hl.bind(cfg.mainMod .. " + SHIFT + CTRL + up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(cfg.mainMod .. " + SHIFT + CTRL + down", hl.dsp.window.move({ workspace = "e+1" }))
