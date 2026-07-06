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

# cp with a progress bar (rsync under the hood). Use \cp to bypass.
cp() {
  rsync -ah --info=progress2 --no-inc-recursive "$@"
}

# gpg leaves lock files behind after crashes/reboots and then hangs waiting on
# them forever. Clear locks whose holder PID is dead before running pass.
pass() {
  local f pid
  for f in ~/.gnupg/**/*.lock(N); do
    pid=$(awk 'NR==1 {print $1}' "$f")
    [[ -n "$pid" ]] && ! kill -0 "$pid" 2>/dev/null && rm -f "$f"
  done
  command pass "$@"
}

# Debian/Ubuntu rename fd to fdfind; only alias when that's actually the case.
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  alias fd=fdfind
fi
