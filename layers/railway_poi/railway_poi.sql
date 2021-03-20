-- etldoc: layer_railway_poi[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_railway_poi | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_railway_poi(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id   bigint,
                geometry geometry,
                name     text,
                name_en  text,
                name_de  text,
                tags     hstore,
                class    text,
                subclass text,
                layer    integer,
                "rank"   int
            )
AS
$$
SELECT osm_id_hash AS osm_id,
       geometry,
       NULLIF(name, '') AS name,
       COALESCE(NULLIF(name_en, ''), name) AS name_en,
       COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
       tags,
       railway_poi_class(subclass, mapping_key) AS class,
       CASE
           WHEN subclass = 'information'
               THEN NULLIF(information, '')
           WHEN subclass = 'place_of_worship'
               THEN NULLIF(religion, '')
           WHEN subclass = 'pitch'
               THEN NULLIF(sport, '')
           ELSE subclass
           END AS subclass,
       NULLIF(layer, 0) AS layer,
       "level",
       CASE WHEN indoor = TRUE THEN 1 END AS indoor,
       row_number() OVER (
           PARTITION BY LabelGrid(geometry, 100 * pixel_width)
           ORDER BY CASE WHEN name = '' THEN 2000 ELSE railway_poi_class_rank(poi_class(subclass, mapping_key)) END ASC
           )::int AS "rank"
FROM (
         -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z14_
         SELECT *,
                osm_id * 10 AS osm_id_hash
         FROM osm_railway_poi_point
         WHERE geometry && bbox
           AND zoom_level >= 14

         UNION ALL

         -- etldoc: osm_railway_poi_polygon ->  layer_railway_poi:z14_
         SELECT *,
                CASE
                    WHEN osm_id < 0 THEN -osm_id * 10 + 4
                    ELSE osm_id * 10 + 1
                    END AS osm_id_hash
         FROM osm_railway_poi_polygon
         WHERE geometry && bbox
           AND zoom_level >= 14
     ) AS railway_poi_union
ORDER BY "rank"
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
