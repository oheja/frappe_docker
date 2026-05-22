#!/bin/bash

# Full refresh for ANY changes (Doctypes, JS/CSS, Python)
# Handles database migrations + asset rebuilds + cache clear + restart
# Faster than dev/refresh.sh — no container down/up

echo "=== Running migrate ==="
docker compose -p frappe exec -T backend bench --site localhost migrate

echo "=== Building assets in backend ==="
docker compose -p frappe exec -T backend bench build --force

echo "=== Building assets in frontend ==="
docker compose -p frappe exec -T frontend bench build --force

echo "=== Clearing cache ==="
docker compose -p frappe exec -T backend bench --site localhost clear-cache

echo "=== Restarting services ==="
docker compose -p frappe restart backend frontend

echo "=== Done ==="
