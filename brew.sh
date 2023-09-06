apps=(
    1password
    airbuddy
    arc
    arq
    balenaetcher
    bartender
    calibre
    cryptomator
    dropbox
    discord
    firefox
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
    notion
    obsidian
    pdf-expert
    postman
    quitter
    raycast
    rectangle
    rocket
    slack
    signal
    slack
    spotify
    the-unarchiver
    unity-hub
    veracrypt
    vlc
    visual-studio-code   
    whatsapp
)

cli=(
    gh
    git
    go
    hugo
    mackup
    node
    python
)

############################
# Install cli apps
############################
brew install "${cli[@]}"

############################
# Install cask packages
############################
brew install --cask "${apps[@]}"