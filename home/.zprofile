path_prepend() { for dir in $@; [[ -d $dir:A ]] && path=($dir:A $path) }

typeset -U path
path_prepend ~/.local/bin ~/bin ~/.asdf/shims

export LC_COLLATE=C.UTF-8             # Force sorting to be byte-wise.
export QT_QPA_PLATFORMTHEME=gtk2      # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2=1              # Mozilla smooth scrolling/touchpads.
export _JAVA_AWT_WM_NONREPARENTING=1  # Fix for Java applications in dwm.

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
  exec startx
fi
