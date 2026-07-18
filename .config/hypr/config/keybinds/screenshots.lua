local cfg = require("config.programs")

hl.bind(cfg.mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(cfg.mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
