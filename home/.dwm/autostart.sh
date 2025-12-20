#!/bin/sh

picom_version=$(picom --version)

# gnome-keyring-daemon -r -d &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
autorandr --change --force && nitrogen --restore
sxhkd &
dwmblocks &
clipmenud &
if [ "$picom_version" = 'v9.1' ]; then
    picom --experimental-backends &
else
    picom &
fi
dunst &
redshift -l -23.5:-46.6 &
unclutter &
sh ~/.dwm/poststart.sh 2>/dev/null &
