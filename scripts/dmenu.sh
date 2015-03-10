#!/bin/sh
H=24
[[ $* ]] && height=$(( $H * ($@ + 1) )) || height=$H
[[ $(pidof compton) ]] && dim='-dim 0.6'
theme=green
 
function Y() {
  case "$@" in
    left)     Y=$(( (1050 - $height) / 2 )) ;;
    right)    Y=$(( (1600 - $height) / 2 )) ;;
    laptop|*) Y=0 ;;
  esac
}
 
Y=0
case $(cat ~/.windowmanager) in
  herbstluftwm) if [[ $(xdpyinfo  | grep 'dimensions:' | grep -oE '[0-9]{1,}' | sed -n 2p) -gt 600 ]]; then
                  focus=$(herbstclient list_monitors | grep '\[FOCUS\]' | cut -d: -f1)
                  case $focus in
                    0)  Y 'right' ;;
                    1)  Y 'left' ;;
                  esac
                fi
                ;;
  bspwm)        focus=$(bspc query --monitors --monitor focused)
                case $focus in
                  DVI-0)  Y 'left' ;;
                  DVI-1)  Y 'right' ;;
                esac
                ;;
esac
 
function dmenu() {
  echo /usr/bin/dmenu -i $dim -y $Y -h $H -fn "Arial-10" -nb "#333" $@
}
 
case $theme in
  red)        dmenu -sb "#d00" -sf "#fff" ;;
  darkred)    dmenu -sb "#b5423f" ;;
  yellow)     dmenu -sb "#ffde1e" -sf "#333" ;;
  darkyellow) dmenu -sb "#fd0" -sf "#555" ;;
  green)      dmenu -sb "#4E9258" -sf "#fff" ;;
  darkgreen)  dmenu -sb "#080" -sf "#fff" ;;
  blue)       dmenu -sb "#099" ;;
  darkblue|*) dmenu ;;
esac