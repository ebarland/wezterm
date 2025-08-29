-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux     = wezterm.mux

local config  = wezterm.config_builder()

-- === Center + custom margins on the active screen ===
-- Usage:
--   center_with_margin(gui, 60)                      -- uniform 60 on all sides
--   center_with_margin(gui, { all = 60, bottom = 84 }) -- 60 everywhere, 84 bottom
--   center_with_margin(gui, { top=50, right=60, bottom=90, left=60 })
local function center_with_margin(gui_window, margins)
	-- normalize margins
	local m = { top = 0, right = 0, bottom = 0, left = 0 }
	if type(margins) == "number" then
		m.top, m.right, m.bottom, m.left = margins, margins, margins, margins
	elseif type(margins) == "table" then
		local all = margins.all or margins[1]
		if all then m.top, m.right, m.bottom, m.left = all, all, all, all end
		m.top    = margins.top or m.top
		m.right  = margins.right or m.right
		m.bottom = margins.bottom or m.bottom
		m.left   = margins.left or m.left
	else
		-- default uniform margin if nothing passed
		m.top, m.right, m.bottom, m.left = 60, 60, 60, 60
	end

	local screens  = wezterm.gui.screens()
	local active   = screens.active

	local target_w = math.max(200, active.width - (m.left + m.right))
	local target_h = math.max(200, active.height - (m.top + m.bottom))
	local target_x = active.x + m.left
	local target_y = active.y + m.top

	gui_window:set_inner_size(target_w, target_h)
	gui_window:set_position(target_x, target_y)
end

-- wezterm.on("gui-startup", function(cmd)
-- 	local _, _, window = mux.spawn_window(cmd or {})
-- 	local gui = window:gui_window()
-- 	-- uniform margins + a larger bottom margin to taste:
-- 	center_with_margin(gui, { all = 35, bottom = 70 })
-- end)


wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	local gui = window:gui_window()
	gui:maximize()
end)

config.window_padding            = {
	left = 25, right = 25, top = 25, bottom = 0
}

-- Optional: quick recenter with the same margins (CTRL+SHIFT+M)
config.keys                      = {
	{
		key = "M",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, _)
			center_with_margin(win:gui_window(), { all = 35, bottom = 70 })
		end),
	},
}

config.font                      = wezterm.font_with_fallback({
	"JetBrains Mono",         -- your main font
	"Symbols Nerd Font Mono", -- tiny package with devicons/codicons, etc.
	"Noto Color Emoji",       -- optional
})

config.window_decorations        = "RESIZE"
config.enable_tab_bar            = false
config.font_size                 = 10
config.color_scheme              = "Dracula"
-- config.window_background_opacity = 0.97

return config
