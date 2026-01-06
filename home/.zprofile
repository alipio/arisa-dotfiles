pathprepend() { for dir in $@; [[ -d $dir:A ]] && path=($dir:A $path) }

pathprepend ~/.local/bin ~/bin

export LC_COLLATE=C
export LESSHISTFILE=-
export EDITOR=nvim
export VISUAL=$EDITOR
export PAGER=less
export TERMINAL=alacritty
export BROWSER=firefox

export FZF_DEFAULT_OPTS='
  --height 60% --border
  --marker="✚" --pointer="▶" --prompt="❯ "
  --no-separator --scrollbar="┃"
'
export LESS=Ri
export LESS_TERMCAP_md=$'\e[1;36m'    # Begin bold
export LESS_TERMCAP_me=$'\e[0m'       # Reset bold/blink
export LESS_TERMCAP_us=$'\e[1;32m'    # Begin underline
export LESS_TERMCAP_ue=$'\e[0m'       # Reset underline
export LESS_TERMCAP_so=$'\e[1;43;30m' # Begin standout
export LESS_TERMCAP_se=$'\e[0m'       # Reset standout
export GROFF_NO_SGR=1
export QT_QPA_PLATFORMTHEME=gtk2      # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2=1              # Mozilla smooth scrolling/touchpads.
export _JAVA_AWT_WM_NONREPARENTING=1  # Fix for Java applications in dwm.
export BAT_THEME=gruvbox-dark
export LS_COLORS="no=00:fi=00:di=34:ln=01;31:so=33:pi=33:ex=31:bd=36:cd=36:\
su=30;41:sg=30;43:tw=30;42:ow=30;46:or=01;35:"

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
  exec startx
fi
