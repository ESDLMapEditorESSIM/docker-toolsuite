#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing ESDL Drive + CDO server in $NAMESPACE"

if [[ -n "${CI_REGISTRY_SERVER:-}" && -n "${CI_REGISTRY_USER_DRIVE:-}" && -n "${CI_REGISTRY_PASS_DRIVE:-}" ]]; then
  kubectl create secret docker-registry ciregistrykey-drive \
    --docker-server="${CI_REGISTRY_SERVER:-}" \
    --docker-username="${CI_REGISTRY_USER_DRIVE}" \
    --docker-password="${CI_REGISTRY_PASS_DRIVE}" \
    -n "${NAMESPACE}" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

gen_sed cdo-server "$SCRIPT_DIR/esdl-drive/cdo-server.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s/{{ POSTGRES_DRIVE_PASSWORD }}/${POSTGRES_DRIVE_PASSWORD}/g"

gen_sed esdl-drive "$SCRIPT_DIR/esdl-drive/esdl-drive.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s/{{ ESDL_DRIVE_KEYCLOAK_CLIENT_SECRET }}/${ESDL_DRIVE_KEYCLOAK_CLIENT_SECRET}/g" \
  -e "s/{{ KEYCLOAK_DNS }}/${KEYCLOAK_DNS:-idm}/g" \
  -e "s/{{ KEYCLOAK_REALM }}/${IDM_REALM}/g" \
  -e "s/{{ DOMAIN_EXTENSION }}/${DOMAIN_EXTENSION}/g"

gen_sed esdl-drive-ingress "$SCRIPT_DIR/esdl-drive/ingress.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s/{{ DRIVE_DNS }}/${DRIVE_DNS:-drive}/g" \
  -e "s/{{ DOMAIN_EXTENSION }}/${DOMAIN_EXTENSION}/g"
