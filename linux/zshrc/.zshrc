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


oc-exec() {
  local app_name="$1"

  if [ -z "$app_name" ]; then
    echo "Usage: oc-exec <app_name>"
    return 1
  fi

  # Get current namespace from `oc project`
  local namespace
  namespace=$(oc project -q 2>/dev/null)

  if [ $? -ne 0 ]; then
    echo "Failed to get current namespace. Are you logged in to OpenShift?"
    return 1
  fi

  # Get pod name based on app label and namespace
  local pod_name
  pod_name=$(oc get pod -l app="$app_name" -n "$namespace" -o jsonpath='{.items[0].metadata.name}')

  if [ -z "$pod_name" ]; then
    echo "No pod found for app='$app_name' in namespace='$namespace'"
    return 1
  fi

  # Execute shell inside the pod
  oc exec -it "$pod_name" -n "$namespace" -- /bin/sh
}

# Bitbucket pipeline watch
function pipeline() {
  local short_repo="$1"

  # Ensure the user provides a repo name
  if [[ -z "$short_repo" ]]; then
    echo "Usage: pipeline <bitbucket-repo>"
    return 1
  fi

  # Map short names to actual Bitbucket repo slugs (URL-compatible names)
  local mapped_repo="$short_repo"
  case "$short_repo" in
    simulator)
      mapped_repo="simple-collega-json-simulator"
      ;;
    converter)
      mapped_repo="converter-iso"
      ;;
    angular)
      mapped_repo="ui-teller-sumut"
      ;;
    *)
      # For unrecognized short_repo, use it as-is
      ;;
  esac

  # Define the command to fetch and display pipeline data
  local watch_command=$(cat <<EOF
    echo ">>> ${mapped_repo}"
    curl -su "baim-mlpt:ATBBcVE65zuSY72EzrQxDYk9xsFW0ABBA1E3" \
      "https://api.bitbucket.org/2.0/repositories/multipolar_eb/${mapped_repo}/pipelines/?sort=-created_on&pagelen=5" 2>/dev/null | \
    jq -r ".values[] | \"\\(.target.ref_name) \\(.created_on) \\(.state.name) \\(.target.commit.hash)\"" | \
    while read -r branch created_on pipeline_status commit; do
      local_time=\$(date -d "\$created_on" "+%Y-%m-%d %H:%M:%S")
      short_commit=\$(echo "\$commit" | cut -c 1-7)
      echo " →  \$branch \$local_time \$short_commit \$pipeline_status"
    done
EOF
  )

  # Use watch to run the command every second
  watch -n 1 "$watch_command"
}



# Docker Image Workflow. Using SKOPEO, example : "push converter:latest"
function push() {
    local image_with_tag="$1"
    local default_registry="image-registry.apps.vdg-dev.banksumut.co.id"
    local default_project="teller"
    local source_repo="visiondgmlpt"

    # Hardcoded credentials
    local dockerhub_username="naivatko"
    local dockerhub_password="33fe9cea-e3e8-4b15-90c8-0aaa71b6a0aa"
    local openshift_username="visiondg"
    local openshift_password="Vision2024!"

    # Validate input
    if [[ -z "$image_with_tag" ]]; then
        echo "❌ Usage: push <image:tag>"
        return 1
    fi

    # Parse image name and tag
    local image="${image_with_tag%%:*}"
    local tag="${image_with_tag##*:}"

    if [[ "$image" == "$tag" ]]; then
        echo "❌ Invalid format. Use <image:tag>."
        return 1
    fi

    local source_image="visiondgmlpt/${image}:${tag}"
    local target_image="${default_registry}/${default_project}/${image}:${tag}"

    # Check for required dependencies
    for cmd in skopeo oc; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "❌ Required command '$cmd' is not installed. Please install it and try again."
            return 1
        fi
    done

    # DockerHub login
    echo "🌍 Logging in to DockerHub..."
    if ! skopeo login --username "$dockerhub_username" --password "$dockerhub_password" docker.io; then
        echo "❌ Failed to log in to DockerHub."
        return 1
    fi

    # OpenShift login
    echo "🔑 Logging in to OpenShift cluster..."
    if ! oc login https://api.vdg-dev.banksumut.co.id:6443 --username="$openshift_username" --password="$openshift_password"; then
        echo "❌ Failed to log in to OpenShift cluster."
        return 1
    fi

    # Switch to target namespace
    echo "🔄 Switching to OpenShift namespace: ${default_project}..."
    if ! oc project "$default_project"; then
        echo "❌ Failed to switch to OpenShift namespace: ${default_project}"
        return 1
    fi

    # Docker login to OpenShift registry
    echo "🔐 Logging in to OpenShift registry..."
    if ! docker login -u visiondg -p "$(oc whoami -t)" "$default_registry"; then
        echo "❌ Failed to log in to OpenShift registry."
        return 1
    fi

    # Pull the Docker image
    echo "🚀 Pulling the Docker image: ${source_image}..."
    if ! docker pull "$source_image"; then
        echo "❌ Failed to pull the image: ${source_image}"
        return 1
    fi

    # Tag the Docker image
    echo "🔖 Tagging the Docker image as: ${target_image}..."
    if ! docker tag "$source_image" "$target_image"; then
        echo "❌ Failed to tag the image: ${target_image}"
        return 1
    fi

    # Push the image to the registry
    echo "📤 Pushing the image to the registry: ${target_image}..."
    if ! docker push "$target_image"; then
        echo "❌ Failed to push the image: ${target_image}"
        return 1
    fi

    # Verify the image
    echo "🔍 Verifying the image in OpenShift project: ${default_project}..."
    if oc get imagestreams -n "$default_project" | grep -q "${image}"; then
        echo "✅ Image ${image}:${tag} successfully updated in OpenShift namespace ${default_project}!"
    else
        echo "❌ Failed to find ${image}:${tag} in OpenShift namespace ${default_project}. Please check manually."
        return 1
    fi

    # Restart the deployment
    echo "🔄 Restarting deployment for ${image}..."
    if oc rollout restart deployment/"$image" -n "$default_project"; then
        echo "✅ Deployment restarted successfully!"
    else
        echo "❌ Failed to restart the deployment. Please check manually."
        return 1
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
