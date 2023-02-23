apps=(
    1password
    arc
    arq
    balenaetcher
    bartender
    cryptomator
    displaperture
    dropbox
    discord
    firefox
    figma
    google-chrome
    github
    gpg-suite-no-mail
    iterm2
    keka
    keybase
    menubar-stats
    notion
    macfuse
    pdf-expert
    postman
    quitter
    raycast
    rocket
    slack
    signal
    sketch
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