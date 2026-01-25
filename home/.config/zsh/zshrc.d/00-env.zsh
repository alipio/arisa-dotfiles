# General options.
setopt auto_cd
setopt extended_glob
setopt no_beep
setopt no_nomatch

# Job control options.
setopt long_list_jobs        # List jobs in the long format by default.
setopt notify                # Report status of background jobs immediately.
setopt no_bg_nice            # Don't run all background jobs at a lower priority.
setopt no_check_jobs         # Don't report on jobs when shell exit.
setopt no_hup                # Don't kill jobs on shell exit.

# Various env variables.
export EDITOR=nvim
export PAGER=less
export BROWSER=firefox
export LESS=-FQMRig
export LESSHISTFILE=-

# Colorful man pages.
export LESS_TERMCAP_md=$'\e[1;36m'    # start bold
export LESS_TERMCAP_so=$'\e[1;43;30m' # start standout
export LESS_TERMCAP_us=$'\e[1;32m'    # start underline
export LESS_TERMCAP_me=$'\e[0m'       # end bold/blink
export LESS_TERMCAP_ue=$'\e[0m'       # end underline
export LESS_TERMCAP_se=$'\e[0m'       # end standout
export MANROFFOPT=-c

# Set config for fzf.
export FZF_DEFAULT_OPTS='
  --height 60% --border
  --marker="✚" --pointer="▶" --prompt="❯ "
  --no-separator --scrollbar="▐"
'

# Set default theme for bat.
export BAT_THEME=ansi

# Colors for ls.
export LS_COLORS="no=00:fi=00:di=34:ln=01;31:so=33:pi=33:ex=31:bd=36:cd=36:\
su=30;41:sg=30;43:tw=30;42:ow=30;46:or=01;35:"
