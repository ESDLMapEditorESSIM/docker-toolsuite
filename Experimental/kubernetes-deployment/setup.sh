#!/bin/bash
BASEDIR=$(cd $(dirname $0) | pwd)

# Traefik
helm install -f $BASEDIR/traefik/traefik-values.yaml traefik traefik/traefik

# postgres
kubectl apply -f $BASEDIR/postgres/boundaries-persistentvolumeclaim.yaml
kubectl apply -f $BASEDIR/postgres/init-database-persistentvolumeclaim.yaml
kubectl apply -f $BASEDIR/postgres/postgres-storage-persistentvolumeclaim.yaml

sleep 1

kubectl apply -f $BASEDIR/postgres/postgres.yaml
POSTGRES=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep postgres)
PG_STATUS=0
while [ $PG_STATUS != "Running" ]
do
  sleep 10
  PG_STATUS=$(kubectl get pods --no-headers -o custom-columns=":status.phase, :metadata.name" | grep postgres | awk '{print $1;}')
done

sleep 3

kubectl cp $BASEDIR/postgres/data/boundaries $POSTGRES:/data/
sleep 1
kubectl cp $BASEDIR/postgres/data/Profiles $POSTGRES:/data/
sleep 1
kubectl cp $BASEDIR/postgres/init-database.sh $POSTGRES:/docker-entrypoint-initdb.d/
sleep 1
BACKUP=0

# # Keycloak and ESDL-Drive backups, comment out if not necessary ------------------------------- #
# BACKUP=1                                                                                        #
# KEYCLOAK_HASH=$(md5sum $BASEDIR/postgres/keycloak.sql | awk '{print $1}')                       #
# KEYCLOAK_HASH_REMOTE=0                                                                          #
# while [ $KEYCLOAK_HASH_REMOTE != $KEYCLOAK_HASH ]                                               #
# do                                                                                              #
#   kubectl cp $BASEDIR/postgres/keycloak.sql $POSTGRES:/                                         #
#   sleep 2                                                                                       #
#   KEYCLOAK_HASH_REMOTE=$(kubectl exec -it $POSTGRES md5sum /keycloak.sql | awk '{print $1}')    #
#   sleep 2                                                                                       #
# done                                                                                            #
#                                                                                                 #
# DRIVE_HASH=$(md5sum $BASEDIR/postgres/drive.sql | awk '{print $1}')                             #
# DRIVE_HASH_REMOTE=0                                                                             #
# while [ $DRIVE_HASH_REMOTE != $DRIVE_HASH ]                                                     #
# do                                                                                              #
#   kubectl cp $BASEDIR/postgres/drive.sql $POSTGRES:/                                            #
#   sleep 2                                                                                       #
#   DRIVE_HASH_REMOTE=$(kubectl exec -it $POSTGRES md5sum /drive.sql | awk '{print $1}')          #
#   sleep 2                                                                                       #
# done                                                                                            #
# # --------------------------------------------------------------------------------------------- #

sleep 3
kubectl exec $POSTGRES /docker-entrypoint-initdb.d/init-database.sh 

# influxdb
kubectl apply -f $BASEDIR/influxdb/influxdb-storage-persistentvolumeclaim.yaml
kubectl apply -f $BASEDIR/influxdb/influxdb.yaml

# mongo
kubectl apply -f $BASEDIR/mongo/mongo-storage-persistentvolumeclaim.yaml
kubectl apply -f $BASEDIR/mongo/mongo.yaml

# boundary-service
kubectl apply -f $BASEDIR/boundary-service/boundary-service.yaml

# nats
kubectl apply -f $BASEDIR/nats/nats.yaml

# keycloak
kubectl apply -f $BASEDIR/keycloak/keycloak-claim0-persistentvolumeclaim.yaml
kubectl apply -f $BASEDIR/keycloak/keycloak-config.yaml
kubectl apply -f $BASEDIR/keycloak/keycloak.yaml
KEYCLOAK=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep keycloak)
KEYCLOAK_STATUS=0
while [ $KEYCLOAK_STATUS != "Running" ]
do
  sleep 10
  KEYCLOAK_STATUS=$(kubectl get pods --no-headers -o custom-columns=":status.phase, :metadata.name" | grep keycloak | awk '{print $1;}')
done
kubectl cp $BASEDIR/keycloak/esdl-mapeditor-realm.json $KEYCLOAK:/tmp/
kubectl cp $BASEDIR/keycloak/init.sh $KEYCLOAK:/tmp/
# IF A BACKUP IS BEING IMPORTED, SKIP THE KEYCLOAK REALM INITIATION BY CREATING THE '/tmp/initialized' FOLDER (SEE REPO: /keycloak/init.sh)
if [ $BACKUP = 1 ]; then
  echo "BACKUP DETECTED"
  kubectl exec -it $KEYCLOAK touch /tmp/initialized
fi
kubectl exec -it $KEYCLOAK /tmp/init.sh

# cdo-server
kubectl apply -f $BASEDIR/cdo-server/cdo-server.yaml

# grafana
kubectl apply -f $BASEDIR/grafana/grafana-storage-persistentvolumeclaim.yaml
kubectl apply -f $BASEDIR/grafana/grafana.yaml
GRAFANA=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep grafana)
GRAFANA_STATUS=0
while [ $GRAFANA_STATUS != "Running" ]
do
  sleep 10
  GRAFANA_STATUS=$(kubectl get pods --no-headers -o custom-columns=":status.phase, :metadata.name" | grep grafana | awk '{print $1;}')
done

# panel-service
sleep 5
GRAFANA_API_KEY=$(curl --insecure -s -X POST -H "Content-Type: application/json" -d '{
  "name": "panel-service",
  "role": "Admin"
}' -u admin:admin https://dashboard.domain.tld/api/auth/keys | jq -r '.key')

echo "GRAFANA_API_KEY: $GRAFANA_API_KEY"
# Replace the API key in the file using sed
sed -i "s/GRAFANA_API_KEY:.*/GRAFANA_API_KEY: $GRAFANA_API_KEY/" $BASEDIR/panel-service/panel-service-panel-service-env-configmap.yaml

kubectl apply -f $BASEDIR/panel-service/panel-service-panel-service-env-configmap.yaml
kubectl apply -f $BASEDIR/panel-service/panel-service.yaml

# drive
kubectl apply -f $BASEDIR/esdl-drive/esdl-drive.yaml

# essim
kubectl apply -f $BASEDIR/essim/essim.yaml

# mapeditor
kubectl apply -f $BASEDIR/mapeditor/mapeditor-mapeditor-open-source-env-configmap.yaml
kubectl apply -f $BASEDIR/mapeditor/mapeditor-claim0-persistentvolumeclaim.yaml
kubectl apply -f $BASEDIR/mapeditor/mapeditor.yaml

### CREATE ADMIN USER IN KEYCLOAK
PROTOCOL=https
KEYCLOAK_DOMAIN=keycloak.domain.tld
KEYCLOAK_ADMIN_PASSWORD=admin
NAME="admin"

# Get access token
KEYCLOAK_TOKEN=$(curl -s --insecure --location --request POST "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/realms/master/protocol/openid-connect/token" \
--header "Content-Type: application/x-www-form-urlencoded" \
--data-urlencode "username=admin" \
--data-urlencode "password=$KEYCLOAK_ADMIN_PASSWORD" \
--data-urlencode "grant_type=password" \
--data-urlencode "client_id=admin-cli" | jq -r .access_token)

sleep 2

NEW_USER_USERNAME=$NAME
NEW_USER_FIRSTNAME=$NEW_USER_USERNAME
NEW_USER_LASTNAME=$NEW_USER_USERNAME
NEW_USER_EMAIL="$NEW_USER_USERNAME@mail.com"
NEW_USER_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
NEW_USER_ATTRIBUTE_ROLE=essim
ESSIM_ROLE_NAME=Admin
MAPEDITOR_ROLE_NAME=mapeditor-admin

# Create new user
curl -s --insecure --location --request POST "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" \
--data-raw "{\"firstName\":\"$NEW_USER_FIRSTNAME\",\"lastName\":\"$NEW_USER_LASTNAME\",\"email\":\"$NEW_USER_EMAIL\",\"enabled\":true,\"username\":\"$NEW_USER_USERNAME\",\"emailVerified\":true}"

sleep 2

# Get new user's ID
USER_ID=$(curl -s --insecure --location --request GET "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users?username=$NEW_USER_USERNAME" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" | jq -r .[0].id)

sleep 2

# Set new user password
curl -s --insecure --location --request PUT "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users/$USER_ID/reset-password" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" \
--data-raw "{\"type\":\"password\",\"value\":\"$NEW_USER_PASSWORD\",\"temporary\":false}"

sleep 2

# Add attribute to new user
curl -s --insecure --location --request PUT "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users/$USER_ID" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" \
--data-raw "{\"attributes\":{\"role\":\"$NEW_USER_ATTRIBUTE_ROLE\"}}"

sleep 2

# Get client ID ESSIM
ESSIM_CLIENT_ID=$(curl -s --insecure --location --request GET "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/clients?clientId=essim-dashboard" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" | jq -r '.[0].id')

sleep 2

# Get role ID ESSIM
ESSIM_ROLE_ID=$(curl -s --insecure --location --request GET "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/clients/$ESSIM_CLIENT_ID/roles" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" | jq -r --arg role "$ESSIM_ROLE_NAME" '.[] | select(.name == $role) | .id')

# Assign role to user ESSIM
curl -s --insecure --location --request POST "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users/$USER_ID/role-mappings/clients/$ESSIM_CLIENT_ID" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" \
--data-raw "[{\"id\":\"$ESSIM_ROLE_ID\",\"name\":\"$ESSIM_ROLE_NAME\",\"composite\":false}]"

sleep 2

# Get client ID mapeditor
MAPEDITOR_CLIENT_ID=$(curl -s --insecure --location --request GET "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/clients?clientId=esdl-mapeditor" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" | jq -r '.[0].id')

sleep 2

# Get role ID mapeditor
MAPEDITOR_ROLE_ID=$(curl -s --insecure --location --request GET "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/clients/$MAPEDITOR_CLIENT_ID/roles" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" | jq -r --arg role "$MAPEDITOR_ROLE_NAME" '.[] | select(.name == $role) | .id')

sleep 2

# Assign role to user mapeditor
curl -s --insecure --location --request POST "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users/$USER_ID/role-mappings/clients/$MAPEDITOR_CLIENT_ID" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $KEYCLOAK_TOKEN" \
--data-raw "[{\"id\":\"$MAPEDITOR_ROLE_ID\",\"name\":\"$MAPEDITOR_ROLE_NAME\",\"composite\":false}]"

echo "Mapeditor admin credentials:"
echo $NEW_USER_USERNAME
echo $NEW_USER_PASSWORD