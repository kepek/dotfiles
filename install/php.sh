# Variables
PHP_PATH="/usr/local/etc/php"
PHP_VERSION="7.1"
PHP_PACKAGE_NAME="php${PHP_VERSION//[-._]/}"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "What version of PHP you wish to install? (default: $PHP_VERSION)"

read userInput

if [[ "$userInput" ]]
then
    PHP_VERSION=$userInput
    PHP_PACKAGE_NAME="php${userInput//[-._]/}"
fi

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap homebrew/php

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Packages
apps=(
    libmemcached
    composer
)

brew install "${apps[@]}"

# PHP Packages
brew install "$PHP_PACKAGE_NAME" --with-httpd24

php_libs=(
    "$PHP_PACKAGE_NAME-opcache"
    "$PHP_PACKAGE_NAME-memcached"
    "$PHP_PACKAGE_NAME-mailparse"
    "$PHP_PACKAGE_NAME-mcrypt"
    "$PHP_PACKAGE_NAME-geoip"
    "$PHP_PACKAGE_NAME-intl"
)
brew install "${php_libs[@]}"

# Remove outdated versions from the cellar
brew cleanup

# PHP Switcher
if test ! $(which sphp)
then
  curl -L https://gist.github.com/w00fz/142b6b19750ea6979137b963df959d11/raw > /usr/local/bin/sphp
  chmod +x /usr/local/bin/sphp
fi

# PHP Code Sniffer
composer global require "squizlabs/php_codesniffer=*"

# Link Configs
(ln -s -f "${DOTFILES_PATH}/php/${PHP_PACKAGE_NAME}.ini" "${PHP_PATH}/${PHP_VERSION}/php.ini")
