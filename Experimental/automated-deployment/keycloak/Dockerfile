FROM jboss/keycloak:11.0.0

USER root

COPY keycloak/esdl-mapeditor-realm.json /tmp/esdl-mapeditor-realm.json
COPY keycloak/init.sh /opt/jboss/startup-scripts/init.sh

RUN chown jboss:jboss /opt/jboss/startup-scripts/init.sh
RUN chmod +x /opt/jboss/startup-scripts/init.sh

USER jboss