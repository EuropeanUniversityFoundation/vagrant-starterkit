#!/usr/bin/env bash
# Provisioning script.

# Preliminary steps.
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Load environment file if it exists.
if [[ -f /home/vagrant/vagrant-root/.env ]]; then
  source /home/vagrant/vagrant-root/.env
  echo -e "Loaded local environment file for ${VM_HOSTNAME:-default}."
else
  echo "ERROR: .env not found!"
  exit 1
fi

# Bash setup.
if [[ ! -z ${BASH_SETUP} ]]; then source ${BASH_SETUP}; fi

# Git setup.
if [[ ! -z ${GIT_SETUP} ]]; then source ${GIT_SETUP}; fi

# SSL setup.
if [[ ! -z ${SSL_SETUP} ]]; then source ${SSL_SETUP}; fi

# Apache2 setup.
if [[ ! -z ${APACHE2_SETUP} ]]; then source ${APACHE2_SETUP}; fi

# Nginx setup.
if [[ ! -z ${NGINX_SETUP} ]]; then source ${NGINX_SETUP}; fi

# MySQL setup.
if [[ ! -z ${MYSQL_SETUP} ]]; then source ${MYSQL_SETUP}; fi
