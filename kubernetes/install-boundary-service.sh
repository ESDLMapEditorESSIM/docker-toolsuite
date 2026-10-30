#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing boundary-service in $NAMESPACE"

if [[ -n "${POSTGRES_BOUNDARY_SERVICE_PASSWORD:-}" ]]; then
  kubectl create secret generic boundaryservice-postgres \
    --namespace "$NAMESPACE" \
    --from-literal=POSTGRES_PASSWORD="$POSTGRES_BOUNDARY_SERVICE_PASSWORD" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

helm upgrade --install boundary-service "$SCRIPT_DIR/boundary-service" \
  -n "$NAMESPACE" \
  -f "$VALUES_DIR/values.yaml" \
  --wait
