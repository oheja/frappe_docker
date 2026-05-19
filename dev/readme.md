# Set up image 
export APPS_JSON_BASE64=$(base64 -w 0 apps.json)

# Build VERSION 15
docker build \
 --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
 --build-arg=FRAPPE_BRANCH=version-15 \
 --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
 --tag=custom:15 \
 --file=images/layered/Containerfile .

# Build VERSION 16

docker build \
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
  --install-app erpnext \
  --install-app hrms \
  <!-- --install-app helpdesk -->


docker compose -p frappe exec -T backend bench new-site frappe.extaa.com \
  --mariadb-user-host-login-scope='%' \
  --db-root-password 123 \
  --admin-password admin \
  --install-app erpnext \
  --install-app hrms 

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
## To stop and remove containers
docker compose -p frappe -f compose.custom.yaml down

## Remove data
docker volume rm frappe_docker_db-data
docker compose -p frappe -f compose.custom.yaml down -v
