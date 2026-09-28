-- this is an extract of the model

with stg_job_ads as (select * from {{ source('job_ads', 'stg_ads') }})

select
    id,
    occupation__label,
    employer__workplace,
    workplace_address__municipality,
    number_of_vacancies as vacancies,
    relevance,
    application_deadline
from stg_job_ads