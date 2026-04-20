############################
# Akash's Zsh Run Commands #
############################

############################
# Atutin
############################
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

############################
# Oh My Posh
############################
eval "$(oh-my-posh init zsh --config 'spaceship')"

############################
# fnm (Fast Node Manager)
############################
eval "$(fnm env --use-on-cd --shell zsh)"

############################
# pnpm
############################
export PNPM_HOME="/Users/akash/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

############################
# Zsh Addons
############################
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

############################
# Aliases
############################

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias repos="cd ~/src/github.com/skyth3r"

# Advanced ls
alias ll="ls -alFh --color=auto"
alias la="ls -A --color=auto"
alias l="ls -CF --color=auto"

# git
alias pull="git pull"
alias push="git push"
alias gs='git status'
alias gb="git branch"
alias gc="git checkout"
alias gl="git log"
alias lm="git checkout main && git pull"
alias gdiff="git diff"

# git commit
alias gcm="git commit -m"
alias commit="git add . && git commit -m"
alias wip="commit wip"

## git stash
alias gst="git stash"
alias pop="git stash pop"
alias gstapp="git stash apply"

#alias ulc='git reset --soft HEAD~1'
#alias gp="git pull && git push"

# pretty git log
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"

# zsh
alias openzs="open ~/.zshrc"
alias sourcezsh="source ~/.zshrc"
alias zsh-history="code ~/.zsh_history"

# npm
alias nrb="npm run build"
alias nrd="npm run dev"
alias ni="npm install"
alias nu="npm uninstall"
alias nr="npm run"

# Docker
alias dcb="docker compose build"
alias dcu="docker compose up -d"
alias dcd="docker compose down"

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kc='kubectx'
alias kn='kubens'

# Python
alias activate="source ./venv/bin/activate"

# Claude Code
alias cld="claude"
alias upcld="brew upgrade claude-code"

# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
