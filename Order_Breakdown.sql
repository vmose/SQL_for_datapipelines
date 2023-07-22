SELECT 
    o.order_id, 
    o.order_date, 
    SUM(ol.quantity * ol.unit_price) AS total_price,
    CASE 
        WHEN SUM(ol.quantity * ol.unit_price) >= 1000 THEN 'High'
        WHEN SUM(ol.quantity * ol.unit_price) >= 500 THEN 'Medium'
        ELSE 'Low'
    END AS price_category
FROM 
    orders o
    JOIN order_details ol ON o.order_id = ol.order_id
GROUP BY 
    o.order_id, 
    o.order_date
ORDER BY 
    o.order_date DESC, 
    total_price DESC;
