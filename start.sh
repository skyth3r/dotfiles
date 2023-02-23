############################
# Xcode CLI install
############################
if [[ ! -e "/Library/Developer/CommandLineTools/" ]]; then
    echo "Installing Xcode CLI tools 🛠️"
    xcode-select --install
elif [[ -e "/Library/Developer/CommandLineTools/" ]]; then
    echo "Xcode CLI tools already installed ✅"
fi

############################
# Oh My Zsh install
############################
if [[ ! -f ~/.zshrc ]]; then
    echo "Installing Oh My Zsh 🐚"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
elif [[ -f ~/.zshrc ]]; then
    echo "Oh My Zsh already installed ✅"
fi

############################
# Homebrew install
############################
if [[ ! -x $(command -v brew) ]]; then
    echo "Installing Homebrew 🍺"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
elif [[ -x $(command -v brew) ]]; then
    echo "Homebrew already installed ✅"
fi