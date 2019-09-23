source ~/.zprezto/init.zsh
host=`uname`
if [[ "$host" == "Darwin" ]]; then
    source ~/.zprezto/init.zsh
    source ~/.zprezto/runcoms/zshrc
    source ~/dotfiles/zprezto/.zpreztorc
    export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
    export TERM='xterm-256color'
    # MacOS: Bug that causes a lot of programs to show "Warning: Failed to set locale category .."
    # https://discourse.brew.sh/t/failed-to-set-locale-category-lc-numeric-to-en-ru/5092/6
    export LC_ALL=en_US.UTF-8

    # from http://apas.gr/2018/11/dark-mode-macos-safari-iterm-vim/
    sith() {
        val=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
        if [[ $val == "Dark" ]]; then
            i
        fi
    }

    i() {
        if [[ $ITERM_PROFILE == "light" ]]; then
            echo -ne "\033]50;SetProfile=dark\a"
            export ITERM_PROFILE="dark"
        else
            echo -ne "\033]50;SetProfile=light\a"
            export ITERM_PROFILE="light"
        fi
    }

    sith

else
    if [[ `export | grep TMUX` ]]; then
    else
        export TERM='xterm-256color'
    fi
    source ~/.zprezto/init.zsh
    source ~/.zprezto/runcoms/zshrc
    source ~/dotfiles/zprezto/.zpreztorc
fi

export EDITOR=nvim
export BROWSER=firefox
export PATH=$HOME/.gem/ruby/2.5.0/bin:$PATH
export PATH=$HOME/dotfiles/scripts:$PATH
export PAGER=less

unset GREP_COLOR
unset GREP_OPTIONS

alias gst='git status'
alias gup='git pull --rebase'
alias clip='xsel -i -b'
alias ls='exa'
alias llsa='exa --all -l --grid --header --git'
alias lls='exa -l --grid --header --git'
#
# tmux aliases
alias tmls='tmux list-sessions'
alias tma='tmux attach-session'
alias tmn='tmux new-session'
alias tmks='tmux kill-server'

# task warrior aliases
alias t='task'

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

if [[ "$host" == "Darwin" ]]; then
    export CLICOLOR=YES
    source ~/.zprezto/init.zsh
    source ~/.zprezto/runcoms/zshrc
    source ~/dotfiles/zprezto/.zpreztorc
else
    source ~/.zprezto/init.zsh
    source ~/.zprezto/runcoms/zshrc
    source ~/dotfiles/zprezto/.zpreztorc
fi

function title() {
    # escape '%' chars in $1, make nonprintables visible
    local a=${(V)1//\%/\%\%}

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")
    case $TERM in
        screen*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            print -Pn "\ek$a\e\\"      # screen title (in ^A")
            print -Pn "\e_$2   \e\\"   # screen location
            ;;
        xterm*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd() {
    title "zsh" "%m:%55<...<%~"
}
# preexec is called just before any command line is executed
function preexec() {
    title "$1" "%m:%35<...<%~"
}

source $HOME/dotfiles/zsh/fzf-marks.plugin.zsh
source $HOME/dotfiles/zsh/my_fzf.sh

stty -ixon

fpath=($fpath ~/dotfiles/zsh/completion)

unset -f make

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
# For OSX
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fpath+=${ZDOTDIR:-~}/.zsh_functions

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# text file are to light for light theme
export LS_COLORS="*.txt=0;0"
