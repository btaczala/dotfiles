local wezterm = require("wezterm")
local act = wezterm.action

function scheme_for_appearance(appearance)
    if appearance:find("Dark") then
        return "Tomorrow Night"
    else
        return "Catppuccin Latte"
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

    return tab.window_title and tab.window_title or (zoomed .. index .. tab.tab_title)
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
    if not current_scheme then
        return
    end
    background = current_scheme.background
    foreground = current_scheme.foreground

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

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
    -- this is set by the plugin, and unset on ExitPre in Neovim
    wezterm.log_info("is_vim original")
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
    ["j"] = "Left",
    ["k"] = "Down",
    ["l"] = "Up",
    [";"] = "Right",
}

local function scroll(scroll)
    return wezterm.action_callback(function(win, pane)
        wezterm.log_info("clicked scrol " .. scroll)
        if is_vim(pane) then
            wezterm.log_info("vim")
            win:perform_action({
                SendKey = { key = scroll, mods = "CTRL" },
            }, pane)
        else
            wezterm.log_info("not vim")
            win:perform_action({ ScrollByPage = scroll == "u" and -1 or 1 }, pane)
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
        action = scroll("d"),
    },
    {
        key = "u",
        mods = "CTRL",
        action = scroll("u"),
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
        key = 'w',
        mods = 'CMD',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    {
        key = 'w',
        mods = 'CMD|SHIFT',
        action = wezterm.action.CloseCurrentTab { confirm = true },
    },
    {
        key = 'Space',
        mods = 'LEADER',
        action = wezterm.action.RotatePanes 'CounterClockwise',
    },
    {
        key = 'w',
        mods = 'LEADER',
        action = wezterm.action.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        },
    },
    {
        key = 'Enter',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.QuickSelect,
    },
    {
        key = 'x',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ActivateCopyMode,
    },
}
wezterm.on("mux-startup", function()
    local tab, pane, window = mux.spawn_window({})
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
    table.insert(
        copy_mode,
        { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveLeft' }
    )
    table.insert(
        copy_mode,
        { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' }
    )
    table.insert(
        copy_mode,
        { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveDown' }
    )
    table.insert(
        copy_mode,
        { key = ';', mods = 'NONE', action = act.CopyMode 'MoveRight' }
    )
end

config.key_tables = {
    copy_mode = copy_mode
}

config.colors = {
    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = 'orange',

    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = '#000000' },
    -- use `AnsiColor` to specify one of the ansi color palette values
    -- (index 0-15) using one of the names "Black", "Maroon", "Green",
    --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
    -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
    copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
    copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
    copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

    quick_select_label_bg = { Color = 'peru' },
    quick_select_label_fg = { Color = '#ffffff' },
    quick_select_match_bg = { AnsiColor = 'Navy' },
    quick_select_match_fg = { Color = '#ffffff' },
}

config.unix_domains = {
    {
        name = "unix",
    },
}

return config
