SELECT
  DATE(event_timestamp) AS usage_date,
  environment,
  COUNT(*) AS total_requests,
  SUM(request_count) AS request_count,
  SUM(input_tokens) AS input_tokens,
  SUM(output_tokens) AS output_tokens,
  SUM(total_tokens) AS total_tokens,
  ROUND(SUM(estimated_cost), 4) AS total_cost_usd
FROM
  `${project_id}.${dataset_id}.ai_usage`
GROUP BY
  usage_date,
  environment
ORDER BY
  usage_date DESC;