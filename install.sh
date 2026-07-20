#!/bin/bash
set -euo pipefail

############################
# Xcode CLI install
############################
if [[ ! -e "/Library/Developer/CommandLineTools/" ]]; then
    echo "Installing Xcode CLI tools 🛠️"
    xcode-select --install
    echo_wait_xcode=false
    until [[ -e "/Library/Developer/CommandLineTools/" ]]; do
        if [[ $echo_wait_xcode == false ]]; then
            echo "Waiting for Xcode CLI tools to be installed... ⏳"
            echo_wait_xcode=true
        fi
        sleep 5
    done
    echo "Xcode CLI tools installed successfully ✅"
else
    echo "Xcode CLI tools already installed, skipping 🦘"
fi

############################
# Git setup
############################

echo "Setting up git 🛠️"
if [[ -z $(git config --global user.name || true) ]]; then
    read -p "Enter name: " name
    git config --global user.name "$name"
    echo "Name set successfully ✅"
else
    echo "git global name already set, skipping 🦘"
fi

if [[ -z $(git config --global user.email || true) ]]; then
    read -p "Enter email address: " email
    git config --global user.email "$email"
    echo "Email set successfully ✅"
else
    echo "git global email already set, skipping 🦘"
fi

email=$(git config --global user.email)

# Generate new SSH key
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
    echo "Generating new SSH key 🔑"
    ssh-keygen -t ed25519 -C "$email"
    echo "Copying SSH key to clipboard 📋"
    pbcopy < ~/.ssh/id_ed25519.pub
    echo "Add this SSH key to GitHub as an 'Authenication Key'"
    open https://github.com/settings/keys
    read -p "After adding the SSH key to GitHub, press enter to continue..."
else
    echo "SSH key already generated, skipping 🦘"
fi

# Sign commits with SSH key
key_fp=$(ssh-keygen -lf ~/.ssh/id_ed25519.pub 2>/dev/null | awk '{print $2}')
if [[ -n "$key_fp" ]] && ssh-add -l 2>/dev/null | grep -qF "$key_fp"; then
    echo "SSH key already in SSH agent, skipping 🦘"
else
    read -p "Add SSH key to keychain and use it to sign commits? y or n: " confirm
    if [[ $confirm == "yes" || $confirm == "y" ]]; then
        echo "Adding SSH key to SSH agent 🔑"
        ssh-add ~/.ssh/id_ed25519
        echo "SSH key added to SSH agent successfully 🔒"

        # Enable commit signing using the generated SSH key
        if [[ -z $(git config --global user.signingkey || true) ]]; then
            echo "Enabling commit signing 🔏"
            git config --global user.signingkey ~/.ssh/id_ed25519.pub
            echo "Commit signing enabled successfully ✅"
        else
            echo "Commit signing already enabled, skipping 🦘"
        fi

        # Enable commit signing globally
        if [[ -z $(git config --global commit.gpgSign || true) ]]; then
            echo "Enabling commit signing globally 🌎"
            git config --global gpg.format ssh
            git config --global commit.gpgSign true
            echo "Global commit signing enabled successfully ✅"
        else
            echo "Commit signing globally already enabled, skipping 🦘"
        fi
    fi
fi

# Enable autoSetupRemote
if [[ -z $(git config --global push.autoSetupRemote || true) ]]; then
    echo "Enabling push.autoSetupRemote 🔗"
    git config --global push.autoSetupRemote true
    echo "push.autoSetupRemote enabled successfully ✅"
else
    echo "push.autoSetupRemote already set, skipping 🦘"
fi

# Rebase on pull instead of merge
if [[ -z $(git config --global pull.rebase || true) ]]; then
    echo "Setting rebase on pull instead of merge 🔃"
    git config --global pull.rebase true
    echo "Rebase on pull set successfully ✅"
else
    echo "Rebase on pull already set, skipping 🦘"
fi

# Auto prune on fetch 
if [[ -z $(git config --global fetch.prune || true) ]]; then
    echo "Setting auto prune on fetch ✂️"
    git config --global fetch.prune true
    echo "Auto prune on fetch set successfully ✅"
else
    echo "Auto prune on fetch already set, skipping 🦘"
fi

# Use Histogram instead of Myers (default) for diff
if [[ -z $(git config --global diff.algorithm || true) ]]; then
    echo "Setting diff algorithm to histogram 📊"
    git config --global diff.algorithm histogram
    echo "Histogram for diffs set successfully ✅"
else
    echo "Histogram for diffs already set, skipping 🦘"
fi

# Use rerere for merge conflicts
if [[ -z $(git config --global rerere.enabled || true) ]]; then
    echo "Setting rerere for managing merge conflicts ♻️"
    git config --global rerere.enabled true
    echo "rerere for managing merge conflicts set successfully ✅"
else
    echo "rerere for managing merge conflicts already set, skipping 🦘"
fi

# Global gitignore
echo "Setting up global gitignore 🛑"
gitignore_dir="$HOME/.config/git"
gitignore_file="$gitignore_dir/ignore"
mkdir -p "$gitignore_dir"

# Point git at the global ignore file (also the XDG default, set explicitly to be safe)
if [[ -z $(git config --global core.excludesfile || true) ]]; then
    echo "Setting core.excludesfile 🛑"
    git config --global core.excludesfile "$gitignore_file"
    echo "core.excludesfile set successfully ✅"
else
    echo "core.excludesfile already set, skipping 🦘"
fi

touch "$gitignore_file"

# Append an entry to the global gitignore only if it is not already present
add_gitignore_entry() {
    local entry="$1"
    if grep -qxF "$entry" "$gitignore_file"; then
        echo "'$entry' already in global gitignore, skipping 🦘"
    else
        echo "$entry" >> "$gitignore_file"
        echo "Added '$entry' to global gitignore ✅"
    fi
}

add_gitignore_entry "**/.claude/settings.local.json"
add_gitignore_entry "**/.vscode/settings.json"
add_gitignore_entry ".DS_Store"
echo "Global gitignore configured ✅"

############################
# Homebrew install
############################

# Check if Homebrew is installed and install it if not
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew 🍺"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # > /dev/null 2>&1
    # Add Homebrew to PATH
    echo "Adding Homebrew to PATH"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "Homebrew installed successfully ✅"
else
    echo "Homebrew already installed, skipping 🦘"
fi
source ~/.zprofile

############################
# Brewfile
############################

# Check if signed into Apple account
check_apple_id() {
    /usr/libexec/PlistBuddy -c "Print :Accounts:0:AccountID" \
        ~/Library/Preferences/MobileMeAccounts.plist 2>/dev/null | grep -q "@"
}

if [[ -f Brewfile ]]; then
    brewfile="Brewfile"
elif [[ -f Brewfile.txt ]]; then
    brewfile="Brewfile.txt"
else
    echo "Error: Neither Brewfile nor Brewfile.txt found ❌"
    exit 1
fi

echo "Installing Homebrew Formulae & Apps 🍻"
brew bundle --file="$brewfile" --verbose

if ! command -v mas &> /dev/null; then
    echo "mas not installed, skipping Mac App Store Apps 🦘"
elif ! check_apple_id; then
    echo "Not logged into Apple account, skipping Mac App Store Apps 🦘"
else
    if [[ -f Brewfile-mas ]]; then
        brewfile_mas="Brewfile-mas"
    elif [[ -f Brewfile-mas.txt ]]; then
        brewfile_mas="Brewfile-mas.txt"
    else
        echo "Error: Neither Brewfile-mas nor Brewfile-mas.txt found ❌"
        exit 1
    fi
    echo "Installing Mac App Store Apps 🍎"
    brew bundle --file="$brewfile_mas" --verbose
fi

############################
# zsh setup
############################

# Setup .zshrc file
if [[ ! -f ~/.zshrc ]]; then
    echo "Downloading .zshrc 📥"
    curl -fsSL https://raw.githubusercontent.com/skyth3r/dotfiles/refs/heads/main/.zshrc -o ~/.zshrc
    echo ".zshrc downloaded successfully ✅"
else
    echo ".zshrc file already exists, skipping 🦘"
fi
zsh -c "source ~/.zshrc"

# Switch shell to zsh
if [[ $SHELL != "/bin/zsh" ]]; then
    echo "Switching shell to zsh 🐚"
    chsh -s /bin/zsh
    echo "Shell switched to zsh successfully ✅"
else
    echo "Shell already set to zsh, skipping 🦘"
fi

############################
# fnm setup
############################

echo "Setting up fnm (Fast Node Manager) 🛠️"
eval "$(fnm env --use-on-cd --shell bash)"
echo "Installing latest LTS version of Node.js 📦"
fnm install --lts
echo "Setting latest LTS version of Node.js as default ✅"
fnm default lts-latest

############################
# npm apps
############################

npm install -g agentmail-cli
npm install -g @readwise/cli
npm install -g cash-cli

############################
# AI tools
############################

echo "Installing AI tools 🤖"

# Claude Code
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code 🦞"
    curl -fsSL https://claude.ai/install.sh | bash
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "Claude Code already installed, skipping 🦘"
fi

# Codex
if ! command -v codex &> /dev/null; then
    echo "Installing Codex 🌀"
    curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
else
    echo "Codex already installed, skipping 🦘"
fi

echo "Installing skills manager..."
npm install -g skills
echo "Skills manager installed ✅"

# Agent Skills
echo "Installing agent skills 🧠"
skills add https://github.com/anthropics/skills --skill skill-creator webapp-testing -g --agent claude-code codex -y
skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices -g --agent claude-code codex -y
skills add https://github.com/mattpocock/skills --skill grill-me grill-with-docs handoff -g --agent claude-code codex -y
skills add https://github.com/shadcn/ui --skill shadcn -g --agent claude-code codex -y
skills add agentmail-to/agentmail-claude-skill -g --agent claude-code codex -y
echo "Agent skills installed ✅"

############################
# Agent plugins
############################

# To add a plugin: append the GitHub repo to PLUGIN_REPOS and the
# corresponding plugin@marketplace spec to PLUGIN_INSTALLS at the same index.
PLUGIN_REPOS=(
    "DietrichGebert/ponytail"
)
PLUGIN_INSTALLS=(
    "ponytail@ponytail"
)

echo "Installing agent plugins 🔌"

for i in "${!PLUGIN_REPOS[@]}"; do
    repo="${PLUGIN_REPOS[$i]}"
    install_spec="${PLUGIN_INSTALLS[$i]}"
    marketplace="${install_spec##*@}"
    plugin_name="${install_spec%%@*}"

    # Claude Code
    if claude plugin marketplace list 2>/dev/null | grep -q "$marketplace"; then
        echo "'$marketplace' marketplace already added to Claude Code, skipping 🦘"
    else
        echo "Adding '$marketplace' marketplace to Claude Code 🦞"
        claude plugin marketplace add "$repo"
    fi
    if claude plugin list 2>/dev/null | grep -q "$install_spec"; then
        echo "'$plugin_name' already installed in Claude Code, skipping 🦘"
    else
        echo "Installing '$install_spec' for Claude Code 🦞"
        claude plugin install "$install_spec"
    fi

    # Codex
    if codex plugin marketplace list 2>/dev/null | grep -q "$marketplace"; then
        echo "'$marketplace' marketplace already added to Codex, skipping 🦘"
    else
        echo "Adding '$marketplace' marketplace to Codex 🌀"
        codex plugin marketplace add "$repo"
    fi
    if codex plugin list 2>/dev/null | grep -q "$install_spec"; then
        echo "'$plugin_name' already installed in Codex, skipping 🦘"
    else
        echo "Installing '$install_spec' for Codex 🌀"
        codex plugin add "$install_spec"
    fi
done
echo "Agent plugins installed ✅"

############################
# Directory setup
############################

mkdir -p src/github.com/skyth3r
cd "$HOME/src/github.com/skyth3r"
echo "Changed directory to ~/src/github.com/skyth3r ♻️"

echo "Cloning public repositories 📥"
git clone https://github.com/skyth3r/dotfiles.git
git clone https://github.com/skyth3r/skyth3r.github.io.git
git clone https://github.com/skyth3r/skyth3r.git
git clone https://github.com/skyth3r/automate-now.git

echo "Setup complete! 🎉"
echo ""
echo "Run 'source ~/.zprofile && source ~/.zshrc' or open a new terminal for brew to be available."