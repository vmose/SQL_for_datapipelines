WITH revenue_by_month AS (
  SELECT 
    DATE_TRUNC('month', date) AS month, 
    SUM(price * quantity) AS revenue
  FROM 
    sales
  GROUP BY 
    DATE_TRUNC('month', date)
), 
top_customers_by_month AS (
  SELECT 
    DATE_TRUNC('month', date) AS month, 
    customer_id, 
    SUM(price * quantity) AS total_spent
  FROM 
    sales
  GROUP BY 
    DATE_TRUNC('month', date),
    customer_id
  ORDER BY 
    DATE_TRUNC('month', date),
    total_spent DESC
), 
ranked_top_customers_by_month AS (
  SELECT 
    month, 
    customer_id, 
    total_spent, 
    RANK() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rank
  FROM 
    top_customers_by_month
)
SELECT 
  month, 
  customer_id, 
  total_spent, 
  rank, 
  revenue, 
  total_spent / revenue AS revenue_share
FROM 
  ranked_top_customers_by_month
  JOIN revenue_by_month ON ranked_top_customers_by_month.month = revenue_by_month.month
WHERE 
  rank <= 10
ORDER BY 
  month, 
  rank
