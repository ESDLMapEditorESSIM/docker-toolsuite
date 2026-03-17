# Upgrading the toolsuite

In early 2026 a major update has been done of the docker-toolsuite because some of the used components became outdated.
Besides improved security for our end users that run this in production, also new functionality is added to some of the
components.

Unfortunately, this means that upgrading to this new version of the toolsuite cannot be done automatically. Some steps, 
specifically databases, require manual backup and restore to make the transition.

If you don't have important data stored in the toolsuite databases, our advice is to throw away this data and start from scratch. 
If you do have data you want to migrate, read further to find out what steps are required to migrate. 

## Summary of the changes:

The following components have been affected:
- Keycloak Identity and Authorization management: upgraded to latest version. 
- ESDL MapEditor: lots of new features, new security implementation
- Postgres/Postgis: move to latest version
- ESSIM: new version of ESSIM with new features, improved kpi modules and many bugfixes
- ESDL Drive: new features and bugfixes
- Mongo document database: move to latest version

## Restart from scratch

1. Bring the containers down by issuing `docker compose down` in `ESDLDrive`, `ESDLMapEditor`, `ESSIM` and `BaseInfrastructure` folders.
2. Remove the postgres volume by:
   `docker volume rm baseinfrastructure_postgres_storage`
   Note: other volumes may also be removed, but not strictly necessary. If this appoach does not work, 
3. Pull this repository to update the docker-compose.yml files
4. Do a `docker compose up -d` in the `BaseInfrastructure` folder and check the logs (`docker compose logs -f`) if everything works. 
   If so, start the other containers again.
   

## Upgrading

### Upgrading postgres/postgis

Postgres/Postgis is updated from version 12 to 17. As each major version is incompatible with the previous version, a
dump of the database is required.

The recommended way to upgrade is to use the script that is included in this repository:
`BaseInfrastructure/postgres/upgrade-postgres.sh`.

Important: the script needs to be able to start your *old* postgres container first (so it can take dumps).
So do not switch the postgres image to version 17 before running the script. If you already updated your
checkout and `docker-compose.yml` is pointing at Postgres 17, temporarily switch the `postgres.image` back
to the old version you were running, run the script, and only then update to the new version.

From the repository root (where the main `docker-compose.yml` is located), run:

1. `./BaseInfrastructure/postgres/upgrade-postgres.sh`

Note: the script currently uses the `docker-compose` command. If your system only has `docker compose`
(Docker Compose v2), install `docker-compose` or adjust the script accordingly.

The script will:
- stop all containers and start only `postgres`
- create backups in `pg_backup/backups_YYYYMMDD_HHMMSS/`
- create a copy of the old volume as `baseinfrastructure_postgres_storage_backup_YYYYMMDD_HHMMSS`
- recreate the `baseinfrastructure_postgres_storage` volume and restore the data into Postgres/PostGIS 17

After the script completes:

1. Ensure your `docker-compose.yml` uses `postgis/postgis:17-master` for the `postgres` service.
2. Start your stack again (for example: `docker compose up -d`).
3. Re-apply database users/passwords/grants by running:
   `./BaseInfrastructure/postgres/run-init-database.sh`

Rollback note:
If you need to revert to the old data volume, the script leaves a volume backup behind
(`baseinfrastructure_postgres_storage_backup_...`). You can copy that volume back into
`baseinfrastructure_postgres_storage` using a simple `alpine` copy container (see the comment in
`BaseInfrastructure/postgres/upgrade-postgres.sh`).

### Upgrading ESDLDrive

### Upgrading Keycloak



 
