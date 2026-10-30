#!/bin/bash
# Shared helpers for install scripts. Source this, don't run directly.

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Load an env file and optional dns/secrets files referenced within it.
load_env() {
  local env_file="$1"
  if [[ ! -f "$env_file" ]]; then
    echo "Env file not found: $env_file"; exit 1
  fi
  set -o allexport
  source "$env_file"
  [[ -n "${DNS_FILE:-}" && -f "$DNS_FILE" ]] && source "$DNS_FILE"
  set +o allexport
  [[ -n "${SECRETS_FILE:-}" && -f "$SECRETS_FILE" ]] && source "$SECRETS_FILE"
}

# Kubernetes services use the same public realm URL.
configure_idm() {
  : "${IDM_BASE_URL:?IDM_BASE_URL is required}"
  IDM_BASE_URL="${IDM_BASE_URL%/}"
  IDM_OIDC_PREFIX="${IDM_BASE_URL}/protocol/openid-connect"
}

# Read client settings on stdin, retaining credentials and application-specific fields.
oidc_client_secrets() {
  configure_idm
  jq --arg issuer "$IDM_BASE_URL" --arg prefix "$IDM_OIDC_PREFIX" '
    .web += {
      issuer: $issuer,
      auth_uri: ($prefix + "/auth"),
      token_uri: ($prefix + "/token"),
      userinfo_uri: ($prefix + "/userinfo"),
      token_introspection_uri: ($prefix + "/token/introspect")
    }
  '
}

# gen_sed <name> <template> <sed-args...>
gen_sed() {
  local name="$1" tmpl="$2"
  log "Applying $name"
  shift 2
  sed "$@" "$tmpl" | kubectl apply -n "${NAMESPACE}" -f -
}
