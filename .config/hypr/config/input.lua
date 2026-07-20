local cfg = require("config.programs")

-- Toggle touch screen
local touchable = true
local function toggle_touchscreen()
	return function()
		touchable = not touchable
		hl.config({
			input = {
				touchdevice = {
					enabled = touchable,
				},
			},
		})

		hl.device({
			name = "synps/2-synaptics-touchpad",
			enabled = touchable,
		})
	end
end

hl.bind("SHIFT + F4", toggle_touchscreen())

-- Zoom bindings
local zoom = 1.0
local MIN_ZOOM = 1.0
local MAX_ZOOM = 5.0
local STEP = 0.2

local function set_zoom(delta)
	return function()
		zoom = math.max(MIN_ZOOM, math.min(MAX_ZOOM, zoom + delta))
		hl.config({
			cursor = {
				zoom_factor = zoom,
			},
		})
	end
end

hl.bind(cfg.mainMod .. " + PLUS", set_zoom(STEP), {
	repeating = true,
})

hl.bind(cfg.mainMod .. " + MINUS", set_zoom(-STEP), {
	repeating = true,
})

-- General input settings
hl.config({
	input = {
		kb_layout = "latam",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		repeat_delay = 250,
		repeat_rate = 40,

		follow_mouse = 0,
		sensitivity = 0.2,

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.45,
		},

		touchdevice = {
			enabled = true,
		},
	},
})

hl.device({
	name = "logitech-wireless-mouse-1",
	sensitivity = -0.1,
})

-- Touchpad Gestures
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "scroll_move",
})
