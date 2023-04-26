#!/usr/bin/env bash
# MySQL setup script.

# Install MariaDB server.
apt-get install mariadb-server -y

if [[ ! -z ${MYSQL_DATA_DIR} ]]; then
  # See https://stackoverflow.com/a/43398493 for more.

  # Set ownership of new directory to match existing one.
  chown --reference=/var/lib/mysql ${MYSQL_DATA_MNT}

  # Set permissions on new directory to match existing one.
  chmod --reference=/var/lib/mysql ${MYSQL_DATA_MNT}

  # Stop MySQL before copying over files.
  service mysql stop

  # Copy all files in default directory, to new one, retaining perms (-p).
  cp -rp /var/lib/mysql/* ${MYSQL_DATA_MNT}

  # Create a new config file.
  echo "[mysqld]" >> /etc/mysql/conf.d/mysqld.cnf
  echo "datadir=${MYSQL_DATA_MNT}"

  # Start MySQL back up.
  service mysql start
fi
