-- this is an extract of the model

with  __dbt__cte__src_job_ads as (
-- this is an extract of the model

with stg_job_ads as (select * from job_ads.staging.technical_field_job_ads)

select
    id,
    occupation__label,
    employer__workplace,
    workplace_address__municipality,
    number_of_vacancies as vacancies,
    relevance,
    application_deadline
from stg_job_ads
), job_ads as (select * from __dbt__cte__src_job_ads)

select
    md5(cast(coalesce(cast(occupation__label as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as occupation_id,
    md5(cast(coalesce(cast(employer__workplace as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(workplace_address__municipality as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as employer_id,
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as job_details_id,
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as auxilliary_attributes_id,
    vacancies,
    relevance,
    application_deadline
from job_ads