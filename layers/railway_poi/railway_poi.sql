-- etldoc: layer_railway_poi[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_railway_poi | <z7> z7 | <z8> z8 | <z9> z9 | <z10> z10 | <z11> z11 | <z12> z12 | <z13> z13 | <z14_> z14+" ] ;

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
                ref      text,
                railway_position text,
                uic_ref  text,
                station  text,
                local_operated boolean,
                resetting boolean,
                layer    integer,
                "rank"   int
            )
AS
$$
SELECT osm_id_hash AS osm_id,
    geometry,
    NULLIF(name, '') AS name,
    COALESCE(NULLIF(name_en, ''), NULLIF(name,'')) AS name_en,
    COALESCE(NULLIF(name_de, ''), NULLIF(name,''), NULLIF(name_en,'')) AS name_de,
    tags,
    class,
    COALESCE(NULLIF(railway_ref,''), NULLIF(ref,'')) AS ref,
    COALESCE(NULLIF(railway_position,''), NULLIF(railway_position_exact,'')) AS railway_position,
    NULLIF(uic_ref, '') AS uic_ref,
    NULLIF(station, '') AS station,
    NULLIF(local_operated, FALSE) AS local_operated,
    NULLIF(resetting, FALSE) AS resetting,
    NULLIF(layer, 0) AS layer,
    row_number() OVER (
        PARTITION BY LabelGrid(geometry, 100 * pixel_width)
        ORDER BY railway_poi_class_rank(class) ASC
        )::int AS "rank"
FROM (
        -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z7
        SELECT *,
              osm_id * 10 AS osm_id_hash
        FROM osm_railway_poi_point
        WHERE geometry && bbox
          AND zoom_level = 7
          AND class IN ('station')
          AND station NOT IN ('subway', 'light_rail')

        UNION ALL

        -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z8
        -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z9
        SELECT *,
              osm_id * 10 AS osm_id_hash
        FROM osm_railway_poi_point
        WHERE geometry && bbox
          AND zoom_level BETWEEN 8 AND 9
          AND class IN ('station', 'yard', 'junction', 'spur_junction', 'service_station', 'crossover', 'site')
          AND station NOT IN ('subway', 'light_rail')

        UNION ALL

        -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z10
        SELECT *,
              osm_id * 10 AS osm_id_hash
        FROM osm_railway_poi_point
        WHERE geometry && bbox
          AND zoom_level = 10
          AND class IN ('station', 'yard', 'junction', 'spur_junction', 'service_station', 'crossover', 'site', 'halt',
                        'milestone')

        UNION ALL

        -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z11
        -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z12
        SELECT *,
              osm_id * 10 AS osm_id_hash
        FROM osm_railway_poi_point
        WHERE geometry && bbox
          AND zoom_level BETWEEN 11 AND 12
          AND class IN ('station', 'yard', 'junction', 'spur_junction', 'service_station', 'crossover', 'site', 'halt',
                        'border', 'turntable', 'traverser', 'milestone')

        UNION ALL

        -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z13
        SELECT *,
              osm_id * 10 AS osm_id_hash
        FROM osm_railway_poi_point
        WHERE geometry && bbox
          AND zoom_level = 13
          AND class IN ('station', 'yard', 'junction', 'spur_junction', 'service_station', 'crossover', 'site', 'halt',
                        'border', 'turntable', 'traverser', 'milestone', 'owner_change', 'tram_stop', 'radio',
                        'level_crossing', 'crossing')

        UNION ALL

        -- etldoc: osm_railway_poi_point ->  layer_railway_poi:z14_
        SELECT *,
              osm_id * 10 AS osm_id_hash
        FROM osm_railway_poi_point
        WHERE geometry && bbox
          AND zoom_level >= 14

        UNION ALL

        -- etldoc: osm_railway_poi_polygon ->  layer_railway_poi:z7
        SELECT *,
              CASE
                  WHEN osm_id < 0 THEN -osm_id * 10 + 4
                  ELSE osm_id * 10 + 1
                  END AS osm_id_hash
        FROM osm_railway_poi_polygon
        WHERE geometry && bbox
          AND zoom_level = 7
          AND class IN ('station')
          AND station NOT IN ('subway', 'light_rail')

        UNION ALL

        -- etldoc: osm_railway_poi_polygon ->  layer_railway_poi:z8
        -- etldoc: osm_railway_poi_polygon ->  layer_railway_poi:z9
        SELECT *,
              CASE
                  WHEN osm_id < 0 THEN -osm_id * 10 + 4
                  ELSE osm_id * 10 + 1
                  END AS osm_id_hash
        FROM osm_railway_poi_polygon
        WHERE geometry && bbox
          AND zoom_level BETWEEN 8 AND 9
          AND class IN ('station', 'yard', 'junction', 'spur_junction', 'service_station', 'crossover', 'site')
          AND station NOT IN ('subway', 'light_rail')

        UNION ALL

        -- etldoc: osm_railway_poi_polygon ->  layer_railway_poi:z10
        SELECT *,
              CASE
                  WHEN osm_id < 0 THEN -osm_id * 10 + 4
                  ELSE osm_id * 10 + 1
                  END AS osm_id_hash
        FROM osm_railway_poi_polygon
        WHERE geometry && bbox
          AND zoom_level = 10
          AND class IN ('station', 'yard', 'junction', 'spur_junction', 'service_station', 'crossover', 'site', 'halt',
                        'milestone')

        UNION ALL

        -- etldoc: osm_railway_poi_polygon ->  layer_railway_poi:z11
        -- etldoc: osm_railway_poi_polygon ->  layer_railway_poi:z12
        SELECT *,
              CASE
                  WHEN osm_id < 0 THEN -osm_id * 10 + 4
                  ELSE osm_id * 10 + 1
                  END AS osm_id_hash
        FROM osm_railway_poi_polygon
        WHERE geometry && bbox
          AND zoom_level BETWEEN 11 AND 12
          AND class IN ('station', 'yard', 'junction', 'spur_junction', 'service_station', 'crossover', 'site', 'halt',
                        'border', 'turntable', 'traverser', 'milestone')

        UNION ALL

        -- etldoc: osm_railway_poi_polygon ->  layer_railway_poi:z13
        SELECT *,
              CASE
                  WHEN osm_id < 0 THEN -osm_id * 10 + 4
                  ELSE osm_id * 10 + 1
                  END AS osm_id_hash
        FROM osm_railway_poi_polygon
        WHERE geometry && bbox
          AND zoom_level = 13
          AND class IN ('station', 'yard', 'junction', 'spur_junction', 'service_station', 'crossover', 'site', 'halt',
                        'border', 'turntable', 'traverser', 'milestone', 'owner_change', 'tram_stop', 'radio',
                        'level_crossing', 'crossing')

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
