#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing boundary-service in $NAMESPACE"

gen_sed boundary-service "$SCRIPT_DIR/boundary-service/boundary-service.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s/{{ POSTGRES_BOUNDARY_SERVICE_PASSWORD }}/${POSTGRES_BOUNDARY_SERVICE_PASSWORD}/g"
