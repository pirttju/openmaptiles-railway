CREATE OR REPLACE FUNCTION railway_brunnel(is_bridge bool, is_tunnel bool) RETURNS text AS
$$
SELECT CASE
           WHEN is_bridge THEN 'bridge'
           WHEN is_tunnel THEN 'tunnel'
           END;
$$ LANGUAGE SQL IMMUTABLE
                STRICT
                PARALLEL SAFE;

-- The classes for railways are derived from the classes used in ClearTables
-- https://github.com/ClearTables/ClearTables/blob/master/transportation.lua
CREATE OR REPLACE FUNCTION railway_class(railway text) RETURNS text AS
$$
SELECT CASE
           WHEN railway IN ('rail', 'narrow_gauge', 'preserved', 'funicular') THEN 'rail'
           WHEN railway IN ('subway', 'light_rail', 'monorail', 'tram') THEN 'transit'
           END;
$$ LANGUAGE SQL IMMUTABLE
                STRICT
                PARALLEL SAFE;

-- Limit service to only the most important values to ensure
-- we always know the values of service
CREATE OR REPLACE FUNCTION railway_service_value(service text) RETURNS text AS
$$
SELECT CASE
           WHEN service IN ('spur', 'yard', 'siding', 'crossover') THEN service
           END;
$$ LANGUAGE SQL IMMUTABLE
                STRICT
                PARALLEL SAFE;
