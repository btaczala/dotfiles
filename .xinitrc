#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrdb ~/.Xresources 
xset +fp ~/.fonts
xset +fp /usr/share/fonts/local 
xset fp rehash 
unclutter -grab -noevents -root &
compton &
dunst -config /home/bata/dotfiles/dunstrc &

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
sxhkd &
xbinkeys &
exec bspwm
