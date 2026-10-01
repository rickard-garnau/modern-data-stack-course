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