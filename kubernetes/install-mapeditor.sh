#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"

log "Installing MapEditor in $NAMESPACE"

kubectl create secret generic mapeditor-secret \
  -n "${NAMESPACE}" \
  --from-literal=POSTGRES_MAPEDITOR_PASSWORD="$POSTGRES_MAPEDITOR_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

if [[ -n "${MAPEDITOR_CLIENT_SECRETS:-}" ]]; then
  kubectl create secret generic mapeditor-oidc-client \
    -n "${NAMESPACE}" \
    --from-literal=client_secrets_opensource.json="${MAPEDITOR_CLIENT_SECRETS}" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

if [[ -n "${RABBITMQ_PASSWORD:-}" ]]; then
  EXISTING_COOKIE=$(kubectl get secret rabbitmq-secret -n "${NAMESPACE}" \
    -o jsonpath='{.data.erlang-cookie}' 2>/dev/null | base64 -d || true)
  RABBITMQ_ERLANG_COOKIE="${RABBITMQ_ERLANG_COOKIE:-${EXISTING_COOKIE:-$(head -c 32 /dev/urandom | base64 | tr -d '/+=' | head -c 32)}}"

  kubectl create secret generic rabbitmq-secret \
    -n "${NAMESPACE}" \
    --from-literal=user="${RABBITMQ_USER:-user}" \
    --from-literal=password="${RABBITMQ_PASSWORD}" \
    --from-literal=erlang-cookie="${RABBITMQ_ERLANG_COOKIE}" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

if [[ -n "${CI_REGISTRY_SERVER:-}" && -n "${CI_REGISTRY_USER_MAPEDITOR:-}" && -n "${CI_REGISTRY_PASS_MAPEDITOR:-}" ]]; then
  kubectl create secret docker-registry ciregistrykey-mapeditor \
    --docker-server="${CI_REGISTRY_SERVER:-}" \
    --docker-username="${CI_REGISTRY_USER_MAPEDITOR}" \
    --docker-password="${CI_REGISTRY_PASS_MAPEDITOR}" \
    -n "${NAMESPACE}" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

helm upgrade --install esdl-mapeditor "$SCRIPT_DIR/esdl-mapeditor" \
  -n "${NAMESPACE}" \
  -f "${VALUES_DIR}/values.yaml"
