# Kubernetes deployment

Reusable install scripts and Helm charts for docker-toolsuite.

Use an install script with an environment file from a separate deployment repo:

```bash
/path/to/docker-toolsuite/kubernetes/install-mapeditor.sh /path/to/deployment-repo/envs/mapeditor-beta/.env
```

For a full deployment, the deployment repo can provide its own `deploy.sh` that calls the needed install scripts in order.

See `reference-deployment/` for a minimal example repo layout.

## Environment files

Each environment should provide:

- `.env` with `NAMESPACE`, `VALUES_DIR`, `SECRETS_FILE`
- `values.yaml` and optionally `values-grafana.yaml`
- `secrets.sh` with the needed passwords, tokens, and `MAPEDITOR_CLIENT_SECRETS`

Install scripts source `secrets.sh` locally. They do not read secrets back from the cluster.

## create-secrets.sh and dump-secrets.sh

These sync a local `secrets.sh` file to and from a `deploy-secrets` Kubernetes secret.
They are only there for convenience, so someone with cluster access can recover the local secrets file later.
