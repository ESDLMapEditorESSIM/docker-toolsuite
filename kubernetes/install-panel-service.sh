#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing panel-service in $NAMESPACE"

if [[ -n "${CI_REGISTRY_SERVER:-}" && -n "${CI_REGISTRY_USER_PANEL_SERVICE:-}" && -n "${CI_REGISTRY_PASS_PANEL_SERVICE:-}" ]]; then
  kubectl create secret docker-registry ciregistrykey-panel-service \
    --docker-server="${CI_REGISTRY_SERVER:-}" \
    --docker-username="${CI_REGISTRY_USER_PANEL_SERVICE}" \
    --docker-password="${CI_REGISTRY_PASS_PANEL_SERVICE}" \
    -n "${NAMESPACE}" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

helm upgrade --install panel-service "$SCRIPT_DIR/panel-service" \
  -n "$NAMESPACE" \
  -f "$VALUES_DIR/values.yaml" \
  --wait
