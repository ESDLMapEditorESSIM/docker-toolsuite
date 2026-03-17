#!/bin/bash
#====================================================================================
# Manually run the init-database script inside the postgres container.
# Run this script from the root, where the main docker-compose is located.
#====================================================================================
set -euo pipefail

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

if [[ ! -f "docker-compose.yml" ]]; then
  echo "Please run this script from the root directory of the repository."
  exit 1
fi

log "Ensuring postgres container is running..."
if ! docker-compose ps -q postgres | grep -q .; then
  docker-compose up -d postgres
fi

log "Running init-database.sh inside the postgres container..."
docker-compose exec -T postgres bash /docker-entrypoint-initdb.d/init-database.sh

log "init-database.sh completed."
