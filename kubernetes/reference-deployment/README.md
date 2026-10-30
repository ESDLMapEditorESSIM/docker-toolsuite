# Reference deployment repo

Example of a thin deployment repo that points at `docker-toolsuite/kubernetes`.

Requires Traefik, cert-manager, a `letsencrypt-prod` ClusterIssuer, and existing namespace, backend services and secrets.

The pattern:
- Keep environment config in the deployment repo
- Keep install scripts and charts in `docker-toolsuite/kubernetes`
- Call the install script directly with the environment file

Copy `.env.example` to `.env`, adjust the environment files, then run an install script:

```bash
cp envs/my-custom-mapeditor/.env.example envs/my-custom-mapeditor/.env
path/to/docker-toolsuite/kubernetes/install-mapeditor.sh envs/my-custom-mapeditor/.env
```

Or check the sample wrapper, which would be used as follows:

```bash
./sample-deploy.sh /path/to/docker-toolsuite
```
