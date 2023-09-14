source ./.env
docker build --build-arg CADDY_VERSION=${CADDY_VERSION} -t esdlmapeditoressim/caddy-with-geoip:${CADDY_VERSION} caddy/
docker push esdlmapeditoressim/caddy-with-geoip:${CADDY_VERSION}
