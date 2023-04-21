#!/usr/bin/env bash

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
