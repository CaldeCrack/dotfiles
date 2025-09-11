typeset -U path PATH
path=(~/.local/bin $path)
export PATH
export XDG_CONFIG_HOME=$HOME/.config

. "$HOME/.cargo/env"
