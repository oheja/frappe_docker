#!/bin/bash

# Safe refresh for mounted code changes
# Use this for Python/JS/CSS changes (NO migrate - avoids orphan deletion issues)

docker compose -p frappe exec -T backend bench --site localhost list-apps

docker compose -p frappe -f compose.custom.yaml -f overrides/compose.dev-mounts.yaml down

docker compose -p frappe -f compose.custom.yaml -f overrides/compose.dev-mounts.yaml up -d

docker compose -p frappe exec -T backend bench --site localhost migrate

docker compose -p frappe exec -T backend bench build --app flower_stock

docker compose -p frappe exec -T backend bench --site localhost clear-cache

docker compose -p frappe restart backend

docker compose -p frappe exec -T backend bench --site localhost list-apps

