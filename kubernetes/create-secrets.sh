#!/bin/bash
# Push secrets from a secrets.sh file into the cluster as a Kubernetes Secret.
# Usage: ./create-secrets.sh <path/to/.env> <path/to/secrets.sh>
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <path/to/.env> <path/to/secrets.sh>"
  exit 1
fi

if [[ ! -f "$1" ]]; then echo "Env file not found: $1"; exit 1; fi
if [[ ! -f "$2" ]]; then echo "Secrets file not found: $2"; exit 1; fi

set -o allexport
source "$1"
set +o allexport
source "$2"

echo "Creating/updating deploy-secrets in namespace: ${NAMESPACE}"

kubectl create secret generic deploy-secrets \
  -n "${NAMESPACE}" \
  --from-literal=CI_REGISTRY_SERVER="${CI_REGISTRY_SERVER}" \
  --from-literal=CI_REGISTRY_USER_ESSIM="${CI_REGISTRY_USER_ESSIM:-}" \
  --from-literal=CI_REGISTRY_PASS_ESSIM="${CI_REGISTRY_PASS_ESSIM:-}" \
  --from-literal=CI_REGISTRY_USER_MAPEDITOR="${CI_REGISTRY_USER_MAPEDITOR:-}" \
  --from-literal=CI_REGISTRY_PASS_MAPEDITOR="${CI_REGISTRY_PASS_MAPEDITOR:-}" \
  --from-literal=CI_REGISTRY_USER_PANEL_SERVICE="${CI_REGISTRY_USER_PANEL_SERVICE:-}" \
  --from-literal=CI_REGISTRY_PASS_PANEL_SERVICE="${CI_REGISTRY_PASS_PANEL_SERVICE:-}" \
  --from-literal=CI_REGISTRY_USER_DRIVE="${CI_REGISTRY_USER_DRIVE:-}" \
  --from-literal=CI_REGISTRY_PASS_DRIVE="${CI_REGISTRY_PASS_DRIVE:-}" \
  --from-literal=POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-}" \
  --from-literal=POSTGRES_BOUNDARY_SERVICE_PASSWORD="${POSTGRES_BOUNDARY_SERVICE_PASSWORD:-}" \
  --from-literal=POSTGRES_DRIVE_PASSWORD="${POSTGRES_DRIVE_PASSWORD:-}" \
  --from-literal=POSTGRES_DATA_MANAGER_PASSWORD="${POSTGRES_DATA_MANAGER_PASSWORD:-}" \
  --from-literal=POSTGRES_ESSIM_PASSWORD="${POSTGRES_ESSIM_PASSWORD:-}" \
  --from-literal=POSTGRES_MAPEDITOR_PASSWORD="${POSTGRES_MAPEDITOR_PASSWORD:-}" \
  --from-literal=RABBITMQ_USER="${RABBITMQ_USER:-}" \
  --from-literal=RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-}" \
  --from-literal=RABBITMQ_ERLANG_COOKIE="${RABBITMQ_ERLANG_COOKIE:-}" \
  --from-literal=MAPEDITOR_CLIENT_SECRETS="${MAPEDITOR_CLIENT_SECRETS:-}" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Done."
