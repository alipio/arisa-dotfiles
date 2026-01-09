# If not running interactively, don't do anything
[[ $- =~ i ]] || return

# Plugins
zsh_load_plugins() {
  local plugin
  for plugin ($@); do
    if [ -r "${ZDOTDIR:-$HOME/.config/zsh}/plugins/$plugin/$plugin.zsh" ]; then
      source "${ZDOTDIR:-$HOME/.config/zsh}/plugins/$plugin/$plugin.zsh" 2>/dev/null
    elif [ -r "${ZDOTDIR:-$HOME/.config/zsh}/plugins/$plugin/$plugin.plugin.zsh" ]; then
      source "${ZDOTDIR:-$HOME/.config/zsh}/plugins/$plugin/$plugin.plugin.zsh" 2>/dev/null
    elif [ -r "${ZDOTDIR:-$HOME/.config/zsh}/plugins/$plugin/$plugin.zsh-theme" ]; then
      source "${ZDOTDIR:-$HOME/.config/zsh}/plugins/$plugin/$plugin.zsh-theme"  2>/dev/null
    else
      echo "$funcstack[1]: Unable to load '$plugin'." >&2
    fi
  done
}

zsh_update_plugins() {
  local plugin
  for plugin (${ZDOTDIR:-$HOME/.config/zsh}/plugins/*(N/)); do
    git -C "$plugin" rev-parse --is-inside-work-tree >/dev/null 2>&1 || continue
    printf '%s: ' "$plugin:t"
    git -C "$plugin" remote -v | grep -q upstream && { git -C "$plugin" fetch upstream || printf '%s: Could not fetch upstream...\n' "$plugin:t" }
    git -C "$plugin" pull 2>/dev/null || echo "Unable to upgrade."
  done
}

setopt auto_cd
setopt extended_glob
setopt no_glob_dots
setopt no_nomatch

plugins=(
  environment
  editor
  history
  stack
  utils
  zsh-z
  completion
  aliases
  prompt
)

zsh_load_plugins $plugins
unset plugins

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

true
