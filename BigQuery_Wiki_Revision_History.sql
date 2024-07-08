WITH RECURSIVE RevisionHistory AS (
    SELECT 
        id,
        timestamp,
        comment,
        contributor_id,
        NULL AS parent_id
    FROM 
        `bigquery-public-data.wikipedia.revision`
    WHERE 
        id = (SELECT MIN(id) FROM `bigquery-public-data.wikipedia.revision`)
    UNION ALL
    SELECT 
        r.id,
        r.timestamp,
        r.comment,
        r.contributor_id,
        rh.id AS parent_id
    FROM 
        `bigquery-public-data.wikipedia.revision` r
    JOIN 
        RevisionHistory rh
    ON 
        r.parentid = rh.id
)
SELECT 
    *
FROM 
    RevisionHistory;
