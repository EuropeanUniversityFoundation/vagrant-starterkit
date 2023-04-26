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
service nginx reload

# Check for existing SSL certificates for current FQDN.
SSL_CERTS=/usr/local/share/ca-certificates
HOSTNAME_F=$(hostname -f)

if [[ -d ${SSL_CERTS}/${HOSTNAME_F} ]]; then
  # Nginx does not ship with a default SSL site configuration.
  NGINX_EXAMPLE_SSL=/etc/nginx/sites-available/default-ssl
  cat > ${NGINX_EXAMPLE_SSL} << 'EOL'
server {
  listen 443 ssl default_server;
  listen [::]:443 ssl default_server;

  ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
  ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;

  server_name _;

  root /var/www/html/nginx;
  index index.html index.htm index.nginx-debian.html;

  location / {
    try_files $uri $uri/ =404;
  }
}
EOL

  SSL_PEM=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.pem
  SSL_KEY=${SSL_CERTS}/${HOSTNAME_F}/${HOSTNAME_F}.key

  if [[ -f ${SSL_PEM} ]] && [[ -f ${SSL_KEY} ]]; then
    # Replace the snakeoil certificate.
    SNAKEOIL_PEM=/etc/ssl/certs/ssl-cert-snakeoil.pem
    SNAKEOIL_KEY=/etc/ssl/private/ssl-cert-snakeoil.key

    sed -i 's,'"${SNAKEOIL_PEM}"','"${SSL_PEM}"',g' ${NGINX_EXAMPLE_SSL}
    sed -i 's,'"${SNAKEOIL_KEY}"','"${SSL_KEY}"',g' ${NGINX_EXAMPLE_SSL}

    ln -s ${NGINX_EXAMPLE_SSL} /etc/nginx/sites-enabled
    service nginx reload
  fi
fi
