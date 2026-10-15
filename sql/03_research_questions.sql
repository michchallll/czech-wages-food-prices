-- Q1: Do wages increase across all industries?

WITH annual_wages AS (
    SELECT DISTINCT
        year,
        industry_branch_code,
        industry_branch,
        average_wage
    FROM t_michael_kubat_project_SQL_primary_final
    WHERE industry_branch_code IS NOT NULL
),
wage_comparison AS (
    SELECT
        year,
        industry_branch,
        average_wage,
        LAG(average_wage) OVER (
            PARTITION BY industry_branch_code
            ORDER BY year
        ) AS previous_wage
    FROM annual_wages
)
SELECT
    year,
    industry_branch,
    average_wage,
    previous_wage,
    ROUND(
        (average_wage - previous_wage)
        / NULLIF(previous_wage, 0) * 100,
        3
    ) AS wage_change_percent
FROM wage_comparison
WHERE average_wage < previous_wage
ORDER BY wage_change_percent;


-- Q2: Purchasing power of milk and bread

SELECT
    year,
    food_category,
    average_wage,
    average_price,
    ROUND(
        average_wage / NULLIF(average_price, 0),
        2
    ) AS purchasable_quantity
FROM t_michael_kubat_project_SQL_primary_final
WHERE industry_branch_code IS NULL
    AND category_code IN (111301, 114201)
    AND year IN (2006, 2018)
ORDER BY food_category, year;


-- Q3: Food categories with the lowest price growth

WITH food_prices AS (
    SELECT
        category_code,
        food_category,
        year,
        average_price
    FROM t_michael_kubat_project_SQL_primary_final
    WHERE industry_branch_code IS NULL
        AND year IN (2006, 2018)
)
SELECT
    food_category,
    MAX(CASE WHEN year = 2006
        THEN average_price END) AS price_2006,
    MAX(CASE WHEN year = 2018
        THEN average_price END) AS price_2018,
    ROUND(
        (
            MAX(CASE WHEN year = 2018
                THEN average_price END)
            -
            MAX(CASE WHEN year = 2006
                THEN average_price END)
        )
        / NULLIF(
            MAX(CASE WHEN year = 2006
                THEN average_price END), 0
        ) * 100,
        2
    ) AS price_change_percent
FROM food_prices
GROUP BY category_code, food_category
HAVING price_2006 IS NOT NULL
    AND price_2018 IS NOT NULL
ORDER BY price_change_percent ASC;


-- Q4: Food price growth compared to wage growth

WITH annual_wages AS (
    SELECT DISTINCT
        year,
        average_wage
    FROM t_michael_kubat_project_SQL_primary_final
    WHERE industry_branch_code IS NULL
),
wage_changes AS (
    SELECT
        year,
        ROUND(
            (average_wage - LAG(average_wage) OVER (
                ORDER BY year
            ))
            / NULLIF(LAG(average_wage) OVER (
                ORDER BY year
            ), 0) * 100,
            2
        ) AS wage_growth_percent
    FROM annual_wages
),
annual_prices AS (
    SELECT DISTINCT
        year,
        category_code,
        average_price
    FROM t_michael_kubat_project_SQL_primary_final
    WHERE industry_branch_code IS NULL
),
price_changes AS (
    SELECT
        year,
        category_code,
        average_price,
        LAG(year) OVER (
            PARTITION BY category_code
            ORDER BY year
        ) AS previous_year,
        LAG(average_price) OVER (
            PARTITION BY category_code
            ORDER BY year
        ) AS previous_price
    FROM annual_prices
),
food_growth AS (
    SELECT
        year,
        ROUND(
            AVG(
                (average_price - previous_price)
                / NULLIF(previous_price, 0) * 100
            ),
            2
        ) AS food_growth_percent
    FROM price_changes
    WHERE previous_year = year - 1
    GROUP BY year
)
SELECT
    w.year,
    w.wage_growth_percent,
    f.food_growth_percent,
    ROUND(
        f.food_growth_percent - w.wage_growth_percent,
        2
    ) AS difference_pp
FROM wage_changes AS w
JOIN food_growth AS f
    ON w.year = f.year
ORDER BY w.year;


-- Q5: GDP growth compared to wage and food price growth

WITH annual_gdp AS (
    SELECT
        year,
        GDP,
        LAG(GDP) OVER (
            ORDER BY year
        ) AS previous_gdp
    FROM t_michael_kubat_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),
gdp_growth AS (
    SELECT
        year,
        (GDP - previous_gdp)
        / NULLIF(previous_gdp, 0) * 100 AS gdp_growth_percent
    FROM annual_gdp
),
annual_wages AS (
    SELECT
        year,
        average_wage,
        LAG(average_wage) OVER (
            ORDER BY year
        ) AS previous_wage
    FROM (
        SELECT DISTINCT
            year,
            average_wage
        FROM t_michael_kubat_project_SQL_primary_final
        WHERE industry_branch_code IS NULL
    ) AS wages
),
wage_growth AS (
    SELECT
        year,
        (average_wage - previous_wage)
        / NULLIF(previous_wage, 0) * 100 AS wage_growth_percent
    FROM annual_wages
),
annual_prices AS (
    SELECT DISTINCT
        year,
        category_code,
        average_price
    FROM t_michael_kubat_project_SQL_primary_final
    WHERE industry_branch_code IS NULL
),
price_comparison AS (
    SELECT
        year,
        category_code,
        average_price,
        LAG(year) OVER (
            PARTITION BY category_code
            ORDER BY year
        ) AS previous_year,
        LAG(average_price) OVER (
            PARTITION BY category_code
            ORDER BY year
        ) AS previous_price
    FROM annual_prices
),
food_growth AS (
    SELECT
        year,
        AVG(
            (average_price - previous_price)
            / NULLIF(previous_price, 0) * 100
        ) AS food_growth_percent
    FROM price_comparison
    WHERE previous_year = year - 1
    GROUP BY year
),
yearly_growth AS (
    SELECT
        g.year,
        g.gdp_growth_percent,
        w.wage_growth_percent,
        f.food_growth_percent
    FROM gdp_growth AS g
    JOIN wage_growth AS w
        ON g.year = w.year
    JOIN food_growth AS f
        ON g.year = f.year
)
SELECT
    year,
    ROUND(gdp_growth_percent, 2) AS gdp_growth_percent,
    ROUND(wage_growth_percent, 2) AS wage_growth_percent,
    ROUND(food_growth_percent, 2) AS food_growth_percent,
    ROUND(
        LEAD(wage_growth_percent) OVER (ORDER BY year), 2
    ) AS next_year_wage_growth,
    ROUND(
        LEAD(food_growth_percent) OVER (ORDER BY year), 2
    ) AS next_year_food_growth
FROM yearly_growth
ORDER BY year;
