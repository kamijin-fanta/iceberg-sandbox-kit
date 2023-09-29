include .env

.PHONY: start stop clean trino minio mysql debug

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
