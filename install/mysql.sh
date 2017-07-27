# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.httpd` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install
brew install mariadb

# Remove outdated versions from the cellar
brew cleanup

# Install
mysql_install_db

# Start Server
mysql.server start
