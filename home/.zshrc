# Disable XON/XOFF (ctrl-s/ctrl-q) flow control.
stty -ixon

setopt extended_glob

fpath=(~/.config/zsh/{prompt,functions,completions} $fpath)

autoload -U promptinit; promptinit
prompt pure

autoload -U compinit; compinit

for func in ~/.config/zsh/functions/*(N.); do
  autoload -U $func:t
done
unset func

for rc in ~/.config/zsh/zshrc.d/*.zsh(N); do
  source "$rc"
done
unset rc

for f in \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
do
  if [[ -f "$f" ]]; then
    source "$f"; unset ZSH_AUTOSUGGEST_USE_ASYNC; break
  fi
done
unset f

for f in \
  ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
  /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  if [[ -f "$f" ]]; then
    source "$f"; break
  fi
done
unset f

ZSHZ_CASE=smart
source ~/.config/zsh/plugins/zsh-z/zsh-z.plugin.zsh

# Local config.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

true
