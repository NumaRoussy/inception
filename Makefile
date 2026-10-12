NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = docker compose -f $(COMPOSE_FILE)

DATA_PATH = /home/nroussy/data
DB_PATH = $(DATA_PATH)/mariadb
WP_PATH = $(DATA_PATH)/wordpress

all:
	@mkdir -p $(DB_PATH) $(WP_PATH)
	$(COMPOSE) up -d --build

build:
	$(COMPOSE) build

up:
	@mkdir -p $(DB_PATH) $(WP_PATH)
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

status:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

clean: down

fclean:
	@echo "Arrêt et suppression de tous les conteneurs, images et volumes..."
	-$(COMPOSE) down --volumes --rmi all
	@echo "Nettoyage des données hôtes..."
	-sudo rm -rf $(DB_PATH)/* $(WP_PATH)/*
	-docker system prune -af

re: fclean all

.PHONY: all build up down stop start status logs clean fclean re
