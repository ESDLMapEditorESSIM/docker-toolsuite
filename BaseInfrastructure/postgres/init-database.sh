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

DB_INIT_MODE="${DB_INIT_MODE:-create_only}"
ENABLE_KEYCLOAK_DB="${ENABLE_KEYCLOAK_DB:-false}"
IMPORT_BOUNDARY_DATA="${IMPORT_BOUNDARY_DATA:-true}"
IMPORT_BOUNDARY_SHAPEFILES="${IMPORT_BOUNDARY_SHAPEFILES:-true}"
BOUNDARY_DATA_DIR="${BOUNDARY_DATA_DIR:-/data/boundaries}"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

create_user_and_db() {
  local username=$1
  local password=$2
  local dbname=$3
  local extra_grants=$4

  if [[ "$DB_INIT_MODE" == "create_or_update" ]]; then
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
  else
    log "Creating user and database for $username..."

    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
      DO \$\$
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$username') THEN
          CREATE USER $username WITH ENCRYPTED PASSWORD '$password';
        END IF;
      END;
      \$\$;
EOSQL
  fi

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT 'CREATE DATABASE $dbname OWNER $username'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$dbname')
    \gexec
EOSQL

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

    shp2pgsql -s 4326 "$BOUNDARY_DATA_DIR/$shapefile.shp" "public.$table_name" | \
      psql --username boundary_service --dbname boundaries
  fi
}

import_boundary_data() {
  if [[ "$IMPORT_BOUNDARY_DATA" != "true" ]]; then
    log "Boundary service data import disabled, skipping"
    return
  fi

  if [[ ! -f "$BOUNDARY_DATA_DIR/bu_wk_gm_es_pv_la.sql" ]]; then
    log "Boundary SQL file not found at $BOUNDARY_DATA_DIR/bu_wk_gm_es_pv_la.sql, skipping"
    return
  fi

  if ! psql --username boundary_service --dbname boundaries -t -c "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'bu_wk_gm_es_pv_la_2019');" | grep -q t; then
    log "Importing boundary_service data..."
    psql --username "$POSTGRES_USER" --dbname boundaries -f "$BOUNDARY_DATA_DIR/bu_wk_gm_es_pv_la.sql"
  else
    log "Boundary service data already imported, skipping"
  fi
}

import_boundary_shapefiles() {
  if [[ "$IMPORT_BOUNDARY_SHAPEFILES" != "true" ]]; then
    log "Boundary shapefile import disabled, skipping"
    return
  fi

  if [[ ! -f "$BOUNDARY_DATA_DIR/buurt_2019_wgs.shp" ]]; then
    log "Boundary shapefiles not found at $BOUNDARY_DATA_DIR, skipping shapefile import"
    return
  fi

  log "Importing shapefiles if needed..."
  import_shapefile "buurt_2019_wgs" "buurt_2019_wgs"
  import_shapefile "wijk_2019_wgs" "wijk_2019_wgs"
  import_shapefile "gem_2019_wgs" "gem_2019_wgs"
  import_shapefile "res_2019_wgs" "res_2019_wgs"
  import_shapefile "prov_2019_wgs" "prov_2019_wgs"
  import_shapefile "land_2019_wgs" "land_2019_wgs"
}

log "Starting database initialization..."

if [[ "$DB_INIT_MODE" == "create_or_update" ]]; then
  log "Updating superuser password..."
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    ALTER ROLE $POSTGRES_USER WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
EOSQL
fi

if [[ "$ENABLE_KEYCLOAK_DB" == "true" ]]; then
  create_user_and_db "keycloak" "${POSTGRES_KEYCLOAK_PASSWORD}" "keycloak" ""
fi

create_user_and_db "boundary_service" "${POSTGRES_BOUNDARY_SERVICE_PASSWORD}" "boundaries" ""
create_user_and_db "drive" "${POSTGRES_DRIVE_PASSWORD}" "esdlrepo" "ALTER USER drive CREATEDB;"
create_user_and_db "drive" "${POSTGRES_DRIVE_PASSWORD}" "esdl_geometries" "ALTER USER drive CREATEDB;"
create_user_and_db "data_manager" "${POSTGRES_DATA_MANAGER_PASSWORD}" "data_manager" ""
create_user_and_db "essim"  "${POSTGRES_ESSIM_PASSWORD}" "essim" ""

log "Setting up PostGIS extensions on databases..."
psql --username "$POSTGRES_USER" --dbname esdl_geometries -c "CREATE EXTENSION IF NOT EXISTS postgis;"
psql --username "$POSTGRES_USER" --dbname esdl_geometries -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"
psql --username "$POSTGRES_USER" --dbname boundaries -c "CREATE EXTENSION IF NOT EXISTS postgis;"
psql --username "$POSTGRES_USER" --dbname boundaries -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"

import_boundary_data
import_boundary_shapefiles

log "Database initialization completed successfully."

touch /var/lib/postgresql/data/.db_init_done
