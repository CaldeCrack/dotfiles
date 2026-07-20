local M = {}

M.terminal = "kitty"
M.fileManager = "thunar"

M.menuName = "rofi"
M.menu = M.menuName .. " -show drun -modi drun -show-icons"
M.emojiMenu = M.menuName .. " -show emoji"
M.clipboardMenu = M.menuName .. " -modi clipboard:~/.local/share/scripts/cliphist-rofi.sh -show clipboard -show-icons"
M.powerMenu = M.menuName .. " -show pm -modi pm:rofi-power-menu"

M.browser = "zen-browser"
M.discord = "vesktop"
M.office = "onlyoffice-desktopeditors"
M.volumeMixer = "pavucontrol"
M.wifi = "kitty nmtui"

M.bar = "ags run ~/.config/ags/app.tsx"

M.mainMod = "SUPER"

return M
