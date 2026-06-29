if [[ ! -f $HOME/.zinit/bin/zi.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zi.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice depth"1"
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions

# zinit light junegunn/fzf
zinit light unixorn/fzf-zsh-plugin
zinit light MichaelAquilina/zsh-auto-notify

zinit load agkozak/zsh-z
zinit light Aloxaf/fzf-tab
