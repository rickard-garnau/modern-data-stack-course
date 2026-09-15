USE ROLE USERADMIN;
CREATE ROLE IF NOT EXISTS parking_dlt_role;

USE ROLE SYSADMIN;
CREATE DATABASE IF NOT EXISTS parking_db;
CREATE SCHEMA IF NOT EXISTS staging;

USE ROLE SECURITYADMIN;

GRANT ROLE parking_dlt_role TO USER extract_loader;
GRANT ROLE parking_dlt_role TO USER garnau;

GRANT USAGE ON WAREHOUSE dev_wh TO ROLE parking_dlt_role;
GRANT USAGE ON DATABASE parking_db TO ROLE parking_dlt_role;

GRANT USAGE ON SCHEMA staging TO ROLE parking_dlt_role;

GRANT CREATE TABLE ON SCHEMA staging TO ROLE parking_dlt_role;