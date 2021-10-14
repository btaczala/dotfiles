#!/bin/bash
export HOMEBREW_NO_AUTO_UPDATE=1

brew install fd fzf exa gnupg pass tig python3 node bat tmuxinator coreutils dfc htop pinentry-mac timewarrior task

# development stuff
brew install ninja just llvm freetype ccache git-delta conan rg

# cask
brew install --cask rectangle spotify

# python
brew install flake8 pylint pyright

hook_file=$(fd on-modify.timewarrior -t f /usr/local/)

mkdir -p $HOME/.task/hooks/
if [ ! -e $HOME/.task/hooks/on-modify.timewarrior ]; then
    cp $hook_file $HOME/.task/hooks/
    chmod +x $HOME/.task/hooks/on-modify.timewarrior
fi
