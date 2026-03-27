#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing RabbitMQ in $NAMESPACE"

# Auto-generate Erlang cookie if not set
RABBITMQ_ERLANG_COOKIE="${RABBITMQ_ERLANG_COOKIE:-$(head -c 32 /dev/urandom | base64 | tr -d '/+=' | head -c 32)}"

# Reuse existing secret if present (preserves the Erlang cookie across upgrades)
EXISTING_COOKIE=$(kubectl get secret rabbitmq-secret -n "${NAMESPACE}" \
  -o jsonpath='{.data.erlang-cookie}' 2>/dev/null | base64 -d || true)
if [[ -n "$EXISTING_COOKIE" ]]; then
  RABBITMQ_ERLANG_COOKIE="$EXISTING_COOKIE"
fi

kubectl create secret generic rabbitmq-secret \
  -n "${NAMESPACE}" \
  --from-literal=user="${RABBITMQ_USER:-user}" \
  --from-literal=password="${RABBITMQ_PASSWORD}" \
  --from-literal=erlang-cookie="${RABBITMQ_ERLANG_COOKIE}" \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install rabbitmq \
  -n "${NAMESPACE}" \
  -f "$SCRIPT_DIR/rabbitmq/values.yaml" \
  oci://registry-1.docker.io/cloudpirates/rabbitmq
