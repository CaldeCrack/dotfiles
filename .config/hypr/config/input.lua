local cfg = require("config.programs")

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
		sensitivity = 0.2,

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.45,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

hl.device({
	name = "logitech-wireless-mouse-1",
	sensitivity = -0.1,
})

-- hl.bind(cfg.mainMod .. " + F4", hl.dsp.input.float({ action = "toggle" }))
