SELECT
  provider,
  SUM(request_count) AS total_requests,
  SUM(total_tokens) AS total_tokens,
  ROUND(SUM(estimated_cost),2) AS total_cost_usd
FROM `${project_id}.${dataset_id}.ai_usage`
GROUP BY provider
ORDER BY total_cost_usd DESC;