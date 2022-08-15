--Checking all our tables

SELECT * FROM..r_prevalence;

SELECT * FROM..r_deaths;

SELECT * FROM..r_incidence;

--Year with most amount of rabies related deaths

SELECT entity, year, MAX(deaths) AS most_deaths FROM..r_deaths
GROUP BY entity, year
ORDER BY most_deaths DESC;

--Years with minimum rabies related deaths

SELECT entity, year, MIN(deaths) AS least_deaths FROM..r_deaths
GROUP BY entity, year
ORDER BY least_deaths;

--Comparison of rabies incidences to deaths
--Shows most people who contract rabies will likely pass

SELECT * FROM..r_incidence
JOIN r_deaths
	ON r_incidence.entity = r_deaths.entity
	AND r_incidence.year = r_deaths.year;

--Prevalence of Rabies versus Incidences 
--Where Prevalence is proportion of population versus Incidence which is new cases

SELECT * FROM..r_incidence
JOIN r_prevalence
	ON r_incidence.entity = r_prevalence.entity
	AND r_incidence.year = r_prevalence.year;

--Let's make a range of low, medium, and high death cases
--where 0-1000 is low, 1000-5000 is medium, and 5000+ is high

SELECT *,
CASE
	WHEN deaths <= 1000 THEN 'low'
	WHEN deaths BETWEEN 1000 AND 5000 THEN 'medium'
	WHEN deaths >= 5000 THEN 'high'
	ELSE 'NA'
END AS 'severity'
FROM r_deaths;

--Calculate the fatality rate using deaths divided by incidences
--however in our data, there are more deaths than instances- it looks like every instance has resulted in a death
--Used NULLIF to avoid dividing by zero values

SELECT r_incidence.entity, r_incidence.year, r_incidence.incidence, r_deaths.deaths, (COUNT(r_deaths.deaths) / NULLIF(COUNT(r_incidence.incidence), 0) * 100.0) AS fatality_rate FROM..r_incidence
JOIN r_deaths
	ON r_incidence.entity = r_deaths.entity
	AND r_incidence.year = r_deaths.year
GROUP BY r_incidence.entity, r_incidence.year, r_incidence.incidence, r_deaths.deaths
ORDER BY fatality_rate DESC;

--Country with most amount of deaths

SELECT entity, year, MAX(deaths) AS most_deaths FROM..r_deaths
WHERE entity NOT LIKE '%world%'
AND entity NOT LIKE '%region%'
AND entity NOT LIKE '%south%'
AND entity NOT LIKE '%G20%'
GROUP BY entity, year
ORDER BY most_deaths DESC;

