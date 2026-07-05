#!/bin/sh
# Sync current-theme.conf to match the OS appearance (macOS or GNOME), then
# push the new colors to every running kitty instance.
config_dir="$HOME/.config/kitty"

case "$(uname)" in
Darwin)
    appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
    [ "$appearance" = "Dark" ] && is_dark=1 || is_dark=0
    kitten_bin="/Applications/kitty.app/Contents/MacOS/kitten"
    ;;
Linux)
    scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
    [ "$scheme" = "'prefer-dark'" ] && is_dark=1 || is_dark=0
    kitten_bin="kitten"
    ;;
*)
    exit 0
    ;;
esac

if [ "$is_dark" = "1" ]; then
    ln -sf "tokyonight_moon.conf" "$config_dir/current-theme.conf"
else
    ln -sf "tokyonight_day.conf" "$config_dir/current-theme.conf"
fi

for socket in "$HOME/.local/share/kitty/mykitty-"*; do
    # set-colors --configured applies the theme without reloading the whole
    # config, so a manual font-size change (cmd +/-) survives a theme sync.
    "$kitten_bin" @ --to "unix:$socket" set-colors --all --configured "$config_dir/current-theme.conf" 2>/dev/null
done
