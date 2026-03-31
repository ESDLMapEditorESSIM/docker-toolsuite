#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

POSTGIS_IMAGE_TAG="${POSTGIS_IMAGE_TAG:-17-master}"
POSTGRES_HOST="${POSTGRES_HOST:-postgis}"

log "Installing boundary data import job in $NAMESPACE"

kubectl create configmap boundary-data-import-script \
  --namespace="${NAMESPACE}" \
  --from-file="$SCRIPT_DIR/boundary-data/import-boundary-data.sh" \
  --dry-run=client -o yaml | kubectl apply -f -

# Delete any previous completed/failed job before re-applying
kubectl delete job import-boundary-data -n "${NAMESPACE}" --ignore-not-found

gen_sed import-boundary-data "$SCRIPT_DIR/boundary-data/import-job.yaml.tmpl" \
  -e "s/{{ NAMESPACE }}/${NAMESPACE}/g" \
  -e "s/{{ POSTGIS_IMAGE_TAG }}/${POSTGIS_IMAGE_TAG}/g" \
  -e "s/{{ POSTGRES_HOST }}/${POSTGRES_HOST}/g"
