# General
alias less='less -R'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias egrep='grep -E'
alias fgrep='grep -F'
alias ..='cd ../'
alias open=xdg-open
alias ping='ping -c 5'
alias reload='exec $SHELL'
alias vim=nvim
alias x=unarchive

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Expand aliases after sudo
alias sudo='sudo '

# ls
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ll -A'
alias lt='ll -tr'

# git
alias gaa='git add -A'
alias gap='git add -p'
alias gb='git branch'
alias gcl='git clone --recursive'
alias gc='git commit'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gmt='git mergetool --no-prompt --tool=vimdiff'
alias gpl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias gri='git rebase -i @{u}'
alias grv='git revert'
alias gsm='git submodule'
alias gsma='git submodule add'
alias gsms='git submodule sync'
alias gsmu='git submodule update --init'
alias gst='git stash'
alias gstc='git stash clear'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gs='git status -sb'

# Global aliases
alias -g N='&>/dev/null'
