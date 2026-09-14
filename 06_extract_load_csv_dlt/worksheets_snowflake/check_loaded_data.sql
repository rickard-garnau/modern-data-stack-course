USE ROLE movies_reader_role;

SHOW DATABASES;

USE DATABASE movies;

DESCRIBE DATABASE movies;
DESCRIBE SCHEMA staging;

DESC TABLE staging.netflix;

SELECT * FROM staging.netflix;