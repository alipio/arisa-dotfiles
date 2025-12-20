pathprepend() { for dir in $@; [[ -d $dir:A ]] && path=($dir:A $path) }

pathprepend ~/.local/bin ~/bin

export LC_COLLATE=C
export EDITOR=nvim
export VISUAL=$EDITOR
export TERMINAL=alacritty
export BROWSER=firefox
export PAGER=less
export LESS=-Ri
export LESSHISTFILE=-
export LS_COLORS="no=00:fi=00:di=34:ln=01;31:pi=34;43:so=31;43:bd=30;43:cd=30;43:or=01;35:ex=31:"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"

# Support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export QT_QPA_PLATFORMTHEME=gtk2
export _JAVA_AWT_WM_NONREPARENTING=1 # Fix for Java applications in dwm
export BAT_THEME=ansi
export XDG_CURRENT_DESKTOP=dwm

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
  exec startx
fi
