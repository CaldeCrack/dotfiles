local cfg = require("config.programs")

-- Common apps
hl.bind(cfg.mainMod .. " + T", hl.dsp.exec_cmd(cfg.terminal))
hl.bind(cfg.mainMod .. " + E", hl.dsp.exec_cmd(cfg.fileManager))
hl.bind(cfg.mainMod .. " + Z", hl.dsp.exec_cmd(cfg.browser))
hl.bind(cfg.mainMod .. " + R", hl.dsp.exec_cmd("pkill " .. cfg.menuName .. " ; " .. cfg.menu))
hl.bind(cfg.mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("pkill " .. cfg.menuName .. " ; " .. cfg.emojiMenu))
hl.bind(cfg.mainMod .. " + PERIOD", hl.dsp.exec_cmd("pkill " .. cfg.menuName .. " ; " .. cfg.clipboardMenu))
hl.bind(cfg.mainMod .. " + escape", hl.dsp.exec_cmd("pkill " .. cfg.menuName .. " ; " .. cfg.powerMenu))

-- Hyprlock
hl.bind(cfg.mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- Hyprpicker
hl.bind(cfg.mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a -q"))

-- Restart / Reload bar
hl.bind(cfg.mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("pkill -f ags"))
hl.bind(cfg.mainMod .. " + B", hl.dsp.exec_cmd(cfg.bar))
