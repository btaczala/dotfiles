export EDITOR=nvim
export BROWSER=firefox
export HISTSIZE=100000
export SAVEHIST=100000
export VIFM=$HOME/dotfiles/config/vifm/vifmrc

if [ -d $HOME/dev/git-fuzzy/bin ]; then
    export PATH=$HOME/dev/git-fuzzy/bin:$PATH
fi

export LANG=en_US.UTF-8
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

export CMAKE_EXPORT_COMPILE_COMMANDS=ON
export CMAKE_C_COMPILER_LAUNCHER=sccache
export CMAKE_CXX_COMPILER_LAUNCHER=sccache
export SCCACHE_CACHE_SIZE="30G"
export CMAKE_GENERATOR="Ninja Multi-Config"
export HOMEBREW_NO_ENV_HINTS
export PATH=$HOME/.local/bin/:$HOME/dotfiles/bin:/usr/local/bin:$HOME/.cargo/bin/:$PATH
export AUTO_NOTIFY_WHITELIST=("brew" "docker" "cmake" "just")
export AUTO_NOTIFY_EXPIRE_TIME=40000

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null; then
eval "$(pyenv init - zsh)"
fi

export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
export PATH=$PATH:/opt/ST/STM32CubeCLT_1.19.0/GNU-tools-for-STM32/bin/
export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources
export CLAUDE_CODE_TMPDIR=~/.local/share/claude/tmp/
