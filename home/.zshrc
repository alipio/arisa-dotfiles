# If not running interactively, don't do anything
[[ $- =~ i ]] || return

# Plugins
zsh_load_plugins() {
  local plugin
  for plugin ($@); do
    if [ -r "${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/plugins/$plugin/$plugin.zsh" ]; then
      source "${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/plugins/$plugin/$plugin.zsh" 2>/dev/null
    elif [ -r "${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/plugins/$plugin/$plugin.plugin.zsh" ]; then
      source "${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/plugins/$plugin/$plugin.plugin.zsh" 2>/dev/null
    elif [ -r "${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/plugins/$plugin/$plugin.zsh-theme" ]; then
      source "${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/plugins/$plugin/$plugin.zsh-theme"  2>/dev/null
    else
      echo "$funcstack[1]: Unable to load '$plugin'." >&2
    fi
  done
}

zsh_update_plugins() {
  local plugin
  for plugin (${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/plugins/*(N/)); do
    git -C "$plugin" rev-parse --is-inside-work-tree >/dev/null 2>&1 || continue
    printf '%s: ' "$plugin:t"
    git -C "$plugin" remote -v | grep -q upstream && { git -C "$plugin" fetch upstream || printf '%s: Could not fetch upstream...\n' "$plugin:t" }
    git -C "$plugin" pull 2>/dev/null || echo "Unable to upgrade."
  done
}

setopt autocd
setopt extendedglob
setopt no_globdots
setopt no_nomatch

plugins=(
  editor
  completion
  history
  aliases
  stack
  utils
  prompt
  zsh-z
)
zsh_load_plugins $plugins

autoload -U compinit
if [[ $HOME/.zcompdump(#qNmh-20) ]]; then
  compinit -C
else
  compinit -i
fi

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

true
