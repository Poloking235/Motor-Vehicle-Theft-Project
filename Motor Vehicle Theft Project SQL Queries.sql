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