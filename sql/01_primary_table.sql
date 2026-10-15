CREATE TABLE t_michael_kubat_project_SQL_primary_final AS
SELECT *
FROM (
    WITH payroll_data AS (
    SELECT
        p.payroll_year AS year,
        p.industry_branch_code,
        b.name AS industry_branch,
        ROUND(AVG(p.value), 2) AS average_wage
    FROM czechia_payroll AS p
    LEFT JOIN czechia_payroll_industry_branch AS b
        ON p.industry_branch_code = b.code
    WHERE p.value_type_code = 5958
        AND p.unit_code = 200
        AND p.calculation_code = 200
        AND p.payroll_year BETWEEN 2006 AND 2018
    GROUP BY
        p.payroll_year,
        p.industry_branch_code,
        b.name
    ),
    price_data AS (
    SELECT
        YEAR(p.date_from) AS year,
        p.category_code,
        c.name AS food_category,
        c.price_value,
        c.price_unit,
        ROUND(AVG(p.value), 2) AS average_price
    FROM czechia_price AS p
    JOIN czechia_price_category AS c
        ON p.category_code = c.code
    WHERE p.region_code IS NULL
        AND YEAR(p.date_from) BETWEEN 2006 AND 2018
    GROUP BY
        YEAR(p.date_from),
        p.category_code,
        c.name,
        c.price_value,
        c.price_unit
    )
    SELECT
        pay.year,
        pay.industry_branch_code,
        pay.industry_branch,
        pay.average_wage,
        pr.category_code,
        pr.food_category,
        pr.price_value,
        pr.price_unit,
        pr.average_price
    FROM payroll_data AS pay
    JOIN price_data AS pr
        ON pay.year = pr.year
) AS result;
