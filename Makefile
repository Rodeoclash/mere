.PHONY: bash-app bash-app-root build setup install

bash-app:
	docker-compose run --rm app bash

bash-app-root:
	docker-compose run --user=root:root --rm app bash

build:
	docker-compose build

setup:
	make build; \
	docker-compose run --user=root:root --rm app chown -R 1000:1000 /opt/hex; \
	docker-compose run --user=root:root --rm app chown -R 1000:1000 /opt/mix; \
	docker-compose run --user=root:root --rm app mkdir -p /home/server; \
	docker-compose run --user=root:root --rm app chown -R 1000:1000 /home/server; \

install:
	docker-compose run --rm app mix setup
	docker-compose run --rm --workdir=/usr/src/app/assets app npm install; \
