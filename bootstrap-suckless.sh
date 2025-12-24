#!/bin/bash
# shellcheck disable=SC2034

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TEMP_DIR=""
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKGS=(
  base-devel git curl man-db less neovim stow libyaml
  arandr autorandr picom libnotify dunst unclutter
  xsel flameshot brightnessctl sxhkd redshift xdotool
  xorg-server xorg-xinit xorg-xprop xorg-xset xorg-xsetroot
  alacritty zsh zsh-syntax-highlighting diff-so-fancy helix
  btop fzf ripgrep jq bat ncdu reflector pacman-contrib openssh rsync
  plocate moreutils acpi sysstat nsxiv mpv ffmpeg yt-dlp fastfetch
  lxappearance firefox galculator zathura zathura-pdf-mupdf zathura-cb
  cantarell-fonts ttf-dejavu ttf-jetbrains-mono-nerd
  noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra
  pulseaudio pulseaudio-alsa alsa-utils pavucontrol
  gnome-keyring polkit-gnome keyd power-profiles-daemon
  thunar thunar-media-tags-plugin tumbler poppler-glib
  thunar-archive-plugin xarchiver 7zip unrar unzip xdg-utils zip
  thunar-volman gvfs gvfs-mtp udisks2
)

log_info() {
  printf "==> %s\n" "$@"
}

log_warn() {
  printf "${YELLOW}[!] Warning:${NC} %s\n" "$@"
}

log_error() {
  printf "${RED}[X] Error:${NC} %s\n" "$@"
}

cleanup() {
  if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
  fi
}

error_handler() {
  local exit_code=$?
  log_error "Script failed with exit code $exit_code at line $LINENO"
  exit $exit_code
}

create_temp_dir() {
  if ! TEMP_DIR=$(mktemp -d -t arch-bootstrap-XXXXXX); then
    log_error "Could not create temporary directory"
    exit 1
  fi
}

check_root() {
  if [[ $EUID -eq 0 ]]; then
    log_error "This script should not be run as root"
    exit 1
  fi
}

check_arch() {
  if [[ ! -f /etc/arch-release ]]; then
    log_error "This script is intended for Arch Linux only"
    exit 1
  fi
}

configure_pacman() {
  log_info "Configuring pacman..."
  # Enable parallel downloads for faster installation.
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
  sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
  # Use all cores for compilation.
  sudo sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf
}

update_system() {
  log_info "Updating system..."
  sudo pacman -Syy --needed --noconfirm archlinux-keyring >/dev/null
  sudo pacman -Su --noconfirm
}

install_deps() {
  log_info "Installing dependencies..."
  install_pkgs
  install_suckless
  install_bw_cli
}

install_pkgs() {
  log_info "Installing required packages..."
  install_yay
  sudo pacman -S --needed --noconfirm "${PKGS[@]}"
  yay -S --needed --noconfirm asdf-vm nitrogen gtk-engine-murrine qt5-styleplugins
}

install_suckless() {
  log_info "Installing suckless programs..."
  sudo "$DOTFILES_ROOT"/suckless/install.sh
}

install_bw_cli() {
  command -v bw >/dev/null && return 0
  log_info "Installing Bitwarden CLI..."
  (
    cd "$TEMP_DIR" || return 1
    curl -Lfs "https://bitwarden.com/download/?app=cli&platform=linux" -o bw.zip
    unzip -q bw.zip
    sudo install -m755 bw -t /usr/local/bin
    rm bw
  )
}

install_yay() {
  command -v yay >/dev/null && return 0
  log_info "Installing yay (AUR helper)..."
  sudo pacman -S --needed --noconfirm base-devel git >/dev/null
  local yay_dir="$TEMP_DIR/yay"
  git clone -q --depth 1 https://aur.archlinux.org/yay-bin.git "$yay_dir"
  (cd "$yay_dir" || return 1; makepkg -si --noconfirm)
  # Make sure *-git AUR packages get updated automatically.
  yay -Y --save --devel
}

deploy_configs() {
  log_info "Deploying configs..."

  mkdir -p ~/.{config,local} \
    ~/{screenshots,notes,Downloads,Documents,Music,Pictures,Videos}

  rm -f ~/.bashrc ~/.bash_*

  (
    cd "$DOTFILES_ROOT" || return 1
    if [ -f .gitmodules ]; then
      git submodule -q sync --recursive
      git submodule -q update --init --recursive
    fi
    stow home -t ~
  )

  # keyd config.
  sudo mkdir -p /etc/keyd
  sudo ln -sf ~/.config/keyd/default.conf /etc/keyd/default.conf

  # Xorg config.
  sudo mkdir -p /etc/X11/xorg.conf.d
  sudo ln -sf ~/.config/xorg/10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
  sudo ln -sf ~/.config/xorg/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
}

install_vim_plugins() {
  log_info "Installing neovim plugins..."
  nvim -c "PlugInstall|qa"
}

enable_services() {
  log_info "Enabling essential services..."
  sudo systemctl enable --now keyd.service
  sudo systemctl enable --now power-profiles-daemon
  systemctl --user daemon-reload
  systemctl --user enable --now checkup.timer || true
}

setup_github_ssh_key() {
  log_info "Setting up GitHub SSH key..."
  BW_SESSION=$(bw login --raw)
  export BW_SESSION
  mkdir -p ~/.ssh
  (umask 077; bw get notes id_rsa_github > ~/.ssh/id_rsa)
  ssh-keyscan -p 22 -H github.com gitlab.com > ~/.ssh/known_hosts
  chown -R "$USER":wheel ~/.ssh
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/*
}

set_zsh_as_default_shell() {
  log_info "Setting zsh as default shell..."
  sudo chsh -s "$(which zsh)" "$USER"
}

main() {
  log_info "Starting Arch Linux suckless bootstrap..."

  trap cleanup EXIT
  trap error_handler ERR

  check_root
  check_arch

  create_temp_dir

  echo ""
  log_warn "This script will install packages and modify system configuration."
  log_warn "Make sure you have a stable internet connection."
  echo ""
  read -rp "Do you want to continue? (y/N): " -n 1
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installation aborted."
    exit 0
  fi

  # Execute installation steps
  configure_pacman
  update_system
  install_deps
  deploy_configs
  install_vim_plugins
  enable_services
  setup_github_ssh_key
  set_zsh_as_default_shell

  log_info "Bootstrap completed successfully!"
  log_info "Please reboot or run 'startx' to start the desktop environment"
}

main "$@"
