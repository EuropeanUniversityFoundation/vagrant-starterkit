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

sudo -u vagrant composer --version

# Integration with web servers.
if [[ ! -z ${APACHE2_SETUP} ]] || [[ ! -z ${NGINX_SETUP} ]]; then
  for b in ${PHP_BINARIES[@]}
  do
    # Install FastCGI Process Manager.
    apt-get install -y $b-fpm --no-install-recommends

    if [[ ! -z ${APACHE2_SETUP} ]]; then
      # Install Apache2 PHP module.
      apt-get install -y libapache2-mod-$b --no-install-recommends

      # Enable relevant modules and configuration.
      a2enmod proxy_fcgi setenvif rewrite
      a2enconf $b-fpm
      service apache2 restart
    fi
  done

  if [[ ! -z ${MYSQL_SETUP} ]]; then
    # Download latest Adminer.
    ADMINER_ROOT=/usr/share/adminer
    mkdir -p ${ADMINER_ROOT}
    wget https://www.adminer.org/latest.php -q -O ${ADMINER_ROOT}/adminer.php

    # Tweaks to Adminer.
    if [[ ! -z ${ADMINER_THEME} ]]; then
      wget ${ADMINER_THEME} -q -O ${ADMINER_ROOT}/adminer.css
    fi

    ADMINER_INDEX=${ADMINER_ROOT}/index.php
    ADMINER_URL=adminer.${HOSTNAME_F}

    # https://sourceforge.net/p/adminer/discussion/960418/thread/75537d20/#91a5
    cat > ${ADMINER_INDEX} << 'EOL'
<?php
function adminer_object() {

    class AdminerNoRoot extends Adminer {

        function login($login, $password) {
            return ($login != 'root');
        }

    }

    return new AdminerNoRoot;
}
include "./adminer.php";
EOL

    if [[ ! -z ${APACHE2_SETUP} ]]; then
      ADMINER_APACHE_HTTP=/etc/apache2/sites-available/adminer.conf

      cp ${APACHE_DEFAULT} ${ADMINER_APACHE_HTTP}

      NAME_OLD="#ServerName www.example.com"
      NAME_NEW="ServerName ${ADMINER_URL}"
      sed -i 's,'"${NAME_OLD}"','"${NAME_NEW}"',g' ${ADMINER_APACHE_HTTP}

      PATH_OLD="/var/www/html/apache2"
      sed -i 's,'"${PATH_OLD}"','"${ADMINER_ROOT}"',g' ${ADMINER_APACHE_HTTP}

      a2ensite adminer.conf
      service apache2 reload
    fi
  fi
fi
