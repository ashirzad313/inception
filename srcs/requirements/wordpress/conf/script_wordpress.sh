#!/bin/bash

# Function to check if MariaDB is ready
wait_for_mariadb() {
  echo "Waiting for MariaDB to be ready..."
  until mysqladmin ping -h "${MYSQL_DB_HOST}" -u root --password="${MYSQL_ROOT_PASSWORD}" --silent; do
    sleep 1
  done
  echo "MariaDB is ready."
}

# Function to validate admin username
validate_admin_username() {
  if echo "${WORDPRESS_ADMIN_USER}" | grep -i -qE "admin|administrator"; then
    echo "Error: Invalid administrator username."
    exit 1
  fi
}

# Function to create wp-config.php
create_wp_config() {
  if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --path=/var/www/html \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${MYSQL_DB_HOST}" \
        --allow-root
  else
    echo "wp-config.php already exists. Skipping creation."
  fi
}

# Function to install WordPress
install_wordpress() {
  if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    wp core install --path=/var/www/html \
        --url=https://${DOMAIN_NAME} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email --allow-root

    echo "Creating a regular user..."
    wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --user_pass="${WORDPRESS_USER_PASSWORD}" --role=subscriber \
        --path=/var/www/html --allow-root

    echo "WordPress installation complete."
  else
    echo "WordPress is already installed. Skipping setup."
  fi
}

# Main execution block
wait_for_mariadb
validate_admin_username
create_wp_config
install_wordpress
