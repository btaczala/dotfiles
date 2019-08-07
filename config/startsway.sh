#!/bin/bash

export QT_QPA_PLATFORMTHEME=qt5ct
# this fixes an issue where Qt apps scale like shit
# after suspend/resume combo
export QT_QPA_PLATFORM=wayland
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
export QT_LOGGING_RULES="qt5ct.debug=false"
export MOZ_ENABLE_WAYLAND=1
export WLR_DRM_DEVICES=/dev/dri/card0
if [ -e /tmp/sway.log ]; then
    rm -rf /tmp/sway.log
fi
sway > /tmp/sway.log 2>&1
