
    
    

select
    employer_id as unique_field,
    count(*) as n_records

from job_ads.warehouse.dim_employer
where employer_id is not null
group by employer_id
having count(*) > 1


