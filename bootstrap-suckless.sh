#!/bin/bash
# shellcheck disable=SC2034

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TEMP_DIR=""
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
AUR_PKGS=(asdf-vm nitrogen gtk-engine-murrine qt5-styleplugins)

log_info() {
  printf "==> %s\n" "$*"
}

log_warn() {
  printf "${YELLOW}[!] %s${NC}\n" "$*"
}

log_error() {
  printf "${RED}[X] %s${NC}\n" "$*" >&2
}

cleanup() {
  rm -rf "$TEMP_DIR"
}

error_handler() {
  local exit_code=$?
  local line_number=$1
  log_error "Script failed with exit code $exit_code at line $line_number"
  exit $exit_code
}

create_temp_dir() {
  if ! TEMP_DIR=$(mktemp -d -t arch-bootstrap-XXXXXX); then
    log_error "Could not create temporary directory."
    exit 1
  fi
}

check_non_root() {
  if [[ $EUID -eq 0 ]]; then
    log_error "This script must not be run as root."
    exit 1
  fi
}

check_arch_distro() {
  if [[ ! -f /etc/arch-release ]]; then
    log_error "This script is intended for Arch Linux only."
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
  sudo pacman -Su --noconfirm >/dev/null
}

install_deps() {
  log_info "Installing core dependencies. Please be patient, this could take a while..."
  install_pkgs
  install_suckless
  install_bw_cli
}

install_pkgs() {
  log_info "Installing required packages..."
  install_yay
  sudo pacman -S --needed --noconfirm "${PKGS[@]}" >/dev/null
  yay -S --needed --noconfirm "${AUR_PKGS[@]}" >/dev/null
}

install_suckless() {
  log_info "Installing suckless programs..."
  sudo suckless/install.sh
}

install_bw_cli() {
  command -v bw >/dev/null && return 0
  log_info "Installing Bitwarden CLI..."
  pushd "$TEMP_DIR" >/dev/null
  curl -Lsf "https://bitwarden.com/download/?app=cli&platform=linux" -o bw.zip
  unzip -q bw.zip
  sudo install -m755 bw -t /usr/local/bin
  popd >/dev/null
}

install_yay() {
  command -v yay >/dev/null && return 0
  log_info "Installing yay (AUR helper)..."
  sudo pacman -S --needed --noconfirm base-devel git >/dev/null
  local yay_dir="$TEMP_DIR/yay"
  git clone --quiet --depth 1 https://aur.archlinux.org/yay-bin.git "$yay_dir"
  (cd "$yay_dir" && makepkg -si --noconfirm >/dev/null)
  # Make sure *-git AUR packages get updated automatically.
  yay -Y --save --devel
}

deploy_configs() {
  log_info "Deploying configs..."

  mkdir -p ~/.{config,local}
  mkdir -p ~/{screenshots,notes,Downloads,Documents,Music,Pictures,Videos}

  rm -f ~/.bashrc ~/.bash_*

  if [ -f .gitmodules ]; then
    git submodule --quiet sync --recursive
    git submodule --quiet update --init --recursive
  fi
  stow -R home -t ~

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
  nvim --headless -c "PlugInstall|qa"
}

enable_services() {
  log_info "Enabling essential services..."
  sudo systemctl --quiet --now enable keyd.service
  sudo systemctl --quiet --now  enable power-profiles-daemon
  systemctl --user daemon-reload
  systemctl --quiet --user --now enable checkup.timer || true
}

setup_ssh_keys() {
  log_info "Setting up SSH keys..."
  if ! bw login --check 2>/dev/null; then
    BW_SESSION=$(bw login --raw)
    export BW_SESSION
  fi
  bw sync --force >/dev/null
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  bw get item github_ssh | jq -r .sshKey.privateKey >~/.ssh/id_ed25519
  bw get item github_ssh | jq -r .sshKey.publicKey >~/.ssh/id_ed25519.pub
  bw logout >/dev/null
  ssh-keyscan github.com gitlab.com >~/.ssh/known_hosts
  echo "AddKeysToAgent yes" >~/.ssh/config
  chmod 600 ~/.ssh/*
  chmod 644 ~/.ssh/{id_ed25519.pub,known_hosts}
}

set_zsh_as_default_shell() {
  log_info "Setting zsh as default shell..."
  sudo chsh -s "$(which zsh)" "$USER"
}

main() {
  log_info "Starting Arch Linux suckless bootstrap..."

  check_non_root
  check_arch_distro

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
  setup_ssh_keys
  set_zsh_as_default_shell

  log_info "Bootstrap completed successfully!"
  log_info "Please reboot or run 'startx' to start the desktop environment"
}

trap cleanup EXIT
trap 'error_handler $LINENO' ERR

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

main "$@"
