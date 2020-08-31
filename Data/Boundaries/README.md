# Data for the Boundary Service

One of the auxiliary services of the ESDL MapEditor is the BoundaryService. It provides geometry information of specific areas in cases where an ESDL file contains a specific reference to an area (using CBS standardized IDs for area coding) and prevents ESDL-files to contain this geometry information itself. 

The data provided here is based on open data from the Dutch CBS and the Kadaster. The basis of this data is the geometry information of the neighbourhoods and the mapping of neighbourhoods to districts, municipalities, RES regions, provinces and the country (provided in `BUWKGMPVESLA.csv`). The CBS shapefile for neighbourhoods was simplified using an online tool called [MapShaper](https://mapshaper.org/), to speed up the process of communicating this information (the detailed geometry is not required for most purposes). The rest of the shapefiles were generated using QGIS and the mapping provided in the csv file.

This data must be uploaded in the PostGIS database such that the BoundaryService can use it. Create a database with name `boundaries` (using psql or PGAdmin). Create a `postgis` extension for this database. Then execute the following commands:

```
shp2pgsql -s 4326 buurt_2019_wgs.shp public.buurt_2019_wgs | psql -h localhost -d boundaries -U xxx
shp2pgsql -s 4326 wijk_2019_wgs.shp public.wijk_2019_wgs | psql -h localhost -d boundaries -U xxx
shp2pgsql -s 4326 gem_2019_wgs.shp public.gem_2019_wgs | psql -h localhost -d boundaries -U xxx
shp2pgsql -s 4326 res_2019_wgs.shp public.res_2019_wgs | psql -h localhost -d boundaries -U xxx
shp2pgsql -s 4326 prov_2019_wgs.shp public.prov_2019_wgs | psql -h localhost -d boundaries -U xxx
shp2pgsql -s 4326 land_2019_wgs.shp public.land_2019_wgs | psql -h localhost -d boundaries -U xxx
```


```
psql -h localhost -d boundaries -f bu_wk_gm_es_pv_la.sql -U xxx
```

## Links
[CBS source data](https://www.cbs.nl/nl-nl/dossier/nederland-regionaal/geografische-data/wijk-en-buurtkaart-2019)
