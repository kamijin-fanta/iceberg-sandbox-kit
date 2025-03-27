include .env

.PHONY: start stop clean trino minio mysql debug build init-table insert-row

start:
	docker compose up -d
	# Service started!
	# Trino: http://localhost:8080 / User: dummy
	# Minio: http://localhost:9000 / User: ${AWS_ACCESS_KEY_ID} / Password: ${AWS_SECRET_ACCESS_KEY}

stop:
	docker compose stop

clean:
	docker compose down --volumes

trino:
	docker compose exec trino trino --catalog iceberg --schema default

minio:
	docker compose exec minio sh -c 'cd /data; bash'

mysql:
	docker compose exec mysql bash -c 'mysql -hlocalhost -p$${MYSQL_ROOT_PASSWORD} $${MYSQL_DATABASE}'

debug:
	docker compose exec debug bash

build:
	docker compose build

init-table:
	docker compose exec trino trino --catalog iceberg --schema default --execute "CREATE SCHEMA IF NOT EXISTS default; USE default; CREATE TABLE IF NOT EXISTS t1 (a int, b int);"

insert-row:
	docker compose exec trino trino --catalog iceberg --schema default --execute "USE default; INSERT INTO t1 VALUES (1, 2); SELECT * FROM t1;"
