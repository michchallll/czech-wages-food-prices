CREATE TABLE t_michael_kubat_project_SQL_secondary_final AS
SELECT
    e.country,
    e.year,
    e.GDP,
    e.gini,
    e.population
FROM economies AS e
JOIN countries AS c
    ON e.country = c.country
WHERE c.continent = 'Europe'
    AND e.year BETWEEN 2006 AND 2018;
