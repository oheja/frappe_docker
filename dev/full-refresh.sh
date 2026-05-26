#!/bin/bash

# Full refresh with workspace rebuild

echo "=== Deleting Flower Stock workspace to force rebuild ==="
docker compose -p frappe exec -T backend bench --site localhost console << 'PYEOF'
frappe.delete_doc("Workspace", "Flower Stock", force=1)
frappe.db.commit()
PYEOF

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

docker compose -p frappe exec -T backend bench set-config -g server_script_enabled 1
echo "=== Done ==="
docker compose -p frappe exec -T backend bench --site localhost list-apps


#  docker compose -p frappe exec -T backend bench --site localhost set-config allow_tests true 
# docker compose -p frappe exec -T backend bench --site localhost run-tests --doctype "Grading Record" --skip-before-tests
