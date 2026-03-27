#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing panel-service in $NAMESPACE"

if [[ -n "${CI_REGISTRY_USER_PANEL_SERVICE:-}" && -n "${CI_REGISTRY_PASS_PANEL_SERVICE:-}" ]]; then
  kubectl create secret docker-registry ciregistrykey-panel-service \
    --docker-server="${CI_REGISTRY_SERVER}" \
    --docker-username="${CI_REGISTRY_USER_PANEL_SERVICE}" \
    --docker-password="${CI_REGISTRY_PASS_PANEL_SERVICE}" \
    -n "${NAMESPACE}" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

gen_sed panel-service "$SCRIPT_DIR/panel-service/panel-service.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s/{{ ESSIM_DASHBOARD_DNS }}/${ESSIM_DASHBOARD_DNS}/g" \
  -e "s/{{ DOMAIN_EXTENSION }}/${DOMAIN_EXTENSION}/g"
