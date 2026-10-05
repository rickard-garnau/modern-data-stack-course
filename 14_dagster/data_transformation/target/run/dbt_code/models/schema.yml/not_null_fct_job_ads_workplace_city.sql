
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select workplace_city
from job_ads.warehouse.fct_job_ads
where workplace_city is null



  
  
      
    ) dbt_internal_test