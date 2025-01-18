#!/bin/bash

DB_DIR="/var/lib/mysql"

# Check if MariaDB data directory exists
if [ ! -d "$DB_DIR/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir="$DB_DIR"
fi

# Modify configuration to allow external connections (if needed)
sed -i "s|bind-address\s*=\s*127.0.0.1|bind-address\s*=\s*0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

# Start MariaDB in the background
mysqld_safe --datadir="$DB_DIR" &

# Wait for MariaDB to start (adjust sleep time as needed)
sleep 5

# Check if MariaDB is running (optional)
while ! mysqladmin ping -h 127.0.0.1 --silent; do
  echo "Waiting for MariaDB to start..."
  sleep 1
done

echo "Configuring MariaDB..."

# Execute SQL commands
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_ADMIN_USER}'@'%';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'%' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"

wait
