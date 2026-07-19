local cfg = require("config.programs")

hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(cfg.mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(cfg.mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
