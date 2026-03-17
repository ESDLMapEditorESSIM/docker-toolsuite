#!/bin/bash
#====================================================================================
# Upgrade PostgreSQL version.
# Run this script from the root, where the main docker-compose is located.
# If you have sensitive data, only run the backup part first to verify you have a
# proper backup.
#====================================================================================
set -euo pipefail

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

if [[ ! -f "docker-compose.yml" ]]; then
  echo "Please run this script from the root directory of the repository."
  exit 1
fi

log "Starting PostgreSQL upgrade from whatever is running to 17."

log "Stopping all containers and only starting postgres..."
docker-compose down
docker-compose up -d postgres

log "Waiting for postgres to become ready..."
until docker-compose exec postgres pg_isready -U postgres >/dev/null 1>&1; do
  sleep 1
done

BACKUP_DATE=$(date '+%Y%m%d_%H%M%S')
BACKUP_DIRECTORY="./pg_backup/backups_${BACKUP_DATE}"
BACKUP_GLOBALS_FILE="${BACKUP_DIRECTORY}/globals.sql"

OLD_VOLUME="baseinfrastructure_postgres_storage"
BACKUP_VOLUME="${OLD_VOLUME}_backup_${BACKUP_DATE}"

mkdir -p "${BACKUP_DIRECTORY}"

# Create a backup of data from the running container.
log "Creating backup of PostgreSQL data..."
# This file contains users and passwords. We won't actually restore them though.
docker exec esdl-toolsuite_postgres pg_dumpall -U postgres --globals-only > "${BACKUP_GLOBALS_FILE}"

log "Creating per-database dumps..."
for db in $(docker exec esdl-toolsuite_postgres psql -U postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"); do
  db_clean=$(echo "$db" | xargs)  # trim whitespace
  log "Backing up database: ${db_clean}"

  # Dump normally in plain SQL format (so we can edit)
  docker exec esdl-toolsuite_postgres pg_dump -U postgres -d "${db_clean}" > "${BACKUP_DIRECTORY}/${db_clean}.sql"

  # Strip PostGIS extension lines (CREATE/COMMENT statements)
  sed -i '/CREATE EXTENSION IF NOT EXISTS postgis/d' "${BACKUP_DIRECTORY}/${db_clean}.sql"
  sed -i '/CREATE EXTENSION IF NOT EXISTS postgis_topology/d' "${BACKUP_DIRECTORY}/${db_clean}.sql"
  sed -i '/COMMENT ON EXTENSION postgis/d' "${BACKUP_DIRECTORY}/${db_clean}.sql"
done

read -p "Backups saved in ${BACKUP_DIRECTORY}. Do you want to continue with the upgrade? (y/n): " choice
case "$choice" in
  y|Y ) log "Continuing with upgrade process...";;
  * ) log "Upgrade aborted. Backups are available at ${BACKUP_DIRECTORY}"; exit 0;;
esac

log "Stopping all containers..."
docker-compose down

# You could restore the volume afterwards with something like:
# docker run --rm \
#  -v baseinfrastructure_postgres_storage_backup_20251014_153357:/from \
#  -v baseinfrastructure_postgres_storage:/to \
#  alpine ash -c "cd /from && cp -a . /to"

log "Creating a backup copy of the existing postgres volume..."
docker volume create --name "${BACKUP_VOLUME}"
docker run --rm \
  -v ${OLD_VOLUME}:/from \
  -v ${BACKUP_VOLUME}:/to \
  alpine ash -c "cd /from && cp -a . /to"

log "Old volume backed up as ${BACKUP_VOLUME}"

log "Recreating postgres volume..."
docker volume rm baseinfrastructure_postgres_storage
docker volume create --name baseinfrastructure_postgres_storage

log "Restoring data to PostgreSQL 17..."
docker run -d --name pg_restore \
  -v "${OLD_VOLUME}:/var/lib/postgresql/data" \
  -v "${BACKUP_DIRECTORY}:/backup" \
  -e POSTGRES_PASSWORD=password \
  -p 5433:5432 \
  postgis/postgis:17-master

log "Waiting for postgres to become ready..."
until docker exec pg_restore pg_isready -U postgres >/dev/null 2>&1; do
  sleep 1
done

# Wait some more, as postgis restarts during initialization at some point.
sleep 10

log "Restoring databases..."
docker exec -i pg_restore psql -U postgres -f /backup/globals.sql

for sql_file in "${BACKUP_DIRECTORY}"/*.sql; do
  db_name=$(basename "${sql_file}" .sql)

  # Skip system databases
  if [[ "${db_name}" == "postgres" || "${db_name}" == "template0" || "${db_name}" == "template1" ]]; then
    log "Skipping system database: ${db_name}"
    continue;
  fi

  log "Creating and restoring database: ${db_name}"

  docker exec -i pg_restore psql -U postgres -c "CREATE DATABASE \"${db_name}\";"
  docker exec -i pg_restore psql -U postgres -d "${db_name}" -c "CREATE EXTENSION IF NOT EXISTS postgis; CREATE EXTENSION IF NOT EXISTS postgis_topology;"
  docker exec -i pg_restore psql -U postgres -d "${db_name}" -f "/backup/${db_name}.sql"
  log "Restored database: ${db_name}"
done

log "All databases restored. Cleaning up..."
docker stop pg_restore
docker rm -f pg_restore >/dev/null 2>&1 || true

# We don't remove the backup directory in case of a calamity.

log "PostgreSQL upgrade completed successfully. Modify the docker-compose.yml to use postgis/postgis:17-master and start."
log "After postgres is running, re-apply user passwords by running: ./BaseInfrastructure/postgres/run-init-database.sh"
