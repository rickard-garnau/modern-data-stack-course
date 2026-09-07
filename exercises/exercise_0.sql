-- 0. Google queries

USE DATABASE GOOGLE_KEYWORDS_SEARCH_DATASET_DISCOVER_ALL_SEARCHES_ON_GOOGLE;

-- a) Use this database and find out the underlying schemas, tables and views to get an overview of its logical structure.
SHOW SCHEMAS;
SHOW TABLES;
USE SCHEMA DATAFEEDS;

-- b) Find out the columns and its data types in the table GOOGLE_KEYWORDS.
DESCRIBE TABLE GOOGLE_KEYWORDS;

-- c) Find out number of rows in the dataset.
SELECT COUNT(*) FROM GOOGLE_KEYWORDS;

-- d) When is the first search and when is the latest search in the dataset?
SELECT 
MAX(DATE) AS latest_date,
MIN(DATE) AS earliest_date 
FROM GOOGLE_KEYWORDS;

-- e) Which are the 10 most popular keywords?
SELECT KEYWORD
FROM GOOGLE_KEYWORDS
GROUP BY KEYWORD 
ORDER BY count(*) DESC
LIMIT 10;

-- f) How many unique keywords are there?
SELECT COUNT(DISTINCT KEYWORD)
FROM GOOGLE_KEYWORDS;

-- g) Check what type of platforms are used and how many users per platform
SELECT DISTINCT PLATFORM FROM GOOGLE_KEYWORDS;
SELECT PLATFORM, SUM(CALIBRATED_USERS)
FROM GOOGLE_KEYWORDS
GROUP BY PLATFORM;

-- h) Let's dive into what swedish people are searching. Go into worldbanks country codes to find out the country code for Sweden. Find the 20 most popular keywords and the number of searches of that keyword.
SELECT KEYWORD
FROM GOOGLE_KEYWORDS
WHERE COUNTRY = 752
GROUP BY KEYWORD
ORDER BY COUNT(*) DESC
LIMIT 20;

-- i) Lets see how popular spotify is around the world. List the top 10 number countries and the number of searches for spotify.
SELECT COUNTRY, COUNT(*)
FROM GOOGLE_KEYWORDS
WHERE KEYWORD = 'spotify'
GROUP BY COUNTRY
ORDER BY COUNT(*) DESC
LIMIT 10;

-- j) Feel free to do additional explorations of this dataset.


-- 1. How much does it cost?
DESCRIBE TABLE GOOGLE_KEYWORDS;

/* 
a) You have a simple workload that runs daily in Snowflake. The workload uses 0.5 credits per day. Calculate the total credit usage and cost for a 30-day month.

-- Enterprise 3$/credit
-- 0.5 * 3 * 30 = 45$
*/

/*
-- b) Your workload varies throughout the month. For the first 10 days, you use 2 credits per day. 
-- For the next 10 days, you use 1.5 credits per day, and for the last 10 days, you use 1 credit per day. 
-- Calculate the total credit usage and cost for a 30-day month.

-- 2 * 3 * 10 = 60 | 1.5 * 3 * 10 = 45 | 1 * 3 * 10 = 30 | 135$
*/

/* 
 c) You have three different warehouses running workloads simultaneously. Warehouse A is of size XS, Warehouse B is of size S, and Warehouse C is of size M. 
 Warehouse A is used for 10h/day, B is used for 2h/day and C is used for 1h/day. Calculate the total monthly cost assuming each warehouse runs for the full 30-day month.
 1 *  3 * 10 * 30 = 900 | 2 * 2 * 3 * 30 = 360 | 4 * 3 * 30 = 360
 900 (A) + 360 (B) + 360 (C) = 1620$ 
 */

/*
d) Your Snowflake warehouse uses auto-scaling. For the first 10 days, it operates on 2 clusters for 10 hours per day. For the next 10 days, it scales up to 3 clusters for 10 hours per day. 
For the last 10 days, it scales up to 4 clusters for 10 hours per day. Calculate the total monthly budget. Assume the warehouse consumes 1 credit per hour per cluster.

Enterprise = 3$ / Credit
Cluster = 1$ / h
10 days * 10 h * 2 cluster * 3 (Enterprise) = 600
10 days * 10 h * 3 * 3 = 900
10 days * 10 h * 4 * 3 = 1200
total = 2700$
*/
