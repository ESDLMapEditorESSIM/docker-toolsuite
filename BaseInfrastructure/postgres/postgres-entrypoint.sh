#!/bin/bash
set -e

# Start PostgreSQL in the background
docker-entrypoint.sh postgres &

# Wait for PostgreSQL to be ready
until pg_isready -U postgres; do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

echo "PostgreSQL started, running database initialization script..."

# Source the environment variables
export PGPASSWORD=$POSTGRES_PASSWORD

# Run the init script
bash /scripts/init-database.sh

# Keep the container running with the background postgres process
wait