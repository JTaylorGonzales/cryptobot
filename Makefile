db-create:
	docker-compose run --rm server mix ecto.setup

start:
	docker-compose up