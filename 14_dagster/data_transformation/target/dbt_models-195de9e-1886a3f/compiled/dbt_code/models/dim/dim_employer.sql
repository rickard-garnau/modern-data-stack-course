with  __dbt__cte__src_employer as (
with stg_job_ads as (select * from job_ads.staging.technical_field_job_ads)

select
    employer__workplace as employer_workplace,
    workplace_address__municipality as workplace_municipality,
    employer__name as employer_name,
    employer__organization_number as employer_organization_number,
    workplace_address__street_address as workplace_street_address,
    workplace_address__region as workplace_region,
    workplace_address__postcode as workplace_postcode,
    workplace_address__city as workplace_city,
    workplace_address__country as workplace_country,
    coalesce(workplace_address__city, workplace_address__municipality) as workplace_city
from stg_job_ads
), src_employer as (select * from __dbt__cte__src_employer)

select
    md5(cast(coalesce(cast(employer_workplace as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(workplace_municipality as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as employer_id,
    employer_workplace,
    workplace_municipality,
    max(employer_name) as employer_name,
    max(employer_organization_number) as employer_organization_number,
    max(workplace_street_address) as workplace_street_address,
    max(workplace_region) as workplace_region,
    max(workplace_postcode) as workplace_postcode,
    max(workplace_city) as workplace_city,
    max(workplace_country) as workplace_country
from src_employer
group by employer_workplace, workplace_municipality