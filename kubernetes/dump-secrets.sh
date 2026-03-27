#!/bin/bash
# Dump the deploy-secrets Secret from the cluster into a local secrets.sh file.
# Usage: ./dump-secrets.sh <path/to/.env> <output/secrets.sh>
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <path/to/.env> <output/secrets.sh>"
  exit 1
fi

if [[ ! -f "$1" ]]; then echo "Env file not found: $1"; exit 1; fi

set -o allexport
source "$1"
set +o allexport

OUTPUT="$2"

decode() {
  kubectl get secret deploy-secrets -n "${NAMESPACE}" \
    -o jsonpath="{.data.$1}" 2>/dev/null | base64 -d
}

cat > "$OUTPUT" << EOF
#!/usr/bin/env bash
# $(basename "$OUTPUT") - do not commit, share out-of-band

export CI_REGISTRY_SERVER="$(decode CI_REGISTRY_SERVER)"
export CI_REGISTRY_USER_ESSIM="$(decode CI_REGISTRY_USER_ESSIM)"
export CI_REGISTRY_PASS_ESSIM="$(decode CI_REGISTRY_PASS_ESSIM)"
export CI_REGISTRY_USER_MAPEDITOR="$(decode CI_REGISTRY_USER_MAPEDITOR)"
export CI_REGISTRY_PASS_MAPEDITOR="$(decode CI_REGISTRY_PASS_MAPEDITOR)"
export CI_REGISTRY_USER_PANEL_SERVICE="$(decode CI_REGISTRY_USER_PANEL_SERVICE)"
export CI_REGISTRY_PASS_PANEL_SERVICE="$(decode CI_REGISTRY_PASS_PANEL_SERVICE)"
export CI_REGISTRY_USER_DRIVE="$(decode CI_REGISTRY_USER_DRIVE)"
export CI_REGISTRY_PASS_DRIVE="$(decode CI_REGISTRY_PASS_DRIVE)"

export POSTGRES_PASSWORD="$(decode POSTGRES_PASSWORD)"
export POSTGRES_BOUNDARY_SERVICE_PASSWORD="$(decode POSTGRES_BOUNDARY_SERVICE_PASSWORD)"
export POSTGRES_DRIVE_PASSWORD="$(decode POSTGRES_DRIVE_PASSWORD)"
export POSTGRES_DATA_MANAGER_PASSWORD="$(decode POSTGRES_DATA_MANAGER_PASSWORD)"
export POSTGRES_ESSIM_PASSWORD="$(decode POSTGRES_ESSIM_PASSWORD)"
export POSTGRES_MAPEDITOR_PASSWORD="$(decode POSTGRES_MAPEDITOR_PASSWORD)"

export RABBITMQ_USER="$(decode RABBITMQ_USER)"
export RABBITMQ_PASSWORD="$(decode RABBITMQ_PASSWORD)"
export RABBITMQ_ERLANG_COOKIE="$(decode RABBITMQ_ERLANG_COOKIE)"

read -r -d '' MAPEDITOR_CLIENT_SECRETS << 'ENDSECRET' || true
$(decode MAPEDITOR_CLIENT_SECRETS)
ENDSECRET
export MAPEDITOR_CLIENT_SECRETS
EOF

chmod 600 "$OUTPUT"
echo "Written to $OUTPUT"
