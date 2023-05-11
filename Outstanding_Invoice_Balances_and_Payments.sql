SELECT 
  i.invoice_id,
  i.customer_name,
  i.invoice_total,
  SUM(p.payment_amount) AS total_payments,
  (i.invoice_total - SUM(p.payment_amount)) AS outstanding_balance,
  DENSE_RANK() OVER (ORDER BY (i.invoice_total - SUM(p.payment_amount)) DESC) AS rank
FROM 
  invoices i
  LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY 
  i.invoice_id
HAVING 
  (i.invoice_total - SUM(p.payment_amount)) > 0
ORDER BY 
  rank ASC;
