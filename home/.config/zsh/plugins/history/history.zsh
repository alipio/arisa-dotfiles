[ -z "$HISTFILE" ] && HISTFILE=~/.local/state/zsh/history
HISTSIZE=11000
SAVEHIST=10000

setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt no_bang_hist
