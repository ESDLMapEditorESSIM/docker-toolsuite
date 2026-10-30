#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"
configure_idm

log "Installing ESDL Drive + CDO server in $NAMESPACE"

if [[ -n "${CI_REGISTRY_SERVER:-}" && -n "${CI_REGISTRY_USER_DRIVE:-}" && -n "${CI_REGISTRY_PASS_DRIVE:-}" ]]; then
  kubectl create secret docker-registry ciregistrykey-drive \
    --docker-server="${CI_REGISTRY_SERVER:-}" \
    --docker-username="${CI_REGISTRY_USER_DRIVE}" \
    --docker-password="${CI_REGISTRY_PASS_DRIVE}" \
    -n "${NAMESPACE}" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

: "${POSTGRES_DRIVE_PASSWORD:?POSTGRES_DRIVE_PASSWORD is required}"
: "${ESDL_DRIVE_KEYCLOAK_CLIENT_SECRET:?ESDL_DRIVE_KEYCLOAK_CLIENT_SECRET is required}"
kubectl create secret generic esdl-drive-secrets \
  --namespace "$NAMESPACE" \
  --from-literal=POSTGRESQL_PASSWORD="$POSTGRES_DRIVE_PASSWORD" \
  --from-literal=KEYCLOAK_CLIENT_SECRET="$ESDL_DRIVE_KEYCLOAK_CLIENT_SECRET" \
  --dry-run=client -o yaml | kubectl apply -f -

gen_sed cdo-server "$SCRIPT_DIR/esdl-drive/cdo-server.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g"

gen_sed esdl-drive "$SCRIPT_DIR/esdl-drive/esdl-drive.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s#{{ IDM_BASE_URL }}#${IDM_BASE_URL}#g"
