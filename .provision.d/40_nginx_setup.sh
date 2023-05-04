#!/usr/bin/env bash
# Nginx setup script.

# Install Nginx web server.
apt-get install nginx -y

# Move sample index.html to subdirectory of webroot.
mkdir /var/www/html/nginx
mv /var/www/html/index.nginx-debian.html /var/www/html/nginx/

# Update default VirtualHost and reload.
NGINX_DEFAULT=/etc/nginx/sites-available/default
sed -i 's,/var/www/html,/var/www/html/nginx,g' ${NGINX_DEFAULT}

# Check for existing SSL certificates for current FQDN.
SSL_CERTS=/usr/local/share/ca-certificates
HOSTNAME_F=$(hostname -f)

SNAKEOIL_PEM=/etc/ssl/certs/ssl-cert-snakeoil.pem
SNAKEOIL_KEY=/etc/ssl/private/ssl-cert-snakeoil.key

if [[ -d ${SSL_CERTS}/${HOSTNAME_F} ]]; then
  SSL_PEM=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.pem
  SSL_KEY=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.key

  if [[ -f ${SSL_PEM} ]] && [[ -f ${SSL_KEY} ]]; then
    # Nginx does not ship with a default SSL site configuration.
    NGINX_EXAMPLE_SSL=/etc/nginx/sites-available/default-ssl

    cp -p ${STARTERKIT_ROOT}/.provision.d/snippets/nginx_example_ssl \
      ${NGINX_EXAMPLE_SSL}

    # Replace the snakeoil certificate.
    sed -i 's,'"${SNAKEOIL_PEM}"','"${SSL_PEM}"',g' ${NGINX_EXAMPLE_SSL}
    sed -i 's,'"${SNAKEOIL_KEY}"','"${SSL_KEY}"',g' ${NGINX_EXAMPLE_SSL}

    # Enable the site.
    ln -s ${NGINX_EXAMPLE_SSL} /etc/nginx/sites-enabled

    # MailHog via SSL.
    MAILHOG_NGINX_CONF=/etc/nginx/sites-available/mailhog-ssl

    cp -p ${STARTERKIT_ROOT}/.provision.d/snippets/nginx_mailhog_ssl \
      ${MAILHOG_NGINX_CONF}

    sed -i 's,LOCAL,'"${HOSTNAME_F}"',g' ${MAILHOG_NGINX_CONF}

    # Replace the snakeoil certificate.
    sed -i 's,'"${SNAKEOIL_PEM}"','"${SSL_PEM}"',g' ${MAILHOG_NGINX_CONF}
    sed -i 's,'"${SNAKEOIL_KEY}"','"${SSL_KEY}"',g' ${MAILHOG_NGINX_CONF}

    # Enable the site.
    ln -s ${MAILHOG_NGINX_CONF} /etc/nginx/sites-enabled
  fi
fi

if [[ -z ${MAILHOG_NGINX_CONF} ]]; then
  # MailHog fallback without SSL.
  MAILHOG_NGINX_CONF=/etc/nginx/sites-available/mailhog

  cp -p ${STARTERKIT_ROOT}/.provision.d/snippets/nginx_mailhog \
    ${MAILHOG_NGINX_CONF}

  sed -i 's,LOCAL,'"${HOSTNAME_F}"',g' ${MAILHOG_NGINX_CONF}

  # Enable the site.
  ln -s ${MAILHOG_NGINX_CONF} /etc/nginx/sites-enabled
fi

service nginx reload
