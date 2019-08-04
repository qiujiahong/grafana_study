#!/bin/bash


# security
#   allow_embedding
#   admin_password

docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_PANELS_DISABLE_SANITIZE_HTML=true" \
  -e "GF_SECURITY_ALLOW_EMBEDDING=true" \
  -e "GF_SECURITY_ADMIN_PASSWORD=123456" \
    grafana/grafana:6.2.5

