# Reference deployment repo

Example of a thin deployment repo that points at `docker-toolsuite/kubernetes`.

The pattern:
- Keep environment config in the deployment repo
- Keep install scripts and charts in `docker-toolsuite/kubernetes`
- Call the install script directly with the environment file

Example command:

```bash
path/to/docker-toolsuite/kubernetes/install-mapeditor.sh envs/my-custom-mapeditor/.env
```

Or check the sample wrapper, which would be used as follows:

```bash
./sample-deploy.sh /path/to/docker-toolsuite
```
