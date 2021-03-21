CREATE OR REPLACE FUNCTION railway_signal_subclass(tags hstore)
    RETURNS text AS
$$
SELECT CASE
            WHEN exist(tags, 'railway:signal:main') THEN 'main'
            WHEN exist(tags, 'railway:signal:main_repeated') THEN 'main_repeated'
            WHEN exist(tags, 'railway:signal:distant') THEN 'distant'
            WHEN exist(tags, 'railway:signal:minor') THEN 'minor'
            WHEN exist(tags, 'railway:signal:minor_distant') THEN 'minor_distant'
            WHEN exist(tags, 'railway:signal:combined') THEN 'combined'
            WHEN exist(tags, 'railway:signal:shunting') THEN 'shunting'
            WHEN exist(tags, 'railway:signal:crossing') THEN 'crossing'
            WHEN exist(tags, 'railway:signal:crossing_distant') THEN 'crossing_distant'
            WHEN exist(tags, 'railway:signal:crossing_info') THEN 'crossing_info'
            WHEN exist(tags, 'railway:signal:crossing_hint') THEN 'crossing_hint'
            WHEN exist(tags, 'railway:signal:electricity') THEN 'electricity'
            WHEN exist(tags, 'railway:signal:humping') THEN 'humping'
            WHEN exist(tags, 'railway:signal:speed_limit') THEN 'speed_limit'
            WHEN exist(tags, 'railway:signal:speed_limit_distant') THEN 'speed_limit_distant'
            WHEN exist(tags, 'railway:signal:whistle') THEN 'whistle'
            WHEN exist(tags, 'railway:signal:ring') THEN 'ring'
            WHEN exist(tags, 'railway:signal:route') THEN 'route'
            WHEN exist(tags, 'railway:signal:route_distant') THEN 'route_distant'
            WHEN exist(tags, 'railway:signal:wrong_road') THEN 'wrong_road'
            WHEN exist(tags, 'railway:signal:stop') THEN 'stop'
            WHEN exist(tags, 'railway:signal:stop_demand') THEN 'stop_demand'
            WHEN exist(tags, 'railway:signal:station_distant') THEN 'station_distant'
            WHEN exist(tags, 'railway:signal:radio') THEN 'radio'
            WHEN exist(tags, 'railway:signal:departure') THEN 'departure'
            WHEN exist(tags, 'railway:signal:resetting_switch') THEN 'resetting_switch'
            WHEN exist(tags, 'railway:signal:resetting_switch_distant') THEN 'resetting_switch_distant'
            WHEN exist(tags, 'railway:signal:snowplow') THEN 'snowplow'
            WHEN exist(tags, 'railway:signal:short_route') THEN 'short_route'
            WHEN exist(tags, 'railway:signal:brake_test') THEN 'brake_test'
            WHEN exist(tags, 'railway:signal:fouling_point') THEN 'fouling_point'
            WHEN exist(tags, 'railway:signal:helper_engine') THEN 'helper_engine'
            WHEN exist(tags, 'railway:signal:train_protection') THEN 'train_protection'
            WHEN exist(tags, 'railway:signal:steam_locomotive') THEN 'steam_locomotive'
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
