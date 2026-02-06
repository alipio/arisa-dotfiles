# General
alias ..='cd ../'
alias gti=git
alias less='less -R'
alias open=xdg-open
alias ping='ping -c 4'
alias reload='exec $SHELL'
alias sudo='sudo ' # Expand aliases after sudo
alias vim=nvim
alias x=extract

# Tell grep to highlight matches and avoid VCS folders
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias egrep='grep -E'
alias fgrep='grep -F'

# ls
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ll -A'
alias lt='ll -tr'

# Pretty print the path
alias path='echo $PATH | tr -s : \\n'

# Global aliases
alias -g G='| grep -i'
alias -g L='| less'
alias -g N='>/dev/null'
alias -g E='2>/dev/null'
