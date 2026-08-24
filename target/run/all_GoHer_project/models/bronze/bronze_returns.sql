
  
    
        create or replace table `dbt_dev`.`bronze`.`bronze_returns`
      
      
  using delta
      
      
      
      
      
      
      
      as
      SELECT
    *
FROM
    `dbt_dev`.`source`.`fact_returns`
  