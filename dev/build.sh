#!/bin/bash

export APPS_JSON_BASE64=$(base64 -i apps.json)
echo "APPS_JSON_BASE64 set to: $APPS_JSON_BASE64"

docker compose -p frappe -f compose.custom.yaml down

 docker build \
 --platform linux/arm64 \
 --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
 --build-arg=FRAPPE_BRANCH=version-16 \
 --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
 --tag=custom:16 \
 --no-cache \
 --file=images/layered/Containerfile .


# docker compose --env-file custom.env \
#     -f compose.yaml \
#     -f overrides/compose.mariadb.yaml \
#     -f overrides/compose.redis.yaml \
#     -f overrides/compose.noproxy.yaml \
#     config > compose.custom.yaml∆
echo "Custom compose file generated at compose.custom.yaml"


docker compose -p frappe \
  -f compose.custom.yaml \
  -f overrides/compose.dev-mounts.yaml \
  up -d



docker compose -p frappe exec -T backend bench --site localhost migrate


