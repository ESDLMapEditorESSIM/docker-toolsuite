#!/bin/bash
source .env

# change esdl-mapeditor-realm.json
if [[ ! -z "${DOMAIN}" && "${DOMAIN}" != "localhost" ]]; then
    sed "s#http://localhost:${GRAFANA_PORT}#${PROTOCOL}://${GRAFANA_DOMAIN}#g; \
    s#http://localhost:${ESDL_DRIVE_PORT}#${PROTOCOL}://${DRIVE_DOMAIN}#g; \
    s#http://localhost:${MAPEDITOR_PORT}#${PROTOCOL}://${MAPEDITOR_DOMAIN}#g" \
    keycloak/esdl-mapeditor-realm.json > keycloak/realms/esdl-mapeditor-realm.json
else
    echo "Domain is not set or set to localhost"
    cp keycloak/esdl-mapeditor-realm.json keycloak/realms/esdl-mapeditor-realm.json
fi

# Generate random alphanumeric strings that are 32 characters long if passwords are empty
if [ -z "$INFLUXDB_ADMIN_PASSWORD" ]; then
    echo "INFLUXDB_ADMIN_PASSWORD not found, generating..."
    INFLUXDB_ADMIN_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(INFLUXDB_ADMIN_PASSWORD\s*=\s*\).*/\1${INFLUXDB_ADMIN_PASSWORD}/" .env
fi

if [ -z "$INFLUXDB_WRITE_USER_PASSWORD" ]; then
    echo "INFLUXDB_WRITE_USER_PASSWORD not found, generating..."
    INFLUXDB_WRITE_USER_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(INFLUXDB_WRITE_USER_PASSWORD\s*=\s*\).*/\1${INFLUXDB_WRITE_USER_PASSWORD}/" .env
fi

if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "POSTGRES_PASSWORD not found, generating..."
    POSTGRES_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(POSTGRES_PASSWORD\s*=\s*\).*/\1${POSTGRES_PASSWORD}/" .env
fi

if [ -z "$POSTGRES_KEYCLOAK_PASSWORD" ]; then
    echo "POSTGRES_KEYCLOAK_PASSWORD not found, generating..."
    POSTGRES_KEYCLOAK_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(POSTGRES_KEYCLOAK_PASSWORD\s*=\s*\).*/\1${POSTGRES_KEYCLOAK_PASSWORD}/" .env
fi

if [ -z "$POSTGRES_BOUNDARY_SERVICE_PASSWORD" ]; then
    echo "POSTGRES_BOUNDARY_SERVICE_PASSWORD not found, generating..."
    POSTGRES_BOUNDARY_SERVICE_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(POSTGRES_BOUNDARY_SERVICE_PASSWORD\s*=\s*\).*/\1${POSTGRES_BOUNDARY_SERVICE_PASSWORD}/" .env
fi

if [ -z "$POSTGRES_DRIVE_PASSWORD" ]; then
    echo "POSTGRES_DRIVE_PASSWORD not found, generating..."
    POSTGRES_DRIVE_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(POSTGRES_DRIVE_PASSWORD\s*=\s*\).*/\1${POSTGRES_DRIVE_PASSWORD}/" .env
fi

if [ -z "$PGADMIN_DEFAULT_PASSWORD" ]; then
    echo "PGADMIN_DEFAULT_PASSWORD not found, generating..."
    PGADMIN_DEFAULT_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(PGADMIN_DEFAULT_PASSWORD\s*=\s*\).*/\1${PGADMIN_DEFAULT_PASSWORD}/" .env
fi

if [ -z "$KEYCLOAK_ADMIN_PASSWORD" ]; then
    echo "KEYCLOAK_ADMIN_PASSWORD not found, generating..."
    KEYCLOAK_ADMIN_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(KEYCLOAK_ADMIN_PASSWORD\s*=\s*\).*/\1${KEYCLOAK_ADMIN_PASSWORD}/" .env
fi

if [ -z "$GF_SECURITY_ADMIN_PASSWORD" ]; then
    echo "GF_SECURITY_ADMIN_PASSWORD= not found, generating..."
    GF_SECURITY_ADMIN_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
    sed -i "s/\(GF_SECURITY_ADMIN_PASSWORD\s*=\s*\).*/\1${GF_SECURITY_ADMIN_PASSWORD}/" .env
fi

# Setting the passwords in postgres/init-database.sh
sed -e "s/keycloak WITH ENCRYPTED PASSWORD 'password';/keycloak WITH ENCRYPTED PASSWORD '$POSTGRES_KEYCLOAK_PASSWORD';/" \
    -e "s/boundary_service WITH ENCRYPTED PASSWORD 'password';/boundary_service WITH ENCRYPTED PASSWORD '$POSTGRES_BOUNDARY_SERVICE_PASSWORD';/g" \
    -e "s/drive WITH ENCRYPTED PASSWORD 'password';/drive WITH ENCRYPTED PASSWORD '$POSTGRES_DRIVE_PASSWORD';/g" \
    init-database.sh > postgres/init-database.sh