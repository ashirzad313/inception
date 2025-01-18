# Variables
WP_DATA=/home/ashirzad/data/wordpress
DB_DATA=/home/ashirzad/data/mariadb
COMPOSE_FILE=./srcs/docker-compose.yml

# Colors
GREEN=\033[0;32m
RED=\033[0;31m
NC=\033[0m

# Default target
all: up

# Start the containers
up: build
	@echo "$(GREEN)Creating data directories...$(NC)"
	@mkdir -p $(WP_DATA) $(DB_DATA)
	@echo "$(GREEN)Starting containers...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) up -d

# Stop and remove containers, networks, and volumes
down:
	@echo "$(RED)Stopping and removing containers...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) down

# Stop containers without removing them
stop:
	@echo "$(RED)Stopping containers...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) stop

# Start stopped containers
start:
	@echo "$(GREEN)Starting containers...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) start

# Build or rebuild services
build:
	@echo "$(GREEN)Building containers...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) build

# Clean up containers, images, volumes, and networks
clean:
	@echo "$(RED)Cleaning up Docker resources...$(NC)"
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@echo "$(RED)Removing data directories...$(NC)"
	@rm -rf $(WP_DATA) 2>/dev/null || true
	@rm -rf $(DB_DATA) 2>/dev/null || true

# Rebuild everything from scratch
re: clean up

# Prune the Docker system (including unused images and volumes)
prune: clean
	@echo "$(RED)Pruning Docker system...$(NC)"
	@docker system prune -a --volumes -f

# Help message
help:
	@echo "$(GREEN)Available targets:$(NC)"
	@echo "  all       - Build and start the containers (default target)"
	@echo "  up        - Start the containers"
	@echo "  down      - Stop and remove containers, networks, and volumes"
	@echo "  stop      - Stop containers without removing them"
	@echo "  start     - Start stopped containers"
	@echo "  build     - Build or rebuild services"
	@echo "  clean     - Clean up containers, images, volumes, and networks"
	@echo "  re        - Rebuild everything from scratch"
	@echo "  prune     - Prune the Docker system (including unused images and volumes)"
	@echo "  help      - Show this help message"

.PHONY: all up down stop start build clean re prune help
