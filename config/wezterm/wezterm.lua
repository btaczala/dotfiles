local wezterm = require("wezterm")

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Tomorrow Night"
	else
		return "Classic Light (base16)"
	end
end

local current_scheme = nil

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end

	return zoomed .. index .. tab.tab_title
end)

wezterm.on("window-config-reloaded", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
	end
	current_scheme = wezterm.color.get_builtin_schemes()[scheme]

	overrides.window_frame = {}
	overrides.window_frame.active_titlebar_bg = current_scheme.background
	window:set_config_overrides(overrides)
end)

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	background = current_scheme.background
	foreground = current_scheme.foreground

	local title = tab_title(tab)

	if tab.is_active then
		foreground = current_scheme.brights[3]
	end

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
	}
end)

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

-- if you *ARE* lazy-loading smart-splits.nvim (not recommended)
-- you have to use this instead, but note that this will not work
-- in all cases (e.g. over an SSH connection). Also note that
-- `pane:get_foreground_process_name()` can have high and highly variable
-- latency, so the other implementation of `is_vim()` will be more
-- performant as well.
local function is_vim(pane)
	-- This gsub is equivalent to POSIX basename(3)
	-- Given "/foo/bar" returns "bar"
	-- Given "c:\\foo\\bar" returns "bar"
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function scroll_up(scroll)
	return wezterm.action_callback(function(win, pane)
		if is_vim(pane) then
			win:perform_action({
				SendKey = { key = scroll, mods = "CTRL" },
			}, pane)
		else
			win:perform_action({ ScrollByPage = scroll == 'u' and -1 or 1 }, pane)
		end
	end)
end

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

local config = {
	font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"Iosevka",
		"Fira Code",
		"Hack Nerd Font",
	}),
	font_size = 15,
	automatically_reload_config = true,
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	allow_square_glyphs_to_overflow_width = "Always",
	use_cap_height_to_scale_fallback_fonts = true,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	adjust_window_size_when_changing_font_size = false,
}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.ShowLauncher,
	},
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 30 } }),
	},
	{
		key = "d",
		mods = "CTRL",
		action = scroll_up("d"),
	},
	{
		key = "u",
		mods = "CTRL",
		action = scroll_up("u"),
	},
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
}

config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),

	font_size = 14.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#FFF",

	inactive_titlebar_bg = "#000",
}

return config
