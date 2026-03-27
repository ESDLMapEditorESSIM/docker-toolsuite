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

# gen_sed <name> <template> <sed-args...>
gen_sed() {
  local name="$1" tmpl="$2"
  log "Applying $name"
  shift 2
  sed "$@" "$tmpl" | kubectl apply -n "${NAMESPACE}" -f -
}
