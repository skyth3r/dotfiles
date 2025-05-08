taps=(
    jandedobbeleer/oh-my-posh
)

apps=(
    1password
    arc
    arq
    balenaetcher
    bruno
    calibre
    cryptomator
    docker
    dropbox
    discord
    figma
    goland
    google-chrome
    github
    gpg-suite-no-mail
    iterm2
    keka
    kindle
    keybase
    legcord
    macfuse
    obsidian
    pdf-expert
    quitter
    raycast
    rectangle
    rocket
    slack
    signal
    slack
    spotify
    veracrypt
    vlc
    visual-studio-code   
    whatsapp
)

cli=(
    gh
    git
    go
    helm
    hugo
    jandedobbeleer/oh-my-posh/oh-my-posh
    kubernetes-cli
    mackup
    mailsy
    nvm
    protobuf
    python
    speedtest-cli
    tilt
    yt-dlp
    woff2
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
)

############################
# Taps
############################
brew tap "${taps[@]}"

############################
# Install cli apps
############################
brew install "${cli[@]}"

# TODO: Add x to .zshrc

############################
# Install cask packages
############################
brew install --cask "${apps[@]}"