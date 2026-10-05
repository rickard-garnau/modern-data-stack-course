






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and relevance >= 0 and relevance <= 1
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







