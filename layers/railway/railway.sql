-- etldoc: layer_railway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_railway |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
CREATE OR REPLACE FUNCTION layer_railway(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                osm_id    bigint,
                geometry  geometry,
                class     text,
                subclass  text,
                brunnel   text,
                service   text,
                layer     int,
                usage     text,
                track_ref text
            )
AS
$$
SELECT osm_id,
       geometry,
       CASE
           WHEN NULLIF(railway, '') IS NOT NULL THEN railway_class(railway)
           END AS class,
       CASE
           WHEN railway IS NOT NULL THEN railway
           END AS subclass,
       railway_brunnel(is_bridge, is_tunnel) AS brunnel,
       NULLIF(service, '') AS service,
       NULLIF(layer, 0) AS layer,
       NULLIF(usage, '') AS usage,
       NULLIF(track_ref, '') AS track_ref
FROM (
-- etldoc: osm_railway_linestring_gen_z4  ->  layer_railway:z4
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z4
         WHERE zoom_level = 4
           AND railway = 'rail'
           AND service = ''
           AND usage = 'main'
         UNION ALL

         -- etldoc: osm_railway_linestring_gen_z5  ->  layer_railway:z5
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z5
         WHERE zoom_level = 5
           AND railway = 'rail'
           AND service = ''
           AND usage = 'main'
         UNION ALL

         -- etldoc: osm_railway_linestring_gen_z6  ->  layer_railway:z6
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z6
         WHERE zoom_level = 6
           AND railway = 'rail'
           AND service = ''
           AND usage = 'main'
         UNION ALL

         -- etldoc: osm_railway_linestring_gen_z7  ->  layer_railway:z7
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z7
         WHERE zoom_level = 7
           AND railway = 'rail'
           AND service = ''
           AND usage = 'main'
         UNION ALL

         -- etldoc: osm_railway_linestring_gen_z8  ->  layer_railway:z8
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z8
         WHERE zoom_level = 8
           AND railway NOT IN ('disused', 'abandoned', 'razed', 'proposed', 'construction')
           AND service = ''
           AND usage IN ('main', 'branch')
         UNION ALL

         -- etldoc: osm_railway_linestring_gen_z9  ->  layer_railway:z9
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z9
         WHERE zoom_level = 9
           AND service = ''
           AND usage IN ('main', 'branch')
         UNION ALL

         -- etldoc: osm_railway_linestring_gen_z10  ->  layer_railway:z10
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z10
         WHERE zoom_level = 10
           AND railway <> 'tram'
           AND service = ''
         UNION ALL

         -- etldoc: osm_railway_linestring_gen_z11  ->  layer_railway:z11
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z11
         WHERE zoom_level = 11
           AND railway IN ('rail', 'narrow_gauge', 'light_rail', 'tram', 'disused', 'abandoned', 'razed', 'proposed', 'construction')
         UNION ALL

         -- etldoc: osm_railway_linestring_gen_z12  ->  layer_railway:z12
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring_gen_z12
         WHERE zoom_level = 12
         UNION ALL

         -- etldoc: osm_railway_linestring ->  layer_railway:z13
         -- etldoc: osm_railway_linestring ->  layer_railway:z14_
         SELECT osm_id,
                geometry,
                railway,
                railway_service_value(service) AS service,
                is_bridge,
                is_tunnel,
                layer,
                usage,
                track_ref,
                z_order
         FROM osm_railway_linestring
         WHERE zoom_level >= 13
     ) AS zoom_levels
WHERE geometry && bbox
ORDER BY z_order ASC;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
