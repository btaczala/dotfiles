#!/bin/bash

packages=('xwobf-git' 'bspwm' 'sway' 'xorg-xprop' 'pass' 'rofi' 'greenclip' 'pass-ssh' 'rofi-pass' 'pinentry-rofi')

function install_yaourt() {
    sudo pacman -S --needed base-devel git wget yajl
    cd $(mktemp -d)
    echo "$PWD"
    git clone https://aur.archlinux.org/package-query.git > /dev/null
	cd package-query
	makepkg -si > /dev/null
    cd ..
    git clone https://aur.archlinux.org/yaourt.git > /dev/null
    cd yaourt
    makepkg -si > /dev/null
    cd .. 
    rm -rfv yaourt/ package-query/
}

function install_if_needed() {
    package=$1
    pacman -Qi $package > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Package $package already installed"
    else 
        yaourt -S $package --noconfirm
    fi
}

echo "Checking for yaourt"
pacman -Qi > /dev/null 2>&1
if [ ! $? -eq 0 ]; then
    install_yaourt
fi

for package in "${packages[@]}" 
do
    echo "Installing $package"
    install_if_needed $package
done

