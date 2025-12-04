#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPS=(libx11 libxft libxinerama libxrandr libxext freetype2 fontconfig pam)

if [ "$EUID" -ne 0 ]; then
  printf "This script should be run as root.\n"
  exit 1
fi

cd "$SCRIPT_DIR"

printf "Installing required dependencies...\n"
pacman -S --needed --noconfirm "${DEPS[@]}"

for prog in clipnotify clipmenu dmenu dwm dwmblocks slock; do
  pushd "$prog" >/dev/null
  printf "Installing %s...\n" "$prog"
  rm -f config.h
  make clean install
  popd >/dev/null
done
unset prog
