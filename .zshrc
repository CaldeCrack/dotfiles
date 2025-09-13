# Created by CaldeCrack
#
# Hellwal terminal colors
source ~/.cache/hellwal/variables.sh
sh ~/.cache/hellwal/terminal.sh

# fastfetch on startup
fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH environment variables
export ZSH=/usr/share/oh-my-zsh
export ZSH_CACHE_DIR=~/.cache/oh-my-zsh/
export ZSH_COMPDUMP=$ZSH_CACHE_DIR/.zcompdump-$HOST-$ZSH_VERSION

# Autocompletion features
autoload -Uz compinit
compinit -d $ZSH_COMPDUMP

# Predicting syntax
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Oh My Zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  ssh
  copyfile
  copypath
  fzf
  gitfast
  gitignore
  pip
  python
  qrcode
  sudo
  zsh-interactive-cd
)
source $ZSH/oh-my-zsh.sh

# Color output
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
export LESS='-R --use-color -Dd+r$Du+b$'
alias ls='ls --color=auto'
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Persistent history across sessions
SAVEHIST=1000
HISTFILE=~/.zsh_history
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias lobster='lobster --discord -q 720'
alias lgit='eza -la --no-user --header --git --icons=always'
alias lc='eza -la --no-user --header --icons=always'
alias l='eza'
alias nv='nvim'
alias update='source ~/.zshrc'
alias sudo='sudo '

# Environment variables
export SUDO_EDITOR=nvim

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

