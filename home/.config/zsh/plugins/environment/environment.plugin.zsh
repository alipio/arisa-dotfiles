# Disable ctrl-s/ctrl-q to freeze/unfreeze terminal.
stty -ixon

export LESS='-FQMRig'
export LESSHISTFILE=-
export LESS_TERMCAP_md=$'\e[1;36m'    # start bold
export LESS_TERMCAP_so=$'\e[1;43;30m' # start standout
export LESS_TERMCAP_us=$'\e[1;32m'    # start underline
export LESS_TERMCAP_me=$'\e[0m'       # end bold/blink
export LESS_TERMCAP_ue=$'\e[0m'       # end underline
export LESS_TERMCAP_se=$'\e[0m'       # end standout
export MANROFFOPT=-c

# Custom ls colors.
export LS_COLORS="no=00:fi=00:di=34:ln=01;31:so=33:pi=33:ex=31:bd=36:cd=36:\
su=30;41:sg=30;43:tw=30;42:ow=30;46:or=01;35:"

export FZF_DEFAULT_OPTS='
  --height 60% --border
  --marker="✚" --pointer="▶" --prompt="❯ "
  --no-separator --scrollbar="▐"
'
