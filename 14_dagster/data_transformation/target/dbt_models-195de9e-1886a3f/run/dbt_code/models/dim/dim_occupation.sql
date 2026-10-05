
  
    

create or replace transient table job_ads.warehouse.dim_occupation
    
    
    
    
    

    as (with  __dbt__cte__src_occupation as (
with stg_job_ads as (select * from job_ads.staging.technical_field_job_ads)

select
    occupation_group__concept_id as occupation_group_id,
    occupation_field__concept_id as occupation_field_id,
    occupation__label as occupation,
    occupation_group__label as occupation_group,
    occupation_field__label as occupation_field
from stg_job_ads
), src_occupation as (select * from __dbt__cte__src_occupation)

-- we use aggregate function max() for deduplicate, but there are more alternative codes one can use for this purpose
select
    md5(cast(coalesce(cast(occupation as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as occupation_id,
    occupation,
    max(occupation_group) as occupation_group,
    max(occupation_field) as occupation_field
from src_occupation
group by occupation
    )
;


  