
  
  
  create or replace view `dbt_dev`.`bronze`.`bronze_product`
  
  as (
    SELECT
    *
FROM
    `dbt_dev`.`source`.`dim_product`
  )
