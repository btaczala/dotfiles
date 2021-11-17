#!/usr/bin/env bash

if [[ ! ( $($HOME/dotfiles/bin/darkMode) =~ 'Dark' ) ]]; then
   /usr/local/bin/tmux source-file /Users/btaczala/dotfiles/tmux/tmux_tokyonight_day.tmux
else
   /usr/local/bin/tmux source-file /Users/btaczala/dotfiles/tmux/tmux_tokyonight_night.tmux
fi
