## Project Overview

This project analyzes the development of wages and food prices in the Czech Republic between 2006 and 2018, together with selected European economic indicators.

The analysis focuses on wage growth, purchasing power, food price changes, and the relationship between GDP growth, wages, and food prices.

## Technologies

- **Database:** MariaDB
- **Language:** SQL
- **Database management:** DBeaver
- **Version control:** Git and GitHub

## Data Sources

The project uses datasets provided as part of the ENGETO SQL Academy, including:

- Czech payroll data by industry
- Czech food price data
- European economic indicators (GDP, population, GINI coefficient)
- Country and industry reference tables

## Methodology

Two analytical tables were created by joining, filtering, and aggregating the original datasets.

- Payroll data were aggregated into annual averages using quarterly wage records.
- Food prices were averaged from available nationwide measurements.
- The analysis focuses on the common period from 2006 to 2018.
- Year-over-year changes were calculated using SQL window functions.
- Food price growth was calculated as the unweighted average of percentage changes across comparable categories.
- Correlation analysis was used to explore relationships between GDP, wages, and food prices without assuming causation.
- Annual wages were calculated as the arithmetic mean of quarterly average monthly wages.
- Food price measurements varied in frequency across the analyzed period, which may affect the comparability of annual averages.

## Research Questions

### Q1: Do Wages Increase Across All Industries?

Wages did not increase continuously across all industries between 2006 and 2018.

The analysis identified **25 instances of year-over-year wage decreases** across the 19 monitored industries.

The largest decline occurred in Financial and Insurance Activities in **2013**, when the average wage decreased by **8.83%**, from CZK 50,800.50 to CZK 46,316.50.

The year 2013 was particularly notable, with wage decreases recorded in 11 out of 19 industries.

These findings demonstrate that wage development varied significantly across industries and years.

### Q2: Purchasing Power of Milk and Bread

In 2006, the average monthly wage (CZK 19,536) was sufficient to purchase approximately **1,212 kg of bread** or **1,353 liters of milk**.

By 2018, the average wage had increased to CZK 32,043, allowing the purchase of approximately **1,322 kg of bread** or **1,617 liters of milk**.

Although the prices of both products increased during this period, purchasing power improved by **9.1% for bread** and **19.5% for milk**, as wage growth outpaced the price increases of these products.

### Q3: Which Food Category Had the Lowest Price Increase?

Between 2006 and 2018, **2 out of 26 food categories decreased in price**, while the remaining 24 became more expensive.

The largest price decrease was recorded for **granulated sugar (-27.52%)**, followed by **tomatoes (-23.07%)**.

Among the categories that increased in price, bananas had the lowest increase (+7.36%).

In contrast, butter experienced the highest price increase **(+98.37%)**.

The analysis compares average prices in 2006 and 2018 rather than annual price fluctuations.

### Q4: Did Food Prices Increase Significantly Faster Than Wages?

Between 2007 and 2018, **no year recorded food price growth exceeding wage growth by more than 10 percentage points**.

The largest difference occurred in **2013**, when food prices increased by 6.01%, while average wages decreased by 0.13%, resulting in a gap of **6.14 percentage points**.

Food prices grew faster than wages in 6 of the 12 analyzed years, but the difference never exceeded the specified threshold.

The analysis uses the unweighted average of year-over-year percentage changes across comparable food categories, rather than the official consumer price index.

### Q5: Is GDP Growth Related to Wage and Food Price Growth?

The analysis compared year-over-year changes in GDP, average wages, and food prices in the Czech Republic between 2007 and 2018, including wage and price changes in the following year.

**GDP and wage growth showed some similar patterns**, but the relationship was not consistent across all years. Food price changes were even less consistent with GDP development.

For example, in **2009**, GDP declined by 4.66% and food prices decreased by 6.58%, while average wages continued to grow by 3.37%. In **2017**, all three indicators increased, with GDP growing by 5.17%, wages by 6.74%, and food prices by 7.06%.

Overall, the comparison suggests that economic growth may be associated with wage and food price developments, but **no consistent relationship, including a one-year lag, can be established** from this descriptive analysis alone.

## Repository Structure

```text
czech-wages-food-prices/
├── sql/
│   ├── 01_primary_table.sql
│   ├── 02_secondary_table.sql
│   └── 03_research_questions.sql
├── results/
│   ├── q1_wage_declines.json
│   └── q1_wage_declines.xml
├── README.md
└── LICENSE
```

## How to Run

1. Set up a MariaDB database and import the original ENGETO SQL Academy dataset.
2. Execute `sql/01_primary_table.sql` to create the primary analytical table.
3. Execute `sql/02_secondary_table.sql` to create the secondary analytical table.
4. Run the queries in `sql/03_research_questions.sql` to reproduce the analysis.

The original source tables are not modified. The project creates separate analytical tables for further processing.

**Note:** The original dataset is not included in this repository.

## Data Export

The results of the first research question were exported to **JSON and XML** using DBeaver.

Both files contain 25 instances of year-over-year wage decreases across Czech industries between 2006 and 2018.

The exports were validated using Python's `json` and `xml.etree.ElementTree` modules.

- `results/q1_wage_declines.json`
- `results/q1_wage_declines.xml`
