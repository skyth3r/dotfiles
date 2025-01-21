#!/bin/bash

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
elif [[ -e "/Library/Developer/CommandLineTools/" ]]; then
    echo "Xcode CLI tools already installed, skipping 🦘"
fi

############################
# Git setup
############################

echo "Setting up git 🛠️"
if [[ -z $(git config --global user.name) ]]; then
    read -p "Enter name: " name
    git config --global user.name "$name"
    echo "Name set successfully ✅"
else
    echo "git global name already set, skipping 🦘"
fi

if [[ -z $(git config --global user.email) ]]; then
    read -p "Enter email address: " email
    git config --global user.email "$email"
    echo "Email set successfully ✅"
else
    echo "git global email already set, skipping 🦘"
fi

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
read -p "Add SSH key to keychain and use it to sign commits? y or n: " confirm
if [[ $confirm == "yes" || $confirm == "y" ]]; then
    echo "Adding SSH key to SSH agent 🔑"
    ssh-add ~/.ssh/id_ed25519
    echo "SSH key added to SSH agent successfully 🔒"

    # Enable commit signing using the generated SSH key
    if [[ -z $(git config --global user.signingkey) ]]; then
        echo "Enabling commit signing 🔏"
        git config --global user.signingkey $(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')
        echo "Commit signing enabled successfully ✅"
    else
        echo "Commit signing already enabled, skipping 🦘"
    fi

    # Enable commit signing globally
    if [[ -z $(git config --global commit.gpgSign) ]]; then
        echo "Enabling commit signing globally 🌎"
        git config --global commit.gpgSign true
        echo "Global commit signing enabled successfully ✅"
    else
        echo "Commit signing globally already enabled, skipping 🦘"
    fi
fi

############################
# Homebrew install
############################

# Check if Homebrew is installed and install it if not
if [[ ! command -v brew &> /dev/null ]]; then
    echo "Installing Homebrew 🍺"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # > /dev/null 2>&1
    # Add Homebrew to PATH
    echo "Adding Homebrew to PATH"
    echo >> ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "Homebrew installed successfully ✅"
elif [[ -x $(command -v brew) ]]; then
    echo "Homebrew already installed, skipping 🦘"
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
elif [[ $SHELL == "/bin/zsh" ]]; then
    echo "Shell already set to zsh, skipping 🦘"
fi

echo "Setup complete! 🎉"