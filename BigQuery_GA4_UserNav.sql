WITH RECURSIVE UserNavigation AS (
    SELECT 
        fullVisitorId,
        visitId,
        hit.page.pagePath AS current_page,
        LAG(hit.page.pagePath) OVER (PARTITION BY fullVisitorId, visitId ORDER BY hit.time) AS previous_page,
        hit.time
    FROM 
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
        UNNEST(hits) AS hit
    WHERE 
        _TABLE_SUFFIX BETWEEN '20170801' AND '20170831'

    UNION ALL

    SELECT 
        fullVisitorId,
        visitId,
        previous_page AS current_page,
        LAG(previous_page) OVER (PARTITION BY fullVisitorId, visitId ORDER BY hit.time) AS previous_page,
        hit.time
    FROM 
        UserNavigation
)
SELECT 
    *
FROM 
    UserNavigation
ORDER BY 
    fullVisitorId, visitId, hit.time;
