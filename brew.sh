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
    kubernetes-cli
    mackup
    nvm
    python
    tilt
)

############################
# Install cli apps
############################
brew install "${cli[@]}"

############################
# Install cask packages
############################
brew install --cask "${apps[@]}"