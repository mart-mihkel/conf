hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 8,
		border_size = 1,
		col = { active_border = "#000000", inactive_border = "#000000" },
	},
	decoration = {
		rounding = 0,
		shadow = { enabled = false },
		blur = { enabled = false },
	},
	animations = { enabled = false },
	input = {
		kb_layout = "ee",
		kb_variant = "nodeadkeys",
		repeat_rate = 32,
		repeat_delay = 256,
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = { natural_scroll = false },
	},
	misc = { disable_hyprland_logo = true },
	cursor = { inactive_timeout = 1 },
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	mirror = "eDP-1",
	scale = 1,
})

hl.on("hyprland.start", function()
	hl.exec_cmd("wayland-piperwire-idle-inhibit")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("gammastep")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("waybar")
	hl.exec_cmd("dunst")
end)

hl.bind("SUPER + B", hl.dsp.exec_cmd("tofi-wallpaper"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("tofi-emoji"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("tofi-drun"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + Q", hl.dsp.exec_cmd("foot"))

hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exit())

hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("CONTROL + Print", hl.dsp.exec_cmd("grimblast --notify copysave screen"), { locked = true })
hl.bind("ALT + Print", hl.dsp.exec_cmd("grimblast --notify copysave active"), { locked = true })
hl.bind("Print", hl.dsp.exec_cmd("grimblast --notify copysave area"), { locked = true })

hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

local xf_opts = { locked = true, repeating = true }

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"), xf_opts)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), xf_opts)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), xf_opts)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), xf_opts)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 2%-"), xf_opts)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 2%+"), xf_opts)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), xf_opts)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), xf_opts)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), xf_opts)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), xf_opts)
