#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $EUID -ne 0 ]; then
  echo "This script should be run as root."
  exit 1
fi

# Install required dependencies for suckless programs.
pacman -S --needed --noconfirm libx11 libxft libxinerama libxrandr libxext \
  freetype2 fontconfig pam >/dev/null

for prog in clipnotify clipmenu dmenu dwm dwmblocks slock; do
  pushd "$SCRIPT_DIR/$prog" >/dev/null
  printf "Installing %s...\n" "$prog"
  rm -f config.h
  make clean install
  popd >/dev/null
done
unset prog
