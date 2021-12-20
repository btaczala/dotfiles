local wezterm = require 'wezterm'

function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Tomorrow Night"
  else
    return "Tomorrow"
  end
end

wezterm.on("window-config-reloaded", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local scheme = scheme_for_appearance(appearance)
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

return {
	font = wezterm.font_with_fallback({
		"Iosevka Term",
		"Hack Nerd Font",
	}),
	automatically_reload_config = True,
    enable_tab_bar = False,
    hide_tab_bar_if_only_one_tab = True,
}
