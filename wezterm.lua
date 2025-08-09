-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux     = wezterm.mux

-- Configuration builder
local config  = wezterm.config_builder()

-- Automatically maximize on startup (windowed-fullscreen)
wezterm.on("gui-startup", function(cmd)
	-- Spawn the window and retrieve the mux window object
	local _, _, window = mux.spawn_window(cmd or {})
	-- Maximize the GUI window (not exclusive fullscreen)
	window:gui_window():maximize()
end)

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols              = 120
config.initial_rows              = 28

config.window_padding = {
	left = 50,
	right = 50,
	top = 50,
	bottom = 0
}

-- config.font                     = wezterm.font("JetBrainsMono NF")

-- Hide titlebar and borders for a clean look; keep resize handle
config.window_decorations        = "RESIZE"
config.enable_tab_bar            = false
-- or, changing the font size and color scheme.
config.font_size                 = 10
-- config.color_scheme             = 'Dracula'
-- config.color_scheme              = 'Gruvbox Material (Gogh)'
config.color_scheme 			 = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte
config.window_background_opacity = 0.97

-- Finally, return the configuration to wezterm:
return config
