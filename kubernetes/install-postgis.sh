#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing PostGIS in $NAMESPACE"

kubectl create configmap postgis-initdb \
  --namespace="${NAMESPACE}" \
  --from-file "$SCRIPT_DIR/../BaseInfrastructure/postgres/init-database.sh" \
  --dry-run=client -o yaml | kubectl apply -f -

gen_sed postgis "$SCRIPT_DIR/postgis/postgis.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s/{{ POSTGRES_PASSWORD }}/${POSTGRES_PASSWORD}/g" \
  -e "s/{{ POSTGRES_BOUNDARY_SERVICE_PASSWORD }}/${POSTGRES_BOUNDARY_SERVICE_PASSWORD:-}/g" \
  -e "s/{{ POSTGRES_DRIVE_PASSWORD }}/${POSTGRES_DRIVE_PASSWORD:-}/g" \
  -e "s/{{ POSTGRES_DATA_MANAGER_PASSWORD }}/${POSTGRES_DATA_MANAGER_PASSWORD:-}/g" \
  -e "s/{{ POSTGRES_ESSIM_PASSWORD }}/${POSTGRES_ESSIM_PASSWORD:-}/g"
