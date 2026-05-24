#!/bin/sh
# Sync current-theme.conf to match the current macOS appearance, then reload kitty config
config_dir="$HOME/.config/kitty"
appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
if [ "$appearance" = "Dark" ]; then
    ln -sf "$config_dir/tokyonight_moon.conf" "$config_dir/current-theme.conf"
else
    ln -sf "$config_dir/tokyonight_day.conf" "$config_dir/current-theme.conf"
fi
for socket in "$HOME/.local/share/kitty/mykitty-"*; do
    /Applications/kitty.app/Contents/MacOS/kitten @ --to "unix:$socket" action load_config_file 2>/dev/null
done
