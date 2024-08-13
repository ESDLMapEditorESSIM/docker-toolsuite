#!/bin/sh
if [ ! -f /tmp/initialized ]; then
  echo -e "LOADING ESDL-MAPEDITOR REALM"
  touch /tmp/initialized

  timeout --signal=SIGINT 75 /opt/jboss/keycloak/bin/standalone.sh \
  -Djboss.socket.binding.port-offset=100 \
  -Dkeycloak.profile.feature.upload_scripts=enabled \
  -Dkeycloak.migration.action=import \
  -Dkeycloak.migration.provider=singleFile \
  -Dkeycloak.migration.strategy=OVERWRITE_EXISTING \
  -Dkeycloak.migration.file=/tmp/esdl-mapeditor-realm.json \
  || true
  
  echo -e "ESDL-MAPEDITOR LOADED SUCCESSFULLY, RESTARTING..."
fi