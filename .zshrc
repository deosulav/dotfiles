# Helper functions local to script
_check_and_install() {
  local cmd=$1
  local pkg=$2

  if ! command -v $cmd &> /dev/null; then
    echo "$cmd could not be found. Installing $pkg..."
    if [[ $(uname) == "Darwin" ]]; then
      brew install $pkg
    else
      sudo apt-get update
      sudo apt-get install -y $pkg
    fi
  fi
}

_version_less_than() {
  local version1 version2
  version1=$(echo "$1" | awk -F. '{ printf "%d%03d%03d\n", $1,$2,$3 }')
  version2=$(echo "$2" | awk -F. '{ printf "%d%03d%03d\n", $1,$2,$3 }')
  [ "$version1" -lt "$version2" ]
}


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ $(uname) == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# Set the directory for zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's absent
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Add Powerlevel 10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Plugins setup
export NVM_LAZY_LOAD=true

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light lukechilds/zsh-nvm
zinit light Aloxaf/fzf-tab

# load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Mac specific bindings
if [[ $(uname) == "Darwin" ]]; then
  bindkey "\e[1;3D" backward-word     # ⌥←
  bindkey "\e[1;3C" forward-word      # ⌥→
  bindkey "^[[1;9D" beginning-of-line # cmd+←
  bindkey "^[[1;9C" end-of-line       # cmd+→
else
  bindkey "^[[1;5C" forward-word
  bindkey "^[[1;5D" backward-word
fi


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

# Install necessary tools
_check_and_install fzf fzf
_check_and_install zoxide zoxide 

# Completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias cls=clear

# Shell Integrations
local fzf_installed_version
fzf_installed_version=$(fzf --version | awk '{print $1}')

if _version_less_than "$fzf_installed_version" "0.48.0"; then
  if [[ ! -f ~/.fzf.completion.zsh ]]; then
    curl -fsSL https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh -o ~/.fzf.completion.zsh
  fi
  if [[ ! -f ~/.fzf.key-bindings.zsh ]]; then
    curl -fsSL https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh -o ~/.fzf.key-bindings.zsh
  fi
  source ~/.fzf.completion.zsh  
  source ~/.fzf.key-bindings.zsh
else
  eval "$(fzf --zsh)"
fi

if [[ $(uname) == "Darwin" ]]; then
  eval "$(zoxide init zsh)"
else
  eval "$(zoxide init zsh --cmd j)"
fi

# Yazi cd on exit
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Remove script specific functions
unset -f _check_and_install
unset -f _version_less_than
source ~/.zshenv
