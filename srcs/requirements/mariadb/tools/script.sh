#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

# Bind MariaDB to all IP addresses
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Start the MariaDB service
service mariadb start

# Wait for MariaDB to be fully up and running
echo -e "${GREEN}Waiting for MariaDB to start...${NC}"
until mysqladmin ping -u root &>/dev/null; do
  echo -e "${GREEN}MariaDB is not ready yet. Retrying in 2 seconds...${NC}"
  sleep 2
done

# Set the root password (if needed) and create the database/user
echo -e "${GREEN}Configuring MariaDB...${NC}"
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Restart MariaDB to apply changes
echo -e "${GREEN}Restarting MariaDB...${NC}"
service mariadb restart

echo -e "${GREEN}MariaDB setup complete!${NC}"
