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

# Ensure the additional disk is partitioned.
if [[ -z $( lsblk | grep vdb1 ) ]]; then
  echo "/dev/vdb is not partitioned."

  # See https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux for details.
  apt-get install parted -y
  parted /dev/vdb mklabel gpt
  parted -a opt /dev/vdb mkpart primary ext4 0% 100%
  mkfs.ext4 -L datapartition /dev/vdb1

  lsblk | grep vdb1
fi

# Ensure the additional disk is mounted at startup.
if [[ -z $( grep datapartition /etc/fstab ) ]]; then
  echo "/dev/vdb1 is not mounted at startup."

  mkdir -p /mnt/data
  mount -o defaults /dev/vdb1 /mnt/data
  echo "LABEL=datapartition /mnt/data ext4 defaults 0 2" >> /etc/fstab

  grep datapartition /etc/fstab
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

# PHP setup.
if [[ ! -z ${PHP_SETUP} ]]; then source ${PHP_SETUP}; fi

# NodeJS setup.
if [[ ! -z ${NODE_SETUP} ]]; then source ${NODE_SETUP}; fi
