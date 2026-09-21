USE ROLE USERADMIN;

CREATE ROLE IF NOT EXISTS job_ads_dbt_role;

GRANT ROLE job_ads_dbt_role TO USER transformer;
GRANT ROLE job_ads_dbt_role TO USER garnau;