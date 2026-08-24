
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        country as value_field,
        count(*) as n_records

    from `dbt_dev`.`bronze`.`bronze_store`
    group by country

)

select *
from all_values
where value_field not in (
    'USA','Canada','Mexico'
)



  
  
      
    ) dbt_internal_test