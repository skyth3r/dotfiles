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

# Create blank zshrc file
if [[ ! -f ~/.zshrc ]]; then
    touch ~/.zshrc
    echo ".zshrc file created successfully ✅"
else
    echo ".zshrc file already exists, skipping 🦘"
fi

# Switch shell to zsh
if [[ $SHELL != "/bin/zsh" ]]; then
    echo "Switching shell to zsh 🐚"
    chsh -s /bin/zsh
    echo "Shell switched to zsh successfully ✅"
else
    echo "Shell already set to zsh, skipping 🦘"
fi

echo "Setup complete! 🎉"
echo ""
echo "Run 'source ~/.zprofile' or open a new terminal for brew to be available."