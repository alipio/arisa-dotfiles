[ -z "$HISTFILE" ] && HISTFILE=~/.zsh_history
HISTSIZE=11000
SAVEHIST=10000

setopt extended_history
setopt inc_append_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt no_bang_hist
