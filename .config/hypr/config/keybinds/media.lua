-- Media keys (bindl: locked only)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Wallpaper carousel
hl.bind("SHIFT + F9", hl.dsp.exec_cmd("~/.local/share/scripts/bg_carousel/bg_carousel.sh -b"))
hl.bind("SHIFT + F11", hl.dsp.exec_cmd("~/.local/share/scripts/bg_carousel/bg_carousel.sh"))
