-- etldoc: layer_railway_signal[shape=record fillcolor=red, style="rounded,filled",
-- etldoc:     label="layer_railway_signal | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_railway_signal(bbox geometry, zoom_level integer, pixel_width numeric)
    RETURNS TABLE
            (
                osm_id   bigint,
                geometry geometry,
                tags     hstore,
                class    text,
                ref      text,
                railway_position text,
                signal_position text,
                direction text,
                catenary_mast boolean,
                layer    integer,
                "rank"   int
            )
AS
$$
SELECT osm_id_hash AS osm_id,
    geometry,
    tags,
    class,
    railway_signal_subclass(tags) AS subclass,
    ref,
    tags -> 'railway:signal:' || railway_signal_subclass(tags) AS signal_type,
    COALESCE(NULLIF(railway_position, ''), railway_position_exact) AS railway_position,
    signal_position,
    direction,
    catenary_mast,
    NULLIF(layer, 0) AS layer,
    row_number() OVER (
        PARTITION BY LabelGrid(geometry, 100 * pixel_width)
        ORDER BY railway_signal_subclass_rank(class) ASC
        )::int AS "rank"
FROM (
        -- etldoc: osm_railway_signal_point ->  layer_railway_signal:z14_
        SELECT *,
              osm_id * 10 AS osm_id_hash
        FROM osm_railway_signal_point
        WHERE geometry && bbox
          AND zoom_level >= 14
    ) AS railway_signal_union
ORDER BY "rank"
$$ LANGUAGE SQL STABLE
                PARALLEL SAFE;
-- TODO: Check if the above can be made STRICT -- i.e. if pixel_width could be NULL
