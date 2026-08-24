
  
    
        create or replace table `dbt_dev`.`gold`.`source_gold_items`
      
      
  using delta
      
      
      
      
      
      
      
      as
      WITH dedup_query AS
(
    SELECT 
        id,
        name,
        category,
        updateDate,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY updateDate DESC) as deduplication_id
    FROM
        `dbt_dev`.`source`.`items`
)
SELECT
    id,
    name,
    category,
    updateDate
FROM
    dedup_query
WHERE
    deduplication_id = 1
  