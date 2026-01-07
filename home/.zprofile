pathprepend() { for dir in $@; [[ -d $dir:A ]] && path=($dir:A $path) }

typeset -U path
pathprepend ~/.local/bin ~/bin

export LC_COLLATE=C
export LESSHISTFILE=-
export TERMINAL=alacritty
export EDITOR=nvim
export BROWSER=firefox
export PAGER=less

export QT_QPA_PLATFORMTHEME=gtk3      # Have QT use gtk3 theme.
export MOZ_USE_XINPUT2=1              # Mozilla smooth scrolling/touchpads.
export _JAVA_AWT_WM_NONREPARENTING=1  # Fix for Java applications in dwm.
export BAT_THEME=ansi

export FZF_DEFAULT_OPTS='
  --height 60% --border
  --marker="✚" --pointer="▶" --prompt="❯ "
  --no-separator --scrollbar="▐"
'

export LS_COLORS='no=00:fi=00:di=34:ln=01;31:so=33:pi=33:ex=31:bd=36:cd=36:\
su=30;41:sg=30;43:tw=30;42:ow=30;46:or=01;35:'

export LESS=Ri
export LESS_TERMCAP_md=$'\e[1;36m'    # Begin bold
export LESS_TERMCAP_us=$'\e[1;32m'    # Begin underline
export LESS_TERMCAP_so=$'\e[1;43;30m' # Begin standout
export LESS_TERMCAP_me=$'\e[0m'       # End bold/blink
export LESS_TERMCAP_ue=$'\e[0m'       # End underline
export LESS_TERMCAP_se=$'\e[0m'       # End standout
export MANROFFOPT=-c

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
  exec startx
fi
