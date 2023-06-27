#!/usr/bin/env bash

if [[ ! ($($HOME/dotfiles/bin/darkMode) =~ 'Dark') ]]; then
    $(brew --prefix tmux)/bin/tmux source-file $HOME//dotfiles/tmux/tmux_tokyonight_day.tmux
else
	$(brew --prefix tmux)/bin/tmux source-file $HOME/dotfiles/tmux/tmux_tokyonight_night.tmux
fi
