#!/bin/sh
# info.sh
# Output information with formatted background colors in lemonbar format
# This script can take arguments for what bar information to display(meant to be the names of the functions)

# clickable area aliases
AC='%{A:'           # start click area
AB=':}'             # end click area cmd
AE='%{A}'           # end click area

icon() {
    echo -n -e "${cIcon}\u$1 ${cContent}"
}

clock() {
    display="$(icon f073)$(date '+%b%e,%l:%M')"
    command='urxvt -hold -title calendar_floating -g 120x50 -e /usr/bin/gcalcli calm -w 16'
    echo ${AC}$command${AB}$display${AE}
}

mail() {
    icon f0e0
    $HOME/.config/bspwm/panel/panel_mail
}

memory() {
    icon f17c
    used=`free -m | grep Mem | cut -d ' ' -f20`
    total=`free -m | grep Mem | cut -d ' ' -f12`
    echo $used/$total
}

disk() {
    icon f0a0
    used=`df -h | grep home | awk '{print $3}'`
    total=`df -h | grep home | awk '{print $2}'`
    echo $used/$total
}

battery() {
    BATC=/sys/class/power_supply/BAT1/capacity
    BATS=/sys/class/power_supply/BAT1/status
    icon f0e7
    if [ -f $BATC ]; then
        [ "`cat $BATS`" = "Charging" ] && echo -n '+' || echo -n '-'
        cat $BATC
    else
        #no battery information found.
        echo '+100'
    fi
}

volume() {
    vol=`$HOME/.config/bspwm/panel/panel_volume`
    
    display="$(icon f028)$vol"
    command='pavucontrol'
    echo ${AC}$command${AB}$display${AE}
}

network() {
    read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
    if iwconfig $int1 >/dev/null 2>&1; then
        wifi=$int1
        eth0=$int2
    else
        wifi=$int2
        eth0=$int1
    fi
    ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 ||int=$wifi
    icon f0ac
    ping -W 1 -c 1 8.8.8.8 >/dev/null 2>&1 &&
        echo -e '\uf00c' || echo -e '\uf00d'
}

mpd() {
    cur_song=$(mpc current | cut -c1-30)

    icon f025
    if [ -z "$cur_song" ]; then
        echo "Stopped"
    else
        paused=$(mpc | grep paused)
        [ -z "$paused" ] && echo "${AC}mpc pause${AB} $cur_song${AE}" ||
                            echo "${AC}mpc play${AB} $cur_song${AE}"
    fi
}

yaourtUpdates() {
    updates=$(eval yaourt -Qu | wc --lines)
    command='urxvt -e sh -c "yaourt -Syua"'
    echo ${AC}$command${AB}$(icon f062)$updates${AE}
}

#determine what to display based on arguments, unless there are none, then display all.
while :; do
    buf="S"
    if [ -z "$*" ];then
        buf="${buf}${delim2}$(mpd)"
        buf="${buf}${delim}$(mail)"
        buf="${buf}${delim2}$(yaourtUpdates)"
        buf="${buf}${delim}$(battery)"
        buf="${buf}${delim2}$(network)"
        buf="${buf}${delim2}$(disk)"
        buf="${buf}${delim2}$(memory)"
        buf="${buf}${delim}$(volume)"
        buf="${buf}${delim}$(clock)"
    else
        cur_delim="$delim2"
        for arg in "$@"; do
            buf="${buf}${cur_delim}$($arg)"
            [ "$cur_delim" = "$delim" ] && cur_delim="$delim2" || cur_delim="$delim"
        done
    fi

    echo "$buf $pBG"
    sleep 1 # The HUD will be updated every second
done
