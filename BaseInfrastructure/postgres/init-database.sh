#!/bin/bash
#===================================================================================
# Set up PostgreSQL users, databases, extensions, and import data.
# This script is designed to be idempotent. When making any changes, please ensure
# that it remains that way!
#
# This script is automatically executed by postgres-entrypoint.sh when the PostgreSQL
# container starts.
#===================================================================================

set -e

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

create_user_and_db() {
  local username=$1
  local password=$2
  local dbname=$3
  local extra_grants=$4

  log "Creating or updating user and database for $username..."

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    DO \$\$
    BEGIN
      IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$username') THEN
        CREATE USER $username WITH ENCRYPTED PASSWORD '$password';
      ELSE
        ALTER ROLE $username WITH ENCRYPTED PASSWORD '$password';
      END IF;
    END;
    \$\$;
EOSQL
psql --username "$POSTGRES_USER" --dbname esdl_geometries -c "CREATE EXTENSION IF NOT EXISTS postgis;"

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT 'CREATE DATABASE $dbname OWNER $username'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$dbname')
    \gexec
EOSQL

  # Grant privileges (idempotent)
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE $dbname TO $username;
    $extra_grants
EOSQL
}

import_shapefile() {
  local shapefile=$1
  local table_name=$2

  local table_exists=$(psql --username boundary_service --dbname boundaries -t -c "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '$table_name');")

  if [[ $table_exists =~ t ]]; then
    log "Table $table_name already exists, skipping import"
  else
    log "Importing $shapefile into $table_name..."
    shp2pgsql -s 4326 "/data/boundaries/$shapefile.shp" "public.$table_name" | \
      psql --username boundary_service --dbname boundaries
  fi
}

log "Starting database initialization..."

# Create users and databases
create_user_and_db "keycloak" "${POSTGRES_KEYCLOAK_PASSWORD}" "keycloak" ""
create_user_and_db "boundary_service" "${POSTGRES_BOUNDARY_SERVICE_PASSWORD}" "boundaries" ""
create_user_and_db "drive" "${POSTGRES_DRIVE_PASSWORD}" "esdlrepo" "ALTER USER drive CREATEDB;"
create_user_and_db "drive" "${POSTGRES_DRIVE_PASSWORD}" "esdl_geometries" "ALTER USER drive CREATEDB;"
create_user_and_db "data_manager" "${POSTGRES_DATA_MANAGER_PASSWORD}" "data_manager" ""

log "Setting up PostGIS extensions on boundaries database..."
psql --username "$POSTGRES_USER" --dbname boundaries -c "CREATE EXTENSION IF NOT EXISTS postgis;"
psql --username "$POSTGRES_USER" --dbname boundaries -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"

# Import boundary_service data - check if already imported
if ! psql --username boundary_service --dbname boundaries -t -c "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'bu_wk_gm_es_pv_la_2019');" | grep -q t; then
  log "Importing boundary_service data..."
  psql --username "$POSTGRES_USER" --dbname boundaries -f /data/boundaries/bu_wk_gm_es_pv_la.sql
else
  log "Boundary service data already imported, skipping"
fi

# Import shapefiles
log "Importing shapefiles if needed..."
import_shapefile "buurt_2019_wgs" "buurt_2019_wgs"
import_shapefile "wijk_2019_wgs" "wijk_2019_wgs"
import_shapefile "gem_2019_wgs" "gem_2019_wgs"
import_shapefile "res_2019_wgs" "res_2019_wgs"
import_shapefile "prov_2019_wgs" "prov_2019_wgs"
import_shapefile "land_2019_wgs" "land_2019_wgs"

log "Database initialization completed successfully."
