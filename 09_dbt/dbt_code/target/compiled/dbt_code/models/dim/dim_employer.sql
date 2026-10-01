with  __dbt__cte__src_employer as (
with stg_job_ads as (select * from job_ads.staging.technical_field_job_ads)

select
    employer__workplace as employer_workplace,
    workplace_address__municipality as workplace_municipality,
    employer__name as employer_name,
    employer__url as employer_url,
    employer__organization_number as employer_organization_number,
    workplace_address__street_address as workplace_street_address,
    workplace_address__region as workplace_region,
    workplace_address__postcode as workplace_postcode,
    workplace_address__country as workplace_country,
    coalesce(workplace_address__city, workplace_address__municipality) as workplace_city
from stg_job_ads
), src_employer as (select * from __dbt__cte__src_employer)

select
    md5(cast(coalesce(cast(employer_workplace as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(workplace_municipality as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))
    as employer_id,
    max(coalesce(
        employer_organization_number, 'saknar organisationsnummer'
    )) as employer_organization_number,
    max(coalesce(employer_name, 'namn ej angiven')) as employer_name,
    max(coalesce(employer_workplace, 'plats ej angiven')) as employer_workplace,
    max(coalesce(workplace_country, 'land ej angiven')) as workplace_country,
    max(coalesce(workplace_region, 'region ej angiven')) as workplace_region,
    max(coalesce(employer_url, 'webbplats ej angiven')) as employer_url,
    max(coalesce(
    case
        when coalesce(src_employer.workplace_city, src_employer.workplace_municipality) is null
        then null
        else upper(substr(coalesce(src_employer.workplace_city, src_employer.workplace_municipality), 1, 1)) || lower(substr(coalesce(src_employer.workplace_city, src_employer.workplace_municipality), 2))
    end
, 'stad ej angiven')) as workplace_city
from src_employer
group by employer_workplace, workplace_municipality