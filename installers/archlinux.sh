#!/bin/bash

packages=('sway-git' 'xorg-xprop' 'pass' 'rofi' 'greenclip' 'rofi-greenclip' 'rofi-pass' 'pinentry-rofi' 'ripgrep' 'vifm' 'python-pywal' 'nohang-git')

function install_yay() {
    package="yay"
    pacman -Qi $package > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Package $package already installed"
    else
        cd $(mktemp -d)
        echo "$PWD"
        git clone https://aur.archlinux.org/yay.git && cd yay
        makepkg -si
    fi

}

function install_if_needed() {
    package=$1
    pacman -Qi $package > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Package $package already installed"
    else
        yay -S $package --noconfirm
    fi
}

install_yay
for package in "${packages[@]}"
do
    echo "Installing $package"
    install_if_needed $package
done

