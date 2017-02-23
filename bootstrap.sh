#!/bin/bash

function install_yaourt() {
    cd /tmp
    sudo pacman -S --needed base-devel git wget
    git clone https://aur.archlinux.org/package-query.git 
    cd package-query
    makepkg -si 

    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt
    makepkg -si
}

if ! hash yaourt 2>/dev/null; then
    install_yaourt
else
    echo "Yaourt already installed"
fi
