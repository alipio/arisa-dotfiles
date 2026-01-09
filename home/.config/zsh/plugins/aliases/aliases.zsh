# Remove all previous environment defined aliases.
unalias -a

# Global aliases.
alias -g N='&>/dev/null'

# Misc.
alias less='less -R'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias egrep='grep -E'
alias fgrep='grep -F'
alias ..='cd ../'
alias reload='exec zsh'
alias vim='nvim'
alias sudo='sudo ' # expand aliases with sudo.
alias open='xdg-open'

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ll -A'
alias lt='ll -t'

##=========

# Git.
alias gaa='git add -A'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gci='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gpl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gs='git status -sb'
