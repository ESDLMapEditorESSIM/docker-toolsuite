#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_env "$1"
configure_idm

log "Installing ESSIM + Grafana in $NAMESPACE"

helm repo add grafana https://grafana.github.io/helm-charts 2>/dev/null
helm repo update

helm upgrade --install grafana \
  -n "${NAMESPACE}" \
  -f "${VALUES_DIR}/values-grafana.yaml" \
  --set-string env.GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET="${GRAFANA_OAUTH_CLIENT_SECRET:-}" \
  --set-string env.GF_AUTH_SIGNOUT_REDIRECT_URL="${IDM_OIDC_PREFIX}/logout" \
  --set-string env.GF_AUTH_GENERIC_OAUTH_AUTH_URL="${IDM_OIDC_PREFIX}/auth" \
  --set-string env.GF_AUTH_GENERIC_OAUTH_TOKEN_URL="${IDM_OIDC_PREFIX}/token" \
  --set-string env.GF_AUTH_GENERIC_OAUTH_API_URL="${IDM_OIDC_PREFIX}/userinfo" \
  grafana/grafana

if [[ -n "${CI_REGISTRY_SERVER:-}" && -n "${CI_REGISTRY_USER_ESSIM:-}" && -n "${CI_REGISTRY_PASS_ESSIM:-}" ]]; then
  kubectl create secret docker-registry ciregistrykey-essim \
    --docker-server="${CI_REGISTRY_SERVER:-}" \
    --docker-username="${CI_REGISTRY_USER_ESSIM}" \
    --docker-password="${CI_REGISTRY_PASS_ESSIM}" \
    -n "${NAMESPACE}" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

helm upgrade --install essim "$SCRIPT_DIR/essim" \
  -n "${NAMESPACE}" \
  -f "${VALUES_DIR}/values.yaml"
