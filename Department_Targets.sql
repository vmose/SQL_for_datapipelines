SELECT 
  CONCAT_WS(' ', first_name, last_name) AS full_name,
  SUM(CASE 
    WHEN order_date BETWEEN '2022-01-01' AND '2022-03-31' THEN total_price 
    ELSE 0 
  END) AS q1_sales,
  SUM(CASE 
    WHEN order_date BETWEEN '2022-04-01' AND '2022-06-30' THEN total_price 
    ELSE 0 
  END) AS q2_sales,
  SUM(CASE 
    WHEN order_date BETWEEN '2022-07-01' AND '2022-09-30' THEN total_price 
    ELSE 0 
  END) AS q3_sales,
  SUM(CASE 
    WHEN order_date BETWEEN '2022-10-01' AND '2022-12-31' THEN total_price 
    ELSE 0 
  END) AS q4_sales
FROM 
  orders 
  JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY 
  full_name
HAVING 
  q1_sales + q2_sales + q3_sales + q4_sales > 10000
