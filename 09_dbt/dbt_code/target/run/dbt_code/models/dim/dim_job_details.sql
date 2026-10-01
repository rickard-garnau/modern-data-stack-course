
  
    

create or replace transient table job_ads.warehouse.dim_job_details
    
    
    
    
    

    as (with  __dbt__cte__src_job_details as (
-- this is an extract of the model
with stg_job_ads as (select * from job_ads.staging.technical_field_job_ads)

select
    occupation__label,
    number_of_vacancies as vacancies,
    relevance,
    application_deadline
from 
    stg_job_ads
order by application_deadline
), src_job_details as (select * from __dbt__cte__src_job_details)

select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as job_details_id,
    headline,
    description,
    description_html,
    coalesce(duration, 'ej angiven') as duration,
    salary_type,
    coalesce(working_hours_type, 'ej specificerad') as working_hours_type, 
    scope_of_work_min,
    scope_of_work_max
from src_job_details
    )
;


  