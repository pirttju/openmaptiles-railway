CREATE OR REPLACE FUNCTION railway_poi_class_rank(class text)
    RETURNS int AS
$$
SELECT CASE class
           WHEN 'railway' THEN 40
           ELSE 1000
           END;
$$ LANGUAGE SQL IMMUTABLE
                PARALLEL SAFE;

CREATE OR REPLACE FUNCTION railway_poi_class(subclass text, mapping_key text)
    RETURNS text AS
$$
SELECT CASE
           %%FIELD_MAPPING: class %%
           ELSE subclass
           END;
$$ LANGUAGE SQL IMMUTABLE
                PARALLEL SAFE;
