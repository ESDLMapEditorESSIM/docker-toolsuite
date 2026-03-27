#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing MongoDB in $NAMESPACE"
helm upgrade --install mongodb "$SCRIPT_DIR/mongodb" \
  -n "${NAMESPACE}" --create-namespace \
  -f "${VALUES_DIR}/values.yaml"
