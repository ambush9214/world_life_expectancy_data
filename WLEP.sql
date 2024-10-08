# World Life Expectancy Project (Data Cleaning)

SELECT *
FROM worldlifeexpectancy;

-- Looking for duplicates

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifeexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year), 
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM worldlifeexpectancy
    ) AS Row_Table
WHERE Row_Num > 1;

-- Deleting duplicates alter
DELETE FROM worldlifeexpectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
    SELECT Row_ID, 
	CONCAT(Country, Year), 
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM worldlifeexpectancy
    ) AS Row_Table
WHERE Row_Num > 1
);

SELECT *
FROM worldlifeexpectancy;

-- Fixing the status column and filling in the correct values for missing status' of countries
    
SELECT *
FROM worldlifeexpectancy
WHERE Status = '';


SELECT DISTINCT(Status)
FROM worldlifeexpectancy
WHERE Status <> '';


SELECT DISTINCT(Country)
FROM  worldlifeexpectancy
WHERE Status = 'Developing';

UPDATE worldlifeexpectancy
SET Status = 'Developing'
WHERE Country IN (
					SELECT DISTINCT(Country)
					FROM  worldlifeexpectancy
					WHERE Status = 'Developing');
-- this did not work

UPDATE worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = '' 
AND t2.Status <> ''
AND t2.Status = 'Developing'
;


SELECT *
FROM worldlifeexpectancy
WHERE  Country = 'United States of America';

-- USA is a Developed country so need to populate the status in missing rows

UPDATE worldlifeexpectancy t1
JOIN worldlifeexpectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = '' 
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

SELECT *
FROM worldlifeexpectancy;

-- I want to populate the life expectancy column, to do this I will join the table to itself. Then take the values is the rows above and below missing values and replace the blanks with the average. 
-- The average will give us a rough estimate 

SELECT Country, Year, `Life expectancy`
FROM worldlifeexpectancy
;


SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1)
FROM worldlifeexpectancy t1
JOIN  worldlifeexpectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN  worldlifeexpectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
WHERE t1.`Life expectancy`= ''
;

UPDATE worldlifeexpectancy t1
JOIN  worldlifeexpectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN  worldlifeexpectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1)
WHERE t1.`Life expectancy` = ''
;

-- this code worked

SELECT `Life expectancy`
FROM worldlifeexpectancy
WHERE `Life expectancy` = '';

SELECT *
FROM worldlifeexpectancy;