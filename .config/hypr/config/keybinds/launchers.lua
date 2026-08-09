local cfg = require("config.programs")

-- Common apps
hl.bind(cfg.mainMod .. " + T", hl.dsp.exec_cmd(cfg.terminal))
hl.bind(cfg.mainMod .. " + E", hl.dsp.exec_cmd(cfg.fileManager))
hl.bind(cfg.mainMod .. " + Z", hl.dsp.exec_cmd(cfg.browser))
hl.bind(cfg.mainMod .. " + D", hl.dsp.exec_cmd(cfg.discord))
hl.bind(cfg.mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(cfg.office))
hl.bind(cfg.mainMod .. " + CTRL + V", hl.dsp.exec_cmd(cfg.volumeMixer))
hl.bind(cfg.mainMod .. " + CTRL + W", hl.dsp.exec_cmd(cfg.wifi))
hl.bind(cfg.mainMod .. " + SPACE", hl.dsp.exec_cmd("pkill " .. cfg.menuName .. " ; " .. cfg.menu))

-- Hyprlock
hl.bind(cfg.mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

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
