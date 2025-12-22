# Utility

alias -g N='&>/dev/null'

alias less='less -R'
alias ..='cd ../'
alias reload='exec $SHELL'
alias cls=clear

# Tell grep to highlight matches and avoid VCS folders
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias egrep='grep -E'
alias fgrep='grep -F'

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ll -A'
alias lt='ll -t'

##=========

# Git

alias gaa='git add -A'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gci='git commit -v'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gs='git status'
