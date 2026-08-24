WITH dedup_query AS
(
    SELECT 
        id,
        name,
        category,
        updateDate,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY updateDate DESC) as deduplication_id
    FROM
        {{ source('source', 'items') }}
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