local M = {}

M.terminal = "kitty"
M.fileManager = "kitty ~/.config/hypr/scripts/kitty-run.sh spf"

M.menuName = "rofi"
M.menu = M.menuName .. " -show drun -modi drun -show-icons"

M.browser = "zen-browser"
M.discord = "vesktop"
M.office = "onlyoffice-desktopeditors"
M.volumeMixer = "pavucontrol"
M.wifi = "kitty ~/.config/hypr/scripts/kitty-run.sh nmtui"

M.bar = "qs -n"
M.closeBar = "qs kill"

M.mainMod = "SUPER"

return M
