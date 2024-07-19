USE FINAL;
CREATE TABLE coronavirus (
    Province VARCHAR(255),
    Country_Region VARCHAR(255),
    Latitude FLOAT,
    Longitude FLOAT,
    Date DATE,
    Confirmed INT,
    Deaths INT,
    Recovered INT
);


USE FINAL;

-- Q1. Check for NULL values
SELECT 
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS confirmed_nulls,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS deaths_nulls,
    SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS recovered_nulls
FROM coronavirus_data;

-- Q2. Update NULL values with zeros for all columns
UPDATE coronavirus_data
SET 
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);

-- Q3. Check total number of rows
SELECT COUNT(*) AS total_rows
FROM coronavirus_data;

-- Q4. Check the start date and end date
SELECT 
    MIN(Date) AS start_date,
    MAX(Date) AS end_date
FROM coronavirus_data;

-- Q5. Number of months present in the dataset
SELECT 
    COUNT(DISTINCT DATE_FORMAT(Date, '%Y-%m')) AS total_months
FROM coronavirus_data;

-- Q6. Find the monthly average for confirmed, deaths, recovered
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    AVG(Confirmed) AS avg_confirmed,
    AVG(Deaths) AS avg_deaths,
    AVG(Recovered) AS avg_recovered
FROM coronavirus_data
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY month;

-- Q7. Find the most frequent value for confirmed, deaths, recovered each month
-- Step 1: Create the frequency table
CREATE TEMPORARY TABLE frequency_table AS
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    Confirmed,
    Deaths,
    Recovered,
    COUNT(*) AS frequency
FROM coronavirus_data
GROUP BY month, Confirmed, Deaths, Recovered;

-- Step 2: Create the table to find the maximum frequency per month
CREATE TEMPORARY TABLE max_frequency_table AS
SELECT 
    month,
    MAX(frequency) AS max_frequency
FROM frequency_table
GROUP BY month;

-- Step 3: Join the tables to get the most frequent values
SELECT 
    f.month,
    f.Confirmed,
    f.Deaths,
    f.Recovered
FROM frequency_table f
JOIN max_frequency_table m
ON f.month = m.month AND f.frequency = m.max_frequency;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM coronavirus_data
GROUP BY YEAR(Date)
ORDER BY year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM coronavirus_data
GROUP BY YEAR(Date)
ORDER BY year;

-- Q10. The total number of cases of confirmed, deaths, recovered each month
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM coronavirus_data
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY month;

-- Q11. Spread of the virus with respect to confirmed cases
SELECT 
    SUM(Confirmed) AS total_confirmed,
    AVG(Confirmed) AS avg_confirmed,
    VARIANCE(Confirmed) AS variance_confirmed,
    STDDEV(Confirmed) AS stdev_confirmed
FROM coronavirus_data;

-- Q12. Spread of the virus with respect to death cases per month
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    SUM(Deaths) AS total_deaths,
    AVG(Deaths) AS avg_deaths,
    VARIANCE(Deaths) AS variance_deaths,
    STDDEV(Deaths) AS stdev_deaths
FROM coronavirus_data
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY month;

-- Q13. Spread of the virus with respect to recovered cases
SELECT 
    SUM(Recovered) AS total_recovered,
    AVG(Recovered) AS avg_recovered,
    VARIANCE(Recovered) AS variance_recovered,
    STDDEV(Recovered) AS stdev_recovered
FROM coronavirus_data;

-- Q14. Find the country having the highest number of confirmed cases
SELECT 
    Country_Region AS country,
    SUM(Confirmed) AS total_confirmed
FROM coronavirus_data
GROUP BY Country_Region
ORDER BY total_confirmed DESC
LIMIT 1;

-- Q15. Find the country having the lowest number of death cases
SELECT 
    Country_Region AS country,
    SUM(Deaths) AS total_deaths
FROM coronavirus_data
GROUP BY Country_Region
ORDER BY total_deaths ASC
LIMIT 1;

-- Q16. Find the top 5 countries having the highest recovered cases
SELECT 
    Country_Region AS country,
    SUM(Recovered) AS total_recovered
FROM coronavirus_data
GROUP BY Country_Region
ORDER BY total_recovered DESC
LIMIT 5;
