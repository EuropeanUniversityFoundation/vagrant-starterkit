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

if [[ -d ${SSL_CERTS}/${HOSTNAME_F} ]]; then
  SSL_PEM=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.pem
  SSL_KEY=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.key

  if [[ -f ${SSL_PEM} ]] && [[ -f ${SSL_KEY} ]]; then
    # Replace the snakeoil certificate.
    SNAKEOIL_PEM=/etc/ssl/certs/ssl-cert-snakeoil.pem
    SNAKEOIL_KEY=/etc/ssl/private/ssl-cert-snakeoil.key

    sed -i 's,'"${SNAKEOIL_PEM}"','"${SSL_PEM}"',g' ${APACHE_DEFAULT_SSL}
    sed -i 's,'"${SNAKEOIL_KEY}"','"${SSL_KEY}"',g' ${APACHE_DEFAULT_SSL}

    a2enmod ssl
    a2ensite default-ssl.conf
    service apache2 restart
  fi
fi

# Switch to alternative ports to prevent conflicts with Nginx.
if [[ ! -z ${NGINX_SETUP} ]]; then
  APACHE_PORTS=/etc/apache2/ports.conf

  sed -i 's,80,'"${APACHE2_ALT_HTTP:-8080}"',g' ${APACHE_PORTS}
  sed -i 's,80,'"${APACHE2_ALT_HTTP:-8080}"',g' ${APACHE_DEFAULT}
  sed -i 's,443,'"${APACHE2_ALT_HTTPS:-8443}"',g' ${APACHE_PORTS}
  sed -i 's,443,'"${APACHE2_ALT_HTTPS:-8443}"',g' ${APACHE_DEFAULT_SSL}

  service apache2 restart
fi
