#!/bin/sh

xinitdir="/etc/X11/xinit"

if [ -d "$xinitdir"/xinitrc.d ]; then
  for f in "$xinitdir/xinitrc.d"/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# keyboard stuff
setxkbmap br
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
xset r rate 200 60

exec dwm >"$HOME"/.dwm/log 2>&1
