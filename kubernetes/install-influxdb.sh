#!/bin/bash
# InfluxDB 1.7 - legacy, will be phased out.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing InfluxDB in $NAMESPACE"

helm upgrade --install influxdb "$SCRIPT_DIR/influxdb" \
  -n "$NAMESPACE" \
  -f "$VALUES_DIR/values.yaml" \
  --wait
