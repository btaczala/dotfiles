#!/bin/bash
ICON=/tmp/xkcd.png
TMPBG=/tmp/screen.png
~/dotfiles/skype_away.py away 
curl -s $(curl -sL "http://dynamic.xkcd.com/random/comic/" | grep -o "http://imgs.xkcd.com/comics/[^ ]*") -o $ICON &
scrot $TMPBG && convert $TMPBG -scale 5% -scale 2000% $TMPBG &
wait


PX=0
PY=0
# lockscreen image info
R=$(file $ICON | grep -o '[0-9]* x [0-9]*')
RA=(${R// x / })
SR=$(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*')
for RES in $SR
  do
    # monitor position/offset
    SRA=(${RES//[x+]/ })
    PX=$((${SRA[2]} + ${SRA[0]} / 2 - ${RA[0]} / 2))
    PY=$((${SRA[3]} + ${SRA[1]} / 2 - ${RA[1]} / 2))
    convert $TMPBG $ICON -geometry +$PX+$PY -composite -matte $TMPBG
done

i3lock -u -i $TMPBG -I 5 -d

rm /tmp/screen.png
rm /tmp/xkcd.png
~/dotfiles/skype_away.py online

