#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# Keyboard stuff.
xset r rate 200 60
xkbcomp -w 0 ~/.config/xkb/personal $DISPLAY
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
autorandr --change --force && nitrogen --restore
sxhkd &
dwmblocks &
clipmenud &
picom &
dunst &
redshift -l -23.5:-46.6 &
unclutter &
sh ~/.dwm/poststart.sh 2>/dev/null &
