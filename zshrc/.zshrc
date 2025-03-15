# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# Environment Variables & PATH
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export EDITOR="vim"
export KUBE_EDITOR="vim"
export AWS_CLI_AUTO_PROMPT="on-partial"
export PATH="/usr/local/bin:$HOME/bin:$HOME/.krew/bin:$HOME/.local/bin:$PATH"
export KUBECONFIG="$HOME/.kube/config"
export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
# ==============================================================================
# History Configuration
# ==============================================================================
ZSH_THEME="powerlevel10k/powerlevel10k"
export HISTTIMEFORMAT="[%F %T] "


# IntelliJ IDEA on WSL2
alias idea='"/mnt/c/Program Files/JetBrains/IntelliJ IDEA Community Edition 2024.1/bin/idea64.exe"'

# Ping servers
alias ping-oc-dev-sumut="ping 192.168.90.10"
alias ping-oc-dc-sumut="ping 192.168.70.66"
alias ping-oc-drc-sumut="ping 192.168.70.98"
alias ping-dev-sumut="ping 192.168.40.20"
alias ping-dc-sumut="ping 192.168.50.18"

# ==============================================================================
# Functions
# ==============================================================================
function oc-login() {
  if [[ $1 == "dev-co" ]]; then
    export KUBECONFIG=~/.kube/config-cluster1
    oc login https://api.vdg.visiondg.xyz:6443 --username=clusteradmin --password=P4ssw0rd1!
  elif [[ $1 == "dev-sumut" ]]; then
    export KUBECONFIG=~/.kube/config-cluster2
    oc login https://api.vdg-dev.banksumut.co.id:6443 --username=visiondg --password=Vision2024!
  else
    echo "Usage: oc-login <cluster1|cluster2>"
  fi
}

# ==============================================================================
# ZSH Plugins & Configuration
# ==============================================================================
plugins=(
#  zsh-z
  zsh-autosuggestions
  aws
  git
  brew
  docker
  docker-compose
  gradle
  terraform
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"
source <(oc completion zsh)

# Fast directory switching
eval "$(zoxide init zsh)"

# Load extra configuration if available
[[ -f "$HOME/.zsh/envs.zsh" ]] && source "$HOME/.zsh/envs.zsh"
[[ -f "$HOME/.zsh/aliases.zsh" ]] && source "$HOME/.zsh/aliases.zsh"
[[ -f "$HOME/.zsh/functions.zsh" ]] && source "$HOME/.zsh/functions.zsh"

# Powerlevel10k Configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Fuzzy Finder (fzf)
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Homebrew setup
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# SDKMAN setup
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Miscellaneous Configurations
export WSL_DISTRIBUTION_NAME=Debian
export LIBGL_ALWAYS_INDIRECT=1
zsh_disable_completions=true
export UPDATE_ZSH_DAYS=7

# ==============================================================================
# Aliases
# ==============================================================================
unalias ll 

#alias lk='exa -lah'
alias v='nvim' vi='nvim' vim='nvim'
alias lk='exa -lah --icons --group-directories-first --git'
alias ll='exa -l --icons --group-directories-first --git'
alias bat='batcat'
alias cls='clear'


