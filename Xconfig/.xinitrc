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
unclutter -noevents -root &
dunst -config ~/dotfiles/dunstrc &
nitrogen --restore
export XDG_CURRENT_DESKTOP=GNOME
export QT_QPA_PLATFORMTHEME=qt5ct

systemctl --user start redshift

sxhkd &
xbindkeys &
synclient VertScrollDelta=-111
synclient HorizScrollDelta=-111
export KDE_FULL_SESSION=1
exec bspwm > /tmp/bspwm.log 2>&1
