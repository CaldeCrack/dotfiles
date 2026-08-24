-- Special workspace rules
hl.window_rule({
	name = "scratchpad-aspect",
	match = {
		workspace = "special:scratchpad",
	},
	maximize = false,
	fullscreen = false,
	float = true,
	size = { 400, 400 },
	move = {
		"(monitor_w - 400 - 10)",
		"(monitor_h - 400 - 10)",
	},
	content = "photo",
	render_unfocused = true,
})

hl.workspace_rule({
	workspace = "special:scratchpad",
	on_created_empty = "imv ~/Pictures/Calde/waguri-dance.gif",
})

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
