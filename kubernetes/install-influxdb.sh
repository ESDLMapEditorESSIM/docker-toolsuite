#!/bin/bash
# InfluxDB 1.7 - legacy, will be phased out.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing InfluxDB in $NAMESPACE"

gen_sed influxdb "$SCRIPT_DIR/influxdb/influxdb.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s/{{ DOMAIN_EXTENSION }}/${DOMAIN_EXTENSION}/g" \
  -e "s/{{ INFLUXDB_DNS }}/${INFLUXDB_DNS}/g"
