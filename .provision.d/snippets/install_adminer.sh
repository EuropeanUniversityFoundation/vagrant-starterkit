#!/usr/bin/env bash
# Snippet: Install Adminer.

# Download latest Adminer.
ADMINER_ROOT=/usr/share/adminer
mkdir -p ${ADMINER_ROOT}
wget https://www.adminer.org/latest.php -q -O ${ADMINER_ROOT}/adminer.php

# Tweaks to Adminer.
if [[ ! -z ${ADMINER_THEME} ]]; then
  wget ${ADMINER_THEME} -q -O ${ADMINER_ROOT}/adminer.css
fi

# https://sourceforge.net/p/adminer/discussion/960418/thread/75537d20/#91a5
cp -p ${STARTERKIT_ROOT}/.provision.d/snippets/adminer_noroot.php \
  ${ADMINER_ROOT}/index.php

ADMINER_URL=adminer.${HOSTNAME_F}

# Handle different web server configurations.
if [[ ! -z ${NGINX_SETUP} ]]; then

  if [[ -d ${SSL_CERTS}/${HOSTNAME_F} ]]; then
    SSL_PEM=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.pem
    SSL_KEY=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.key

    if [[ -f ${SSL_PEM} ]] && [[ -f ${SSL_KEY} ]]; then
      # Adminer via SSL.
      ADMINER_NGINX_CONF=/etc/nginx/sites-available/adminer-ssl

      cp -p ${STARTERKIT_ROOT}/.provision.d/snippets/nginx_adminer_ssl \
        ${ADMINER_NGINX_CONF}

      sed -i 's,LOCAL,'"${HOSTNAME_F}"',g' ${ADMINER_NGINX_CONF}

      # Replace the snakeoil certificate.
      sed -i 's,'"${SNAKEOIL_PEM}"','"${SSL_PEM}"',g' ${ADMINER_NGINX_CONF}
      sed -i 's,'"${SNAKEOIL_KEY}"','"${SSL_KEY}"',g' ${ADMINER_NGINX_CONF}

      # Enable the site.
      ln -s ${ADMINER_NGINX_CONF} /etc/nginx/sites-enabled
    fi
  fi

  if [[ -z ${ADMINER_NGINX_CONF} ]]; then
    # Adminer fallback without SSL.
    ADMINER_NGINX_CONF=/etc/nginx/sites-available/adminer

    cp -p ${STARTERKIT_ROOT}/.provision.d/snippets/nginx_adminer \
      ${ADMINER_NGINX_CONF}

    sed -i 's,LOCAL,'"${HOSTNAME_F}"',g' ${ADMINER_NGINX_CONF}

    # Enable the site.
    ln -s ${ADMINER_NGINX_CONF} /etc/nginx/sites-enabled
  fi

  service nginx reload

else
  # If Nginx is not installed, Apache must allow access to Adminer.
  ADMINER_APACHE_CONF=/etc/apache2/sites-available/adminer.conf

  cp -p ${STARTERKIT_ROOT}/.provision.d/snippets/adminer.conf \
    ${ADMINER_APACHE_CONF}

  sed -i 's,LOCAL,'"${HOSTNAME_F}"',g' ${ADMINER_APACHE_CONF}

  if [[ -d ${SSL_CERTS}/${HOSTNAME_F} ]]; then
    SSL_PEM=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.pem
    SSL_KEY=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.key

    if [[ -f ${SSL_PEM} ]] && [[ -f ${SSL_KEY} ]]; then
      # Replace the snakeoil certificate.
      sed -i 's,'"${SNAKEOIL_PEM}"','"${SSL_PEM}"',g' ${ADMINER_APACHE_CONF}
      sed -i 's,'"${SNAKEOIL_KEY}"','"${SSL_KEY}"',g' ${ADMINER_APACHE_CONF}
    fi
  fi

  a2ensite adminer.conf
  service apache2 reload
fi
