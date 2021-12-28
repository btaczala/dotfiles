local wezterm = require("wezterm")

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
	font = wezterm.font("Iosevka Nerd Font"),
    font_rules = {
		{
			italic = true,
			font = wezterm.font("Iosevka Nerd Font", {
                italic = true,
			}),
		},
	},
	automatically_reload_config = true,
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
}
