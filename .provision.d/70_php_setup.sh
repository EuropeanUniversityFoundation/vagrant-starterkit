#!/usr/bin/env bash
# PHP setup script.

# Install known dependencies.
apt-get install curl zip unzip -y

# Add PHP repository.
# https://github.com/oerdnj/deb.sury.org/wiki/Frequently-Asked-Questions#debian
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
apt-get update

# Define PHP versions to install.
if [[ ! -z ${PHP_VERSIONS} ]]; then
  PHP_BINARIES=( "${PHP_VERSIONS[@]/#/php}" )
else
  PHP_BINARIES=(php)
fi

# Install PHP CLI.
for b in ${PHP_BINARIES[@]}
do
  echo "Installing $b CLI..."
  apt-get install -y $b-cli --no-install-recommends
done

# Install PHP modules.
if [[ -z ${PHP_MODULES} ]]; then
  source ${STARTERKIT_ROOT}/.provision.d/snippets/php_modules.sh
fi

for b in ${PHP_BINARIES[@]}
do
  echo "Installing $b modules..."
  for m in ${PHP_MODULES[@]}
  do
    apt-get install -y $b-$m --no-install-recommends
  done
done

# Install Composer.
# https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
fi

php composer-setup.php --install-dir=/usr/local/bin --filename composer --quiet
rm composer-setup.php
