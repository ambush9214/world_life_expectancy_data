# World Life Expectancy Project (Data EXPLORATION)

SELECT *
FROM worldlifeexpectancy;

SELECT Country, MIN(`Life expectancy`), MAX(`Life expectancy`)
FROM worldlifeexpectancy
GROUP BY Country
ORDER BY Country DESC;

-- THERE ARE 0'S IN `Life expectancy`, going to filter out the 0's 

SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`), 
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS Life_Increase_15_Years
FROM worldlifeexpectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
	AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC;

SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM worldlifeexpectancy
GROUP BY Year
ORDER BY Year;

-- need to filter out the 0's again because they could be effecting our averages

SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM worldlifeexpectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year;

-- Filtering out the 0's did not change the averages. 

-- Correlations 

SELECT *
FROM worldlifeexpectancy
;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM worldlifeexpectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP ASC
;

-- Lower GDP has a correlation of lower life exp

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM worldlifeexpectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END), 1) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END), 1) Low_GDP_Life_Expectancy
FROM worldlifeexpectancy
;


SELECT *
FROM worldlifeexpectancy
;


SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM worldlifeexpectancy
GROUP BY Status
;

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM worldlifeexpectancy
GROUP BY Status
;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM worldlifeexpectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;

-- BMI may is not accurate because there are values over 40 

-- Rolling total for adult mortality 

SELECT Country, 
Year, 
`Life expectancy`,
`Adult Mortality`, 
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM worldlifeexpectancy
WHERE Country LIKE '%United%'
;













