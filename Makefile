# Phony targets
.PHONY: all up down stop build clean re prune logs exec shell enter

# Define paths to data directories
WP_DATA := /home/ashirzad/data/wordpress
DB_DATA := /home/ashirzad/data/mariadb
DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml

# Default target
all: up

# Ensure directories exist and start the containers
up:
	@mkdir -p "$(WP_DATA)" "$(DB_DATA)"
	docker-compose -f "$(DOCKER_COMPOSE_FILE)" up -d

# Stop and remove containers, networks, and volumes
down:
	docker-compose -f "$(DOCKER_COMPOSE_FILE)" down

# Stop running containers without removing them
stop:
	docker-compose -f "$(DOCKER_COMPOSE_FILE)" stop

# Build or rebuild services
build:
	docker-compose -f "$(DOCKER_COMPOSE_FILE)" build

# Follow logs for all services
logs:
	docker-compose -f "$(DOCKER_COMPOSE_FILE)" logs -f

# Execute a command in a running container (default: bash)
exec:
	docker-compose -f "$(DOCKER_COMPOSE_FILE)" exec -it wordpress bash

# Open a shell in a running container (default: sh)
shell:
	docker-compose -f "$(DOCKER_COMPOSE_FILE)" exec -it wordpress sh

# Alias for exec, opens a bash shell in a running container
enter:
	docker-compose -f "$(DOCKER_COMPOSE_FILE)" exec -it wordpress /bin/bash

# Clean up Docker resources and local data
clean:
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@rm -rf "$(WP_DATA)" "$(DB_DATA)" 2>/dev/null || true
	@./clear.sh  # Assuming clear.sh is a custom script for additional cleanup

# Rebuild the project from scratch
re: clean up

# Clean up Docker system and volumes
prune: clean
	@docker system prune -a --volumes -f

