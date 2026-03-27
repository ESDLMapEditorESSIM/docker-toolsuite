#!/bin/bash
# Usage: ./sample-deploy.sh <path-to-docker-toolsuite>
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 <path-to-docker-toolsuite>"
  exit 1
fi

"$1/kubernetes/install-mapeditor.sh" envs/my-custom-mapeditor/.env
