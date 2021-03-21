CREATE OR REPLACE FUNCTION railway_poi_class_rank(class text)
    RETURNS int AS
$$
SELECT CASE class
           WHEN 'station' THEN 20
           WHEN 'yard' THEN 40
           WHEN 'museum' THEN 50
           WHEN 'container_terminal' THEN 60
           WHEN 'halt' THEN 70
           WHEN 'service_station' THEN 80
           WHEN 'junction' THEN 90
           WHEN 'spur_junction' THEN 100
           WHEN 'crossover' THEN 110
           WHEN 'site' THEN 120
           WHEN 'level_crossing' THEN 130
           WHEN 'tram_level_crossing' THEN 150
           WHEN 'crossing' THEN 160
           WHEN 'tram_crossing' THEN 170
           WHEN 'border' THEN 180
           WHEN 'owner_change' THEN 190
           WHEN 'subway_entrance' THEN 200
           WHEN 'tram_stop' THEN 210
           WHEN 'crossing_box' THEN 300
           WHEN 'signal_box' THEN 310
           WHEN 'blockpost' THEN 320
           WHEN 'switch' THEN 400
           WHEN 'derail' THEN 490
           WHEN 'phone' THEN 500
           WHEN 'radio' THEN 510
           WHEN 'defect_detector' THEN 520
           WHEN 'loading_ramp' THEN 600
           WHEN 'car_shuttle' THEN 610
           WHEN 'rolling_highway' THEN 620
           WHEN 'loading_rack' THEN 630
           WHEN 'turntable' THEN 640
           WHEN 'traverser' THEN 650
           WHEN 'milestone' THEN 700
           ELSE 1000
           END;
$$ LANGUAGE SQL IMMUTABLE
                PARALLEL SAFE;
