SELECT
  model,
  COUNT(*) AS events,
  SUM(total_tokens) AS total_tokens,
  ROUND(SUM(estimated_cost),2) AS total_cost_usd
FROM `${project_id}.${dataset_id}.ai_usage`
GROUP BY model
ORDER BY total_tokens DESC;