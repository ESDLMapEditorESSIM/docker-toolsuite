# Configuring Keycloak for the whole system

## Importing the ESDL-mapeditor realm
Bring the base-infrastructure up (docker-compose up)
Copy the config file:

```
docker cp keycloak/esdl-mapeditor-realm.json keycloak:/tmp/esdl-mapeditor-realm.json
```

Run the import:
```
docker exec -it keycloak /opt/jboss/keycloak/bin/standalone.sh \
	-Djboss.socket.binding.port-offset=100 \
	-Dkeycloak.profile.feature.upload_scripts=enabled
	-Dkeycloak.migration.action=import \
	-Dkeycloak.migration.provider=singleFile \
	-Dkeycloak.migration.strategy=OVERWRITE_EXISTING \
	-Dkeycloak.migration.file=/tmp/esdl-mapeditor-realm.json
```
And press Ctrl-C when the server has successfully started and you see this:
```
09:11:37,905 INFO  [org.keycloak.services] (ServerService Thread Pool -- 57) KC-SERVICES0030: Full model import requested. Strategy: OVERWRITE_EXISTING
09:11:37,906 INFO  [org.keycloak.exportimport.singlefile.SingleFileImportProvider] (ServerService Thread Pool -- 57) Full importing from file /tmp/esdl-mapeditor-realm.json
09:11:42,318 INFO  [org.keycloak.exportimport.util.ImportUtils] (ServerService Thread Pool -- 57) Realm 'esdl-mapeditor' imported
09:11:42,386 INFO  [org.keycloak.services] (ServerService Thread Pool -- 57) KC-SERVICES0032: Import finished successfully
...
09:11:42,913 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0025: Keycloak 10.0.2 (WildFly Core 11.1.1.Final) started in 24772ms - Started 592 of 890 services (606 services are lazy, passive or on-demand)
```


### Configure and Add users
Login with the admin account (username = admin), password is in the docker-compose.yml file) and change the admin password!
- Go to Master realm -> Users -> select admin and update credentials.

Add groups to the esdl-mapeditor Realm.
- Go to esdl-mapeditor realm -> Groups 
- Add the Project group and create for each project its own group. These groups are then found in the ESDLDrive in the mapeditor.

Add users to the esdl-mapeditor Realm.
- Go to esdl-mapeditor realm -> Users
- Create users
- Add them to the right project groups.




## Exporting (for updates of the realm)
Start the base-infrastructure
Run:
```
docker exec -it keycloak /opt/jboss/keycloak/bin/standalone.sh \
	-Djboss.socket.binding.port-offset=100 \
	-Dkeycloak.migration.action=export \
	-Dkeycloak.migration.provider=singleFile \
	-Dkeycloak.migration.realmName=esdl-mapeditor \
	-Dkeycloak.migration.usersExportStrategy=SKIP \
	-Dkeycloak.migration.file=/tmp/esdl-mapeditor-realm.json
```
Press Ctrl-C after it says it successfully started.
Now it saved the export of the whole realm including secrets into /tmp/esdl-mapeditor-realm.json

Copy it out of the container with:
```
docker cp keycloak:/tmp/esdl-mapeditor-realm.json keycloak/esdl-mapeditor-realm.json
```

See the keycloak administration guide if you also want to export users and more.



# Files affected when changing hosts
Mapeditor:
- settings.py -> configure settingsStorage, userLogging and CDO
- credentials/client_secrets_opensource.json
  - check the client-secret, it may have changed if keycloak is redeployed without an import of the realm
  - check host names of keycloak: 
    - issuer and auth_uri should point to the public address (localhost) (this is the browser facing address)
	- token_uri, token_introspection_uri, userinfo_uri should point to the internal docker address (keycloak),
      if it is not deployed on a public accessible IP adress.
	  Otherwise wants to connect to localhost:8080, which is the mapeditor docker container instead 
	  of the keycloak docker container but that is the external address
  - check redirect url, this should match the *external* url accessible by the browser



## Option 2 (depricated now, as Option 1 is better)
This option copies everything except all secrets.

- Login to the keycloak container `docker exec -it keycloak /bin/bash`
- go to the keycloak bin folder (/opt/jboss/keycloak)
- Login to the realm as admin:
```
$ ./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin
```

Get the esdl-mapeditor realm settings:
```
./kcadm.sh get realms/esdl-mapeditor > /tmp/esdl-mapeditor-realm.json
```

Get the clients:
```
./kcadm.sh get clients -r esdl-mapeditor > /tmp/all-esdl-mapeditor-clients.json
```


Add realm:
```
./kcadm.sh create realms -f /tmp/config/esdl-mapeditor-realm.json
```


add clients (for each json):
```
./kcadm.sh create clients -r esdl-mapeditor -f /tmp/config/esdl-mapeditor-client.json
```

