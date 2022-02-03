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
	font = wezterm.font_with_fallback({
		"Iosevka",
		"Symbols Nerd Font Mono",
	}),
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
}
