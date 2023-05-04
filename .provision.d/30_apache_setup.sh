#!/usr/bin/env bash
# Apache2 setup script.

# Install Apache2 web server.
apt-get install apache2 -y

# Move sample index.html to subdirectory of webroot.
mkdir /var/www/html/apache2
mv /var/www/html/index.html /var/www/html/apache2/

# Update default VirtualHosts and reload.
APACHE_DEFAULT=/etc/apache2/sites-available/000-default.conf
APACHE_DEFAULT_SSL=/etc/apache2/sites-available/default-ssl.conf

sed -i 's,/var/www/html,/var/www/html/apache2,g' ${APACHE_DEFAULT}
sed -i 's,/var/www/html,/var/www/html/apache2,g' ${APACHE_DEFAULT_SSL}

service apache2 reload

# Check for existing SSL certificates for current FQDN.
SSL_CERTS=/usr/local/share/ca-certificates
HOSTNAME_F=$(hostname -f)

SNAKEOIL_PEM=/etc/ssl/certs/ssl-cert-snakeoil.pem
SNAKEOIL_KEY=/etc/ssl/private/ssl-cert-snakeoil.key

if [[ -d ${SSL_CERTS}/${HOSTNAME_F} ]]; then
  SSL_PEM=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.pem
  SSL_KEY=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.key

  if [[ -f ${SSL_PEM} ]] && [[ -f ${SSL_KEY} ]]; then
    # Replace the snakeoil certificate.
    sed -i 's,'"${SNAKEOIL_PEM}"','"${SSL_PEM}"',g' ${APACHE_DEFAULT_SSL}
    sed -i 's,'"${SNAKEOIL_KEY}"','"${SSL_KEY}"',g' ${APACHE_DEFAULT_SSL}

    a2enmod ssl
    a2ensite default-ssl.conf
    service apache2 restart
  fi
fi

APACHE_PORTS=/etc/apache2/ports.conf

# Handle different web server configurations.
if [[ ! -z ${NGINX_SETUP} ]]; then
  # Switch to alternative ports to prevent conflicts with Nginx.
  sed -i 's,80,'"${APACHE2_ALT_HTTP:-8080}"',g' ${APACHE_PORTS}
  sed -i 's,80,'"${APACHE2_ALT_HTTP:-8080}"',g' ${APACHE_DEFAULT}
  sed -i 's,443,'"${APACHE2_ALT_HTTPS:-8443}"',g' ${APACHE_PORTS}
  sed -i 's,443,'"${APACHE2_ALT_HTTPS:-8443}"',g' ${APACHE_DEFAULT_SSL}

  service apache2 restart
else
  # If Nginx is not installed, Apache must allow access to MailHog.
  # https://gist.github.com/flocondetoile/1854ba0907e2c5073ea6d5406ca8d243#configure-apache-as-a-proxy
  a2enmod vhost_alias proxy proxy_http proxy_wstunnel

  MAILHOG_APACHE_CONF=/etc/apache2/sites-available/mailhog.conf

  cp -p ${STARTERKIT_ROOT}/.provision.d/snippets/mailhog.conf \
    ${MAILHOG_APACHE_CONF}

  sed -i 's,.local,.'"${HOSTNAME_F}"',g' ${MAILHOG_APACHE_CONF}

  if [[ -d ${SSL_CERTS}/${HOSTNAME_F} ]]; then
    SSL_PEM=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.pem
    SSL_KEY=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.key

    if [[ -f ${SSL_PEM} ]] && [[ -f ${SSL_KEY} ]]; then
      # Replace the snakeoil certificate.
      sed -i 's,'"${SNAKEOIL_PEM}"','"${SSL_PEM}"',g' ${MAILHOG_APACHE_CONF}
      sed -i 's,'"${SNAKEOIL_KEY}"','"${SSL_KEY}"',g' ${MAILHOG_APACHE_CONF}
    fi
  fi

  a2ensite mailhog.conf
  service apache2 restart
fi
