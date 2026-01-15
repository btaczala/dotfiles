alias gst='git status'
alias gup='git pull --rebase'
alias ls='eza --icons=always'
alias ll='eza -lah --icons=always --git'
alias lg='lazygit'
alias j=just
alias icat="kitty +kitten icat"
alias gco='git checkout'
alias gc='git commit'
alias gst='git status'
alias gb='git branch'

alias lldb_last='lldb -o "run" -- $(fc -ln -1)'
alias cat='bat'

#
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias fd=fdfind
fi
