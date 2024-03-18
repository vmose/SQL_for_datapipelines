SELECT 
  c.campaign_id,
  c.campaign_name,
  COUNT(DISTINCT v.visitor_id) AS visitors,
  COUNT(DISTINCT CASE WHEN v.converted = 1 THEN v.visitor_id END) AS conversions,
  ROUND((COUNT(DISTINCT CASE WHEN v.converted = 1 THEN v.visitor_id END) / COUNT(DISTINCT v.visitor_id)) * 100, 2) AS conversion_rate,
  COUNT(DISTINCT c.click_id) AS clicks,
  ROUND((COUNT(DISTINCT v.visitor_id) / COUNT(DISTINCT c.click_id)) * 100, 2) AS clickthrough_rate,
  SUM(c.cost) AS cost,
  SUM(CASE WHEN v.converted = 1 THEN c.revenue ELSE 0 END) AS revenue,
  ROUND(((SUM(CASE WHEN v.converted = 1 THEN c.revenue ELSE 0 END) - SUM(c.cost)) / SUM(c.cost)) * 100, 2) AS roi
FROM 
  campaigns c
  LEFT JOIN clicks c2 ON c.campaign_id = c2.campaign_id
  LEFT JOIN visitors v ON c2.click_id = v.click_id
GROUP BY 
  c.campaign_id, 
  c.campaign_name
