





    with grouped_expression as (
    select
        
        
    
  
( 1=1 and percentile_cont(0.99) within group (order by vacancies) >= 1 and percentile_cont(0.99) within group (order by vacancies) <= 20
)
 as expression


    from job_ads.warehouse.fct_job_ads
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors





