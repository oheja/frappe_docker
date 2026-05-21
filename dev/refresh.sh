#!/bin/bash

# Quick refresh for mounted code changes
# Run this after editing code in apps/flower_stock/

docker compose -p frappe exec -T backend bench --site localhost migrate
docker compose -p frappe exec -T backend bench build
docker compose -p frappe restart backend

echo "✅ Refresh complete. Hard-refresh your browser (Cmd+Shift+R or Ctrl+F5)"
