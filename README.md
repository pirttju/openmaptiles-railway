## OpenMapTiles-Railway

OpenMapTiles-Railway is a fork of OpenMapTiles focusing on railways.

## Railway Layers

The [OpenMapTiles Schema](https://openmaptiles.org/schema/) is extended with three railway related layers:

### railway

Railway contains railway lines. At lower zoom levels only lines with usage=main are shown.

### railway_poi

Railway Points of interests containing stations, halts, tram stops, junctions, yards, level crossings, buffer stops, switches and assorted railway amenities.

### signals

Signals containing anything tagged as railway=signal.

## Develop

To work on OpenMapTiles you need Docker.

- Install [Docker](https://docs.docker.com/engine/installation/). Minimum version is 1.12.3+.
- Install [Docker Compose](https://docs.docker.com/compose/install/). Minimum version is 1.7.1+.

### Build

Build the tileset.

```bash
git clone https://github.com/openmaptiles/openmaptiles.git
cd openmaptiles
# Build the imposm mapping, the tm2source project and collect all SQL scripts
make
```

You can execute the following manual steps (for better understanding)
or use the provided `quickstart.sh` script to automatically download and import given area. If area is not given, finland will be imported.

```
./quickstart.sh <area>
```

### Prepare the Database

Now start up the database container.

```bash
make start-db
```

Import external data from [OpenStreetMapData](http://osmdata.openstreetmap.de/), [Natural Earth](http://www.naturalearthdata.com/) and [OpenStreetMap Lake Labels](https://github.com/lukasmartinelli/osm-lakelines).

```bash
make import-data
```

Download OpenStreetMap data extracts from any source like [Geofabrik](http://download.geofabrik.de/), and store the PBF file in the `./data` directory. To use a specific download source, use `download-geofabrik`, `download-bbbike`, or `download-osmfr`, or use `download` to make it auto-pick the area. You can use `area=planet` for the entire OSM dataset (very large).  Note that if you have more than one `data/*.osm.pbf` file, every `make` command will always require `area=...` parameter (or you can just `export area=...` first).

```bash
make download area=finland
```

[Import OpenStreetMap data](https://github.com/openmaptiles/openmaptiles-tools/tree/master/docker/import-osm) with the mapping rules from
`build/mapping.yaml` (which has been created by `make`). Run after any change in layers definition.  Also create borders table using extra processing with [osmborder](https://github.com/pnorman/osmborder) tool.

```bash
make import-osm
make import-borders
```

Import labels from Wikidata. If an OSM feature has [Key:wikidata](https://wiki.openstreetmap.org/wiki/Key:wikidata), OpenMapTiles check corresponding item in Wikidata and use its [labels](https://www.wikidata.org/wiki/Help:Label) for languages listed in [openmaptiles.yaml](openmaptiles.yaml). So the generated vector tiles includes multi-languages in name field.

This step uses [Wikidata Query Service](https://query.wikidata.org) to download just the Wikidata IDs that already exist in the database.

```bash
make import-wikidata
```

### Work on Layers

Each time you modify layer SQL code run `make` and `make import-sql`.

```
make clean
make
make import-sql
```

Now you are ready to **generate the vector tiles**. By default, `./.env` specifies the entire planet BBOX for zooms 0-7, but running `generate-bbox-file` will analyze the data file and set the `BBOX` param to limit tile generation.

```
make generate-bbox-file  # compute data bbox -- not needed for the whole planet
make generate-tiles      # generate tiles
```

## License

All code in this repository is under the [BSD license](./LICENSE.md) and the cartography decisions encoded in the schema and SQL are licensed under [CC-BY](./LICENSE.md).

Products or services using maps derived from OpenMapTiles schema need to visibly credit "OpenMapTiles.org" or reference "OpenMapTiles" with a link to https://openmaptiles.org/. Exceptions to attribution requirement can be granted on request.

For a browsable electronic map based on OpenMapTiles and OpenStreetMap data, the
credit should appear in the corner of the map. For example:

[© OpenMapTiles](https://openmaptiles.org/) [© OpenStreetMap contributors](https://www.openstreetmap.org/copyright)

For printed and static maps a similar attribution should be made in a textual
description near the image, in the same fashion as if you cite a photograph.
