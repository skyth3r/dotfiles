############################
# Aliases
############################

# git
alias pull="git pull"
alias push="git push"
alias gs='git status'
alias gb="git branch"
alias gc="git checkout"
alias lm="git checkout main && git pull"

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

# zsh
alias openzs="open ~/.zshrc"
alias sourcezs="source ~/.zshrc"

# Docker
alias dcb="docker compose build"
alias dcu="docker compose up -d"
alias dcd="docker compose down"

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kc='kubectx'
alias kn='kubens'

# npm
alias nrd="npm run dev"
alias nrb="npm run build"
alias ni="npm install"
alias nu="npm uninstall"
alias nr="npm run"

# working directory
alias skyth3r="cd ~/src/Github/skyth3r"

# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias reloadshell="omz reload"
