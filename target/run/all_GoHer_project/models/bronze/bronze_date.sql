
  
  
  create or replace view `dbt_dev`.`bronze`.`bronze_date`
  
  as (
    SELECT
    *
FROM
    `dbt_dev`.`source`.`dim_date`
  )
