FROM debian:12-slim

RUN apt-get update && apt-get install -y \
  wget \
  unzip \
  s3fs \
  avro-bin \
  bash \
  jq \
  curl \
  tree \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN curl https://install.duckdb.org | sh
ENV PATH="/root/.duckdb/cli/latest:${PATH}"

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY ./run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/run.sh
ENV AWS_S3_MOUNT=/mnt/s3

WORKDIR /mnt/s3
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/bin/run.sh"]
