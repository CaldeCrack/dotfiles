-- Handle Lid switch
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("sh ~/.config/hypr/scripts/lid-close.sh"), { locked = true })

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
