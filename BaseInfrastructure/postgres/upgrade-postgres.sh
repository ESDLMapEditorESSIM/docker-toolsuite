#!/bin/bash
#====================================================================================
# Upgrade PostgreSQL from version 12 to 13.
# Run this script from the root, where the main docker-compose is located.
# Make sure postgres in the docker-compose is running before executing this script.
# If you have sensitive data, only run the backup part first to verify you have a
# proper backup.
#====================================================================================
set -euo pipefail

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Starting PostgreSQL upgrade from 12 to 13. Make sure postgres 12 is running."

mkdir -p ./pg_backup

BACKUP_DATE=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="./pg_backup/full_backup_${BACKUP_DATE}.sql"

# Create a backup of data from the running container.
log "Creating backup of PostgreSQL 12 data..."
docker exec esdl-toolsuite_postgres pg_dumpall -U postgres > "${BACKUP_FILE}"

read -p "Backup saved at ${BACKUP_FILE}. Do you want to continue with the upgrade? (y/n): " choice
case "$choice" in
  y|Y ) log "Continuing with upgrade process...";;
  * ) log "Upgrade aborted. Backup is available at ${BACKUP_FILE}"; exit 0;;
esac

log "Stopping all containers..."
docker-compose down

log "Recreating PostgreSQL volume..."
docker volume rm baseinfrastructure_postgres_storage
docker volume create --name baseinfrastructure_postgres_storage

log "Restoring data to PostgreSQL 13..."
docker run --name pg_restore \
  -v baseinfrastructure_postgres_storage:/var/lib/postgresql/data \
  -v ./pg_backup:/backup \
  -v $(pwd)/BaseInfrastructure/postgres/init-database.sh:/scripts/init-database.sh \
  -v $(pwd)/Data/Boundaries:/data/boundaries \
  -e POSTGRES_PASSWORD=password \
  postgis/postgis:13-master \
  bash -c "docker-entrypoint.sh postgres & \
           sleep 10 && \
           psql -U postgres -f /backup/full_backup_${BACKUP_DATE}.sql && \
           sleep 5"

# Clean up
docker rm pg_restore

# We don't remove the backup directory in case of a calamity.

log "PostgreSQL upgrade completed successfully. Modify the docker-compose.yml to use postgis/postgis:13-master and start."