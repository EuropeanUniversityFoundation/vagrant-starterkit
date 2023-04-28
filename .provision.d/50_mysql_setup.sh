#!/usr/bin/env bash
# MySQL setup script.

# Install MariaDB server.
apt-get install mariadb-server -y

# Create a non-root admin account.
mysql --user=root <<_EOF_
  CREATE USER IF NOT EXISTS 'vagrant'@'localhost' IDENTIFIED BY 'vagrant';
  GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'localhost' WITH GRANT OPTION;
  FLUSH PRIVILEGES;
_EOF_

# Handle persistent data.
if [[ ! -z ${DB_DATA} ]]; then
  DB_DATA_PATH=/mnt/data/${DB_DATA}

  # Stop MySQL before performing any operations.
  service mysql stop

  if [[ ! -d ${DB_DATA_PATH} ]]; then
    # See https://stackoverflow.com/a/43398493 for more.
    mkdir ${DB_DATA_PATH}
    # Set ownership of new directory to match existing one.
    chown --reference=/var/lib/mysql ${DB_DATA_PATH}
    # Set permissions on new directory to match existing one.
    chmod --reference=/var/lib/mysql ${DB_DATA_PATH}
    # Copy all files in default directory, to new one, retaining perms (-p).
    cp -rp /var/lib/mysql/* ${DB_DATA_PATH}
  fi

  MARIADB_CONF=/etc/mysql/mariadb.conf.d/50-server.cnf

  sed -i 's,/var/lib/mysql,'"${DB_DATA_PATH}"',g' ${MARIADB_CONF}

  # Start MySQL back up.
  service mysql start
fi
