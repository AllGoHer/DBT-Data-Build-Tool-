
  
  
  create or replace view `dbt_dev`.`bronze`.`bronze_sales`
  
  as (
    SELECT
    *
FROM
    `dbt_dev`.`source`.`fact_sales`
  )
