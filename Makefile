.PHONY: all up down stop build clean re prune logs exec shell enter

# Define paths to data directories
WP_DATA := /home/ashirzad/data/wordpress
DB_DATA := /home/ashirzad/data/mariadb

all: up 

up: 
        @mkdir -p "$(WP_DATA)" 
        @mkdir -p "$(DB_DATA)" 
        docker-compose -f ./srcs/docker-compose.yml up -d 

down:
        docker-compose -f ./srcs/docker-compose.yml down

stop:
        docker-compose -f ./srcs/docker-compose.yml stop

build:
        docker-compose -f ./srcs/docker-compose.yml build

logs:
        docker-compose -f ./srcs/docker-compose.yml logs -f

exec:
        docker-compose -f ./srcs/docker-compose.yml exec -it wordpress bash

shell:
        docker-compose -f ./srcs/docker-compose.yml exec -it wordpress sh

enter:
        docker-compose -f ./srcs/docker-compose.yml exec -it wordpress /bin/bash

clean:
        @docker stop $(docker ps -qa) || true
        @docker rm $(docker ps -qa) || true
        @docker rmi -f $(docker images -qa) || true
        @docker volume rm $(docker volume ls -q) || true
        @docker network rm $(docker network ls -q) || true
        @rm -rf "$(WP_DATA)" || true
        @rm -rf "$(DB_DATA)" || true
        @./clear.sh  # Assuming clear.sh is a custom script for additional cleanup

re: clean

prune: clean
        @docker system prune -a --volumes -f

