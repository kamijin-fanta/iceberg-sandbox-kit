#!/bin/sh

set -e

if [ -z "$AWS_S3_ACCESS_KEY_ID" ] && \
  [ -z "$AWS_S3_SECRET_ACCESS_KEY" ] && \
  [ -z "$AWS_S3_SECRET_ACCESS_KEY_FILE" ] && \
  [ -z "$AWS_S3_AUTHFILE" ];
then
  echo "You need to provide some credentials"
  exit 1
fi

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "You need to provide a bucket name"
  exit 1
fi

AWS_S3_AUTHFILE=/etc/passwd-s3fs
echo "${AWS_S3_ACCESS_KEY_ID}:${AWS_S3_SECRET_ACCESS_KEY}" > "${AWS_S3_AUTHFILE}"
chmod 600 "${AWS_S3_AUTHFILE}"

mkdir -p "${AWS_S3_MOUNT}"

echo "Mounting ${AWS_S3_BUCKET} to ${AWS_S3_MOUNT}..."
s3fs "${AWS_S3_BUCKET}" "${AWS_S3_MOUNT}" \
  -o passwd_file="${AWS_S3_AUTHFILE}" \
  -o url="${AWS_S3_URL}" \
  -o use_path_request_style \
  -o allow_other

exec "$@"
