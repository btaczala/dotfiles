#!/bin/bash

mode=$($HOME/dotfiles/bin/darkMode.py)
if [[ ! ($($HOME/dotfiles/bin/darkMode) =~ 'Dark') ]]; then
	/usr/local/bin/kitty @ --to unix:/tmp/mykitty set-colors --all --configured $HOME/dotfiles/config/kitty/kitty_tokyonight_day.conf
else
	/usr/local/bin/kitty @ --to unix:/tmp/mykitty set-colors --all --configured $HOME/dotfiles/config/kitty/kitty_tokyonight_night.conf
fi

if pgrep -x "tmux" >/dev/null; then
	$HOME/dotfiles/tmux/darkmode_tmux.sh
fi
