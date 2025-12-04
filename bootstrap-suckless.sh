#!/bin/bash

set -eu

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TEMP_DIR=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKGS=(
  base-devel git curl man-db less neovim stow libyaml
  arandr autorandr libnotify picom nitrogen dunst unclutter
  flameshot brightnessctl xsel sxhkd redshift xdotool
  xorg-server xorg-xinit xorg-xprop xorg-xset xorg-xsetroot
  alacritty zsh zsh-syntax-highlighting
  diff-so-fancy btop fzf ripgrep jq bat
  ncdu helix reflector openssh rsync
  ffmpeg yt-dlp plocate moreutils
  firefox nsxiv mpv galculator lxappearance
  zathura zathura-cb zathura-pdf-mupdf
  cantarell-fonts ttf-dejavu ttf-jetbrains-mono-nerd
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
  pulseaudio pulseaudio-alsa alsa-utils pavucontrol
  polkit-gnome keyd power-profiles-daemon
  thunar thunar-media-tags-plugin tumbler poppler-glib
  thunar-archive-plugin xarchiver 7zip unrar unzip xdg-utils zip
  thunar-volman gvfs gvfs-mtp gvfs-smb udisks2
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

clean_up() {
  if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
  fi
}

error_exit() {
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
  # Enable parallel downloads for faster installation.
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
  sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
  # Use all cores for compilation.
  sudo sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf
}

install_yay() {
  command -v yay &> /dev/null && return 0
  log_info "Installing yay (AUR helper)..."
  sudo pacman -S --needed --noconfirm base-devel git &>/dev/null
  local yay_dir="$TEMP_DIR/yay"
  git clone -q --depth 1 https://aur.archlinux.org/yay-bin.git "$yay_dir"
  (cd "$yay_dir" && makepkg -si --noconfirm) || log_error "yay installation failed"
  # Make sure *-git AUR packages get updated automatically.
  yay -Y --save --devel
}

update_system() {
  log_info "Updating system..."
  sudo pacman -Syy --needed --noconfirm archlinux-keyring
  sudo pacman -Su --noconfirm
}

install_base_packages() {
  log_info "Installing base packages..."

  sudo pacman -S --needed --noconfirm "${PKGS[@]}"
}

install_aur_packages() {
  log_info "Installing AUR packages..."
  yay -S --needed --noconfirm asdf-vm
}

install_suckless() {
  log_info "Installing suckless tools..."
  "$SCRIPT_DIR/suckless/install.sh"
}

enable_services() {
  log_info "Enabling essential services..."
  sudo systemctl enable --now keyd.service
}

create_user_dirs() {
  log_info "Creating basic user directories..."
  mkdir -p ~/.{config,local} \
    ~/{screenshots,notes,Downloads,Documents,Music,Pictures,Videos}
  cat > ~/.config/user-dirs.dirs << 'EOF'
XDG_DESKTOP_DIR="$HOME"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
XDG_PUBLICSHARE_DIR="$HOME"
EOF
}

deploy_dotfiles() {
  log_info "Deploying dotfiles..."

  # Sometimes there's a bashrc.
  rm -f ~/.bashrc

  cd ~/git
  stow --ignore "^(suckless|bootstrap)" dotfiles
  cd - >/dev/null
}

# TODO: set up GH ssh key

# Main execution function
main() {
  log_info "Starting Arch Linux suckless bootstrap..."

  trap clean_up EXIT
  trap error_exit ERR

  check_root
  check_arch

  create_temp_dir

  # Confirm with user
  echo ""
  log_warning "This script will install packages and modify system configuration."
  log_warning "Make sure you have a stable internet connection."
  echo ""
  read -rp "Do you want to continue? (y/N): " -n 1
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installation aborted."
    exit 0
  fi

  # Execute installation steps
  configure_pacman
  install_yay
  update_system
  install_base_packages
  install_aur_packages
  install_suckless
  enable_services
  create_user_dirs
  deploy_dotfiles

  log_info "Bootstrap completed successfully!"
  log_info "Please reboot or run 'startx' to start the desktop environment"
}

main "$@"
