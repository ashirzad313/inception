FROM debian:buster

# Install MariaDB server and required tools
RUN apt-get update && apt-get install -y \
    mariadb-server \
    procps \  # Install procps for the 'ps' command
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy the initialization script
COPY ./tools/script.sh /mariadb/script.sh
RUN chmod +x /mariadb/script.sh

# Expose the MariaDB port
EXPOSE 3306

# Set the entrypoint to run the script
ENTRYPOINT ["sh", "/mariadb/script.sh"]
