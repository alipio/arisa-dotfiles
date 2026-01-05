pathprepend() { for dir in $@; [[ -d $dir:A ]] && path=($dir:A $path) }

pathprepend ~/.local/bin ~/bin

export LC_COLLATE=C
export EDITOR=nvim
export VISUAL=$EDITOR
export TERMINAL=alacritty
export BROWSER=firefox
export PAGER=less
export MANPAGER="less --use-color -Dd+g -Du+r"

export FZF_DEFAULT_OPTS="--height 60%"
export LESSHISTFILE=-
export LESS=Ri
export LS_COLORS="no=00:fi=00:di=34:ln=01;31:so=33:pi=33:ex=31:bd=36:cd=36:su=30;41:sg=30;43:tw=30;42:ow=30;46:or=01;35:"
export MANROFFOPT=-c
export BAT_THEME=gruvbox-dark
export QT_QPA_PLATFORMTHEME=gtk2
export _JAVA_AWT_WM_NONREPARENTING=1 # Fix for Java applications in dwm.
export XDG_CURRENT_DESKTOP=dwm

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
  exec startx
fi
