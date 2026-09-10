-- 0. Google queries
USE DATABASE GOOGLE_KEYWORDS_SEARCH_DATASET_DISCOVER_ALL_SEARCHES_ON_GOOGLE;

-- a) Use this database and find out the underlying schemas, tables and views to get an overview of its logical structure.
SHOW SCHEMAS;

SHOW TABLES;

USE SCHEMA DATAFEEDS;

-- b) Find out the columns and its data types in the table GOOGLE_KEYWORDS.
DESCRIBE TABLE GOOGLE_KEYWORDS;

-- c) Find out number of rows in the dataset.
SELECT
    COUNT(*)
FROM
    GOOGLE_KEYWORDS;

-- d) When is the first search and when is the latest search in the dataset?
SELECT
    MAX(DATE) AS latest_date,
    MIN(DATE) AS earliest_date
FROM
    GOOGLE_KEYWORDS;

-- e) Which are the 10 most popular keywords?
SELECT
    KEYWORD
FROM
    GOOGLE_KEYWORDS
GROUP BY
    KEYWORD
ORDER BY
    count(*) DESC
LIMIT
    20;

-- f) How many unique keywords are there?
SELECT
    COUNT(DISTINCT KEYWORD)
FROM
    GOOGLE_KEYWORDS;

-- g) Check what type of platforms are used and how many users per platform
SELECT DISTINCT
    PLATFORM
FROM
    GOOGLE_KEYWORDS;

SELECT
    PLATFORM,
    SUM(CALIBRATED_USERS)
FROM
    GOOGLE_KEYWORDS
GROUP BY
    PLATFORM;

-- h) Let's dive into what swedish people are searching. Go into worldbanks country codes to find out the country code for Sweden. Find the 20 most popular keywords and the number of searches of that keyword.
SELECT
    KEYWORD
FROM
    GOOGLE_KEYWORDS
WHERE
    COUNTRY = 752
GROUP BY
    KEYWORD
ORDER BY
    COUNT(*) DESC
LIMIT
    20;

-- i) Lets see how popular spotify is around the world. List the top 10 number countries and the number of searches for spotify.
SELECT
    COUNTRY,
    COUNT(*)
FROM
    GOOGLE_KEYWORDS
WHERE
    KEYWORD = 'spotify'
GROUP BY
    COUNTRY
ORDER BY
    COUNT(*) DESC
LIMIT
    10;

-- j) Feel free to do additional explorations of this dataset.