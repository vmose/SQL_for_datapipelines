SELECT 
    c.customer_name, 
    COUNT(DISTINCT o.order_id) AS total_orders, 
    SUM(p.price * ol.quantity) AS total_spent
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_lines ol ON o.order_id = ol.order_id
    JOIN products p ON ol.product_id = p.product_id
WHERE 
    o.order_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY 
    c.customer_name
HAVING 
    total_spent > (
        SELECT 
            AVG(total_spent)
        FROM 
            (
                SELECT 
                    c.customer_id, 
                    SUM(p.price * ol.quantity) AS total_spent
                FROM 
                    customers c
                    JOIN orders o ON c.customer_id = o.customer_id
                    JOIN order_lines ol ON o.order_id = ol.order_id
                    JOIN products p ON ol.product_id = p.product_id
                WHERE 
                    o.order_date BETWEEN '2022-01-01' AND '2022-12-31'
                GROUP BY 
                    c.customer_id
            ) AS t
    )
ORDER BY 
    total_spent DESC;
