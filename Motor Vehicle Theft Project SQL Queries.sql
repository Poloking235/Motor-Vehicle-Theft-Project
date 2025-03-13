-- Finding the number of vehicles stolen each year 
SELECT YEAR(date_stolen), COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles 
GROUP BY YEAR(date_stolen);

-- Finding the number of vehicles stolen each month
SELECT YEAR(date_stolen), MONTH(date_stolen), COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles 
GROUP BY MONTH(date_stolen), YEAR(date_stolen)
ORDER BY num_vehicles DESC;

-- Finding the number of vehicles stolen each day of the week 
SELECT DAYOFWEEK(date_stolen) AS day_of_week, COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles 
GROUP BY MONTH(date_stolen), DAYOFWEEK(date_stolen) 
ORDER BY day_of_week;

-- Analyzing number of vehicles stolen based on full day of the week 
SELECT DAYOFWEEK(date_stolen) AS dow, 
CASE 
	WHEN DAYOFWEEK(date_stolen) = 1 THEN 'Sunday'
    WHEN DAYOFWEEK(date_stolen) = 2 THEN 'Monday'
    WHEN DAYOFWEEK(date_stolen) = 3 THEN 'Tuesday'
    WHEN DAYOFWEEK(date_stolen) = 4 THEN 'Wednesday'
    WHEN DAYOFWEEK(date_stolen) = 5 THEN 'Thursday'
    WHEN DAYOFWEEK(date_stolen) = 6 THEN 'Friday'
    ELSE 'Saturday'
END AS day_of_week,
	COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles 
GROUP BY DAYOFWEEK(date_stolen), day_of_week
ORDER BY dow;

-- Finding the vehicle types that are most and least often stolen 
SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles 
GROUP BY vehicle_type
ORDER BY num_vehicles
LIMIT 5; 

-- Finding the average age of cars that are stolen by vehicle type 
SELECT vehicle_type, AVG(YEAR(date_stolen) - model_year) AS avg_age
FROM stolen_vehicles 
GROUP BY vehicle_type
ORDER BY avg_age DESC;

-- Finding the percent of vehicles stolen that are luxury verus standard 
WITH lux_standard AS (
SELECT vehicle_type, 
CASE 
	WHEN make_type = 'Luxury' THEN 1 
    ELSE 0 
END AS luxury, 
1 AS all_cars
FROM stolen_vehicles AS sv
LEFT JOIN make_details AS md 
	ON sv.make_id = md.make_id)
    
SELECT vehicle_type, COUNT(luxury) / SUM(all_cars) * 100 AS pct_lux
FROM lux_standard
GROUP BY vehicle_type
ORDER BY pct_lux DESC;

-- CASE Statement explaining top 10 vehicles stolen by color 
SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicles,
		SUM(CASE WHEN color = 'Silver' THEN 1 ELSE 0 END) AS silver,
        SUM(CASE WHEN color = 'White' THEN 1 ELSE 0 END) AS white,
        SUM(CASE WHEN color = 'Black' THEN 1 ELSE 0 END) AS black,
        SUM(CASE WHEN color = 'Blue' THEN 1 ELSE 0 END) AS blue,
        SUM(CASE WHEN color = 'Red' THEN 1 ELSE 0 END) AS red,
        SUM(CASE WHEN color = 'Grey' THEN 1 ELSE 0 END) AS grey,
        SUM(CASE WHEN color = 'Green' THEN 1 ELSE 0 END) AS green,
        SUM(CASE WHEN color IN ('Gold', 'Brown', 'Yellow', 'Orange', 'Purple', 'Cream', 'Pink') THEN 1 ELSE 0 END) AS other 
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 10;

-- Finding the number of vehicles stolen in each region 
SELECT region, COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles 
LEFT JOIN locations 
	ON locations.location_id = stolen_vehicles.location_id
GROUP BY region;

-- Finding the population and density for each region 
SELECT region, COUNT(vehicle_id) AS num_vehicles, 
		population, density
FROM stolen_vehicles 
LEFT JOIN locations 
	ON locations.location_id = stolen_vehicles.location_id
GROUP BY region, population, density
ORDER BY num_vehicles DESC;

-- Anazlying if the types of vehicles stolen in the three most dense regions differ from the three least dense regions 
SELECT region, COUNT(vehicle_id) AS num_vehicles, 
		population, density
FROM stolen_vehicles 
LEFT JOIN locations 
	ON locations.location_id = stolen_vehicles.location_id
GROUP BY region, population, density
ORDER BY density DESC;


(SELECT 'High Density', vehicle_type, COUNT(vehicle_id) AS num_vehicles 
FROM stolen_vehicles 
LEFT JOIN locations 
	ON locations.location_id = stolen_vehicles.location_id
WHERE region IN ('Auckland', 'Nelson', 'Wellington')
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5)

UNION 

(SELECT 'Low Density', vehicle_type, COUNT(vehicle_id) AS num_vehicles 
FROM stolen_vehicles 
LEFT JOIN locations 
	ON locations.location_id = stolen_vehicles.location_id
WHERE region IN ('Otago', 'Gisborne', 'Southland')
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5);
