#!/bin/bash
# Downloads boundary data from the docker-toolsuite GitHub repo and imports it
# into the boundaries database. Safe to re-run, skips already-imported tables.
set -e

GITHUB_BASE="https://raw.githubusercontent.com/ESDLMapEditorESSIM/docker-toolsuite/main/Data/Boundaries"
DATA_DIR="/data/boundaries"
PGHOST="${POSTGRES_HOST:-postgis}"
PGPORT="${POSTGRES_PORT:-5432}"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Downloading boundary data from GitHub..."
mkdir -p "$DATA_DIR"

files=(
  bu_wk_gm_es_pv_la.sql
  BUWKGMPVESLA.csv
  buurt_2019_wgs.shp buurt_2019_wgs.dbf buurt_2019_wgs.shx buurt_2019_wgs.prj buurt_2019_wgs.cpg
  wijk_2019_wgs.shp wijk_2019_wgs.dbf wijk_2019_wgs.shx wijk_2019_wgs.prj wijk_2019_wgs.cpg
  gem_2019_wgs.shp gem_2019_wgs.dbf gem_2019_wgs.shx gem_2019_wgs.prj gem_2019_wgs.cpg
  res_2019_wgs.shp res_2019_wgs.dbf res_2019_wgs.shx res_2019_wgs.prj res_2019_wgs.cpg
  prov_2019_wgs.shp prov_2019_wgs.dbf prov_2019_wgs.shx prov_2019_wgs.prj prov_2019_wgs.cpg
  land_2019_wgs.shp land_2019_wgs.dbf land_2019_wgs.shx land_2019_wgs.prj land_2019_wgs.cpg
)

for f in "${files[@]}"; do
  if [[ ! -f "$DATA_DIR/$f" ]]; then
    log "Downloading $f..."
    curl -fsSL "$GITHUB_BASE/$f" -o "$DATA_DIR/$f"
  fi
done

export PGPASSWORD="${POSTGRES_PASSWORD}"

log "Waiting for PostgreSQL to be ready..."
until pg_isready -h "$PGHOST" -p "$PGPORT" -U "$POSTGRES_USER"; do
  sleep 2
done

import_shapefile() {
  local shapefile=$1
  local table_name=$2
  local table_exists
  PGPASSWORD="${POSTGRES_BOUNDARY_SERVICE_PASSWORD}" \
  table_exists=$(psql -h "$PGHOST" -p "$PGPORT" -U boundary_service -d boundaries -t -c \
    "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '$table_name');")
  if [[ $table_exists =~ t ]]; then
    log "Table $table_name already exists, skipping"
  else
    log "Importing $shapefile..."
    shp2pgsql -s 4326 "$DATA_DIR/$shapefile.shp" "public.$table_name" | \
      PGPASSWORD="${POSTGRES_BOUNDARY_SERVICE_PASSWORD}" \
      psql -h "$PGHOST" -p "$PGPORT" -U boundary_service -d boundaries
  fi
}

log "Importing boundary SQL data..."
if ! psql -h "$PGHOST" -p "$PGPORT" -U "$POSTGRES_USER" -d boundaries -t -c \
  "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'bu_wk_gm_es_pv_la_2019');" | grep -q t; then
  psql -h "$PGHOST" -p "$PGPORT" -U "$POSTGRES_USER" -d boundaries -f "$DATA_DIR/bu_wk_gm_es_pv_la.sql"
else
  log "Boundary SQL data already imported, skipping"
fi

log "Importing shapefiles..."
import_shapefile "buurt_2019_wgs" "buurt_2019_wgs"
import_shapefile "wijk_2019_wgs" "wijk_2019_wgs"
import_shapefile "gem_2019_wgs" "gem_2019_wgs"
import_shapefile "res_2019_wgs" "res_2019_wgs"
import_shapefile "prov_2019_wgs" "prov_2019_wgs"
import_shapefile "land_2019_wgs" "land_2019_wgs"

log "Boundary data import complete."
