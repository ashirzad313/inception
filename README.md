# Inception 

This project aims to introduce you to system administration by working with Docker. You'll gain hands-on experience with containerization and deploying applications in a multi-container environment.

## Table of Contents
- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Components Overview](#components-overview)
  - [WordPress](#wordpress)
  - [Nginx](#nginx)
  - [MariaDB](#mariadb)

## Project Overview
Inception is designed to help you understand the basics of system administration using Docker. You'll learn to:
- Set up and configure Docker containers.
- Work with Docker Compose to manage multi-container applications.

## Prerequisites
Before you begin, ensure you have the following installed:
- Docker: [Installation Guide](https://docs.docker.com/get-docker/)
- Docker Compose: [Installation Guide](https://docs.docker.com/compose/install/)

## Installation
1. Clone this repository:
    ```sh
    git clone https://github.com/hamidthri/inception.git
    cd inception
    ```

2. Create the necessary directories and build the Docker images:
    ```sh
    make build
    ```

3. Start the Docker containers:
    ```sh
    make up
    ```

## Usage
- Access your application at `http://localhost` (or the appropriate port specified in your Docker setup).
- To stop the containers, run:
    ```sh
    make down
    ```
- To restart the containers, run:
    ```sh
    make restart
    ```
- To stop the containers without removing them, run:
    ```sh
    make stop
    ```
- To start the stopped containers again, run:
    ```sh
    make start
    ```
- To clean up and remove all containers, images, and volumes, run:
    ```sh
    make clean
    ```

## Project Structure
- `Makefile`: Makefile to manage Docker commands.
- `srcs/docker-compose.yml`: Configuration file for Docker Compose.
- `Dockerfile`: Instructions to build individual Docker images.
- `src/`: Source code for your application.

## Components Overview

### WordPress
[WordPress](https://wordpress.org/) is an open-source content management system (CMS) that is widely used for creating websites and blogs. It is written in PHP and uses a MySQL database to store content. In this project, WordPress is deployed in a Docker container to allow easy setup and management.

### Nginx
[Nginx](https://nginx.org/) is a high-performance web server that is used to serve static content, reverse proxy to other web servers, and handle incoming HTTP requests. In this project, Nginx is configured to serve the WordPress application and handle all incoming web traffic. Nginx will listen on port 443 and forward requests to the WordPress container.

### MariaDB
[MariaDB](https://mariadb.org/) is an open-source relational database management system (RDBMS) that is a fork of MySQL. It is used to store the data for the WordPress application. In this project, MariaDB is deployed in a Docker container, and it will store the WordPress database. The WordPress container will connect to the MariaDB container to read and write data.

### How They Work Together
- **Nginx**: Acts as the web server and reverse proxy, handling incoming HTTP requests on port 443. It forwards these requests to the WordPress container.
- **WordPress**: Runs the WordPress application, which generates dynamic web content. It connects to the MariaDB container to retrieve and store data.
- **MariaDB**: Provides the database backend for WordPress, storing all the content and configuration information.

The interaction between these components is managed using Docker Compose, which defines the services, networks, and volumes needed for the application to run seamlessly.


Feel free to reach out if you have any questions or need further assistance. Happy coding!
