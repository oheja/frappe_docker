# Set up image 
export APPS_JSON_BASE64=$(base64 -i apps.json)

## To stop and remove containers
docker compose -p frappe -f compose.custom.yaml down

# Build VERSION 16

docker build \
 --platform linux/arm64 \
 --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
 --build-arg=FRAPPE_BRANCH=version-16 \
 --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
 --tag=custom:16 \
 --no-cache \
 --file=images/layered/Containerfile .

# Create compose 
docker compose --env-file custom.env \
    -f compose.yaml \
    -f overrides/compose.mariadb.yaml \
    -f overrides/compose.redis.yaml \
    -f overrides/compose.noproxy.yaml \
    config > compose.custom.yaml

# Start app
docker compose -p frappe -f compose.custom.yaml up -d

# Create local host
docker compose -p frappe exec -T backend bench new-site localhost \
  --mariadb-user-host-login-scope='%' \
  --db-root-password 123 \
  --admin-password admin \
  --install-app flower_stock \
  --install-app erpnext \
  --install-app hrms \
  --install-app crm \
  --install-app insights \
  --install-app csf_ke


docker compose -p frappe exec -T backend bench new-site frappe.extaa.com \
  --mariadb-user-host-login-scope='%' \
  --db-root-password 123 \
  --admin-password admin \
  --install-app erpnext \
  --install-app hrms 

# install frapper dev NEW
docker compose -p frappe exec -T backend bench new-site frappe-dev.extaa.com \
  --mariadb-user-host-login-scope='%' \
  --db-root-password 123 \
  --admin-password admin \
  --install-app flower_stock \
  --install-app erpnext \
  --install-app hrms \
  --install-app crm \
  --install-app insights \
  --install-app csf_ke

# update frappe devsite
1. Check existing sites

docker compose -p frappe exec -T backend bench --site frappe-dev.extaa.com list-apps
2. Update apps
docker compose -p frappe exec -T backend bench --site frappe-dev.extaa.com install-app erpnext
docker compose -p frappe exec -T backend bench --site frappe-dev.extaa.com install-app hrms
docker compose -p frappe exec -T backend bench --site frappe-dev.extaa.com install-app crm
docker compose -p frappe exec -T backend bench --site frappe-dev.extaa.com install-app insights
docker compose -p frappe exec -T backend bench --site frappe-dev.extaa.com install-app csf_ke
docker compose -p frappe exec -T backend bench --site frappe-dev.extaa.com install-app flower_stock

3. Migrate site


docker compose -p frappe exec -T backend bench --site frappe-dev.extaa.com migrate

docker compose -p frappe exec -T backend bench --site localhost migrate

1. Check existing sites

docker compose -p frappe exec -T backend bench --site localhost list-apps
2. Update apps
docker compose -p frappe exec -T backend bench --site localhost install-app erpnext
docker compose -p frappe exec -T backend bench --site localhost install-app hrms
docker compose -p frappe exec -T backend bench --site localhost install-app crm
docker compose -p frappe exec -T backend bench --site localhost install-app insights
docker compose -p frappe exec -T backend bench --site localhost install-app csf_ke
docker compose -p frappe exec -T backend bench --site localhost install-app flower_stock
## Remove data
docker volume rm frappe_docker_db-data
docker compose -p frappe -f compose.custom.yaml down -v


# Build VERSION 15
docker build \
 --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
 --build-arg=FRAPPE_BRANCH=version-15 \
 --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
 --tag=custom:15 \
 --file=images/layered/Containerfile .