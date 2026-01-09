pathprepend() { for dir in $@; [[ -d $dir:A ]] && path=($dir:A $path) }

typeset -U path
pathprepend ~/.local/bin ~/bin

export LC_COLLATE=C
export EDITOR=nvim
export BROWSER=firefox
export PAGER=less
export QT_QPA_PLATFORMTHEME=gtk3      # Have QT use gtk3 theme.
export MOZ_USE_XINPUT2=1              # Mozilla smooth scrolling/touchpads.
export _JAVA_AWT_WM_NONREPARENTING=1  # Fix for Java applications in dwm.

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
  exec startx
fi
