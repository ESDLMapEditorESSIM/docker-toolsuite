#!/bin/sh
# Manual helper script to configure the Grafana API key for panel-service.
# Run this from the host machine (not inside a container) after Grafana is running.
# Note: The docker-compose.yml uses panel-service-init container for automated setup.
. ./panel_service.env
if [ -z $GRAFANA_API_KEY ] || [ "$GRAFANA_API_KEY" = "null" ] ; then
  GRAFANA_API_KEY=$(curl --insecure -s -X POST -H "Content-Type: application/json" -d '{
  "name": "panel-service",
  "role": "Admin"
}' -u admin:admin http://localhost:3000/api/auth/keys | jq -r '.key')
   if [ "$GRAFANA_API_KEY" = "null" ] ; then
        echo $GRAFANA_API_KEY
        echo "Failed to get API KEY"
        exit 1
   fi

   echo "GRAFANA_API_KEY configured in panel_service.env to: $GRAFANA_API_KEY"
   echo "GRAFANA_API_KEY=$GRAFANA_API_KEY" > panel_service.env
else
   echo "GRAFANA_API_KEY already configured in panel_service.env"
fi
