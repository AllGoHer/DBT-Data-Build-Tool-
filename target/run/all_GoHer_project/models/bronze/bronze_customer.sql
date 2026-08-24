
  
    
        create or replace table `dbt_dev`.`bronze`.`bronze_customer`
      
      
  using delta
      
      
      
      
      
      
      
      as
      SELECT
    *
FROM
    `dbt_dev`.`source`.`dim_customer`
  