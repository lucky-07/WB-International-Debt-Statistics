SELECT * FROM international_debt limit 10;         

# Finding number of distinct countries  (124)
SELECT COUNT(DISTINCT country_name) AS total_num_countries 
FROM international_debt;   

# Finding Out the Distinct Debt Indicators (25)
SELECT DISTINCT indicator_code AS debt_indicators FROM international_debt ORDER BY debt_indicators;

# Totaling the Amount of Debt Owed by the Countries  ('3079734487675.7915')
SELECT SUM(debt) as total_debt_USD FROM international_debt;

#Country with the Highest Debt               (china : 285.79 B USD)
SELECT country_name, 
       ROUND(total_debt / 1000000000, 2) AS total_debt_Billion_USD
FROM (
    SELECT country_name,
           SUM(debt) AS total_debt,
           RANK() OVER (ORDER BY SUM(debt) DESC) AS rnk
    FROM international_debt
    GROUP BY country_name
) AS ranked_debt
WHERE rnk = 1;

#  Average Amount of Debt Across Indicators
SELECT indicator_code, indicator_name, ROUND(AVG(debt)/1000000000,2) as avg_debt_Billion_USD
FROM international_debt
GROUP BY indicator_code, indicator_name
ORDER BY avg_debt_Billion_USD DESC;

# The Highest Amount of Principal Repayments
SELECT country_name, 
       ROUND(debt / 1000000000, 2) AS principal_repayment_debt_Billion_USD
FROM (
    SELECT country_name, debt,
           RANK() OVER (ORDER BY debt DESC) AS rnk
    FROM international_debt
    WHERE indicator_code = 'DT.AMT.DLXF.CD'
) AS ranked_data
WHERE rnk <= 5
ORDER BY debt DESC;

# The Highest Amount of Principal Repayments
SELECT indicator_code, country_count
FROM (
    SELECT indicator_code, 
           COUNT(*) AS country_count,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM international_debt
    GROUP BY indicator_code
) AS ranked_indicators
WHERE rnk = 1;


# Other Viable Debt Issues and Conclusion
WITH max_debt_country AS
(
    SELECT country_name, MAX(debt) as max_debt
    FROM international_debt
    GROUP BY country_name
)
SELECT i.country_name, i.indicator_code, ROUND(i.debt/1000000000,2) AS debt_Billion_USD
FROM international_debt i
INNER JOIN max_debt_country
ON i.country_name = max_debt_country.country_name
AND max_debt_country.max_debt = i.debt
ORDER BY debt_Billion_USD DESC;
   

