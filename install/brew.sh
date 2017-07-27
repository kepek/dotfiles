#!/bin/bash

# Installs Homebrew and some of the common dependencies needed/desired for software development

# Ask for the administrator password upfront
sudo -v

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap homebrew/core
brew tap homebrew/php
brew tap homebrew/apache
brew tap Goles/battery

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install the Homebrew packages I use on a day-to-day basis.
#
# - Languages: rvm (Ruby), nvm (Node.js), go
# - Databases: Progres, MySQL, Redis, Mongo, Elasticsearch
# - Servers: Apache, Nginx
# - Fuck (https://github.com/nvbn/thefuck): Correct your previous command. Note
#   that this needs to be added to zsh or bash. See the project README.
# - Foreman & Forego:
# - Tree (http://mama.indstate.edu/users/ice/tree/): A directory listing utility
#   that produces a depth indented listing of files.
# - Tor ():
# - git-extras (https://vimeo.com/45506445): Adds a shit ton of useful commands #   to git.
# - autoenv (https://github.com/kennethreitz/autoenv): this utility makes it
#   easy to apply environment variables to projects. I mostly use it for Go and
#   Node.js projects. For Ruby projects, I just use Foreman or Forego.
# - autojump (https://github.com/joelthelion/autojump): a faster way to navigate
#   your filesystem.
# Note that I install nvm (https://github.com/creationix/nvm) instead
# of installing Node directly. This gives me more explicit control over
# which version I'm using.

apps=(
    httpd24 --with-privileged-ports --with-http2
    ngrep
    mongodb
    mysql
    elasticsearch
    bash-completion2
    coreutils
    moreutils
    findutils
    ffmpeg
    fortune
    ponysay
    git
    git-extras
    git-lfs
    hub
    gnu-sed --with-default-names
    grep --with-default-names
    brew-cask-completion
    grep
    openssh
    mtr
    autojump
    imagemagick --with-webp
    python
    source-highlight
    the_silver_searcher
    tree
    ffmpeg --with-libvpx
    wget
    wifi-password
    dark-mode
    autoconf
    boost
    composer
    freetype
    gdbm
    gettext
    highlight
    icu4c
    jpeg
    libpng
    libxml2
    lua
    openssl
    pcre
    php71 # php56
    php71-mailparse # php56-mailparse
    python3
    readline
    sqlite
    unixodbc
    xz
    imagemagick --with-webp
    lynx
    p7zip
    pigz
    pv
    rename
    rhino
    speedtest_cli
    ssh-copy-id
    testssl
    tree
    vbindiff
    webkit2png
    zopfli
    yarn
    watchman
)

brew install "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup
