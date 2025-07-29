# Upgrading the toolsuite

In summer 2025 a mayor update has been done of the docker-toolsuite because some of the used components became outdated. 
Besides improved security for our end users that run this in production, also new functionality is added to some of the components.

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
Postgres/Postgis is updated from version 12 to 17. As each major version is incompatible with the previous version, a dump of the database is required.

This can be done as follows in the BaseInfrastructure folder:

1. Run
  `docker exec -it postgres pg_dumpall -U postgres > dump.sql`

  This creates a dump.sql that can be imported into the new version of postgres

2. Stop the old postgres container
3. Remove the old volume data: `docker volume rm baseinfrastructure_postgres_storage`
4. Update the docker-compose.yml to the newest version
5. Start the new postgres container: `docker compose up postgres -d`
6. Import the data:
  `docker exec -it postgres psql -U postgres < dump.sql`
7. Restart the container `docker compose restart postgres`

### Upgrading ESDLDrive

### Upgrading Keycloak



 
