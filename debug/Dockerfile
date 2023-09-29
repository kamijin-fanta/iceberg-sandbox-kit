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
RUN wget https://github.com/manojkarthick/pqrs/releases/download/v0.3.1/pqrs-0.3.1-x86_64-unknown-linux-gnu.zip \
  && unzip pqrs-0.3.1-x86_64-unknown-linux-gnu.zip \
  && mv ./pqrs-0.3.1-x86_64-unknown-linux-gnu/bin/pqrs /usr/local/bin/pqrs \
  && rm -rf pqrs-0.3.1-x86_64-unknown-linux-gnu.zip pqrs-0.3.1-x86_64-unknown-linux-gnu

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY ./run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/run.sh
ENV AWS_S3_MOUNT=/mnt/s3

WORKDIR /mnt/s3
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/bin/run.sh"]
