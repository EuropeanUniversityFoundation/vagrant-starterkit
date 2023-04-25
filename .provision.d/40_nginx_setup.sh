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
