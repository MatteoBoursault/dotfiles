-- Configure le chemin de recherche Lua
local config_dir = os.getenv("HOME") .. "/.config/hypr"

-- Import du thème et du keymap
local theme = dofile(config_dir .. "/theme.lua")
local keymaps_conf = "dvp"
local keymap = dofile(config_dir .. "/keymaps/" .. keymaps_conf .. ".lua")

----------------
--- MONITORS ---
----------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-------------------
--- MY PROGRAMS ---
-------------------

local menu = "wofi --show drun"
local terminal = "kitty"
local navigator = "firefox"
local fileManager = terminal .. ' --detach nu -i -c "yazi"'
local passwordManager = "keepassxc"

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
end)

-- Workspaces spéciaux avec applications au démarrage
hl.workspace_rule({
	workspace = "special:passwordManagerWorkspace",
	on_created_empty = passwordManager,
})

hl.workspace_rule({
	workspace = "special:navigatorWorkspace",
	on_created_empty = navigator,
})

hl.workspace_rule({
	workspace = "special:terminalWorkspace",
	on_created_empty = terminal,
})

hl.workspace_rule({
	workspace = "special:fileManagerWorkspace",
	on_created_empty = fileManager,
})

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("EDITOR", "nvim")

---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 1,

		col = {
			active_border = theme.base0E,
		},

		resize_on_border = false,
		allow_tearing = false,
	},

	decoration = {
		active_opacity = 1.0,
		inactive_opacity = 0.8,
	},

	animations = {
		enabled = false,
	},

	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
		background_color = theme.base00,
	},
})

-------------
--- INPUT ---
-------------

hl.config({
	input = {
		kb_layout = keymap.layout,
		kb_variant = keymap.variant,
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER"

-- Bindings de base
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(
	mainMod .. " + G",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + " .. keymap.left_key, hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + " .. keymap.right_key, hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + " .. keymap.up_key, hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + " .. keymap.down_key, hl.dsp.focus({ direction = "down" }))

-- Switch workspace/monitor with mainMod + CTRL + arrow keys
hl.bind(mainMod .. " + CTRL + " .. keymap.up_key, hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + " .. keymap.down_key, hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + CTRL + " .. keymap.right_key, hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + CTRL + " .. keymap.left_key, hl.dsp.focus({ monitor = "-1" }))

-- Move active window to workspace/monitor with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + " .. keymap.up_key, hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + SHIFT + " .. keymap.down_key, hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + " .. keymap.right_key, hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + " .. keymap.left_key, hl.dsp.window.move({ monitor = "-1" }))

-- Switch to special workspace
hl.bind(mainMod .. " + " .. keymap.one_key, hl.dsp.workspace.toggle_special("terminalWorkspace"))
hl.bind(mainMod .. " + " .. keymap.two_key, hl.dsp.workspace.toggle_special("fileManagerWorkspace"))
hl.bind(mainMod .. " + " .. keymap.three_key, hl.dsp.workspace.toggle_special("passwordManagerWorkspace"))
hl.bind(mainMod .. " + " .. keymap.four_key, hl.dsp.workspace.toggle_special("navigatorWorkspace"))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- Coloration des fenêtres dans les workspaces spéciaux
hl.window_rule({
	name = "specialWorkspace",
	match = { workspace = "s[true]" },

	border_color = theme.base0B,
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

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Popup window rule (e.g., "Ouvrir" dialog)
hl.window_rule({
	name = "resize_popup_window",
	match = { title = "^(Ouvrir).*" },

	float = true,
	size = "800 600",
})
