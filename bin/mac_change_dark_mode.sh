#!/bin/bash

mode=$($HOME/dotfiles/bin/darkMode.py)
if [[ ! ( $($HOME/dotfiles/bin/darkMode) =~ 'Dark' ) ]]; then
  /usr/local/bin/fd mykitty /tmp -x /usr/local/bin/kitty @ --to unix:{} set-colors --all --configured ~/.config/kitty/kitty-themes/themes/Tomorrow.conf
else
  /usr/local/bin/fd mykitty /tmp -x /usr/local/bin/kitty @ --to unix:{} set-colors --all --configured ~/.config/kitty/kitty-themes/themes/Tomorrow_Night.conf
fi
