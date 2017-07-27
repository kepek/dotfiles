# Variables
APACHE_VERSION="2.4"
APACHE_HTTPD_VERSION="httpd${APACHE_VERSION//[-._]/}"
APACHE_PATH="/usr/local/etc/apache2/${APACHE_VERSION}"
SSL_COUNTRY="AE"
SSL_STATE="Dubai"
SSL_CITY="Dubai"
SSL_ORGANIZATION="localhost-LLC"
SSL_DOMAIN="localhost"
SSL_EMAIL="${USER_EMAIL}"
SSL_CONFIG_PATH="${HOME}/dotfiles/httpd/server.conf"
SSL_EXPIRE=$((10 * 365)) # 10 years

# Ask for the administrator password upfront
sudo -v

# Create new self-signed SSL Certificate
sudo openssl genrsa -out "${APACHE_PATH}/server.key" 2048
sudo openssl rsa -in "${APACHE_PATH}/server.key" -out "${APACHE_PATH}/server.key.rsa"
sudo openssl req -new -key "${APACHE_PATH}/server.key" -subj "/C=${SSL_COUNTRY}/ST=${SSL_STATE}/L=${SSL_CITY}/O=${SSL_ORGANIZATION}/CN=${SSL_DOMAIN}/emailAddress=${SSL_EMAIL}/" -out "${APACHE_PATH}/server.csr" -config "${SSL_CONFIG_PATH}"
sudo openssl x509 -req -extensions v3_req -days ${SSL_EXPIRE} -in "${APACHE_PATH}/server.csr" -signkey "${APACHE_PATH}/server.key.rsa" -out "${APACHE_PATH}/server.crt" -extfile "${SSL_CONFIG_PATH}"
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "${APACHE_PATH}/server.crt"

# Keep-alive: update existing `sudo` time stamp until `.httpd` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Stop system httpd
sudo apachectl stop

# Unload system httpd
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap homebrew/apache

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

apps=(
    ${APACHE_HTTPD_VERSION} --with-privileged-ports
)

brew install "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup

# Link Configs
(ln -s -f "${DOTFILES_PATH}/httpd/httpd.conf" "${APACHE_PATH}/httpd.conf")
(cd "${DOTFILES_PATH}/httpd/extra" && for f in *.conf; do ln -s -f $PWD/$f "${APACHE_PATH}/extra"; done)

# Launch Homebrew httpd on startup
sudo brew services start ${APACHE_HTTPD_VERSION}

# Restart Homebrew httpd
sudo brew services restart ${APACHE_HTTPD_VERSION}
