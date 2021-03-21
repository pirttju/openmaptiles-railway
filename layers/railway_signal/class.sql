CREATE OR REPLACE FUNCTION railway_signal_subclass(tags hstore)
    RETURNS text AS
$$
SELECT CASE
            WHEN tags -> 'railway:signal:main' IS NOT NULL THEN 'main'
            WHEN tags -> 'railway:signal:main_repeated' IS NOT NULL THEN 'main_repeated'
            WHEN tags -> 'railway:signal:distant' IS NOT NULL THEN 'distant'
            WHEN tags -> 'railway:signal:minor' IS NOT NULL THEN 'minor'
            WHEN tags -> 'railway:signal:minor_distant' IS NOT NULL THEN 'minor_distant'
            WHEN tags -> 'railway:signal:combined' IS NOT NULL THEN 'combined'
            WHEN tags -> 'railway:signal:shunting' IS NOT NULL THEN 'shunting'
            WHEN tags -> 'railway:signal:crossing' IS NOT NULL THEN 'crossing'
            WHEN tags -> 'railway:signal:crossing_distant' IS NOT NULL THEN 'crossing_distant'
            WHEN tags -> 'railway:signal:crossing_info' IS NOT NULL THEN 'crossing_info'
            WHEN tags -> 'railway:signal:crossing_hint' IS NOT NULL THEN 'crossing_hint'
            WHEN tags -> 'railway:signal:electricity' IS NOT NULL THEN 'electricity'
            WHEN tags -> 'railway:signal:humping' IS NOT NULL THEN 'humping'
            WHEN tags -> 'railway:signal:speed_limit' IS NOT NULL THEN 'speed_limit'
            WHEN tags -> 'railway:signal:speed_limit_distant' IS NOT NULL THEN 'speed_limit_distant'
            WHEN tags -> 'railway:signal:whistle' IS NOT NULL THEN 'whistle'
            WHEN tags -> 'railway:signal:ring' IS NOT NULL THEN 'ring'
            WHEN tags -> 'railway:signal:route' IS NOT NULL THEN 'route'
            WHEN tags -> 'railway:signal:route_distant' IS NOT NULL THEN 'route_distant'
            WHEN tags -> 'railway:signal:wrong_road' IS NOT NULL THEN 'wrong_road'
            WHEN tags -> 'railway:signal:stop' IS NOT NULL THEN 'stop'
            WHEN tags -> 'railway:signal:stop_demand' IS NOT NULL THEN 'stop_demand'
            WHEN tags -> 'railway:signal:station_distant' IS NOT NULL THEN 'station_distant'
            WHEN tags -> 'railway:signal:radio' IS NOT NULL THEN 'radio'
            WHEN tags -> 'railway:signal:departure' IS NOT NULL THEN 'departure'
            WHEN tags -> 'railway:signal:resetting_switch' IS NOT NULL THEN 'resetting_switch'
            WHEN tags -> 'railway:signal:resetting_switch_distant' IS NOT NULL THEN 'resetting_switch_distant'
            WHEN tags -> 'railway:signal:snowplow' IS NOT NULL THEN 'snowplow'
            WHEN tags -> 'railway:signal:short_route' IS NOT NULL THEN 'short_route'
            WHEN tags -> 'railway:signal:brake_test' IS NOT NULL THEN 'brake_test'
            WHEN tags -> 'railway:signal:fouling_point' IS NOT NULL THEN 'fouling_point'
            WHEN tags -> 'railway:signal:helper_engine' IS NOT NULL THEN 'helper_engine'
            WHEN tags -> 'railway:signal:train_protection' IS NOT NULL THEN 'train_protection'
            WHEN tags -> 'railway:signal:steam_locomotive' IS NOT NULL THEN 'steam_locomotive'
            ELSE ''
            END;
$$ LANGUAGE SQL IMMUTABLE
                PARALLEL SAFE;

CREATE OR REPLACE FUNCTION railway_signal_subclass_rank(subclass text)
    RETURNS int AS
$$
SELECT CASE subclass
            WHEN 'main' THEN 20
            WHEN 'main_repeated' THEN 40
            WHEN 'distant' THEN 60
            WHEN 'minor' THEN 80
            WHEN 'minor_distant' THEN 100
            WHEN 'combined' THEN 120
            WHEN 'shunting' THEN 140
            WHEN 'crossing' THEN 160
            WHEN 'crossing_distant' THEN 180
            WHEN 'crossing_info' THEN 200
            WHEN 'crossing_hint' THEN 220
            WHEN 'electricity' THEN 240
            WHEN 'humping' THEN 260
            WHEN 'speed_limit' THEN 280
            WHEN 'speed_limit_distant' THEN 300
            WHEN 'whistle' THEN 320
            WHEN 'ring' THEN 340
            WHEN 'route' THEN 360
            WHEN 'route_distant' THEN 380
            WHEN 'wrong_road' THEN 400
            WHEN 'stop' THEN 420
            WHEN 'stop_demand' THEN 440
            WHEN 'station_distant' THEN 460
            WHEN 'radio' THEN 480
            WHEN 'departure' THEN 500
            WHEN 'resetting_switch' THEN 520
            WHEN 'resetting_switch_distant' THEN 540
            WHEN 'snowplow' THEN 560
            WHEN 'short_route' THEN 580
            WHEN 'brake_test' THEN 600
            WHEN 'fouling_point' THEN 620
            WHEN 'helper_engine' THEN 640
            WHEN 'train_protection' THEN 660
            WHEN 'steam_locomotive' THEN 680
            ELSE 1000
            END;
$$ LANGUAGE SQL IMMUTABLE
                PARALLEL SAFE;
