source ~/.zprezto/init.zsh
host=`uname`
if [[ "$host" == "Darwin" ]]; then
    export CLICOLOR=YES
    source ~/.zprezto/init.zsh
    source ~/.zprezto/runcoms/zshrc
    source ~/dotfiles/zsh/zpreztorc
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
else
    if [[ `export | grep TMUX` ]]; then
    else
        export TERM='xterm-256color'
    fi
    source ~/.zprezto/init.zsh
    source ~/.zprezto/runcoms/zshrc
    source ~/dotfiles/zprezto/.zpreztorc
fi

export EDITOR=vim
export PATH=$HOME/.gem/ruby/2.1.0/bin:$PATH
export PATH=$HOME/dotfiles/scripts:$PATH
export PAGER=less

unset GREP_COLOR
unset GREP_OPTIONS

alias gst='git status'
alias gup='git pull --rebase'
alias clip='xsel -i -b'
# 
# tmux aliases
alias tmls='tmux list-sessions'
alias tma='tmux attach-session'
alias tmks='tmux kill-server'

# task warrior aliases
alias t='task'

alias m='make -j9'

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

eval "$(fasd --init auto)"
#alias j='fasd_cd -d -i'
alias cola='QT_QPA_PLATFORMTHEME= /usr/bin/git-cola'

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

source /usr/lib/z.sh
source ~/dotfiles/zsh/functions.sh
source ~/dotfiles/zsh/fzf-marks.plugin.zsh
alias j=jump

stty -ixon

fpath=($fpath ~/dotfiles/zsh/completion)


