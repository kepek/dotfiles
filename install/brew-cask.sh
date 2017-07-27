#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Install Caskroom
brew tap caskroom/cask
brew tap caskroom/versions

# Install packages
apps=(
    1password
    alfred
    gyazo
    dropbox
    google-drive
    spectacle
    flux
    dash
    imagealpha
    imageoptim
    evernote
    iterm2
    atom
    visual-studio-code
    webstorm
    firefox
    firefoxnightly
    google-chrome
    google-chrome-canary
    malwarebytes-anti-malware
    glimmerblocker
    hammerspoon
    kaleidoscope
    macdown
    opera
    screenflow
    spotify
    skype
    slack
    caffeine
    tower
    transmit
    elmedia-player
    sequel-pro
    sqlitebrowser
    postman
    virtualbox
    sourcetree
    vlc
    the-unarchiver
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package quicklookase qlvideo

# Remove outdated versions from the cellar
brew cleanup
