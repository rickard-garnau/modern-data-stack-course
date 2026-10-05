
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  SELECT * FROM job_ads.warehouse.fct_job_ads
WHERE relevance > 1
  
  
      
    ) dbt_internal_test