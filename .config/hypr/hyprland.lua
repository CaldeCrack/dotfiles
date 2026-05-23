-- Hyprland Lua config converted from hyprland.conf
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Placeholder colors (replace with your actual values or use the require above)
-- local colors = require("hyprland-colors")
-- local color1, color9, color8 = colors.color1, colors.color9, colors.color8
local color1 = "rgba(b22888ff)"
local color9 = "rgba(77476aff)"
local color8 = "rgba(111212ff)"

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "eDP-1", mode = "highres", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "highres", position = "1366x0", scale = 1 })

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "thunar"
local menuName = "rofi"
local menu = menuName .. " -show drun -modi drun -show-icons"
local emojiMenu = menuName .. " -show emoji"
local clipboardMenu = menuName .. " -modi clipboard:~/.local/share/scripts/cliphist-rofi.sh -show clipboard -show-icons"
local powerMenu = menuName .. " -show pm -modi pm:rofi-power-menu"
local browser = "zen-browser"
local bar = "ags run ~/.config/ags/app.tsx"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprlock")
	hl.exec_cmd("nm-applet & " .. bar .. " & hyprpaper & hypridle")
	hl.exec_cmd("/usr/bin/dunst")
	hl.exec_cmd("wl-paste --watch cliphist store")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRSHOT_DIR", "Pictures/Screenshots")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 2,

		col = {
			active_border = { colors = { color1, color9 }, angle = 45 },
			inactive_border = color8,
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "scrolling",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 0.6,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Bezier curves
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.4, bezier = "easeInOutCubic", style = "slidevert" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
	scrolling = {
		column_width = 0.8,
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
	debug = {
		vfr = true,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "latam",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		repeat_delay = 250,
		repeat_rate = 40,

		follow_mouse = 1,
		sensitivity = -0.15,

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.45,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER"

-- Core window management
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + K", hl.dsp.window.kill()) -- forcekillactive
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(browser))

-- Launchers (kill existing rofi first)
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("pkill " .. menuName .. " ; " .. menu))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("pkill " .. menuName .. " ; " .. emojiMenu))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("pkill " .. menuName .. " ; " .. clipboardMenu))
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("pkill " .. menuName .. " ; " .. powerMenu))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Swap windows with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))

-- Switch workspaces 1–10 and move windows to workspaces 1–10
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Switch workspaces with mainMod + CTRL + arrow keys
hl.bind(mainMod .. " + CTRL + up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "e+1" }))

-- Move active window to adjacent workspace with mainMod + CTRL + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + CTRL + up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + CTRL + down", hl.dsp.window.move({ workspace = "e+1" }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize windows with mainMod + ALT + arrow keys
hl.bind(mainMod .. " + ALT + left", hl.dsp.layout("colresize -0.1"))
hl.bind(mainMod .. " + ALT + right", hl.dsp.layout("colresize +0.1"))

-- Screenshots (hyprshot)
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

-- Lock screen
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- Color picker
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a -q"))

-- Restart / reload bar
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("pkill -f ags"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(bar))

-- Volume (bindel: locked + repeating)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("~/.local/share/scripts/volume-manager.sh -i"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("~/.local/share/scripts/volume-manager.sh -d"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("~/.local/share/scripts/volume-manager.sh -t"),
	{ locked = true, repeating = true }
)
hl.bind(
	"SHIFT + F6",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)

-- Brightness (bindel: locked + repeating)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("~/.local/share/scripts/brightness-manager.sh -i"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("~/.local/share/scripts/brightness-manager.sh"),
	{ locked = true, repeating = true }
)

-- Brightness special modes (plain bind)
hl.bind("SHIFT + F3", hl.dsp.exec_cmd("~/.local/share/scripts/brightness-manager.sh -m"))
hl.bind("SHIFT + F2", hl.dsp.exec_cmd("~/.local/share/scripts/brightness-manager.sh -l"))

-- Media keys (bindl: locked only)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Wallpaper carousel
hl.bind("SHIFT + F9", hl.dsp.exec_cmd("~/.local/share/scripts/bg_carousel/bg_carousel.sh -b"))
hl.bind("SHIFT + F11", hl.dsp.exec_cmd("~/.local/share/scripts/bg_carousel/bg_carousel.sh"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Allow RetroArch to render while unfocused
hl.window_rule({
	name = "retroarch-render-unfocused",
	match = { class = "com.libretro.RetroArch" },
	render_unfocused = true,
})

-- Ignore maximize requests from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
