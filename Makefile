all : up

up :
	@docker-compose -f docker-compose.yml up -d

down :
	@docker-compose -f docker-compose.yml down

start :
	@docker-compose -f docker-compose.yml start

stop :
	@docker-compose -f docker-compose.yml stop

status :
	@docker ps
