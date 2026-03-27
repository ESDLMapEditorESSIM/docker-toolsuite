#!/bin/bash
set -euo pipefail

# Install a CNPG PostGIS cluster for the mapeditor suite.
# Requires the CNPG operator to be installed first.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAMESPACE="${1:-cnpg}"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

SECRETS_FILE="$SCRIPT_DIR/secrets.sh"
if [[ ! -f "$SECRETS_FILE" ]]; then
  echo "Secrets file not found: $SECRETS_FILE"
  echo "Create it from the template: cp $SCRIPT_DIR/secrets.sh.template $SECRETS_FILE"
  exit 1
fi
source "$SECRETS_FILE"

log "Setting up CNPG cluster in namespace: $NAMESPACE"

kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic cnpg-superuser-secret \
  -n "${NAMESPACE}" \
  --from-literal=username=postgres \
  --from-literal=password="${POSTGRES_PASSWORD}" \
  --dry-run=client -o yaml | kubectl apply -f -

for role_secret in \
  "cnpg-role-keycloak:${POSTGRES_KEYCLOAK_PASSWORD}" \
  "cnpg-role-boundary-service:${POSTGRES_BOUNDARY_SERVICE_PASSWORD}" \
  "cnpg-role-drive:${POSTGRES_DRIVE_PASSWORD}" \
  "cnpg-role-data-manager:${POSTGRES_DATA_MANAGER_PASSWORD}" \
  "cnpg-role-essim:${POSTGRES_ESSIM_PASSWORD}" \
  "cnpg-role-mapeditor:${POSTGRES_MAPEDITOR_PASSWORD}"
do
  name="${role_secret%%:*}"
  pass="${role_secret##*:}"
  kubectl create secret generic "${name}" \
    -n "${NAMESPACE}" \
    --from-literal=password="${pass}" \
    --dry-run=client -o yaml | kubectl apply -f -
done

helm upgrade --install cnpg-cluster cloudnative-pg/cluster \
  -n "${NAMESPACE}" \
  -f "$SCRIPT_DIR/values.yaml"

log "CNPG cluster installed."
