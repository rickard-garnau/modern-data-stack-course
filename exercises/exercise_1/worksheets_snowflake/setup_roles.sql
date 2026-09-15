USE ROLE USERADMIN;

CREATE ROLE IF NOT EXISTS marketing_dlt_role;

USE ROLE SECURITYADMIN;
GRANT ROLE marketing_dlt_role TO USER extract_loader;


GRANT USAGE ON SCHEMA ifood.staging TO ROLE marketing_dlt_role;
GRANT USAGE ON WAREHOUSE dev_wh TO ROLE marketing_dlt_role;
GRANT USAGE ON DATABASE ifood TO ROLE marketing_dlt_role;
GRANT CREATE TABLE ON SCHEMA ifood.staging TO ROLE marketing_dlt_role;
