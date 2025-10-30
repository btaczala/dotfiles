local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

-- sessions
wezterm.on("gui-startup", function(cmd)
	local hostname = wezterm.hostname()
	-- dotfiles
	do
		local dotfiles_path = wezterm.home_dir .. "/dotfiles"
		local tab, build_pane, window = mux.spawn_window({
			workspace = "dotfiles",
			cwd = dotfiles_path,
		})
		build_pane:send_text("nvim\n")
		tab:set_title("dotfiles")
		mux.set_active_workspace("dotfiles")

		local ip = nil
		if hostname and string.find(hostname, "Bartoszs%-MacBook%-Pro%-3") then
			ip = "192.168.1.159"
		elseif hostname and string.find(hostname, "mac%-mini") then
			ip = "192.168.1.60"
		end

		local qmk_tab, _, _ =
			window:spawn_tab({ cwd = wezterm.home_dir .. "/dev/qmk_firmware/keyboards/splitkb/aurora/lily58" })
		qmk_tab:set_title("qmk")

		if hostname then
			local glances_tab, _, _ = window:spawn_tab({ args = { "/opt/homebrew/bin/glances", "-w", "-B", ip } })
			glances_tab:set_title("glances")
		end
	end

	if hostname and string.find(hostname, "Bartoszs%-MacBook%-Pro%-3") then
		local tab, pane, _ = mux.spawn_window({
			workspace = "mediamaster",
			cwd = wezterm.home_dir .. "/Projects/chamsys/mediamaster",
		})
		pane:send_text("nvim\n")
		tab:set_title("mediamaster")
	end
end)

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Tokyo Night Moon"
	else
		return "Tokyo Night Day"
	end
end

local current_scheme = nil

wezterm.on("format-window-title", function(tab, _, tabs, _, _)
	local zoomed = ""
	local window = wezterm.mux.get_window(tab.window_id)
	-- wezterm.log_info(window:get_workspace())
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end

	return window:get_workspace() and window:get_workspace() or (zoomed .. index .. tab.tab_title)
end)

wezterm.on("window-config-reloaded", function(window, _)
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

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	if not current_scheme then
		return
	end
	local background = current_scheme.background
	local foreground = current_scheme.foreground

	local title = tab_title(tab)

	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	if tab.is_active then
		foreground = current_scheme.brights[3]
	end

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = zoomed .. title },
	}
end)

local function is_vim(pane)
	-- This gsub is equivalent to POSIX basename(3)
	-- Given "/foo/bar" returns "bar"
	-- Given "c:\\foo\\bar" returns "bar"
	print(pane:get_foreground_process_name())
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
	["j"] = "Left",
	["k"] = "Down",
	["l"] = "Up",
	[";"] = "Right",
}
--
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

config.leader = { key = "y", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		key = "z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "l",
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
		mods = "CTRL|SHIFT",
		-- action = scroll("d"),
		action = act.ScrollByPage(1),
	},
	{
		key = "u",
		mods = "CTRL|SHIFT",
		-- action = scroll("u"),
		action = act.ScrollByPage(-1),
	},
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	split_nav("move", ";"),
	-- resize panes
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	split_nav("resize", ";"),
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		key = "Enter",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.ReloadConfiguration,
	},
	{
		key = "d",
		mods = "LEADER",
		action = wezterm.action.ShowDebugOverlay,
	},
	{
		key = "Space",
		mods = "LEADER",
		action = wezterm.action.RotatePanes("CounterClockwise"),
	},
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	{
		key = "Enter",
		mods = "CTRL|SHIFT",
		action = wezterm.action.QuickSelect,
	},
	{
		key = "x",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = "d",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
}
config.key_tables = {
	copy_mode = {
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = ";", mods = "NONE", action = act.CopyMode("MoveRight") },
		{
			key = "y",
			mods = "NONE",

			action = act.Multiple({
				act.ClearSelection,
				-- clear the selection mode, but remain in copy mode
			}),
		},
	},
}
wezterm.on("mux-startup", function()
	local _, pane, _ = mux.spawn_window({})
	pane:split({ direction = "Top" })
end)

config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 14.0,
	active_titlebar_bg = "#FFF",
	inactive_titlebar_bg = "#FFF",
}

local copy_mode = nil
if wezterm.gui then
	copy_mode = wezterm.gui.default_key_tables().copy_mode
	table.insert(copy_mode, { key = "j", mods = "NONE", action = act.CopyMode("MoveLeft") })
	table.insert(copy_mode, { key = "k", mods = "NONE", action = act.CopyMode("MoveDown") })
	table.insert(copy_mode, { key = "l", mods = "NONE", action = act.CopyMode("MoveUp") })
	table.insert(copy_mode, { key = ";", mods = "NONE", action = act.CopyMode("MoveRight") })
end

config.key_tables = {
	copy_mode = copy_mode,
}

config.colors = {
	-- Since: 20220319-142410-0fcdea07
	-- When the IME, a dead key or a leader key are being processed and are effectively
	-- holding input pending the result of input composition, change the cursor
	-- to this color to give a visual cue about the compose state.
	compose_cursor = "orange",

	-- Colors for copy_mode and quick_select
	-- available since: 20220807-113146-c2fee766
	-- In copy_mode, the color of the active text is:
	-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
	-- 2. selection_* otherwise
	copy_mode_active_highlight_bg = { Color = "#000000" },
	-- use `AnsiColor` to specify one of the ansi color palette values
	-- (index 0-15) using one of the names "Black", "Maroon", "Green",
	--  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
	-- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
	copy_mode_active_highlight_fg = { AnsiColor = "Black" },
	copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
	copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

	quick_select_label_bg = { Color = "peru" },
	quick_select_label_fg = { Color = "#ffffff" },
	quick_select_match_bg = { AnsiColor = "Navy" },
	quick_select_match_fg = { Color = "#ffffff" },
}
config.macos_window_background_blur = 20
config.window_background_opacity = 1

config.unix_domains = {
	{
		name = "unix",
	},
}

return config
