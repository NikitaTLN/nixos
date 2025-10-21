# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

autoload -Uz compinit && compinit

zinit cdreplay -q

eval "$(oh-my-posh init zsh --config $HOME/.config/omp/config.toml)"

bindkey -e

bindkey '^k' history-search-backward
bindkey '^j' history-search-forward
bindkey '^[w' kill-region
bindkey -s '^g' "python3 $HOME/nixos/config/scripts/forge.py"$'\n'
bindkey -s '^v' "python3 $HOME/nixos/config/scripts/gcom.py"$'\n'
bindkey -s '^f' "$HOME/nixos/config/scripts/dive"$'\n'
bindkey -s '^w' "$HOME/nixos/config/scripts/markdown"$'\n'
bindkey -s '^b' "$HOME/nixos/config/scripts/menu-tui"$'\n'
bindkey -s '^e' "$HOME/nixos/config/scripts/fuzzcat"$'\n'


#if command -v tmux >/dev/null 2>&1; then
#  if [ -z "$TMUX" ]; then
#    tmux attach -t workflow || tmux new -s workflow
#  fi
#fi


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

alias vim='nvim'
alias v="nvim -c Telescope find_files"
alias ls='eza -a -1 --color=always --icons=always'
alias et='eza -a -1 --color=always --icons=always -T'
alias build="sudo nixos-rebuild --flake ~/nixos#nixos-btw --impure switch"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
